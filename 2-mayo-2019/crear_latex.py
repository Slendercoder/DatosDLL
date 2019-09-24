# --------------------------------------------------
# Produce LaTeX file
# --------------------------------------------------
print("loading packages...")
import pandas as pd

data_archivo = 'puntaje.csv'

# Opens the file with data from DCL experiment and parses it into data
print("Reading data...")
#data = pd.read_csv(data_archivo, sep='\t', header=0)
data = pd.read_csv(data_archivo, index_col=False)
#data = pd.read_csv(data_archivo, index_col=False)
print("Data readed!")
# print data[:3]

graph_each_dyad = int(input("Do you want to create graphics for each dyad? (1=YES/0=NO): "))

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

fl.write('\\section{Averages}\n')

for stg in Stgs:
    fl.write('\\textbf{' + titulo[int(stg) - 1] + '}\n')
    fl.write('\n')
    fl.write('\\ \n')
    fl.write('\n')
    fl.write('\hspace*{-1.5cm}\\begin{tabular}{cc}\n')
    fl.write('Average Score & Average Accumulated Score \cr \n')
    fl.write('\includegraphics[scale=0.5]{Graficas/Stage' + str(stg) + '/score.png} &')
    fl.write('\includegraphics[scale=0.5]{Graficas/Stage' + str(stg) + '/ac_score.png} \cr \n')
    fl.write('\end{tabular}\n')
    fl.write('\n')

fl.write('\n')
fl.write('\\ \n')
fl.write('\n')
fl.write('\\textbf{Communication:} \n')
fl.write('\n')
fl.write('\\ \n')
fl.write('\n')
fl.write('\includegraphics[scale=0.5]{Graficas/amount_comm.png} \n')
fl.write('\n')
fl.write('\hspace*{-1.5cm}\\begin{tabular}{cc}\n')
fl.write('\includegraphics[scale=0.5]{Graficas/affResp.png} & ')
fl.write('\includegraphics[scale=0.5]{Graficas/negResp.png} \cr')
fl.write('\includegraphics[scale=0.5]{Graficas/correctClassTraining.png} & ')
fl.write('\includegraphics[scale=0.5]{Graficas/correctClassGame.png} \cr')
fl.write('\end{tabular}\n')
fl.write('\n')

if graph_each_dyad:
    for stg in Stgs:
        fl.write('\\section{' + titulo[int(stg) - 1] + ' per dyad}\n')
        fl.write('\n')
        for Key in Dyads:
            fl.write('\hspace*{-1.5cm}\\begin{tabular}{cc}\n')
            fl.write('Average Score & Average Accumulated Score \cr \n')
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
