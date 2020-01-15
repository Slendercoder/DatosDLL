#-*- coding: utf-8 -*-
print("Importando paquetes...")
import pandas as pd
import matplotlib.pyplot as plt
import sys
import os
print("Listo!")

print("Leyendo datos...")
df = pd.read_csv('puntaje.csv')
print(df[:3])

# Creo la columna de umbrales
umbrales = {}
umbrales[1] = 1;
umbrales[2] = 3;
umbrales[3] = 5;
umbrales[4] = 10;
for i in range(5, 16):
    umbrales[i] = 15

# Organiza el DataFrame por Player
df = df.sort_values(['Dyad','Player', 'Round'], ascending=[True, True, True])

# Encontrando el puntaje de la ronda
aux = []
for key, grp in df.groupby(['Dyad', 'Player', 'Round']):
    dict = {}
    dict['Dyad'] = key[0]
    dict['Player'] = key[1]
    dict['Round'] = key[2]
    puntajeAcumulado = grp['Score'].sum()
    dict['Score'] = puntajeAcumulado
    dict['Threshold'] = umbrales[key[2]]
    # print("Puntaje acumulado " + str(key[1]) + " en la ronda " + str(key[2]) + " es: " + str(puntajeAcumulado))
    aux.append(dict)

data = pd.DataFrame(aux)

print(data[['Player', 'Round', 'Score', 'Threshold']][:30])

print("Verificando path...")
d = 'Graficas/'

try:
    os.makedirs(d)
    print("Creando " + d)
except OSError:
    if not os.path.isdir(d):
        raise

# Encuentra puntajes máximo y mínimo
minimum_score = data['Score'].min()
maximum_score = data['Score'].max()

print(u"Puntaje mínimo " + str(minimum_score) + u"; Puntaje máximo " + str(maximum_score))

print(u"Generando gráficas...")
for Key, grp in data.groupby(['Dyad']):

    # figs for Score
    print("Preparando figuras para score por ronda...")
    fig, axes = plt.subplots(1,2)
    for a in axes:
        a.set_xlabel('Rounds', fontsize = 18)
        a.set_ylabel('Score', fontsize = 18)
        a.set_ylim([minimum_score-2, maximum_score+2])
    axes[1].yaxis.tick_right()
    axes[1].yaxis.set_label_position("right")

    # Plot per player
    i = 0
    for key, Grp in grp.groupby(['Player']):
        # Plot Score
        fig.suptitle('Dyad: ' + str(Key))
        Grp[['Score', 'Threshold']].plot(use_index=False, x=Grp['Round'], ax=axes[i], \
                            title='Player: ' + str(key))
        print("Score of player " + str(Key) + " dibujado")
        i += 1

    archivo = d + str(Key) + '_score.png'
    fig.savefig(archivo)
    print("Figura score de la pareja " + str(Key) + " dibujada en " + archivo)
    fig.close()

print("Buscando promedios...")
promedioScore = pd.DataFrame(data.groupby('Round')[['Score', 'Threshold']].mean())

promedioScore['umbralPropuesto'] = [1, 2, 3, 4, 5, 5, 5, 5, 6, 7, 8, 9, 10, 15, 15]

print(promedioScore)

fig, axes = plt.subplots()

promedioScore.plot(use_index=False, ax=axes, \
                    title='Player: ' + str(key))

archivo = d + 'meanScore.png'
fig.savefig(archivo)
