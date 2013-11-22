from sklearn.datasets import load_files
from sklearn.feature_extraction.text import CountVectorizer

# Load the text data
categories = [
    'alt.atheism',
    'talk.religion.misc',
    'comp.graphics',
    'sci.space',
]
twenty_train_subset = load_files('20news-bydate-train/', categories=categories, charset='latin-1')
twenty_test_subset = load_files('20news-bydate-test/', categories=categories, charset='latin-1')

vectorizer = CountVectorizer()
X_train = vectorizer.fit_transform(twenty_train_subset.data)



#Comparing decision tree and random forest classifiers
from sklearn.ensemble import RandomForestClassifier
from sklearn.cross_validation import cross_val_score
from sklearn.tree import DecisionTreeClassifier

model = RandomForestClassifier(n_estimators=10, compute_importances=True)
model = model.fit(X_train.toarray(), twenty_train_subset.target)

#Sort the features by importance in classifying and print them 
print sorted(zip(model.feature_importances_, vectorizer.get_feature_names()), reverse=True)[:10]





