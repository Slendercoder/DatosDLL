# Python 3.7

# 	Parse from json format into csv format
# 	It creates "comunicacion.csv"

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
stage = []
ronda = []
Contador = []
objetoSolicitado = []
rotulo = []
Sups = []
mensajeRecibido = []
dictRecibido = {}

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

	# Getting data from Comunicacion
	# Encuentra primero que se respondio a cada pedido
	for d in Data:
		try:
			print("Reading line with recibido data...", len(d[u'Respuesta']))
			p = d[u'player']
			s = d[u'stage'][u'stage']
			r = d[u'stage'][u'round']
			siNo = d[u'Respuesta'][0]
			# perro = d[u'Respuesta'][1]
			contador = int(d[u'Respuesta'][2])
			print("Tupla: ", (p, s, r, contador))
			dictRecibido[(p, s, r, contador)] = siNo
			# m = int(d[u'Respuesta'][1])
			# dictRecibido[(p, r, m)] = d[u'Respuesta'][0]
			# print(dictRecibido)
		except:
			print("No respuesta. Skip!")
		# # Verificar el mal marcado Comunicacion: Ignorar
		# try:
		# 	print("Verificando Ignorar escondido", len(d[u'Comunicacion']))
		# 	if d[u'Comunicacion'][0] == 'Ignorar':
		# 		print("Pillado!")
		# 		p = d[u'player']
		# 		r = d[u'stage'][u'round']
		# 		m = d[u'Comunicacion'][1]
		# 		dictRecibido[(p, r, m)] = 'Ignorar'
		# 		print(dictRecibido)
		# except:
		# 	print("Continue")

	for d in Data:
		try:
			print("Reading line with comunicacion data...", len(d[u'Comunicacion']))
			# print('Intentando...')
			pareja.append(dyadName)
			jugador.append(d[u'player'])
			s = d[u'stage'][u'stage']
			stage.append(s)
			r = d[u'stage'][u'round']
			ronda.append(r)
			rotulo.append(d[u'Comunicacion'][0])
			objetoSolicitado.append(d[u'Comunicacion'][1])
			Sups.append(d[u'Comunicacion'][2])
			contador = d[u'Comunicacion'][3]
			Contador.append(contador)
			if Players[0] == d[u'player']:
				p = Players[1]
			else:
				p = Players[0]
			print("Tupla: ", (p, s, r, contador))
			try:
				o = dictRecibido[(p, s, r, contador)]
				mensajeRecibido.append(o)
			except:
				print("No response!")
				mensajeRecibido.append('-')
		except:
			print("No comunicacion. Skip!")

dict = {
	'Dyad': pareja,
	'Player': jugador,
	'Stage': stage,
	'Round': ronda,
	'Contador': contador,
	'Perro': objetoSolicitado,
	'Rotulo': rotulo,
	'suposicion': Sups,
	'Recibido': mensajeRecibido
}
data = pd.DataFrame.from_dict(dict)

archivo = 'comunicacion.csv'
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
