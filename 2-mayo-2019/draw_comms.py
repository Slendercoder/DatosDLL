print("loading packages...")
import pandas as pd
import matplotlib.pyplot as plt
import os

data_archivo = 'comunicacion.csv'
# Opens the file with data from DCL experiment and parses it into data
print("Reading data...")
#data = pd.read_csv(data_archivo, sep='\t', header=0)
data = pd.read_csv(data_archivo, index_col=False)
print("Data read!")
# print data[:3]

# Checking daataframe has the required columns
lleno = 1
try:
    print(data['Dog'][:3])
except:
    lleno = 0
assert(lleno == 1), "Error: comunicacion.csv incompleto. Intente primerto\n > python3 crea_dicts_comunicacion.py"

print("Verifying path...")
d = 'Graficas/'
try:
    os.makedirs(d)
    print("Creating " + d)
except OSError:
    if not os.path.isdir(d):
        raise

# Creating tables
data['Rotulo'] = pd.Categorical(data['Rotulo'])

data1 = pd.DataFrame(data.groupby('Recibido').get_group('Si'))
tabla1 = pd.crosstab(index=data1['Rotulo'], columns=data1['Guess']).apply(lambda r: r/r.sum(), axis=1)
fig1, axes1 = plt.subplots()
fig1.suptitle('Affirmative response from partner')
tabla1.plot(kind='bar', stacked=True, ax=axes1, rot=0)
fig1.savefig(d + 'affResp.png')
plt.close(fig1)

data2 = pd.DataFrame(data.groupby('Recibido').get_group('No'))
tabla2 = pd.crosstab(index=data2['Rotulo'], columns=data2['Guess']).apply(lambda r: r/r.sum(), axis=1)
fig2, axes2 = plt.subplots()
fig2.suptitle('Negative response from partner')
tabla2.plot(kind='bar', stacked=True, ax=axes2, rot=0)
fig2.savefig(d + 'negResp.png')
plt.close(fig2)

print('Done!')
