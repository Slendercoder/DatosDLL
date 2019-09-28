print("loading packages...")
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from sys import argv
import os

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
# print data[:3]

# Find accumulated score
# data = data.groupby('Stage').get_group(1)
data['Ac_Score'] = data['Score'].cumsum()

# Find the min value of score
# minimum_score = data['Score'].min()
# maximum_score = data['Score'].max()

# Find the number of rounds
Num_Rondas = data.Round.unique().max()
print("Numero de rondas: ", Num_Rondas)
# This is for the graphics with visited locations
# step = 1. / Num_Loc

directorio_graficas = 'Graficas/'


# directorios = ['../Graficas/score', '../Graficas/ac_score', \
#     '../Graficas/consistency/', '../Graficas/dist_path', \
#     '../Graficas/dist_comp', '../Graficas/vis_loc', \
#     '../Graficas/Demographic', '../Graficas/Norm_Score',\
#     '../Graficas/fairness', '../Graficas/dlindex']

# directorios = ['/Graficas', '/Graficas/score', '/Graficas/ac_score', \
#     '/Graficas/consistency/', '/Graficas/dist_path', \
#     '/Graficas/dist_comp', '/Graficas/vis_loc']

# print "Verifying paths..."
#
# for d in directorios:
#     try:
#         os.makedirs(d)
#         print "Creating " + d
#     except OSError:
#         if not os.path.isdir(d):
#             raise


# Modifica el tamanho de letra de las legendas en las graficas
plt.rc('legend', fontsize=16)

# Produce graphics
print("Producing graphics...")

for stg, GRP in data.groupby(['Stage']):
    for Key, grp in GRP.groupby(['Dyad']):
        # figs for Score
        print("Preparando figuras para score por ronda...")
        fig, axes = plt.subplots(1,2)
        for a in axes:
            a.set_xlabel('Rounds', fontsize = 18)
            a.set_ylabel('Score', fontsize = 18)
            a.set_ylim([-0.1, 5.1])
            # a.set_ylim([minimum_score-2, maximum_score+2])
        axes[1].yaxis.tick_right()
        axes[1].yaxis.set_label_position("right")

        print("Preparando figuras para accumulated score por ronda...")
        # figs for Accumulated Score
        fig1, axes1 = plt.subplots(1,2)
        for a in axes1:
            a.set_xlabel('Rounds', fontsize = 18)
            a.set_ylabel('Accumulated Score', fontsize = 18)
        axes1[1].yaxis.tick_right()
        axes1[1].yaxis.set_label_position("right")

        # Plot per player
        i = 0
        for key, Grp in grp.groupby(['Player']):
            # Plot Score
            fig.suptitle('Dyad: ' + str(Key))
            Grp['Score'].plot(use_index=False, x=Grp['Round'], ax=axes[i], \
                                title='Player: ' + str(key))
            print("Score of player " + str(Key) + " dibujado")

            # Plot Accumulated Score
            fig1.suptitle('Dyad: ' + str(Key))
            Grp['Ac_Score'].plot(use_index=False, x=Grp['Round'], ax=axes1[i], \
                                    title='Player: ' + str(key))
            print("Accumulated Score of player " + str(Key) + " dibujado")

            i += 1

        print("Verifying paths for dyad...")
        d = directorio_graficas + "Stage_" + str(stg) + "_" + str(Key)
        try:
            os.makedirs(d)
            print("Creating " + d)
        except OSError:
            if not os.path.isdir(d):
                raise
        fig.savefig(directorio_graficas + "Stage_" + str(stg) + "_" + str(Key) + '/score.png')
        fig1.savefig(directorio_graficas + "Stage_" + str(stg) + "_" + str(Key) + '/ac_score.png')
        plt.close(fig)
        plt.close(fig1)

print('Done!')
