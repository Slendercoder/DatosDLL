#-*- coding: utf-8 -*-
print("Importando paquetes...")
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import sys
import os
print("Listo!")

print("Leyendo datos...")
df = pd.read_csv('comunicacion_raw.csv')
print(df[:3])

# Organiza el DataFrame
df = df.sort_values(['Dyad', 'Round', 'Turn', 'Ask_or_Respond'], ascending=[True, True, True, True])

for key, grp in df.groupby(['Dyad', 'Round', 'Turn']):
    jugadores = list(grp['Player'])
    print(jugadores)
