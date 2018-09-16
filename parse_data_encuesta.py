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