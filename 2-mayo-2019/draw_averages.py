print("loading packages...")
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from sys import argv
import os

directorio_graficas = 'Graficas/'

script, data_archivo = argv
# N = input("Please enter the number n such that the experiment had an nxn grid: ")
# Num_Loc = int(N)

# Vid_graph = input("Do you want to create graphics for measures? (1=YES/0=NO): ")
#
# Vid = input("Do you want to create figures for the videos? (1=YES/0=NO): ")

# Opens the file with data from DCL experiment and parses it into data
print("Reading data...")
#data = pd.read_csv(data_archivo, sep='\t', header=0)
data = pd.read_csv(data_archivo, index_col=False)
#data = pd.read_csv(data_archivo, index_col=False)
print("Data readed!")
print(data[:3])

titulo = ['Training Rounds', 'Game Rounds']

# Find accumulated score
# data = data.groupby('Stage').get_group(1)
for key, grp in data.groupby('Stage'):

    print(grp[:3])
    # Preparing figures for average score
    fig, axes = plt.subplots()
    axes.set_xlabel('Rounds')
    axes.set_ylabel('Average Score')
    axes.set_ylim(-0.1, 5.1)

    # Preparing figures for average accumulated score
    fig1, axes1 = plt.subplots()
    axes1.set_xlabel('Rounds')
    axes1.set_ylabel('Average Accumulated Score')
    axes1.set_ylim(-0.1, 25*5)

    df = pd.DataFrame(grp.groupby('Round')['Score'].mean())
    df['Ac_Score'] = df['Score'].cumsum()
    # print(df[:3])

    df['Score'].plot(ax=axes, title=titulo[int(key) - 1])
    print("Average Score of player " + str(key) + " dibujado")

    df['Ac_Score'].plot(ax=axes1, title=titulo[int(key) - 1])
    print("Average Ac. Score of player " + str(key) + " dibujado")

    print("Verifying paths for dyad...")
    d = directorio_graficas + "Stage" + str(key)
    try:
        os.makedirs(d)
        print("Creating " + d)
    except OSError:
        if not os.path.isdir(d):
            raise

    fig.savefig(directorio_graficas + "Stage" + str(key) + '/score.png')
    fig1.savefig(directorio_graficas + "Stage" + str(key) + '/ac_score.png')
    plt.close(fig)
    plt.close(fig1)
