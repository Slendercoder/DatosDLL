# Python 3.7

# 	Parse from json format into csv format
# 	It creates "encuesta.csv"

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
genero = []
edad = []
carrera = []
estrategia = []
mensajes = []
categorias = []

for counter in indices:
	# Opens json file with data from experiment and uploads it into Data
	data_archivo = 'data_lgc' + counter + '.json'
	with open(data_archivo) as data_file:
		Data = json.load(data_file)
	data_file.close()

	# --------------------------------------------------
	# Processing information of players performance
	# --------------------------------------------------

	# Getting data from Encuesta
	for d in Data:
		try:
			print("Reading line with encuesta data...", len(d[u'valores_demogra']))
			jugador.append(d[u'player'])
			genero.append(d[u'valores_demogra'][u'forms'][u'gender'][u'choice'])
			edad.append(d[u'valores_demogra'][u'forms'][u'age'][u'choice'])
			carrera.append(d[u'valores_demogra'][u'forms'][u'carreer'][u'choice'])
# =======
# 			estrategia.append(d[u'valores'][u'forms'][u'strategy'][u'choice'])
# 			genero.append(d[u'valores'][u'forms'][u'gender'][u'choice'])
# 			edad.append(d[u'valores'][u'forms'][u'age'][u'choice'])
# 			carrera.append(d[u'valores'][u'forms'][u'carreer'][u'choice'])
# 			# mensajes.append((d[u'valores'][u'forms'][u'messages'][u'choice'])[0])
# 			# categorias.append((d[u'valores'][u'forms'][u'recognition'][u'choice'])[0])
# 			cat = ''
# 			for i in d[u'valores'][u'forms'][u'recognition'][u'choice']:
# 				val = i + ', '
# 				cat += val
# 			categorias.append(cat)
# 			mes = ''
# 			for i in d[u'valores'][u'forms'][u'messages'][u'choice']:
# 				val = i + ', '
# 				mes += val
# 			mensajes.append(mes)
# >>>>>>> d200add1b2a4d10633353c65154e2094edb38015

		except:
			print("No communication phase. Skip!")

dict = {
	'Player': jugador,
	'Genero': genero,
	'Edad': edad,
	'Carrera': carrera
}

print('len(jugador)', len(jugador))
print('len(genero)', len(genero))
print('len(edad)', len(edad))
print('len(carrera)', len(carrera))

data = pd.DataFrame.from_dict(dict)

archivo = 'encuesta.csv'
data.to_csv(archivo, index=False)
print("Data saved to ", archivo)
