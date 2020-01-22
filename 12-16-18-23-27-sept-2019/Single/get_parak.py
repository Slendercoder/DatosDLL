# Python 3.7

# 	Parse from json format into csv format
# 	It creates "puntaje.csv"

print("Importing libraries...")
import json
#import numpy as np
import pandas as pd
print("Done!")

######################################################
# Functions
######################################################

def correctness(x):
	guess = list(x['Object'])[0]
	# print('guess', guess)
	if guess == x['Label']:
		return 1
	else:
		return 0

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
Imagen = []
Rotulo = []

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
	assert(len(Players) == 1), "Error: Pareja no contiene numero exacto de jugadores!"

	dyadName = str(Players[0][:5]) + '-' + str(Players[0][:5])
	print("Dyad name: ", dyadName)

	razas = ""
	for d in Data:
		# Encontrando razas
		try:
			if d[u'stage'][u'stage'] == 5:
				if d[u'ParaK'][1] == "A" or d[u'ParaK'][1] == "C":
					razas = "terrier"
				else:
					razas = "hound"
				break
		except:
			print("Orden raro :(")

	# Getting data from paraK
	for d in Data:
		try:
			print("Reading line with paraK data...", len(d[u'ParaK']))
			pareja.append(dyadName)
			jugador.append(d[u'player'])
			raza.append(razas)
			stage.append(d[u'stage'][u'stage'])
			ronda.append(d[u'stage'][u'round'])
			Imagen.append(d[u'ParaK'][0])
			Rotulo.append(d[u'ParaK'][1])
		except:
			print("No paraK. Skip!")

dict = {
	'Dyad': pareja,
	'Player': jugador,
	'Raza': raza,
	'Stage': stage,
	'Round': ronda,
	'Object': Imagen,
	'Label': Rotulo
}
data = pd.DataFrame.from_dict(dict)

# Finds kind of dog
data['Kind'] = data.apply(lambda x: list(x['Object'])[0], axis=1)

# Determining correctness per classification
data['Correct'] = data.apply(lambda x: correctness(x), axis=1)

archivo = 'paraK.csv'
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
