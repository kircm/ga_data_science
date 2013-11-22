# Aaron class
# homework assignement - logistic regression and naive bayes

import pandas as pd
train = pd.read_csv('train.csv')
test = pd.read_csv('test.csv')

from sklearn.feature_extraction.text import CountVectorizer
vectorizer = CountVectorizer()
X_train = vectorizer.fit_transform(train.Comment)

X_train.shape

X_test = vectorizer.transform(test.Comment)

from sklearn.naive_bayes import MultinomialNB
from sklearn.linear_model import LogisticRegression
from sklearn.cross_validation import cross_val_score
from sklearn.metrics import auc_score

#Using Naive Bayes
cross_val_results_naive_bayes = cross_val_score(MultinomialNB(), X_train, train.Insult, score_func=auc_score, cv=10)
print cross_val_results_naive_bayes
print cross_val_results_naive_bayes.mean()

#Using logistic regression
cross_val_results_logistic_regression = cross_val_score(LogisticRegression(), X_train, train.Insult, score_func=auc_score, cv=10)

print cross_val_results_logistic_regression
print cross_val_results_logistic_regression.mean()


classifier = MultinomialNB().fit(X_train, list(train.Insult))

predictions = classifier.predict_proba(X_test)

print predictions
#The predictions are an array of arrays where each prediction shows the probability of not being an insult and the prob. of being an insult
print predictions[:,1]
print type(predictions)
print predictions.size

submission = pd.DataFrame({'id': test.id, 'insult': predictions[:,1]})

print submission

submission.to_csv('submission_insult.csv', index=False)















