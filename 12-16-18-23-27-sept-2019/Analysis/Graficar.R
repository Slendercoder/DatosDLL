library(ggplot2)
library(Rmisc)
library(ggplot2)
library(gridExtra)
library(latex2exp)
library(grid)

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


dfCalificacion = read.csv('calificacion.csv')
head(dfCalificacion)

dfTerriers <- 

proms <- c(mean(dfCalificacion$GradingA), 
           mean(dfCalificacion$GradingB), 
           mean(dfCalificacion$GradingC), 
           mean(dfCalificacion$GradingD))

proms

dfKindA <- summarySE(dfCalificacion, measurevar="GradingA", groupvars=c("Kind"))
head(dfKindA)

dfKindB <- summarySE(dfCalificacion, measurevar="GradingB", groupvars=c("Kind"))
head(dfKindB)

dfKindC <- summarySE(dfCalificacion, measurevar="GradingC", groupvars=c("Kind"))
head(dfKindC)

dfKindD <- summarySE(dfCalificacion, measurevar="GradingD", groupvars=c("Kind"))
head(dfKindD)

g2 <- ggplot(dfScore, aes(x = Round, y = Score, group = "Kind", color = "Kind")) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = Score - sd,
                  ymax = Score + sd), alpha = 0.2) +
  #  scale_colour_manual(values = c("Observed behavior" = "#999999", "WSLS" = "#E69F00", "FRA" = "#56B4E9")) +  
  xlab("Round") +
  ylab("Av. Score") +
  theme_bw()

g2
