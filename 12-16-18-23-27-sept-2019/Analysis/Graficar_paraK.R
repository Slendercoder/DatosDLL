library(ggplot2)
library(Rmisc)
library(gridExtra)
library(dplyr)

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
# Analizando desempeño por perro durante el training
##########################################################################

dfCalificacionGroup = read.csv('paraK_group.csv')
dfCalificacionGroup <- dfCalificacionGroup[dfCalificacionGroup$Stage == 1, ]
dfCalificacionGroup$Exp <- as.character('Pairs')
head(dfCalificacionGroup)

dfCalificacionSingle = read.csv('paraK_single.csv')
dfCalificacionSingle <- dfCalificacionSingle[dfCalificacionSingle$Stage == 5, ]
dfCalificacionSingle$Exp <- as.character('Single')
head(dfCalificacionSingle)

dfCalificacion <- rbind(
  dfCalificacionGroup[c(
    'Player',
    'Raza',
    'Stage',
    'Round',
    'Kind',
    'Correct',
    'Exp')
    ],
  dfCalificacionSingle[c(
    'Player',
    'Raza',
    'Stage',
    'Round',
    'Kind',
    'Correct',
    'Exp')
    ]
)
dfCalificacion$Kind <- mapvalues(dfCalificacion$Kind, 
                                  from = levels(dfCalificacion$Kind), 
                                  to = c('Cairn Terrier',
                                         'Irish Wolfhound',
                                         'Norwich Terrier', 
                                         'Scottish Deerhound'))

head(dfCalificacion)

correct_summary <- dfCalificacion %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Kind, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(correct_summary)


gTrainingRaza <- ggplot(correct_summary, aes(x=Round, y=meanCorrect, color=Kind, group=Kind)) +
  geom_line(size=0.8) +
#  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
#                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Race") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
  scale_color_colorblind() +
  ylim(c(0.5,1)) + 
#  ggtitle("Cairn Terrier") +
  theme_bw() +
  theme(legend.position="right")

gTrainingRaza


##########################################################################
# Analizando condicion PAREJAS -- TERRIERS
##########################################################################

dfPuntajeGroup = read.csv('paraK_group.csv')
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Stage == 1, ]
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Raza == 'terrier', ]
head(dfPuntajeGroup)

comunicacion_summary <- dfPuntajeGroup %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Kind, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE)) # calculates the standard error of each group
head(comunicacion_summary)

gTrainingRaza <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Kind, group=Kind)) +
  geom_line(size=0.8) +
#  geom_ribbon(aes(ymin = Score - sd,
#                  ymax = Score + sd), alpha = 0.2) +
#  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
#  labs(color = "Expertise") +
#  xlab("Round") +
#  ylab("Av. Score") +
  ylim(c(0.5,1)) + 
  ggtitle("Training") +
  theme_bw() +
  theme(legend.position="none")

gTrainingRaza

dfPuntajeGroup = read.csv('paraK_group.csv')
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Stage == 2, ]
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Raza == 'terrier', ]
head(dfPuntajeGroup)

comunicacion_summary <- dfPuntajeGroup %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Kind, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE)) # calculates the standard error of each group
head(comunicacion_summary)

gGameRaza <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Kind, group=Kind)) +
  geom_line(size=0.8) +
  #  geom_ribbon(aes(ymin = Score - sd,
  #                  ymax = Score + sd), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  #  labs(color = "Expertise") +
  #  xlab("Round") +
  #  ylab("Av. Score") +
  ylim(c(0.5,1)) + 
  ggtitle("Game") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza

g1 <- grid.arrange(gTrainingRaza, gGameRaza, nrow = 1, top="Terrier experts")

##########################################################################
# Analizando condicion INDIVIDUOS -- TERRIERS
##########################################################################

dfPuntajeGroup = read.csv('paraK_single.csv')
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Stage == 5, ]
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Raza == 'terrier', ]
head(dfPuntajeGroup)

comunicacion_summary <- dfPuntajeGroup %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Kind, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE)) # calculates the standard error of each group
head(comunicacion_summary)

gTrainingRaza <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Kind, group=Kind)) +
  geom_line(size=0.8) +
  #  geom_ribbon(aes(ymin = Score - sd,
  #                  ymax = Score + sd), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  #  labs(color = "Expertise") +
  #  xlab("Round") +
  #  ylab("Av. Score") +
  ylim(c(0.5,1)) + 
  ggtitle("Training") +
  theme_bw() +
  theme(legend.position="none")

gTrainingRaza

dfPuntajeGroup = read.csv('paraK_single.csv')
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Stage == 6, ]
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Raza == 'terrier', ]
head(dfPuntajeGroup)

comunicacion_summary <- dfPuntajeGroup %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Kind, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE)) # calculates the standard error of each group
head(comunicacion_summary)

gGameRaza <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Kind, group=Kind)) +
  geom_line(size=0.8) +
  #  geom_ribbon(aes(ymin = Score - sd,
  #                  ymax = Score + sd), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  #  labs(color = "Expertise") +
  #  xlab("Round") +
  #  ylab("Av. Score") +
  ylim(c(0.5,1)) + 
  ggtitle("Game") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza

g2 <- grid.arrange(gTrainingRaza, gGameRaza, nrow = 1, top="Terrier experts")

##########################################################################
# Analizando condicion PAREJAS -- HOUNDS
##########################################################################

dfPuntajeGroup = read.csv('paraK_group.csv')
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Stage == 1, ]
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Raza == 'hound', ]
head(dfPuntajeGroup)

comunicacion_summary <- dfPuntajeGroup %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Kind, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE)) # calculates the standard error of each group
head(comunicacion_summary)

gTrainingRaza <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Kind, group=Kind)) +
  geom_line(size=0.8) +
  #  geom_ribbon(aes(ymin = Score - sd,
  #                  ymax = Score + sd), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  #  labs(color = "Expertise") +
  #  xlab("Round") +
  #  ylab("Av. Score") +
  ylim(c(0.4,1)) + 
  ggtitle("Training") +
  theme_bw() +
  theme(legend.position="none")

gTrainingRaza

dfPuntajeGroup = read.csv('paraK_group.csv')
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Stage == 2, ]
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Raza == 'hound', ]
head(dfPuntajeGroup)

comunicacion_summary <- dfPuntajeGroup %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Kind, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE)) # calculates the standard error of each group
head(comunicacion_summary)

gGameRaza <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Kind, group=Kind)) +
  geom_line(size=0.8) +
  #  geom_ribbon(aes(ymin = Score - sd,
  #                  ymax = Score + sd), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  #  labs(color = "Expertise") +
  #  xlab("Round") +
  #  ylab("Av. Score") +
  ylim(c(0.4,1)) + 
  ggtitle("Game") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza

g1 <- grid.arrange(gTrainingRaza, gGameRaza, nrow = 1, top="Hound experts")

##########################################################################
# Analizando condicion INDIVIDUOS -- HOUNDS
##########################################################################

dfPuntajeGroup = read.csv('paraK_single.csv')
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Stage == 5, ]
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Raza == 'hound', ]
head(dfPuntajeGroup)

comunicacion_summary <- dfPuntajeGroup %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Kind, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE)) # calculates the standard error of each group
head(comunicacion_summary)

gTrainingRaza <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Kind, group=Kind)) +
  geom_line(size=0.8) +
  #  geom_ribbon(aes(ymin = Score - sd,
  #                  ymax = Score + sd), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  #  labs(color = "Expertise") +
  #  xlab("Round") +
  #  ylab("Av. Score") +
  ylim(c(0.4,1)) + 
  ggtitle("Training") +
  theme_bw() +
  theme(legend.position="none")

gTrainingRaza

dfPuntajeGroup = read.csv('paraK_single.csv')
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Stage == 6, ]
dfPuntajeGroup <- dfPuntajeGroup[dfPuntajeGroup$Raza == 'hound', ]
head(dfPuntajeGroup)

comunicacion_summary <- dfPuntajeGroup %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Kind, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE)) # calculates the standard error of each group
head(comunicacion_summary)

gGameRaza <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Kind, group=Kind)) +
  geom_line(size=0.8) +
  #  geom_ribbon(aes(ymin = Score - sd,
  #                  ymax = Score + sd), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  #  labs(color = "Expertise") +
  #  xlab("Round") +
  #  ylab("Av. Score") +
  ylim(c(0.4,1)) + 
  ggtitle("Game") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza

g2 <- grid.arrange(gTrainingRaza, gGameRaza, nrow = 1, top="Hound experts")

##########################################################################
# Analizando desempeño novatos por perro
##########################################################################

dfCalificacionGroup = read.csv('paraK_group.csv')
dfCalificacionGroup <- dfCalificacionGroup[dfCalificacionGroup$Stage == 2, ]
dfCalificacionGroup$Exp <- as.character('Pairs')
head(dfCalificacionGroup)

dfCalificacionSingle = read.csv('paraK_single.csv')
dfCalificacionSingle <- dfCalificacionSingle[dfCalificacionSingle$Stage == 6, ]
dfCalificacionSingle$Exp <- as.character('Single')
head(dfCalificacionSingle)

dfCalificacion <- rbind(
  dfCalificacionGroup[c(
    'Player',
    'Raza',
    'Stage',
    'Round',
    'Kind',
    'Correct',
    'Exp')
    ],
  dfCalificacionSingle[c(
    'Player',
    'Raza',
    'Stage',
    'Round',
    'Kind',
    'Correct',
    'Exp')
    ]
)
head(dfCalificacion)

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'A', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Raza == 'hound', ]

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Exp, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)


gGameRaza1 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Exp, group=Exp)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Condition") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Cairn Terrier") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza1

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'C', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Raza == 'hound', ]

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Exp, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)


gGameRaza2 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Exp, group=Exp)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Condition") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Norwich Terrier") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza2

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'B', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Raza == 'terrier', ]

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Exp, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)

gGameRaza3 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Exp, group=Exp)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Condition") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Irish Wolfhound") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza3

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'D', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Raza == 'terrier', ]

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Exp, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)

gGameRaza4 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Exp, group=Exp)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Condition") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Scottish Deerhound") +
  theme_bw() +
  theme(legend.position="bottom")

gGameRaza4 

legend <- get_legend(gGameRaza4)

gGameRaza1 <- gGameRaza1 + theme(legend.position="none")
gGameRaza2 <- gGameRaza2 + theme(legend.position="none")
gGameRaza3 <- gGameRaza3 + theme(legend.position="none")
gGameRaza4 <- gGameRaza4 + theme(legend.position="none")

g <- grid.arrange(gGameRaza1, gGameRaza3, gGameRaza2, gGameRaza4, 
                  nrow=2, 
                  top="Novices performance in game rounds",
                  bottom=legend)

##########################################################################
# Analizando desempeño expertos por perro
##########################################################################

dfCalificacionGroup = read.csv('paraK_group.csv')
dfCalificacionGroup <- dfCalificacionGroup[dfCalificacionGroup$Stage == 2, ]
dfCalificacionGroup$Exp <- as.character('Pairs')
head(dfCalificacionGroup)

dfCalificacionSingle = read.csv('paraK_single.csv')
dfCalificacionSingle <- dfCalificacionSingle[dfCalificacionSingle$Stage == 6, ]
dfCalificacionSingle$Exp <- as.character('Single')
head(dfCalificacionSingle)

dfCalificacion <- rbind(
  dfCalificacionGroup[c(
    'Player',
    'Raza',
    'Stage',
    'Round',
    'Kind',
    'Correct',
    'Exp')
    ],
  dfCalificacionSingle[c(
    'Player',
    'Raza',
    'Stage',
    'Round',
    'Kind',
    'Correct',
    'Exp')
    ]
)
head(dfCalificacion)

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'A', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Raza == 'terrier', ]

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Exp, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)


gGameRaza1 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Exp, group=Exp)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Condition") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Cairn Terrier") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza1

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'C', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Raza == 'terrier', ]

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Exp, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)


gGameRaza2 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Exp, group=Exp)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Condition") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Norwich Terrier") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza2

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'B', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Raza == 'hound', ]

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Exp, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)

gGameRaza3 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Exp, group=Exp)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Condition") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Irish Wolfhound") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza3

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'D', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Raza == 'hound', ]

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Exp, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)

gGameRaza4 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Exp, group=Exp)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  #  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Condition") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Scottish Deerhound") +
  theme_bw() +
  theme(legend.position="bottom")

gGameRaza4 

legend <- get_legend(gGameRaza4)

gGameRaza1 <- gGameRaza1 + theme(legend.position="none")
gGameRaza2 <- gGameRaza2 + theme(legend.position="none")
gGameRaza3 <- gGameRaza3 + theme(legend.position="none")
gGameRaza4 <- gGameRaza4 + theme(legend.position="none")

g <- grid.arrange(gGameRaza1, gGameRaza3, gGameRaza2, gGameRaza4, 
                  nrow=2, 
                  top="Experts performance in game rounds",
                  bottom=legend)


########################################################################################
# Comparando expertos y novatos respecto a misma raza en rondas juego -- Parejas
########################################################################################

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'A', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Exp == 'Pairs', ]

dfCalificacionPerro$Raza <- mapvalues(dfCalificacionPerro$Raza, 
                                  from = levels(dfCalificacionPerro$Raza), 
                                  to = c('Novice',
                                         'Expert'))

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Raza, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)


gGameRaza1 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Raza, group=Raza)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  scale_colour_manual(values = c("Novice" = "#000000", "Expert" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
#  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Cairn Terrier") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza1

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'B', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Exp == 'Pairs', ]

dfCalificacionPerro$Raza <- mapvalues(dfCalificacionPerro$Raza, 
                                      from = levels(dfCalificacionPerro$Raza), 
                                      to = c('Expert',
                                             'Novice'))

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Raza, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)


gGameRaza2 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Raza, group=Raza)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  scale_colour_manual(values = c("Novice" = "#000000", "Expert" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
#  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Irish Wolfhound") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza2

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'C', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Exp == 'Pairs', ]

dfCalificacionPerro$Raza <- mapvalues(dfCalificacionPerro$Raza, 
                                      from = levels(dfCalificacionPerro$Raza), 
                                      to = c('Novice',
                                             'Expert'))

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Raza, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)


gGameRaza3 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Raza, group=Raza)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  scale_colour_manual(values = c("Novice" = "#000000", "Expert" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
#  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Norwich Terrier") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza3

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'D', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Exp == 'Pairs', ]

dfCalificacionPerro$Raza <- mapvalues(dfCalificacionPerro$Raza, 
                                      from = levels(dfCalificacionPerro$Raza), 
                                      to = c('Expert',
                                             'Novice'))

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Raza, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)


gGameRaza4 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Raza, group=Raza)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  scale_colour_manual(values = c("Novice" = "#000000", "Expert" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
#  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Scottish Deerhound") +
  theme_bw() +
  theme(legend.position="bottom")

gGameRaza4

legend <- get_legend(gGameRaza4)

gGameRaza1 <- gGameRaza1 + theme(legend.position="none")
gGameRaza2 <- gGameRaza2 + theme(legend.position="none")
gGameRaza3 <- gGameRaza3 + theme(legend.position="none")
gGameRaza4 <- gGameRaza4 + theme(legend.position="none")

g <- grid.arrange(gGameRaza1, gGameRaza2, gGameRaza3, gGameRaza4, nrow=2, bottom=legend)

########################################################################################
# Comparando expertos y novatos respecto a misma raza en rondas juego -- Individuos
########################################################################################

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'A', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Exp == 'Single', ]

dfCalificacionPerro$Raza <- mapvalues(dfCalificacionPerro$Raza, 
                                      from = levels(dfCalificacionPerro$Raza), 
                                      to = c('Novice',
                                             'Expert'))

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Raza, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)


gGameRaza1 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Raza, group=Raza)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  scale_colour_manual(values = c("Novice" = "#000000", "Expert" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
  #  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Cairn Terrier") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza1

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'B', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Exp == 'Single', ]

dfCalificacionPerro$Raza <- mapvalues(dfCalificacionPerro$Raza, 
                                      from = levels(dfCalificacionPerro$Raza), 
                                      to = c('Expert',
                                             'Novice'))

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Raza, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)


gGameRaza2 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Raza, group=Raza)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  scale_colour_manual(values = c("Novice" = "#000000", "Expert" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
  #  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Irish Wolfhound") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza2

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'C', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Exp == 'Single', ]

dfCalificacionPerro$Raza <- mapvalues(dfCalificacionPerro$Raza, 
                                      from = levels(dfCalificacionPerro$Raza), 
                                      to = c('Novice',
                                             'Expert'))

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Raza, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)


gGameRaza3 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Raza, group=Raza)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  scale_colour_manual(values = c("Novice" = "#000000", "Expert" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
  #  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Norwich Terrier") +
  theme_bw() +
  theme(legend.position="right")

gGameRaza3

dfCalificacionPerro <- dfCalificacion[dfCalificacion$Kind == 'D', ]
dfCalificacionPerro <- dfCalificacionPerro[dfCalificacionPerro$Exp == 'Single', ]

dfCalificacionPerro$Raza <- mapvalues(dfCalificacionPerro$Raza, 
                                      from = levels(dfCalificacionPerro$Raza), 
                                      to = c('Expert',
                                             'Novice'))

comunicacion_summary <- dfCalificacionPerro %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Raza, Round) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Correct, na.rm=TRUE),  # calculates the mean of each group
                   sd_PL = sd(Correct, na.rm=TRUE), # calculates the standard deviation of each group
                   n_PL = n(),  # calculates the sample size per group
                   SE_PL = sd(Correct, na.rm=TRUE)/sqrt(n())) # calculates the standard error of each group
head(comunicacion_summary)


gGameRaza4 <- ggplot(comunicacion_summary, aes(x=Round, y=meanCorrect, color=Raza, group=Raza)) +
  geom_line(size=0.8) +
  geom_ribbon(aes(ymin = meanCorrect - sd_PL,
                  ymax = meanCorrect + sd_PL), alpha = 0.2) +
  scale_colour_manual(values = c("Novice" = "#000000", "Expert" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. correct classification (%)") +
  #  scale_color_colorblind() +
  ylim(c(0,1.3)) + 
  ggtitle("Scottish Deerhound") +
  theme_bw() +
  theme(legend.position="bottom")

gGameRaza4

legend <- get_legend(gGameRaza4)

gGameRaza1 <- gGameRaza1 + theme(legend.position="none")
gGameRaza2 <- gGameRaza2 + theme(legend.position="none")
gGameRaza3 <- gGameRaza3 + theme(legend.position="none")
gGameRaza4 <- gGameRaza4 + theme(legend.position="none")

g <- grid.arrange(gGameRaza1, gGameRaza2, gGameRaza3, gGameRaza4, nrow=2, bottom=legend)
