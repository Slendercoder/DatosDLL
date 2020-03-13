#-*- coding: utf-8 -*-
print("Importando paquetes...")
import pandas as pd
from pandas import ExcelWriter
print("Listo!")

print("Leyendo datos...")
#df = pd.read_excel('reporte-comp-novatos.xlsx')
df = pd.read_csv('uso-experto-inv.csv')
print(df[:3])
data = pd.read_csv('puntaje_group.csv')
print(data[:3])

# Crea el dict
dict = {}
for pareja, grp in data.groupby('Dyad'):
    jugadores = grp.Player.unique()
    dict[jugadores[0]] = jugadores[1]
    dict[jugadores[1]] = jugadores[0]

print(dict)

data['Player1'] = data['Player'].map(dict)
print(data[:3])

df['Player'] = df['Player'].map(dict)
df.to_csv('uso-experto.csv')
