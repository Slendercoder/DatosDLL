#-*- coding: utf-8 -*-
print("Importando paquetes...")
import pandas as pd
import matplotlib.pyplot as plt
import sys
import os
print("Listo!")

print("Leyendo datos...")
df = pd.read_csv('marcacion.csv')
print(df[:3])

# Organiza el DataFrame por Player
df = df.sort_values(['Dyad','Player', 'Round'], ascending=[True, True, True])

# Encontrando el objeto de experticia del jugador
expertos = {}
problemas = []
for key, grp in df[['Dyad', 'Player', 'objectMarked']].groupby('Player'):
    marcados = grp.objectMarked.unique()
    if 'Xol' in marcados:
        experticia = 'Xol'
    elif 'Dup' in marcados:
        experticia = 'Dup'
    else:
        print("Faltan datos del jugador " + str(key))
        problemas.append(key)

    expertos[key] = experticia
    print("El jugador " + str(key) + " es experto en " + str(experticia))

print("")
print("Tratando de resolver problemas...")

grp = df.groupby('Player')
for key in problemas:
    print("Lidiando con jugador ", key)
    pareja = grp.get_group(key)['Dyad'].unique()[0]
    print("Pareja: ", pareja)
    jugadores = list(df.groupby('Dyad').get_group(pareja)['Player'].unique())
    print("Jugadores en la pareja: ", jugadores)
    assert(key in jugadores)
    for j in range(2):
        if jugadores[j] == key:
            otroJugador = jugadores[1 - j]
            break

    experticiaOtrojugador = expertos[otroJugador]
    print("Otro jugador: " + str(otroJugador) + " es experto en " + experticiaOtrojugador)
    if experticiaOtrojugador == 'Xol':
        expertos[key] = 'Dup'
        print("El jugador " + str(key) + " es experto en Dup")
    elif experticiaOtrojugador == 'Dup':
        expertos[key] = 'Xol'
        print("El jugador " + str(key) + " es experto en Xol")
    else:
        print("Problema: error en experticia!")

jugadores = list(df.Player.unique())
llaves = expertos.keys()
diferencia = [x for x in jugadores if x not in llaves]
print(diferencia)

if not diferencia:
    print("Todos los problemas resueltos: ")
else:
    print(u"Aún quedan problemas")

data = pd.DataFrame([{'Player': key, 'Expertice': expertos[key]} for key in llaves])

print(data)

sys.exit()

# Encontrando el porcentaje de marcación acertada de la ronda
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

sys.exit()

print("Verificando path...")
d = 'Graficas/'

try:
    os.makedirs(d)
    print "Creando " + d
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
        print "Score of player " + str(Key) + " dibujado"
        i += 1

    archivo = d + str(Key) + '_score.png'
    fig.savefig(archivo)
    print("Figura score de la pareja " + str(Key) + " dibujada en " + archivo)
