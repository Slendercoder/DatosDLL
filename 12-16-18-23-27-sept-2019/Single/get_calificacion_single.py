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
raza = []
calificacionA = []
calificacionB = []
calificacionC = []
calificacionD = []
valores = [str(x) for x in range(8)]

for counter in indices:
	# Opens json file with data from experiment and uploads it into Data
	data_archivo = 'data_lgc' + counter + '.json'
	print('Processing file', data_archivo)
	with open(data_archivo) as data_file:
		Data = json.load(data_file)
	data_file.close()

	# --------------------------------------------------
	# Processing information of players performance
	# --------------------------------------------------

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

	# Getting data from Encuesta
	for d in Data:
		try:
			print("Reading line with calificacion data...", len(d[u'valores_comprension']))
			# print(d[u'valores_comprension'][u'forms'])
			# pareja.append(dyadName)
			if d[u'valores_comprension'][u'forms'][u'Cairn'][u'value'] not in valores:
				break
			if d[u'valores_comprension'][u'forms'][u'Norwich'][u'value'] not in valores:
				break
			if d[u'valores_comprension'][u'forms'][u'Irish'][u'value'] not in valores:
				break
			if d[u'valores_comprension'][u'forms'][u'Scottish'][u'value'] not in valores:
				break
			calificacionA.append(d[u'valores_comprension'][u'forms'][u'Cairn'][u'value'])
			calificacionC.append(d[u'valores_comprension'][u'forms'][u'Norwich'][u'value'])
			calificacionB.append(d[u'valores_comprension'][u'forms'][u'Irish'][u'value'])
			calificacionD.append(d[u'valores_comprension'][u'forms'][u'Scottish'][u'value'])
			jugador.append(d[u'player'])
			raza.append(razas)
		except:
			a = True
			# print("No grading phase. Skip!")

print('len(jugador)', len(jugador))
print('len(raza)', len(raza))
print('len(calificacionA)', len(calificacionA))
print('len(calificacionB)', len(calificacionB))
print('len(calificacionC)', len(calificacionC))
print('len(calificacionD)', len(calificacionD))

dict = {
	# 'Dyad': pareja,
	'Player': jugador,
	'Kind': raza,
	'GradingA': calificacionA,
	'GradingB': calificacionB,
	'GradingC': calificacionC,
	'GradingD': calificacionD
}
data = pd.DataFrame.from_dict(dict)

archivo = 'calificacion.csv'
data.to_csv(archivo, index=False)
print("Data saved to ", archivo)
