import sklearn
from sklearn.datasets import load_files

categories = [
    'alt.atheism',
    'talk.religion.misc',
    'comp.graphics',
    'sci.space',
]

twenty_train_subset = load_files('20news-bydate-train/', categories=categories, charset='latin-1')
twenty_test_subset = load_files('20news-bydate-test/', categories=categories, charset='latin-1')

print twenty_train_subset.data[0]

from sklearn.feature_extraction.text import CountVectorizer

v = CountVectorizer(stop_words='english')

# Functions to extract features and transform them into a sparce matrix of occurances of values 
# v.fit - v.fit_transform 

text_features = v.fit_transform(twenty_train_subset.data)

print text_features

# show the words that show in the first document 
print text_features.toarray()[0]

print v.get_feature_names()[1:10]


