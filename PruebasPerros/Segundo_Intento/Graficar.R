library(ggplot2)
library(gridExtra)
library(Rmisc)

df = read.csv("puntaje.csv")
head(df)

# Plot DLIndex with error regions
p1 <- ggplot(df, aes(x = Round, y = Score, colour=Player, group=Player)) +
  geom_line(size=0.7) 

p1

# Summarize data
dfPuntaje <- summarySE(df, measurevar="Score", groupvars=c("Stage", "Round"))
head(dfPuntaje)

p2 <- ggplot(dfPuntaje, aes(x = Round, y = Score)) +
  geom_line(size=0.7) 

p2
