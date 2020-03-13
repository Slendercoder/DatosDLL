library(ggplot2)
library(Rmisc)
library(gridExtra)
library(dplyr)
library(readxl)

##########################################################################
# Functions
##########################################################################

get_legend<-function(myggplot){
  tmp <- ggplot_gtable(ggplot_build(myggplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
} # end get_legend

##########################################################################
# Encontrando indice
##########################################################################

df = read.csv('indice.csv')
head(df)

comunicacion_summary <- df %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Round, Player) %>%   # the grouping variable
  dplyr::summarise(numerator = sum(Numerador),
                   N = sum(Novatada)) %>%
  mutate(indiceCop = numerator/N) %>%
  ungroup() %>%
  dplyr::group_by(Round) %>%
  dplyr::summarise(meanNovatada = mean(N, na.rm=TRUE),
                   sd_PL = sd(N, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(N, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)

gNovatada <- ggplot(comunicacion_summary, aes(x=Round, y=meanNovatada)) +
  geom_line(size=0.8) +
  #  geom_ribbon(aes(ymin = Score - sd,
  #                  ymax = Score + sd), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  #  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. number of dogs outside expertice") +
  ylim(c(0,3)) + 
  ggtitle("Dogs outside expertice") +
  theme_bw() +
  theme(legend.position="none")

gNovatada

comunicacion_summary <- df %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Round, Player) %>%   # the grouping variable
  dplyr::summarise(pregunto = sum(Pregunto),
                   N = sum(Novatada)) %>%
  ungroup() %>%
  dplyr::group_by(Round) %>%
  dplyr::summarise(meanNumerator = mean(pregunto, na.rm=TRUE),
                   sd_PL = sd(pregunto, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(pregunto, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)

gPregunto <- ggplot(comunicacion_summary, aes(x=Round, y=meanNumerator)) +
  geom_line(size=0.8) +
  #  geom_ribbon(aes(ymin = Score - sd,
  #                  ymax = Score + sd), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  #  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. number of messages") +
  ylim(c(0,3)) + 
  ggtitle("Messages") +
  theme_bw() +
  theme(legend.position="none")

gPregunto

comunicacion_summary <- df %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Round, Player) %>%   # the grouping variable
  dplyr::summarise(numerator = sum(Numerador),
                   N = sum(Novatada)) %>%
  mutate(indiceCop = numerator/N) %>%
  ungroup() %>%
  dplyr::group_by(Round) %>%
  dplyr::summarise(meanIndice = mean(indiceCop, na.rm=TRUE),
                   sd_PL = sd(indiceCop, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(indiceCop, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)

gIndice <- ggplot(comunicacion_summary, aes(x=Round, y=meanIndice)) +
  geom_line(size=0.8) +
#  geom_ribbon(aes(ymin = meanIndice - sd_PL,
#                  ymax = meanIndice + sd_PL), alpha = 0.2) +
#  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
#  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. cooperation index") +
  ylim(c(0,1)) + 
#  ggtitle("Aggregate") +
  theme_bw() +
  theme(legend.position="none")

gIndice

#############################################################################################
# Encontrando indice por tipo de experticia
#############################################################################################

comunicacion_summary <- df %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Raza, Round, Player) %>%   # the grouping variable
  dplyr::summarise(numerator = sum(Numerador),
                   N = sum(Novatada)) %>%
  mutate(indiceCop = numerator/N) %>%
  ungroup() %>%
  dplyr::group_by(Raza, Round) %>%
  dplyr::summarise(meanIndice = mean(indiceCop, na.rm=TRUE),
                   sd_PL = sd(indiceCop, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(indiceCop, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)

gIndiceRaza <- ggplot(comunicacion_summary, aes(x=Round, y=meanIndice, group=Raza, color=Raza)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanIndice - sd_PL,
                  ymax = meanIndice + sd_PL), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  #  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. cooperation index") +
  #  ylim(c(0,1)) + 
  ggtitle("Per type of expertise") +
  theme_bw() +
  theme(legend.position="right")

gIndiceRaza

legend <- get_legend(gIndiceRaza)

gIndiceRaza <- gIndiceRaza + theme(legend.position="none")

g <- grid.arrange(gIndice, gIndiceRaza, nrow=1, right=legend, top="Cooperation index")


#############################################################################################
# Encontrando indice por persona por ronda
#############################################################################################

indiceCooperacion <- df %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Round, Player) %>%   # the grouping variable
  dplyr::summarise(numerator = sum(Numerador),
                   N = sum(Novatada)) %>%
  mutate(indiceCop = numerator/N) 

indiceCooperacion <- indiceCooperacion %>% select(1, 2, 5)
indiceCooperacion <- indiceCooperacion[indiceCooperacion$Round < 6, ]
#indiceCooperacion <- indiceCooperacion[indiceCooperacion$Round > 19, ]
head(indiceCooperacion)

dfPuntajeGroup = read.csv('puntaje_group.csv')
dfPuntajeGroupGame <- dfPuntajeGroup[dfPuntajeGroup$Stage == 2, ]
head(dfPuntajeGroupGame)

dfScore <- dfPuntajeGroupGame %>%
  dplyr::group_by(Round, Player) %>%   # the grouping variable
  dplyr::summarise(Score = median(Score)) 
head(dfScore)

total <- merge(indiceCooperacion, dfScore, by=c('Round', 'Player'))
head(total)
dim(total)

g <- ggplot(total, aes(x=indiceCop, y=Score)) +
  geom_point(color='blue', alpha=0.2) + 
  geom_smooth(method = "lm", se = TRUE) +
  xlab("Cooperation index") +
  ylab("Score") +
  theme_bw() +
  ggtitle("First 5 rounds")

g

# Regressing indice coop w.r.t. Score
model1 <- lm(Score ~ indiceCop, data = total)
summary(model1) # => Positive correlation is significant

#par(mfrow=c(2,2)) # init 4 charts in 1 panel
#plot(model1)

library(lmtest)
lmtest::bptest(model1)  # Breusch-Pagan test studentized Breusch-Pagan test

##########################################################################################
# Drawing dispersion between index of cooperation and score
##########################################################################################

comunicacion_summary <- dfCom %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Round, Player) %>%   # the grouping variable
  dplyr::summarise(maxMessag = max(Contador),
                   mean_Corr = mean(Correctitud, na.rm=TRUE)) %>%
  ungroup() %>%
  dplyr::group_by(Round) %>%
  dplyr::summarise(meanMess = mean(maxMessag),
                   mean_Corr = mean(mean_Corr, na.rm=TRUE))
head(comunicacion_summary)

g <- ggplot(comunicacion_summary, aes(x=mean_Corr, y=lead(meanMess))) +
  geom_point(color='blue') + 
  geom_smooth(method = "lm", se = TRUE) +
  xlab("Av. correctness of replies") +
  ylab("Av. number of messages on next round") +
  theme_bw()

g

##########################################################################################
# Uso efectivo de palabras por expertos
##########################################################################################

df = read_excel('uso-experto.xlsx')
df$Player <- as.character(df$Player)
head(df)

# Obtiene el indice de uso
uso <- df %>%
  dplyr::group_by(Player, Kind) %>%
  #dplyr::summarise(numera = sum(Numerador),
  dplyr::summarise(numera = sum(Respondido),
                   N = n()) %>%
  dplyr::mutate(indice = numera/N) %>%
  ungroup()

# Obtiene el valor z
uso <- uso %>%
  dplyr::mutate(promedio = mean(indice),
                desvest = sd(indice)) %>%
  dplyr::group_by(Player, Kind) %>%
  dplyr::mutate(zUSo = (indice - promedio)/desvest)

write.csv(uso, "uso-experto-inv.csv")


uso = read.csv('uso-experto.csv', sep=",")
# Obtiene el ID
uso$Player <- as.character(uso$Player)
uso <- uso[order(uso$Player),]
uso$ID <- paste(uso$Player, uso$Kind, sep="")
uso <- uso[uso$ID != "845030447613389D", ] # No hay problema, pues no le preguntaron sobre perros C
head(uso)
uso <- uso[order(uso$ID), ]
head(uso)

df1 = read_excel('reporte-comp-expertos.xlsx')
#df1 = read.csv('reporte-comp-expertos.csv', sep=";")
head(df1)
df1$Player <- as.character(df1$Player)
# OJO: TOCA REVISAR ESTA PAREJA QUE FALTA EN COMUNICACION
#df1 <- df1[df1$Player != "101017895939220", ]
#df1 <- df1[df1$Player != "322563841246444", ]
#df1 <- df1[order(df1$Player),]
#df1 <- df1[df1$Player != "101017895939220", ]

df1 <- df1[df1$Player != "101017895939220", ]
df1 <- df1[df1$Player != "833437527724022", ]
df1 <- df1[df1$Player != "864237546831637", ]


df1$ID <- paste(df1$Player, df1$Kind, sep="")
# OJO: Revisar por que faltan estos jugadores
#df1 <- df1[df1$ID != "696092780970702D", ]
#df1 <- df1[df1$ID != "765625247183286A", ]
#df1 <- df1[df1$ID != "781261847597636B", ]
#df1 <- df1[df1$ID != "845030447613389B", ]
df1 <- df1[df1$ID != "845030447613389A", ]
df1 <- df1[df1$ID != "355721802475635B", ]
df1 <- df1[df1$ID != "32111755046981D", ]

head(df1)
df1 <- df1 %>%
  dplyr::mutate(promedio = mean(Reporte),
                desvest = sd(Reporte)) %>%
  dplyr::mutate(zReporte = (Reporte - promedio)/desvest)
df1 <- df1[order(df1$ID), ]
head(df1)

a <- unique(uso$Player)
b <- unique(df1$Player)

length(a)
length(b)
setdiff(a, b)

a <- unique(uso$ID)
b <- unique(df1$ID)

length(a)
length(b)

setdiff(b, a)

total <- merge(uso, df1, by="ID")
total <- total[c('ID', 'zUSo', 'zReporte')]
total <- total[order(total$ID), ]
head(total)


g <- ggplot(total, aes(x=zUSo, y=zReporte)) +
  geom_point(color='blue') + 
  geom_smooth(method = "lm", se = TRUE) +
  xlab("Uso efectivo") +
  ylab("Reporte de comprension") +
  theme_bw()

g

# INCLUYENDO EL INDICE DE NOVATOS

df = read.csv('indice.csv')
#df <- df[df$Player != '845030447613389', ]
df <- df[df$Player != '765625247183286', ]
head(df)

# Obtiene el indice de cooperacion
indiceCooperacion <- df %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Round, Player, Kind) %>%   # the grouping variable
  dplyr::summarise(numerator = sum(Numerador),
                   Nov = sum(Novatada),
                   N = n()) %>%
  dplyr::mutate(indiceCop = numerator/Nov) 
head(indiceCooperacion)
indiceCooperacion <- indiceCooperacion[indiceCooperacion$Nov != 0, ]
indiceCooperacion <- indiceCooperacion %>% select(1, 2, 3, 7)
head(indiceCooperacion)
indiceCooperacion <- indiceCooperacion %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Player, Kind) %>%   # the grouping variable
  dplyr::summarise(N = n(),
                   IN = sum(indiceCop)) %>%
  dplyr::mutate(indiceCop = IN/N) %>%
  ungroup()
indiceCooperacion <- indiceCooperacion %>% select(1, 2, 5)
head(indiceCooperacion)

# Obtiene el valor z
indiceCooperacion <- indiceCooperacion %>%
  dplyr::mutate(promedio = mean(indiceCop),
                desvest = sd(indiceCop)) %>%
  dplyr::group_by(Player, Kind) %>%
  dplyr::mutate(zUSo = (indiceCop - promedio)/desvest)
head(indiceCooperacion)

# Obtiene el ID
indiceCooperacion$Player <- as.character(indiceCooperacion$Player)
indiceCooperacion <- indiceCooperacion[order(indiceCooperacion$Player),]
indiceCooperacion$ID <- paste(indiceCooperacion$Player, indiceCooperacion$Kind, sep="")
head(indiceCooperacion)

df1 = read_excel('reporte-comp-novatos.xlsx')
#df1 = read.csv('reporte-comp-novatos.csv')
head(df1)
df1$Player <- as.character(df1$Player)
# OJO: TOCA REVISAR ESTA PAREJA QUE FALTA EN COMUNICACION
#df1 <- df1[df1$Player != "101017895939220", ]
#df1 <- df1[df1$Player != "833437527724022", ]
#df1 <- df1[df1$Player != "322563841246444", ]
df1 <- df1[order(df1$Player),]
df1$ID <- paste(df1$Player, df1$Kind, sep="")
# OJO: Revisar por que faltan estos jugadores
#df1 <- df1[df1$ID != "696092780970702D", ]
#df1 <- df1[df1$ID != "765625247183286A", ]
#df1 <- df1[df1$ID != "781261847597636B", ]
#df1 <- df1[df1$ID != "845030447613389B", ]
head(df1)
df1 <- df1 %>%
  dplyr::mutate(promedio = mean(Reporte),
                desvest = sd(Reporte)) %>%
  dplyr::mutate(zReporte = (Reporte - promedio)/desvest)
head(df1)

a <- unique(indiceCooperacion$Player)
b <- unique(df1$Player)
length(a)
length(b)
setdiff(a, b)

a <- unique(indiceCooperacion$ID)
b <- unique(df1$ID)
length(a)
length(b)
setdiff(a, b)

total1 <- merge(indiceCooperacion, df1, by="ID")
total1 <- total1[c('ID', 'zUSo', 'zReporte')]
total1 <- total1[order(total1$ID), ]
head(total1)

dataCor <- rbind(total, total1 )
dataCor <- dataCor[c('ID', 'zUSo', 'zReporte')]
dataCor <- dataCor[order(dataCor$ID), ]
head(dataCor)

g <- ggplot(dataCor, aes(x=zUSo, y=zReporte)) +
  geom_point(color='blue') + 
  geom_smooth(method = "lm", se = TRUE) +
  xlab("Uso efectivo") +
  ylab("Reporte de comprension") +
  theme_bw()

g

# Para K

dfCalificacionGroup = read.csv('paraK_group.csv')
dfCalificacionGroup <- dfCalificacionGroup[dfCalificacionGroup$Stage == 2, ]

head(dfCalificacionGroup)

df1 <- dfCalificacionGroup %>%
  dplyr::group_by(Player, Kind) %>%
  dplyr::summarise(paraK = mean(Correct)) 

df1$ID <- paste(df1$Player, df1$Kind, sep="")

head(df1)

dataCor <- merge(dataCor, df1, by="ID")
dataCor <- dataCor[c('ID', 'zReporte', 'zUSo', 'paraK')]
head(dataCor)

model1h <- lm(zReporte ~ zUSo*paraK, data = dataCor)
summary(model1h) # => Positive correlation is significant

# Para K Novatos

dfCalificacionGroup = read.csv('paraK_group.csv')
dfCalificacionGroup <- dfCalificacionGroup[dfCalificacionGroup$Stage == 2, ]
dfHound <- dfCalificacionGroup[dfCalificacionGroup$Raza == 'hound', ]
dfTerrier <- dfCalificacionGroup[dfCalificacionGroup$Raza == 'terrier', ]

dfHound <- dfHound[dfHound$Kind != 'B', ]
dfHound <- dfHound[dfHound$Kind != 'D', ]

dfTerrier <- dfTerrier[dfTerrier$Kind != 'A', ]
dfTerrier <- dfTerrier[dfTerrier$Kind != 'C', ]

df1 <- dfHound %>%
  dplyr::group_by(Player, Kind) %>%
  dplyr::summarise(paraK = mean(Correct))

df2 <- dfTerrier %>%
  dplyr::group_by(Player, Kind) %>%
  dplyr::summarise(paraK = mean(Correct)) 

df <- rbind(df1, df2)

df$ID <- paste(df$Player, df$Kind, sep="")

df <- df[c('ID', 'paraK')]
df <- merge(total1, df, by="ID")

head(df)

model1h <- lm(zReporte ~ zUSo*paraK, data = df)
summary(model1h) # => Positive correlation is significant





