library(readxl)

df = read_excel("encuesta.xlsx")
head(df)

genero <- table(df$Genero)

edad <- table(df$Edad)

edad <- (43*19 + 40*22)/83
