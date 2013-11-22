import math

def mean_absolute_error(x,y):
      for (xi, yi) in zip(x,y):
        total = 0
        for (xi, yi) in zip(x,y):
           total = total + math.fabs(xi - yi)
        return total/len(x)


print mean_absolute_error([5],[3])


def mean_squared_error(x,y):
  total = 0.0
  for (xi, yi) in zip(x,y):
    total += (xi - yi)**2
  return total/len(x)

print mean_squared_error([0,0],[2,3])

# compact syntax for processing lists:
x = [1,2,3,4]
x2 = [i**2 for i in x]

print x2

# Rewriting mean squared error with this syntax
def mean_squared_error(x,y):
  new_list = [(xi-yi)**2 for (xi, yi) in zip(x,y)]
  total = float(sum(new_list)) 
  return total/len(x)


print mean_squared_error([0,0],[2,3])

