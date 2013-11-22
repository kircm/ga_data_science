from helper_functions import *
import json
import copy
from glob import glob
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction import DictVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.cross_validation import cross_val_score
from sklearn.metrics import auc_score
from sklearn.metrics import recall_score
from sklearn.metrics import precision_score


##################################################################################
# Use this variable to ignore non-relvant features when training/testing the model
##################################################################################
featues_not_used = ['hotel_id', 'click_actual_cpc']



################################################################
# Extract hotel amenity tokens from all the hotels in the system
################################################################
print "Generating a list of hotel amenities based on scraped data..."
hotel_ids = extract_hotel_ids_from_database_data()
hotel_amenities_dict = generate_hotel_amenities_data_dict(hotel_ids)
hotel_amenities_data = generate_hotel_amenities_data(hotel_ids)
count_vectorizer = CountVectorizer(min_df=1, stop_words='english')
try:
	token_frequencies = count_vectorizer.fit_transform([hotel_amenities_data])
except Exception:
	token_frequencies = sparse.coo_matrix(0,0)
amenities = count_vectorizer.get_feature_names()
print "Generated " + str(len(amenities)) + " hotel amenity elements" 

# For testing, reducing processing time
amenities = ["children", "pool", "conference", "smoking", "wi", "fi", "gym", "tennis", "tv", "shuttle", "dining", "airport", "car", "rental"]
#amenities = []


################
# Training phase
################
# Load training data 
print "Loading training data..."
training_data = load_json_data_from_files('data_files/training/*')
# Add hotel amenities as features to the training data
print "Adding hotel amenities to trainig data..."
add_hotel_amenities_as_features(training_data, hotel_amenities_dict, amenities)
# For convenience when testing features to be excluded
remove_features(training_data, featues_not_used)

print "Training data generated."
print "\n"
print "..............................."
print "First example of training data:"
print training_data[0]
print "..............................."
print "\n"

# Training / testing
print "Training and testing the model..."
model = LogisticRegression(C=0.014, class_weight='auto')
# Without regularization:
# model = LogisticRegression(class_weight='auto')

vectorizer = DictVectorizer()

# Perform cross validation
# We copy the training_data to be able to do cross-validation without losing the was_clicked label on the original training_data
x_data = copy.deepcopy(training_data)
# REMOVE was_clicked from data that will be used as x_values in cross validation
remove_features(x_data, ['was_clicked'])
x_values = vectorizer.fit_transform(x_data)
y_values = np.array([data_item['was_clicked'] for data_item in training_data])
cross_val_results = cross_val_score(model, X=x_values, y=y_values, score_func=auc_score, cv=4)
print "Cross validation performed."
print "\n"
print "========================="
print "Cross validation results: "
print cross_val_results
print "========================="
print "\n"




###########################
# Out of sample predictions 
###########################
# Fit the model with original training data
training_set = vectorizer.fit_transform(training_data)
model.fit(X=training_set, y=[data_item['was_clicked'] for data_item in training_data])
print "Loading out of sample data..."
out_of_sample_data = load_json_data_from_files('data_files/out_of_sample/*')
# Add hotel amenities as features
print "Adding hotel amenities to out of sample data..."
add_hotel_amenities_as_features(out_of_sample_data, hotel_amenities_dict, amenities)
remove_features(out_of_sample_data, featues_not_used)
remove_features(out_of_sample_data, ['was_clicked'])

print "Calculating prediction probabilities on out of sample data..."
out_of_sample_set = vectorizer.transform(out_of_sample_data)


predictions = model.predict_proba(out_of_sample_set)

print "Prediction probabilities calculated."

# Extract summary values from predictions
predictions_max_values = np.max(predictions, axis=0)
predictions_min_values = np.min(predictions, axis=0)
predictions_mean_values = np.mean(predictions, axis=0)
print "\n"
print "=================================="
print "Predictions on Out-of-sample data: (" + str(len(predictions)) +" predictions)"
print predictions
print "\n"
print "Maximum probability of click across predictions: " + str(predictions_max_values[1])
print "Minimum probability of click across predictions: "  + str(predictions_min_values[1])
print "Mean probability of click: " + str(predictions_mean_values[1])
print "=================================="
print "\n"
print "\n"

np.savetxt("predictions.csv", predictions, header="no_click_proba,click_proba", delimiter=",")
print "(predictions stored in predictions.csv)"