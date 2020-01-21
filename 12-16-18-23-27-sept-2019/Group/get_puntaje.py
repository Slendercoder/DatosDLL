# Python 3.7

# 	Parse from json format into csv format
# 	It creates "puntaje.csv"

print("Importing libraries...")
import json
#import numpy as np
import pandas as pd
print("Done!")


######################################################
# Data parsing begins here...
######################################################

N = input("How many data_lgc*.json files are to be parsed?: ")
End = int(N)

indices = []      # Saves the numbers that correspond to data_lgc*.json in folder
D_Frames = []     # Saves the dataframes created for performance from each file

for i in range(1, int(End) + 1):
	print('Trying to open file ' + 'data_lgc' + str(i) + '.json')
	try:
		f = open('data_lgc' + str(i) + '.json', 'r')
		print("OK!")
		f.close()
		indices.append(str(i))
	except:
		print("No good! No indice " + str(i))

# Listas con datos
pareja = []
jugador = []
raza = []
stage = []
ronda = []
puntaje = []

for counter in indices:
	# Opens json file with data from experiment and uploads it into Data
	data_archivo = 'data_lgc' + counter + '.json'
	with open(data_archivo) as data_file:
		Data = json.load(data_file)
	data_file.close()

	# --------------------------------------------------
	# Processing information of players performance
	# --------------------------------------------------

	# Finding dyad
	Players = []
	for d in Data:
		if d[u'player'] not in Players:
			Players.append(d[u'player'])

	print("Lista de jugadores: ", Players)
	assert(len(Players) == 2), "Error: Pareja no contiene numero exacto de jugadores!"

	dyadName = str(Players[0][:5]) + '-' + str(Players[1][:5])
	print("Dyad name: ", dyadName)

	razas = {}
	if Data[0][u'player'] == Players[0]:
		razas[Players[0]] = Data[0][u'Raza']
		razas[Players[1]] = Data[1][u'Raza']
	else:
		razas[Players[0]] = Data[1][u'Raza']
		razas[Players[1]] = Data[0][u'Raza']

	print('Razas:', razas)

	# Getting data from Puntaje
	for d in Data:
		try:
			print("Reading line with puntaje data...", len(d[u'Puntaje']))
			pareja.append(dyadName)
			raza.append(razas[d[u'player']])
			jugador.append(d[u'player'])
			stage.append(d[u'stage'][u'stage'])
			ronda.append(d[u'stage'][u'round'])
			puntaje.append(d[u'Puntaje'][2])
		except:
			print("No score. Skip!")

dict = {
	'Dyad': pareja,
	'Player': jugador,
	'Raza': raza,
	'Stage': stage,
	'Round': ronda,
	'Score': puntaje
}
data = pd.DataFrame.from_dict(dict)

archivo = 'puntaje.csv'
data.to_csv(archivo, index=False)
print("Data saved to ", archivo)

	# matricesFrecuenciasP1 = [[[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]]]
	# matricesFrecuenciasP2 = [[[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]]]
	# # Each matrix in the list represents a round in the game. The rows and columns in the matrices represent the words and the shapes in the game
	# contador = 0
	# player1 = Data[0][u'player']
	# for d in Data:
	# 	print "Counter: ", contador
	# 	if d[u'stage'][u'stage'] == 3:
	# 		if d[u'stage'][u'step'] == 2:
	# 			try:
	# 				for i in range(1, 4):
	# 					if d[u'Encuesta'][i]:
	# 						if d[u'Encuesta'][0] == "Circulo":
	# 							if d[u'player'] == player1:
	# 								matrizFrecuenciasp1[d[u'stage'][u'round']-1][i-1][0] += 1
	# 							else:
	# 								matrizFrecuenciasp2[d[u'stage'][u'round']-1][i-1][0] += 1
	# 						elif d[u'Encuesta'][0] == "Cuadrado":
	# 							if d[u'player'] == player1:
	# 								matrizFrecuenciasp1[d[u'stage'][u'round']-1][i-1][1] += 1
	# 							else:
	# 								matrizFrecuenciasp2[d[u'stage'][u'round']-1][i-1][1] += 1
	# 						else:
	# 							if d[u'player'] == player1:
	# 								matrizFrecuenciasp1[d[u'stage'][u'round']-1][i-1][2] += 1
	# 							else:
	# 								matrizFrecuenciasp2[d[u'stage'][u'round']-1][i-1][2] += 1
	# 						break
	# 			except:
	# 				print "No communication phase. Skip!"
	# 	contador += 1
