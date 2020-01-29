# Python 3.7

# 	Parse from json format into csv format
# 	It creates "indice.csv"

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
ronda = []
kind = []
pregunto = []

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

	if Data[0][u'player'] == Players[0]:
		razas[Players[0]] = Data[0][u'Raza']
		razas[Players[1]] = Data[1][u'Raza']
	else:
		razas[Players[0]] = Data[1][u'Raza']
		razas[Players[1]] = Data[0][u'Raza']

	print('Razas:', razas)

	# Getting data from communication
	dict_perro_comunicado = {}
	for i in range(len(Data)):
		try:
			perro = Data[i][u'Comunicacion'][1]
			iesimo = int(perro[-1])
			jugadorActual = Data[i][u'player']
			rondaActual = Data[i][u'stage'][u'round']
			dict_perro_comunicado[(jugadorActual, rondaActual, iesimo)] = 1
		except:
			print('Seguimos...')

	print('dict_perro_comunicado', dict_perro_comunicado)

	# Getting data from Puntaje
	for d in Data:
		try:
			print("Reading line with puntaje data...", len(d[u'Puntaje']))
			jugadorActual = d[u'player']
			rondaActual = d[u'stage'][u'round']
			perros_lista = d[u'Puntaje'][1]
			print('perros_lista', perros_lista)
			a = 0
			if d[u'stage'][u'stage'] == 2:
				for i in range(1, 6):
					perroKind = perros_lista[i-1]
					print('Ronda', rondaActual, 'Jugador', jugadorActual, 'Perro', i, perroKind)
					comprobacion = False
					try:
						a = dict_perro_comunicado[(jugadorActual, rondaActual, i)]
						print('Ok', i)
						comprobacion = True
					except:
						print('Oops', i)
						comprobacion = False
					if comprobacion:
						a = 1
					else:
						a = 0
					pareja.append(dyadName)
					raza.append(razas[jugadorActual])
					jugador.append(jugadorActual)
					ronda.append(rondaActual)
					kind.append(perroKind)
					pregunto.append(a)
		except:
			print("No score. Skip!")

print('Dyad len', len(pareja))
print('Player len', len(jugador))
print('Raza len', len(raza))
print('Round len', len(ronda))
print('Kind len', len(kind))
print('Pregunto len', len(pregunto))

dict = {
	'Dyad': pareja,
	'Player': jugador,
	'Raza': raza,
	'Round': ronda,
	'Kind': kind,
	'Pregunto': pregunto
}
data = pd.DataFrame.from_dict(dict)

def novatada(x):
	if x['Raza'] == 'hound':
		if x['Kind'] == 'A' or x['Kind'] == 'C':
			return 1
		else:
			return 0
	else:
		if x['Kind'] == 'B' or x['Kind'] == 'D':
			return 1
		else:
			return 0

data['Novatada'] = data.apply(lambda x: novatada(x), axis=1)
data['Numerador'] =  data.apply(lambda x: x['Novatada']*x['Pregunto'], axis=1)

archivo = 'indice.csv'
data.to_csv(archivo, index=False)
print("Data saved to ", archivo)
