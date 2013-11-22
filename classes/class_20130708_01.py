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

# Turn the text documents into vectors of word frequencies
vectorizer = CountVectorizer()
X_train = vectorizer.fit_transform(twenty_train_subset.data)
# output: (document_id, word_id)  #appearences
print X_train



#Using TdfVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer
vectorizer = TfidfVectorizer()
X_train = vectorizer.fit_transform(twenty_train_subset.data)

# output (document_id, word)  weight_computed
print X_train
print vectorizer.get_feature_names()




#Changing the ngram range
vectorizer = TfidfVectorizer(ngram_range=(1,2))
X_train = vectorizer.fit_transform(twenty_train_subset.data)
#The vectorizer now counts words that appear together too
print vectorizer.get_feature_names()



#Adding stop words
vectorizer = TfidfVectorizer(ngram_range=(1,2), stop_words='english')
X_train = vectorizer.fit_transform(twenty_train_subset.data)
#The vectorizer now counts words that appear together too
print vectorizer.get_feature_names()




#Comparing decision tree and random forest classifiers
from sklearn.ensemble import RandomForestClassifier
from sklearn.cross_validation import cross_val_score
from sklearn.tree import DecisionTreeClassifier

vectorizer = TfidfVectorizer(stop_words='english', lowercase=True, ngram_range=(1,1), min_df=1)
X_train = vectorizer.fit_transform(twenty_train_subset.data)

tree_model = DecisionTreeClassifier()
print cross_val_score(tree_model, X_train.toarray(), twenty_train_subset.target)

rf_model = RandomForestClassifier(n_estimators=10)
print cross_val_score(rf_model, X_train.toarray(), twenty_train_subset.target)







