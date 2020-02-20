library(ggplot2)
library(gridExtra)
library(grid)
library(plyr)
library(dplyr)
library(ggthemes)

# The palette with black:
cbp2 <- c("#000000", "#E69F00", "#56B4E9", "#009E73",
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

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
# Analyzing communication 
##########################################################################

#dfCom = read.csv('comunicacion.csv')
dfCom = read.csv('comunicacion-sencillo.csv')
dfCom$Correctitud <- as.numeric(dfCom$Correctitud)
head(dfCom)

##########################################################################
# Drawing average number of messages per round 
##########################################################################

comunicacion_summary <- dfCom %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Raza, Player, Round) %>%   # the grouping variable
  dplyr::summarise(maxMessag = max(Contador),
                   n = n()) %>%
  ungroup() %>%
  dplyr::group_by(Round) %>%
  dplyr::summarise(meanMess=mean(n),
                   sd_PL = sd(n, na.rm=TRUE))
head(comunicacion_summary)

# Version dplyr
gCom <- ggplot(comunicacion_summary, aes(x=Round, y=meanMess)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = meanMess - sd_PL,
                  ymax = meanMess + sd_PL), alpha = 0.2) +
  xlab("Round") +
  ylab("Av. number of messages") +
  ylim(c(0,4.5)) + 
  ggtitle("Aggregate") +
  theme_bw() +
  theme(legend.position="bottom")

gCom

# Por raza
comunicacion_summary <- dfCom %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Raza, Player, Round) %>%   # the grouping variable
  dplyr::summarise(maxMessag = max(Contador),
                   n = n()) %>%
  ungroup() %>%
  dplyr::group_by(Raza, Round) %>%
  dplyr::summarise(meanMess=mean(maxMessag),
                   sd_PL = sd(n, na.rm=TRUE))
head(comunicacion_summary)

gComRaza <- ggplot(comunicacion_summary, aes(x=Round, y=meanMess, group=Raza, color=Raza)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = meanMess - sd_PL,
                  ymax = meanMess + sd_PL), alpha = 0.2) +
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. number of messages") +
  ylim(c(0,4.5)) + 
  ggtitle("Per type of expertise") +
  theme_bw() +
  theme(legend.position="right")

gComRaza

legend <- get_legend(gComRaza)

gComRaza <- gComRaza + theme(legend.position="none")

gMessag <- grid.arrange(gCom, gComRaza, nrow=1, 
                        top="Amount of communication",
                        right=legend)

##########################################################################
# Drawing average number of correct replies per round 
##########################################################################

comunicacion_summary <- dfCom %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Raza, Player, Round) %>%   # the grouping variable
  dplyr::summarise(mean_Corr = mean(Correctitud, na.rm=TRUE)) # calculates the standard error of each group
head(comunicacion_summary)

comunicacion_summary <- dfCom %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Raza, Round) %>%   # the grouping variable
  dplyr::summarise(mean_PL = mean(Correctitud, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correctitud, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correctitud, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)

gComCorr <- ggplot(comunicacion_summary, aes(x = Round, y = mean_PL, color=Raza, group=Raza)) +
  geom_line(size=0.9) +
#  geom_ribbon(aes(ymin = mean_PL - sd_PL,
#                  ymax = mean_PL + sd_PL), alpha = 0.2) +
  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. correct response") +
  ylim(c(0,1)) + 
#  ggtitle("Correctness per round") +
  theme_bw() +
  theme(legend.position="bottom")

gComCorr

##########################################################################
# Drawing average % of responded messages 
##########################################################################

comunicacion_summary <- dfCom %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Round) %>%
  dplyr::mutate(nTotal = n()) %>%
  ungroup() %>%
  dplyr::group_by(Round, Recibido) %>%   # the grouping variables
  dplyr::summarise(freqReci = (1 - n()/median(nTotal))*100)
head(comunicacion_summary)

comunicacion_summary <- comunicacion_summary[comunicacion_summary$Recibido == '-', ]

gResp <- ggplot(comunicacion_summary, aes(x=Round, y=freqReci)) +
  geom_line(size=0.9) +
  xlab("Round") +
  ylab("Answered messages (%)") +
  ylim(c(0,100)) + 
  #  ggtitle("Aggregate") +
  theme_bw() 

gResp

##########################################################################
# Drawing dispersion between average correctnes and average number of messages
##########################################################################

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

##########################################################################
# Drawing composition of messages from experts
##########################################################################

dfTerriers <- dfCom[dfCom$Raza == 'terrier', ]
dfTerriers$Rotulo <- mapvalues(dfTerriers$Rotulo, 
                               from = levels(dfTerriers$Rotulo), 
                               to = c('Cairn Terrier',
                                      'Irish Wolfhound',
                                      'Norwich Terrier', 
                                      'Scottish Deerhound'))

head(dfTerriers)
comunicacion_summary <- dfTerriers %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Rotulo) %>%   # the grouping variable
  dplyr::summarise(n = n()) %>% # calculates the standard error of each group
  mutate(freq = n/sum(n))
head(comunicacion_summary)

gTerriersAsk <- ggplot(comunicacion_summary, aes(Rotulo, fill=Rotulo)) + 
  geom_col(aes(y=freq)) +
  ggtitle("What messages do Hound Laymen ask?") +
  ylim(c(0,0.6)) + 
  labs(y="Relative frequency", 
       x = "") +
  scale_fill_colorblind() +
  theme_classic() +
  theme(legend.position="none")

gTerriersAsk

dfHounds <- dfCom[dfCom$Raza == 'hound', ]
dfHounds$Rotulo <- mapvalues(dfHounds$Rotulo, 
                               from = levels(dfHounds$Rotulo), 
                               to = c('Cairn Terrier',
                                      'Irish Wolfhound',
                                      'Norwich Terrier', 
                                      'Scottish Deerhound'))

head(dfHounds)
comunicacion_summary <- dfHounds %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Rotulo) %>%   # the grouping variable
  dplyr::summarise(n = n()) %>% # calculates the standard error of each group
  mutate(freq = n/sum(n))
head(comunicacion_summary)

gHoundsAsk <- ggplot(comunicacion_summary, aes(Rotulo, fill=Rotulo)) + 
  geom_col(aes(y=freq)) +
  ggtitle("What messages do Terrier Laymen ask?") +
  ylim(c(0,0.6)) + 
  labs(y="Relative frequency", 
       x = "Message \'Is this a ...\'") +
  scale_fill_colorblind() +
  theme_classic() +
  theme(legend.position="none")

gHoundsAsk

gAsk <- grid.arrange(gTerriersAsk, gHoundsAsk, nrow = 2)

##########################################################################
# Drawing composition of guesses when terrier expert asks about hounds
##########################################################################

dfTerriers <- dfCom[dfCom$Raza == 'terrier', ]
#dfTerriersB <- dfTerriers[dfTerriers$Rotulo == 'B', ]
dfTerriersB <- dfTerriersB[dfTerriersB$suposicion != '', ]
dfTerriersB <- dfTerriersB[complete.cases(dfTerriersB$suposicion), ]
dfTerriersB <- dfTerriersB[complete.cases(dfTerriersB$Kind), ]
dfTerriersB <- dfTerriersB[dfTerriersB$Kind != '', ]
levels(dfTerriersB$suposicion)
dfTerriersB$suposicion <- mapvalues(dfTerriersB$suposicion, 
                                    from = levels(dfTerriersB$suposicion), 
                                    to = c('Cairn Terrier',
                                           'Irish Wolfhound',
                                           'Norwich Terrier', 
                                           'Scottish Deerhound',
                                           'No guess'))
levels(dfTerriersB$Kind)
dfTerriersB$Kind <- mapvalues(dfTerriersB$Kind, 
                                    from = levels(dfTerriersB$Kind), 
                                    to = c('NA',
                                           'Incorrect',
                                           'Correct', 
                                           'Incorrect',
                                           'Incorrect'))

head(dfTerriersB)
tabla <- table(dfTerriersB$Kind)
gB <- ggplot(as.data.frame(tabla), aes(x=gender, y = Freq, fill=fraud)) + 
  geom_bar(stat="identity")


gB


comunicacion_summary <- dfTerriersB %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Rotulo, suposicion) %>%   # the grouping variable
  dplyr::summarise(n = n()) %>% # calculates the standard error of each group
  mutate(freq = n/sum(n))
head(comunicacion_summary)

colores <- c(cbp2[2], cbp2[4], cbp2[8])

gB <- ggplot(comunicacion_summary, aes(suposicion, fill=suposicion)) + 
  geom_col(aes(y=freq)) +
  ggtitle("Guess before asking is this Irish Wolfhound?") +
  ylim(c(0,0.7)) + 
  labs(y="Relative frequency", 
       x = "Guess") +
  scale_fill_manual(values = colores) +
  theme_classic() +
  theme(legend.position="none")

gB

dfTerriers <- dfCom[dfCom$Raza == 'terrier', ]
dfTerriersD <- dfTerriers[dfTerriers$Rotulo == 'D', ]
dfTerriersD <- dfTerriersD[dfTerriersD$suposicion != '', ]
dfTerriersD <- dfTerriersD[complete.cases(dfTerriersD$suposicion), ]
levels(dfTerriersD$suposicion)
dfTerriersD$suposicion <- mapvalues(dfTerriersD$suposicion, 
                                    from = levels(dfTerriersD$suposicion), 
                                    to = c('Cairn Terrier',
                                           'Irish Wolfhound',
                                           'Norwich Terrier', 
                                           'Scottish Deerhound',
                                           'No guess'))

comunicacion_summary <- dfTerriersD %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Rotulo, suposicion) %>%   # the grouping variable
  dplyr::summarise(n = n()) %>% # calculates the standard error of each group
  mutate(freq = n/sum(n))
head(comunicacion_summary)

#colores <- c(cbp2[3], cbp2[5], cbp2[8])

gD <- ggplot(comunicacion_summary, aes(suposicion, fill=suposicion)) + 
  geom_col(aes(y=freq)) +
  ggtitle("Guess before asking is this Scottish Deerhound?") +
  ylim(c(0,0.7)) + 
  labs(y="Relative frequency", 
       x = "Guess") +
  scale_fill_manual(values = colores) +
  theme_classic() +
  theme(legend.position="none")

gD

gExpertTerriers <- grid.arrange(gB, gD, nrow = 2, top="Terrier experts")

##########################################################################
# Drawing composition of guesses when hound expert asks about hounds
##########################################################################

dfHounds <- dfCom[dfCom$Raza == 'hound', ]
dfHoundsB <- dfHounds[dfHounds$Rotulo == 'A', ]
dfHoundsB <- dfHoundsB[dfHoundsB$suposicion != '', ]
dfHoundsB <- dfHoundsB[complete.cases(dfHoundsB$suposicion), ]
levels(dfHoundsB$suposicion)
dfHoundsB$suposicion <- mapvalues(dfHoundsB$suposicion, 
                                  from = levels(dfHoundsB$suposicion), 
                                  to = c('Cairn Terrier',
                                         'Irish Wolfhound',
                                         'Norwich Terrier', 
                                         'Scottish Deerhound',
                                         'No guess'))

comunicacion_summary <- dfHoundsB %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Rotulo, suposicion) %>%   # the grouping variable
  dplyr::summarise(n = n()) %>% # calculates the standard error of each group
  mutate(freq = n/sum(n))
head(comunicacion_summary)

colores <- c(cbp2[1], cbp2[3], cbp2[8])

gA <- ggplot(comunicacion_summary, aes(suposicion, fill=suposicion)) + 
  geom_col(aes(y=freq)) +
  ggtitle("Guess before asking is this Cairn Terrier?") +
  ylim(c(0,0.7)) + 
  labs(y="Relative frequency", 
       x = "Guess") +
  scale_fill_manual(values = colores) +
  theme_classic() +
  theme(legend.position="none")

gA

dfHounds <- dfCom[dfCom$Raza == 'hound', ]
dfHoundsD <- dfHounds[dfHounds$Rotulo == 'C', ]
dfHoundsD <- dfHoundsD[dfHoundsD$suposicion != '', ]
dfHoundsD <- dfHoundsD[complete.cases(dfHoundsD$suposicion), ]
levels(dfHoundsD$suposicion)
dfHoundsD$suposicion <- mapvalues(dfHoundsD$suposicion, 
                                  from = levels(dfHoundsD$suposicion), 
                                  to = c('Cairn Terrier',
                                         'Irish Wolfhound',
                                         'Norwich Terrier', 
                                         'Scottish Deerhound',
                                         'No guess'))

comunicacion_summary <- dfHoundsD %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Rotulo, suposicion) %>%   # the grouping variable
  dplyr::summarise(n = n()) %>% # calculates the standard error of each group
  mutate(freq = n/sum(n))
head(comunicacion_summary)

#colores <- c(cbp2[2], cbp2[4], cbp2[1])

gC <- ggplot(comunicacion_summary, aes(suposicion, fill=suposicion)) + 
  geom_col(aes(y=freq)) +
  ggtitle("Guess before asking is this Norwich Terrier?") +
  ylim(c(0,0.7)) + 
  labs(y="Relative frequency", 
       x = "Guess") +
  scale_fill_manual(values = colores) +
  theme_classic() +
  theme(legend.position="none")

gC

gExpertHounds <- grid.arrange(gA, gC, nrow = 1, top="Hound experts")



##############
##############
##############
##############
# Meando fuera del tiesto
###############

dfTerriersA <- dfTerriers[dfTerriers$Rotulo == 'A', ]

comunicacion_summary <- dfTerriersA %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Rotulo, suposicion) %>%   # the grouping variable
  dplyr::summarise(n = n()) %>% # calculates the standard error of each group
  mutate(freq = n/sum(n))
head(comunicacion_summary)

gA <- ggplot(comunicacion_summary, aes(suposicion, fill=suposicion)) + 
  geom_col(aes(y=n)) +
#  geom_col(aes(y=freq)) +
  ggtitle("Guess before message asking is this A?") +
  labs(y="Relative frequency", 
       x = "Guess") +
  theme_classic() +
  theme(legend.position="none")

gA

dfTerriersC <- dfTerriers[dfTerriers$Rotulo == 'C', ]

comunicacion_summary <- dfTerriersC %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Rotulo, suposicion) %>%   # the grouping variable
  dplyr::summarise(n = n()) %>% # calculates the standard error of each group
  mutate(freq = n/sum(n))
head(comunicacion_summary)

gC <- ggplot(comunicacion_summary, aes(suposicion, fill=suposicion)) + 
  geom_col(aes(y=n)) +
  #  geom_col(aes(y=freq)) +
  ggtitle("Guess before message asking is this C?") +
  labs(y="Relative frequency", 
       x = "Guess") +
  theme_classic() +
  theme(legend.position="none")

gC

gExpertTerriersWTF <- grid.arrange(gA, gC, nrow = 1, top="Terrier experts")
