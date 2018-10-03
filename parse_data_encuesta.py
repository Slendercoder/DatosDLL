# 	Parse from json format into csv format
# 	It creates "performance_file_*.csv"

print "Importing libraries..."
import json
#import numpy as np
import pandas as pd
print "Done!"


######################################################
# Data parsing begins here...
######################################################

N = input("How many data_lgc*.json files are to be parsed?: ")
End = int(N)

indices = []            # Saves the numbers that correspond to data_lgc*.json in folder
D_Frames = []     # Saves the dataframes created for performance from each file

for i in range(1, int(End) + 1):
	print "Trying to open file " + 'data_lgc' + str(i) + '.json'
	try:
		f = open('data_lgc' + str(i) + '.json', 'r')
		print "OK!"
		f.close()
		indices.append(str(i))
	except:
		print "No good! No indice " + str(i)

for counter in indices:
	# Opens json file with data from DCL experiment and uploads it into Data
	data_archivo = 'data_lgc' + counter + '.json'
	with open(data_archivo) as data_file:
		Data = json.load(data_file)
	data_file.close()

	# --------------------------------------------------
	# Processing information of players performance
	# --------------------------------------------------


	# Getting data from stage 3
	matricesFrecuenciasP1 = [[[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]]]
	matricesFrecuenciasP2 = [[[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]]]
	# Each matrix in the list represents a round in the game. The rows and columns in the matrices represent the words and the shapes in the game
	contador = 0
	player1 = Data[0][u'player']
	for d in Data:
		print "Counter: ", contador
		if d[u'stage'][u'stage'] == 3:
			if d[u'stage'][u'step'] == 2:
				try:
					for i in range(1, 4):
						if d[u'Encuesta'][i]:
							if d[u'Encuesta'][0] == "Circulo":
								if d[u'player'] == player1:
									matrizFrecuenciasp1[d[u'stage'][u'round']-1][i-1][0] += 1
								else:
									matrizFrecuenciasp2[d[u'stage'][u'round']-1][i-1][0] += 1
							elif d[u'Encuesta'][0] == "Cuadrado":
								if d[u'player'] == player1:
									matrizFrecuenciasp1[d[u'stage'][u'round']-1][i-1][1] += 1
								else:
									matrizFrecuenciasp2[d[u'stage'][u'round']-1][i-1][1] += 1
							else:
								if d[u'player'] == player1:
									matrizFrecuenciasp1[d[u'stage'][u'round']-1][i-1][2] += 1
								else:
									matrizFrecuenciasp2[d[u'stage'][u'round']-1][i-1][2] += 1
							break
				except:
					print "No communication phase. Skip!"
		contador += 1
	
	# Relative frequencies of every word in each round
	frecuenciasRelP1 = [[[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]]]
	frecuenciasRelP2 = [[[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]], [[0,0,0], [0,0,0], [0,0,0]]]
	
	# Filling the data in the matrices
	for rnd in range(5):
		for word in range(3):
			total = 0
			for shape in range(3):
				total += matricesFrecuenciasP1[rnd][word][shape]
			frecuenciasRelP1[rnd][mtrx][shape] = matricesFrecuenciasP1[rnd][word][shape]/total
	for rnd in range(5):
		for word in range(3):
			total = 0
			for shape in range(3):
				total += matricesFrecuenciasP2[rnd][word][shape]
			frecuenciasRelP2[rnd][mtrx][shape] = matricesFrecuenciasP2[rnd][word][shape]/total

	# Difference between the greater and lesser value in each of the matrices in the relative frequencies arrays
	differencesP1 = [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]]
	differencesP2 = [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]]

	# Filling the data in the matrices
	for i in range(5):
		for j in range(3):
			difference = max(frecuenciasRelP1[i][j]) - min(frecuenciasRelP1[i][j])
			differencesP1[i][j] = difference
	for i in range(5):
		for j in range(3):
			difference = max(frecuenciasRelP2[i][j]) - min(frecuenciasRelP2[i][j])
			differencesP2[i][j] = difference