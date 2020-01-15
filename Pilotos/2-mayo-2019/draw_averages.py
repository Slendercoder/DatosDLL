print("loading packages...")
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
# import matplotlib.patches as patches
# from sys import argv
import os

directorio_graficas = 'Graficas/'

# script, data_archivo = argv

graph_score = int(input("Do you want to create graphics for scores? (1=YES/0=NO): "))
graph_cat = int(input("Do you want to create graphics for categorization? (1=YES/0=NO): "))
graph_commu = int(input("Do you want to create graphics for communication? (1=YES/0=NO): "))

if graph_score == 1:

    data_archivo = 'puntaje.csv'

    # Opens the file with data from DCL experiment and parses it into data
    print("Reading data...")
    #data = pd.read_csv(data_archivo, sep='\t', header=0)
    data = pd.read_csv(data_archivo, index_col=False)
    #data = pd.read_csv(data_archivo, index_col=False)
    print("Data read!")
    print(data[:3])

    titulo = ['Training Rounds', 'Game Rounds']

    # Find accumulated score
    # data = data.groupby('Stage').get_group(1)
    # for key, grp in data.groupby('Stage'):

    # print(grp[:3])
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

    # df = pd.DataFrame(grp.groupby(['Stage', 'Round'])['Score'].mean())
    # df = pd.DataFrame(grp.groupby(['Stage', 'Round'])['Score'].mean())
    # df['Ac_Score'] = df['Score'].cumsum()
    # print(df[:3])

    data.groupby('Round')[['Stage', 'Score']].mean().plot(ax=axes)
    # df['Score'].plot(ax=axes, title=titulo[int(key) - 1])
    # print("Average Score of player " + str(key) + " dibujado")

    # df['Ac_Score'].plot(ax=axes1)
    # # df['Ac_Score'].plot(ax=axes1, title=titulo[int(key) - 1])
    # print("Average Ac. Score of player " + str(key) + " dibujado")

    print("Verifying paths for dyad...")
    d = directorio_graficas
    # d = directorio_graficas + "Stage" + str(key)
    try:
        os.makedirs(d)
        print("Creating " + d)
    except OSError:
        if not os.path.isdir(d):
            raise

    fig.savefig(directorio_graficas + '/score.png')
    fig1.savefig(directorio_graficas + '/ac_score.png')
    # fig.savefig(directorio_graficas + "Stage" + str(key) + '/score.png')
    # fig1.savefig(directorio_graficas + "Stage" + str(key) + '/ac_score.png')
    plt.close(fig)
    plt.close(fig1)

if graph_cat == 1:

    data_archivo = 'paraK.csv'

    # Opens the file with data from DCL experiment and parses it into data
    print("Reading data...")
    #data = pd.read_csv(data_archivo, sep='\t', header=0)
    data = pd.read_csv(data_archivo, index_col=False)
    #data = pd.read_csv(data_archivo, index_col=False)
    print("Data read!")
    print(data[:3])

    data['Cat'] = data['Object'].apply(lambda x: x[0])
    print(data[:5])
    data['Result'] = np.where(data['Cat'] == data['Label'], 'Correct', 'Incorrect')

    # Determining training categories
    dict_expert = {}
    aux = pd.DataFrame(data.groupby('Stage').get_group(1))
    for jugador, grp in aux.groupby('Player'):
        dict_expert[jugador] = list(grp.Label.unique())

    # Determining percentage of accurracy TRAINING
    tabla1 = pd.crosstab(index=aux['Cat'], columns=aux['Result']).apply(lambda r: r/r.sum(), axis=1)
    fig1, axes1 = plt.subplots()
    fig1.suptitle('Correct classification ---Training rounds---')
    tabla1.plot(kind='bar', stacked=True, ax=axes1, rot=0)

    print("Verifying paths for dyad...")
    d = directorio_graficas
    try:
        os.makedirs(d)
        print("Creating " + d)
    except OSError:
        if not os.path.isdir(d):
            raise

    fig1.savefig(d + 'correctClassTraining.png')
    plt.close(fig1)

    # Consolidating expertice
    aux = pd.DataFrame(data.groupby('Stage').get_group(2))
    aux['Expert'] = aux['Player'].map(dict_expert)

    def res(x, y):
        if x in y:
            return 'Trained'
        else:
            return 'Untrained'
    aux['Cat_expert'] = aux[['Cat','Expert']].apply(lambda x: res(*x), axis=1)

    # Determining percentage of accurracy GAME
    tabla2 = pd.crosstab(index=aux['Cat_expert'], columns=aux['Result']).apply(lambda r: r/r.sum(), axis=1)

    fig2, axes2 = plt.subplots()
    fig2.suptitle('Correct classification ---Game rounds---')
    tabla2.plot(kind='bar', stacked=True, ax=axes2, rot=0)
    fig2.savefig(d + 'correctClassGame.png')
    plt.close(fig2)

if graph_commu == 1:

    data_archivo = 'comunicacion.csv'

    # Opens the file with data from DCL experiment and parses it into data
    print("Reading data...")
    #data = pd.read_csv(data_archivo, sep='\t', header=0)
    data = pd.read_csv(data_archivo, index_col=False)
    #data = pd.read_csv(data_archivo, index_col=False)
    print("Data read!")
    print(data[:3])

    # Find amount of communication
    # Preparing figures for average score
    fig, axes = plt.subplots()
    axes.set_xlabel('Rounds')
    axes.set_ylabel('Average number of messages')
    # axes.set_ylim(-0.1, 5.1)

    dyads = data.Dyad.unique()
    parejas = []
    ronda = []
    contadores = []
    for key, grp in data.groupby('Dyad'):
        rondas = grp.Round.unique()
        for i in range(1, 26):
            parejas.append(key)
            ronda.append(i)
            if i not in rondas:
                contadores.append(0)
            else:
                a = grp.groupby('Round')['Contador'].get_group(i).max()
                contadores.append(a)
            #
            # print(parejas[-1], ronda[-1], contadores[-1])

    df = pd.DataFrame.from_dict({'Dyad': parejas, 'Round': ronda, 'Contador': contadores})
    print(df[:5])
    df1 = pd.DataFrame(df.groupby('Round')['Contador'].mean())
    df1['Contador'].plot(ax=axes, title='Amount of communication')

    print("Verifying paths for dyad...")
    d = directorio_graficas
    try:
        os.makedirs(d)
        print("Creating " + d)
    except OSError:
        if not os.path.isdir(d):
            raise

    fig.savefig(directorio_graficas + '/amount_comm.png')
    plt.close(fig)
