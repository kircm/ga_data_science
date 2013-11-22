import pandas as pd

data = pd.read_csv('/home/kirchnermarc/general_assembly/data_science/git/cloned/jseabold/538model/data/2012_poll_data_states.csv', sep='\t')
print data['Poll']
data.describe()

data['Poll'].value_counts()

g = data.groupby('Poll')['Obama (D)'].mean()
print g



