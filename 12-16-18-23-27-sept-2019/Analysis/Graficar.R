library(ggplot2)
library(Rmisc)
library(ggplot2)
library(gridExtra)
library(latex2exp)
library(grid)
library(dplyr)


get_legend<-function(myggplot){
  tmp <- ggplot_gtable(ggplot_build(myggplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

######################################################

dfPuntajeGroup = read.csv('puntaje_group.csv')
dfPuntajeGroup$Stage <- factor(dfPuntajeGroup$Stage)
dfPuntajeGroup$Exp <- as.character("Paired")
head(dfPuntajeGroup)

dfPuntajeGroupTraining <- dfPuntajeGroup[dfPuntajeGroup$Stage == 1, ]
dfPuntajeGroupGame <- dfPuntajeGroup[dfPuntajeGroup$Stage == 2, ]

dfPuntajeSingle = read.csv('puntaje_single.csv')
dfPuntajeSingle$Stage <- factor(dfPuntajeSingle$Stage)
dfPuntajeSingle$Exp <- as.character("Single")
head(dfPuntajeSingle)

dfPuntajeSingleTraining <- dfPuntajeSingle[dfPuntajeSingle$Stage == 5, ]
dfPuntajeSingleGame <- dfPuntajeSingle[dfPuntajeSingle$Stage == 6, ]

# Create single data frame for training rounds
df <- rbind(
  dfPuntajeGroupTraining[c('Player',
        'Stage',
        'Round',
        'Score',
        'Exp')],
  dfPuntajeSingleTraining[c('Player',
        'Stage',
        'Round',
        'Score',
        'Exp')]
)
df$Exp <- as.factor(df$Exp)
#df$Exp <- factor(df$Exp, levels = c('Paired', 'Single'))
head(df)

dfScore <- summarySE(df, measurevar="Score", groupvars=c("Exp", "Round"))
head(dfScore)

g1 <- ggplot(dfScore, aes(x = Round, y = Score, color=Exp, group=Exp)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = Score - sd,
                  ymax = Score + sd), alpha = 0.2) +
  scale_colour_manual(values = c("Paired" = "#999999", "Single" = "#E69F00")) + 
  labs(color = "Condition") +
  xlab("Round") +
  ylab("Av. Score") +
  ylim(c(2,6)) + 
  ggtitle("Training") +
  theme_bw() +
  theme(legend.position="bottom")
  
g1

# Create single data frame for game rounds
df <- rbind(
  dfPuntajeGroupGame[c('Player',
                           'Stage',
                           'Round',
                           'Score',
                           'Exp')],
  dfPuntajeSingleGame[c('Player',
                            'Stage',
                            'Round',
                            'Score',
                            'Exp')]
)
df$Exp <- as.factor(df$Exp)
#df$Exp <- factor(df$Exp, levels = c('Paired', 'Single'))
head(df)

dfScore <- summarySE(df, measurevar="Score", groupvars=c("Exp", "Round"))
head(dfScore)

g2 <- ggplot(dfScore, aes(x = Round, y = Score, color=Exp, group=Exp)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = Score - sd,
                  ymax = Score + sd), alpha = 0.2) +
  scale_colour_manual(values = c("Paired" = "#999999", "Single" = "#E69F00")) + 
  labs(color = "Condition") +
  xlab("Round") +
  ylab("Av. Score") +
  ylim(c(2,6)) + 
  ggtitle("Game") +
  theme_bw() +
  theme(legend.position="bottom")

g2

legend <- get_legend(g1)
g1 <- g1 + theme(legend.position="none")
g2 <- g2 + theme(legend.position="none")

gScore <- grid.arrange(g1, g2, nrow = 1, bottom=legend)

###############################################################

dfCalificacionGroup = read.csv('calificacion_group.csv')
dfCalificacionGroup$Exp <- as.character('Pairs')
head(dfCalificacionGroup)

dfCalificacionSingle = read.csv('calificacion_single.csv')
dfCalificacionSingle$Exp <- as.character('Single')
head(dfCalificacionSingle)

dfCalificacion <- rbind(
  dfCalificacionGroup[c(
   'Player',
   'Kind',
   'GradingA',
   'GradingB',
   'GradingC',
   'GradingD',
   'Exp')
   ],
  dfCalificacionSingle[c(
    'Player',
    'Kind',
    'GradingA',
    'GradingB',
    'GradingC',
    'GradingD',
    'Exp')
    ]
)

calificacion_summary <- dfCalificacion %>% # the names of the new data frame and the data frame to be summarised
  group_by(Exp, Kind) %>%   # the grouping variable
  summarise(mean_PL = mean(GradingA),  # calculates the mean of each group
            sd_PL = sd(GradingA), # calculates the standard deviation of each group
            n_PL = n(),  # calculates the sample size per group
            SE_PL = sd(GradingA)/sqrt(n())) # calculates the standard error of each group

gA <- ggplot(calificacion_summary, aes(Kind, group=Exp, fill=Exp)) + 
  geom_col(aes(y=mean_PL), position="dodge") +  
  geom_errorbar(aes(ymin = mean_PL - sd_PL, ymax = mean_PL + sd_PL),
                size=0.3,
                width=0.2,
                position=position_dodge(.9)) +
  ylim(c(0,8)) + 
  ggtitle("Cairn Terrier") +
  labs(y="Confidence ± s.d.", 
       x = "Expertice", 
       fill = "Condition") +
  theme_classic()

calificacion_summary <- dfCalificacion %>% # the names of the new data frame and the data frame to be summarised
  group_by(Exp, Kind) %>%   # the grouping variable
  summarise(mean_PL = mean(GradingB),  # calculates the mean of each group
            sd_PL = sd(GradingB), # calculates the standard deviation of each group
            n_PL = n(),  # calculates the sample size per group
            SE_PL = sd(GradingB)/sqrt(n())) # calculates the standard error of each group

gB <- ggplot(calificacion_summary, aes(Kind, group=Exp, fill=Exp)) + 
  geom_col(aes(y=mean_PL), position="dodge") +  
  geom_errorbar(aes(ymin = mean_PL - sd_PL, ymax = mean_PL + sd_PL),
                size=0.3,
                width=0.2,
                position=position_dodge(.9)) +
  ylim(c(0,8)) + 
  ggtitle("Irish Wolfhound") + 
  labs(y="Confidence ± s.d.", 
       x = "Expertice", 
       fill = "Condition") +
  theme_classic()

calificacion_summary <- dfCalificacion %>% # the names of the new data frame and the data frame to be summarised
  group_by(Exp, Kind) %>%   # the grouping variable
  summarise(mean_PL = mean(GradingC),  # calculates the mean of each group
            sd_PL = sd(GradingC), # calculates the standard deviation of each group
            n_PL = n(),  # calculates the sample size per group
            SE_PL = sd(GradingC)/sqrt(n())) # calculates the standard error of each group

gC <- ggplot(calificacion_summary, aes(Kind, group=Exp, fill=Exp)) + 
  geom_col(aes(y=mean_PL), position="dodge") +  
  geom_errorbar(aes(ymin = mean_PL - sd_PL, ymax = mean_PL + sd_PL),
                size=0.3,
                width=0.2,
                position=position_dodge(.9)) +
  ylim(c(0,8)) + 
  ggtitle("Norwich Terrier") + 
  labs(y="Confidence ± s.d.", 
       x = "Expertice", 
       fill = "Condition") +
  theme_classic()

calificacion_summary <- dfCalificacion %>% # the names of the new data frame and the data frame to be summarised
  group_by(Exp, Kind) %>%   # the grouping variable
  summarise(mean_PL = mean(GradingD),  # calculates the mean of each group
            sd_PL = sd(GradingD), # calculates the standard deviation of each group
            n_PL = n(),  # calculates the sample size per group
            SE_PL = sd(GradingD)/sqrt(n())) # calculates the standard error of each group

gD <- ggplot(calificacion_summary, aes(Kind, group=Exp, fill=Exp)) + 
  geom_col(aes(y=mean_PL), position="dodge") +  
  geom_errorbar(aes(ymin = mean_PL - sd_PL, ymax = mean_PL + sd_PL),
                size=0.3,
                width=0.2,
                position=position_dodge(.9)) +
  ylim(c(0,8)) + 
  ggtitle("Scottish Deerhound") + 
  labs(y="Confidence ± s.d.", 
       x = "Expertice", 
       fill = "Condition") +
  theme_classic()

gGrading <- grid.arrange(gA, gB, gC, gD, nrow = 2)
