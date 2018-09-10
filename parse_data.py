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

	decir = ['xol', 'zab', 'dup']
	dar = ['Triangulo', 'Circulo', 'Cuadrado', 'Ignorar']
	Player = []
	Round = []
	Turn = []
	Say = []
	Give = []

	# Getting data from stage 3
	contador = 0
	for d in Data:
		print "Counter: ", contador
		if d[u'stage'][u'stage'] == 3:
			if d[u'stage'][u'step'] == 1:
				try:
					Turn.append(int(d[u'Comunicacion'][1]))
					aux = str(d[u'Comunicacion'][0])
					if aux in dar:
						Say.append('')
						Give.append(aux)
					elif aux in decir:
						Give.append('')
						Say.append(aux)
					else:
						print "Shit!"
						print d
					Player.append(str(d[u'player']))
					Round.append(int(d[u'stage'][u'round']))
				except:
					print "No communication phase. Skip!"
		contador += 1

	# Creating Dyad's name
	assert(len(set(Player)) == 2), "Oops, more than two players"
	Players = list(set(Player))
	dyad = str(Player[0][:4]) + "-" + str(Player[1][:4])
	Dyad = [dyad] * len(Player)

	# Initialize column names
	cols = ['Dyad','Round','Player','Turn','Say','Give']

	# Prepare dictionary for dataframe
	print "len(Dyad): ", len(Dyad)
	print "len(Round): ", len(Round)
	print "len(Player): ", len(Player)
	print "len(Turn): ", len(Turn)
	print "len(Say): ", len(Say)
	print "len(Give): ", len(Give)

	DF_Performance = {}
	DF_Performance['Dyad'] = Dyad
	DF_Performance['Round'] = Round
	DF_Performance['Player'] = Player
	DF_Performance['Turn'] = Turn
	DF_Performance['Say'] = Say
	DF_Performance['Give'] = Give

	D_Frames.append(pd.DataFrame.from_dict(DF_Performance))
	print 'Performance from data_lgc' + str(counter) + '.json found!'
	# print DF_Performance


data = pd.concat(D_Frames, ignore_index=True)
data = data.sort_values(['Dyad','Round','Turn','Player'], \
				ascending=[True, True, True, True]).reset_index()

# print data
print "Performances processed successfully!"

data.to_csv('performances.csv', index=False)
print "Data saved as performances.csv"

print "Done!"
