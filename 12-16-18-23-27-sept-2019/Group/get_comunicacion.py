# Python 3.7

# 	Parse from json format into csv format
# 	It creates "comunicacion.csv"

print("Importing libraries...")
import json
import numpy as np
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
Contador = []
objetoSolicitado = []
rotulo = []
Sups = []
mensajeRecibido = []
time_sent = []
time_received = []
dictRecibido = {}

# Diccionario de experticias
razas = {}

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

	# Getting expertise from each player
	if Data[0][u'player'] == Players[0]:
		razas[Players[0]] = Data[0][u'Raza']
		razas[Players[1]] = Data[1][u'Raza']
	else:
		razas[Players[0]] = Data[1][u'Raza']
		razas[Players[1]] = Data[0][u'Raza']

	print('Razas:', razas)

	# Getting data from Comunicacion
	# Encuentra primero que se respondio a cada pedido
	for d in Data:
		try:
			print("Reading line with recibido data...", len(d[u'Respuesta']))
			p = d[u'player']
			s = d[u'stage'][u'stage']
			r = d[u'stage'][u'round']
			siNo = d[u'Respuesta'][0]
			tiempo = d[u'timestamp']
			# perro = d[u'Respuesta'][1]
			contador = int(d[u'Respuesta'][2])
			print("Tupla: ", (p, s, r, contador))
			dictRecibido[(p, s, r, contador)] = (siNo, tiempo)
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
			raza.append(razas[d[u'player']])
			s = d[u'stage'][u'stage']
			stage.append(s)
			r = d[u'stage'][u'round']
			ronda.append(r)
			rotulo.append(d[u'Comunicacion'][0])
			objetoSolicitado.append(d[u'Comunicacion'][1])
			Sups.append(d[u'Comunicacion'][2])
			time_sent.append(d[u'timestamp'])
			contador = d[u'Comunicacion'][3]
			Contador.append(contador)
			if Players[0] == d[u'player']:
				p = Players[1]
			else:
				p = Players[0]
			print("Tupla: ", (p, s, r, contador))
			try:
				o = dictRecibido[(p, s, r, contador)][0]
				t = dictRecibido[(p, s, r, contador)][1]
				mensajeRecibido.append(o)
				time_received.append(t)
			except:
				print("No response!")
				mensajeRecibido.append('-')
				time_received.append(np.nan)
		except:
			print("No comunicacion. Skip!")

dict = {
	'Dyad': pareja,
	'Player': jugador,
	'Raza': raza,
	'Stage': stage,
	'Round': ronda,
	'Contador': Contador,
	'Perro': objetoSolicitado,
	'Rotulo': rotulo,
	'suposicion': Sups,
	'Recibido': mensajeRecibido,
	'Time_sent': time_sent,
	'Time_received': time_received
}

data = pd.DataFrame.from_dict(dict)

# Encontrando tipo de perro para cada pareja y cada ronda
perros_dict = {}
for counter in indices:
	# Opens json file with data from experiment and uploads it into Data
	data_archivo = 'data_lgc' + counter + '.json'
	with open(data_archivo) as data_file:
		Data = json.load(data_file)
	data_file.close()

	# --------------------------------------------------
	# Processing information about dogs
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

	# Getting data from Puntaje
	for d in Data:
		try:
			print("Reading line with puntaje data...", len(d[u'Puntaje']))
			print('******************', d[u'stage'][u'stage'])
			print(d[u'Puntaje'][1])
			print(type(d[u'stage'][u'stage']))
			if d[u'stage'][u'stage'] == 2:
				perros_dict[(dyadName, d[u'stage'][u'round'])] = d[u'Puntaje'][1]
		except:
			print("No score. Skip!")

print(perros_dict)

print(data[['Dyad', 'Round', 'Perro']][:10])

def kind_dog(x):
	dupla = (x['Dyad'], x['Round'])
	print('dupla', dupla)
	perro = int(str(x['Perro'])[-1])
	print('Numero de perro', perro)
	try:
		tipo = perros_dict[dupla][perro - 1]
	except:
		tipo = np.nan
	print('Tipo perro', tipo)
	return tipo

data['Kind'] = data.apply(lambda x: kind_dog(x), axis=1)

def correcto(x):
	if x['Kind'] == "":
		return(np.nan)
	elif (x['Rotulo'] == x['Kind']) and (x['Recibido'] == 'Si'):
		return(1)
	elif (x['Rotulo'] != x['Kind']) and (x['Recibido'] == 'No'):
		return(1)
	else:
		return(0)

data['Correctitud'] = data.apply(lambda x: correcto(x), axis=1)

# def cooperacion(x):
#
# 	rounds = [i for i in range(1, 26)]
# 	per_round = dict.fromkeys(rounds, 0)
# 	cont_round = dict.fromkeys(rounds, 0)
# 	index = dict.fromkeys(rounds, 0)
#
# 	# SUMAS DE MENSAJES CORRECTOS POR RONDA
#
# 	for i in range(0, len(x['Correctitud'])):
# 		# if(x['Correctitud'][i] == 1.0):
# 		# 	per_round[x['Round'][i]] += 1
# 		if (x['Raza'][i] == 'hound'):
# 			if(x['Rotulo'][i] == 'A' or x['Rotulo'][i] == 'C'):
# 				if(x['Correctitud'][i] == 1.0):
# 					per_round[x['Round'][i]] += 1
# 		if (x['Raza'][i] == 'terrier'):
# 			if(x['Rotulo'][i] == 'B' or x['Rotulo'][i] == 'D'):
# 				if(x['Correctitud'][i] == 1.0):
# 					per_round[x['Round'][i]] += 1
#
# 	# ASIGNA A CADA RONDA EL VALOR MAXIMO QUE ALCANZO EL CONTADOR DE MENSAJES
#
# 	for i in range(0, len(x['Contador'])):
# 		if(x['Contador'][i] > cont_round[x['Round'][i]]):
# 			cont_round[x['Round'][i]] = x['Contador'][i]
#
# 	# COCIENTES: SUMAS DE MENSAJES CORRECTOS POR RONDA DIVIDIDAS ENTRE NUMERO DE MENSAJES POR RONDA
#
# 	for i in range(1, 26):
# 		if (cont_round[i] != 0):
# 			index[i] = float(float(per_round[i])/float(cont_round[i]))
#
# 	# INDICE DE COOPERACION: SUMA DE COCIENTES POR RONDA DIVIDIDA ENTRE 25
#
# 	var = 0
#
# 	for i in range(1, 26):
# 		var += index[i]
# 	var = var/25
#
# 	print('***DICCIONARIO DE SUMAS', per_round)
# 	print('***DICCIONARIO DE CONTADORES', cont_round)
# 	print('***DICCIONARIO DE INDICES', index)
# 	print('***INDICE DE COOPERACION', var)
#
# 	return var
#
# cooperacion(data)
# # Making sure there is at least one line per round per player

# for pl, grp in data.groupby('Player'):
# 	print('Expertise check...')
# 	try:
# 		print(razas[list(grp.Player.unique())[0]])
# 		print('Expertise ok!')
# 	except:
# 		print('Expertise error!')
# 		print('Dyad', list(grp.Dyad.unique())[0])
# 		print('Player', list(grp.Player.unique())[0])
# 		print('Round', list(grp.Round.unique())[0])
# 		print(razas)
# 	rondas = list(grp.Round.unique())
# 	# print('Rounds', rondas)
# 	rondas_faltantes = [x for x in range(1, 26) if x not in rondas]
# 	print('Missing rounds', rondas_faltantes)
# 	for ronda in rondas_faltantes:
# 		print('Including round', ronda)
# 		data = data.append({'Dyad': list(grp.Dyad.unique())[0],
# 		'Player': list(grp.Player.unique())[0],
# 		'Raza': razas[list(grp.Player.unique())[0]],
# 		'Stage': list(grp.Stage.unique())[0],
# 		'Round': ronda,
# 		'Contador': 0,
# 		'Perro': np.nan,
# 		'Rotulo': np.nan,
# 		'suposicion': np.nan,
# 		'Recibido': np.nan}, ignore_index=True)
# 		print(data[-3:-1])
#
# jugadores = list(data.Player.unique())
# print('jugadores', jugadores)
# for ronda, grp in data.groupby('Round'):
# 	print('Working with round', ronda)
# 	lista = list(grp.Player.unique())
# 	for pl in jugadores:
# 		if pl not in lista:
# 			print('Player', pl, ' not in DataFrame')
# 			data = data.append({'Dyad': list(grp.Dyad.unique())[0],
# 			'Player': pl,
# 			'Raza': razas[pl],
# 			'Stage': list(grp.Stage.unique())[0],
# 			'Round': ronda,
# 			'Contador': 0,
# 			'Perro': np.nan,
# 			'Rotulo': np.nan,
# 			'suposicion': np.nan,
# 			'Recibido': np.nan}, ignore_index=True)
#

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
