import sklearn

from sklearn.datasets import load_iris
iris = load_iris()

print iris.data
print iris.target

from sklearn import neighbors
X, y = iris.data, iris.target

#Create a KNN classifier object of the neighbors library
model = neighbors.KNeighborsClassifier(n_neighbors=1)
#Use the model to fit it to our data
model.fit(X, y)

print model
predictions = model.predict(iris.data)
print predictions[1:10]

print model.score(iris.data, iris.target)

# What kind of iris has 3cm x 5cm sepal and 4cm x 2cm petal?
#print iris.target_names[model.predict([[3, 5, 4, 2]])]

from sklearn.cross_validation import cross_val_score

from sklearn import linear_model
model = linear_model.LogisticRegression()
model = model.fit(iris.data, iris.target)
model.score(iris.data, iris.target)

print cross_val_score(model, iris.data, iris.target, cv=10) 


