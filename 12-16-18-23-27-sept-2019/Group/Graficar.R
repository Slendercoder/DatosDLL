library(ggplot2)
library(Rmisc)


dfPuntaje = read.csv('puntaje.csv')
head(dfPuntaje)

dfScore <- summarySE(dfPuntaje, measurevar="Score", groupvars=c("Round"))
head(dfScore)

g1 <- ggplot(dfScore, aes(x = Round, y = Score)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = Score - sd,
                  ymax = Score + sd), alpha = 0.2) +
  #  scale_colour_manual(values = c("Observed behavior" = "#999999", "WSLS" = "#E69F00", "FRA" = "#56B4E9")) +  
  xlab("Round") +
  ylab("Av. Score") +
  theme_bw()

g1

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
