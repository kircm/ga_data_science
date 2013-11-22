from sklearn.datasets import load_files
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.tree import DecisionTreeClassifier

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
y_train = twenty_train_subset.target

print X_train.toarray()[0]

vectorizer = CountVectorizer(max_features=10)
X_train = vectorizer.fit_transform(twenty_train_subset.data)

print vectorizer.get_feature_names()

model = DecisionTreeClassifier() 
model = model.fit(X_train.toarray(), y_train)

print model

print model.score(X_train.toarray(), y_train)

#To perform cross validation, to confirm that the score is correct across ways of splitting the data
from sklearn.cross_validation import cross_val_score


