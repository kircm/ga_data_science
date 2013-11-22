#Exercise: build a recommendation system based on user-id-brand name pairs in CSV
#Logic: find similar brands based on th users who like them 

from collections import defaultdict
import operator

#Load data into dictionary structures
f = open('user-brands.csv')

user_brands = defaultdict(list)
brand_users = defaultdict(list)

for line in f:
	user, brand = f.next().split(',')
	brand_users[brand].append(user)
	user_brands[user].append(brand)

f.close()

print len(brand_users.keys())
print len(user_brands.keys())



#Calculate similarity matrix
similarity = {}
brand_list = brand_users.keys()
for brand1 in brand_list:
	for brand2 in brand_list:
		inters = set(brand_users[brand1]).intersection(set(brand_users[brand2]))
		unio = set(brand_users[brand1]).union(set(brand_users[brand2]))
		jac = len(inters) * 1.0 / len(unio)
		key = tuple(sorted((brand1, brand2)))
		similarity[key] = jac

#Similarty is a dictionary that maps a key (a tuple of two brands) to a value (the similarity between the two brands in the key)
print similarity[('Columbia\n', 'Journeys\n')]
print similarity[('Columbia\n', 'Columbia\n')]
print similarity[('Columbia\n', 'Columbia\n')]





# Recommend 3 brands to a user (Marc's code)
def recommend(user):
	recommended_brands_and_scores = defaultdict(int)
	for user_brand in user_brands[user]:
		for current_brand in brand_list:
			if (user_brand != brand):				
				current_similarity = similarity[tuple(sorted((current_brand, user_brand)))]
				#accumulate similarity of the current user brand with the current brand
				recommended_brands_and_scores[current_brand] += current_similarity
	sorted_recommended_brands_and_scores = sorted(recommended_brands_and_scores.iteritems(), key=operator.itemgetter(0), reverse=True)
	return sorted_recommended_brands_and_scores[0:10]

print recommend('90217')


#Alice's solution
def get_similar_brands(brand):
	brand_scores = defaultdict(int)
	for other_brand in brand_list:
		if brand == other_brand:
			continue
		key = tuple(sorted([brand, other_brand]))
		sim = similarity.get(key, 0)
		if sim > 0:
			brand_scores[other_brand] += sim
	return brand_scores

def recommend_alice(user):
	brands = user_brands[user]
	all_brand_scores = defaultdict(int)
	for brand in user_brands[user]:
		brand_scores = get_similar_brands(brand)
		for brand1, score in brand_scores.items():
			if brand1 not in user_brands[user]:
				all_brand_scores[brand1] += score
	return sorted(all_brand_scores.iteritems(), key=operator.itemgetter(0), reverse=True)

print('\n\n\n')
print recommend_alice('90217')
print user_brands.get('90217')







