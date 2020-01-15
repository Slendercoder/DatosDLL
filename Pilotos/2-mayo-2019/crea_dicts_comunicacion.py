print("loading packages...")
import pandas as pd

# Opens the file with data from DCL experiment and parses it into data
print("Reading ParaK...")
data_archivo = 'paraK.csv'
data_paraK = pd.read_csv(data_archivo, index_col=False)
print("ParaK read!")
print(data_paraK[:3])

data_paraK = pd.DataFrame(data_paraK.groupby('Stage').get_group(2))
print(data_paraK[:3])

dictPerro = {}
dictGuess = {}

for jugador, grp_j in data_paraK.groupby('Player'):
    for ronda, grp_r in grp_j.groupby('Round'):
        perros = list(grp_r.Object)
        guesses = list(grp_r.Label)
        for i in range(1, 6):
            perro = 'Perro' + str(i)
            dictPerro[(jugador, ronda, perro)] = perros[i - 1]
            dictGuess[(jugador, ronda, perro)] = guesses[i - 1]

def aplica_perros(x, y, z):
    return dictPerro[(x,y,z)][0]

def aplica_guesses(x, y, z):
    return dictGuess[(x,y,z)]

print("Reading comunicacion...")
data_archivo = 'comunicacion.csv'
data_comunicacion = pd.read_csv(data_archivo, index_col=False)
print("comunicacion read!")
print(data_comunicacion[:3])

data_comunicacion['Dog'] = data_comunicacion[['Player', 'Round', 'Perro']].apply(lambda x: aplica_perros(*x), axis=1)
data_comunicacion['Guess'] = data_comunicacion[['Player', 'Round', 'Perro']].apply(lambda x: aplica_guesses(*x), axis=1)
print(data_comunicacion[:3])

data_comunicacion.to_csv(data_archivo, index=False)
print("Data saved to ", data_archivo)
