# --------------------------------------------------
# Produce LaTeX file
# --------------------------------------------------
print("loading packages...")
import pandas as pd
from sys import argv

script, data_archivo = argv

# Opens the file with data from DCL experiment and parses it into data
print("Reading data...")
#data = pd.read_csv(data_archivo, sep='\t', header=0)
data = pd.read_csv(data_archivo, index_col=False)
#data = pd.read_csv(data_archivo, index_col=False)
print("Data readed!")
# print data[:3]

Stgs = data.Stage.unique()
Dyads = data.Dyad.unique()
titulo = ['Training Rounds', 'Game Rounds']

print("Producing LaTeX file...")

fl = open('graphics.tex', 'w')

fl.write('% Este es el archivo consolidado de graficas\\n')
fl.write('\n \\documentclass{article}\n')
fl.write('\\usepackage[top=1cm,bottom=1cm,left=1cm,right=1cm]{geometry}\n')
fl.write('\\usepackage{graphicx}\n')
fl.write('\n \\begin{document}\n')

for stg in Stgs:
    fl.write('\\section{' + titulo[int(stg) - 1] + '}{cc}\n')
    fl.write('\hspace*{-1.5cm}\\begin{tabular}{cc}\n')
    fl.write('\includegraphics[scale=0.5]{Graficas/Stage' + str(stg) + '/score.png} &')
    fl.write('\includegraphics[scale=0.5]{Graficas/Stage' + str(stg) + '/ac_score.png} \cr \n')
    fl.write('\end{tabular}\n')
    fl.write('\n')
    for Key in Dyads:
        fl.write('\hspace*{-1.5cm}\\begin{tabular}{cc}\n')
        fl.write('\includegraphics[scale=0.5]{Graficas/' + "Stage_" + str(stg) + "_" + str(Key) + '/score.png} &')
        fl.write('\includegraphics[scale=0.5]{Graficas/' + "Stage_" + str(stg) + "_" + str(Key) + '/ac_score.png} \cr \n')
        fl.write('\end{tabular}\n')
        fl.write('\n')
        # fl.write('\n \pagebreak\n')

fl.write('\n \end{document}\n')

fl.close()
print('LaTeX file produced!')
print('You can run\n\t> pdflatex graphics.tex\n to obtain the graphics in a single pdf file')
print("Done!")
