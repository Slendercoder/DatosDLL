library(dplyr)

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
head(dfCalificacion)

df1 <- dfCalificacion[dfCalificacion$Kind == 'terrier', ]
df1 <- df1 %>% select(Player, GradingA, Exp)
colnames(df1) <- c('Player', 'Grading', 'Exp')
df2 <- dfCalificacion[dfCalificacion$Kind == 'terrier', ]
df2 <- df2 %>% select(Player, GradingC, Exp)
colnames(df2) <- c('Player', 'Grading', 'Exp')
dfT <- rbind(df1, df2)

df1 <- dfCalificacion[dfCalificacion$Kind == 'hound', ]
df1 <- df1 %>% select(Player, GradingB, Exp)
colnames(df1) <- c('Player', 'Grading', 'Exp')
df2 <- dfCalificacion[dfCalificacion$Kind == 'hound', ]
df2 <- df2 %>% select(Player, GradingD, Exp)
colnames(df2) <- c('Player', 'Grading', 'Exp')
dfH <- rbind(df1, df2)

df <- rbind(dfT, dfH)

mSingle <- mean(df$Grading[df$Exp=="Single"])
mPair <- mean(df$Grading[df$Exp=="Pairs"])

# Density plot
g2 <- ggplot(df, aes(Grading, group=Exp, color=Exp)) +
  geom_density(size=1) +
  scale_colour_manual(values = c("Pairs" = "#E69F00", "Single" = "#56B4E9")) +  
  #  scale_y_continuous(limits = c(0, 5)) + 
  labs(color = "Condition") +
  ggtitle("Experts\' understanding") +
  theme_bw()

g2 <- g2 + geom_vline(xintercept = mSingle, linetype="dotted", 
                  color = "#56B4E9", size=0.8)

g2 <- g2 + geom_vline(xintercept = mPair, linetype="dotted", 
                      color = "#E69F00", size=0.8)

g2  


df1 <- dfCalificacion[dfCalificacion$Kind == 'hound', ]
df1 <- df1 %>% select(Player, GradingA, Exp)
colnames(df1) <- c('Player', 'Grading', 'Exp')
df2 <- dfCalificacion[dfCalificacion$Kind == 'hound', ]
df2 <- df2 %>% select(Player, GradingC, Exp)
colnames(df2) <- c('Player', 'Grading', 'Exp')
dfT <- rbind(df1, df2)

df1 <- dfCalificacion[dfCalificacion$Kind == 'terrier', ]
df1 <- df1 %>% select(Player, GradingB, Exp)
colnames(df1) <- c('Player', 'Grading', 'Exp')
df2 <- dfCalificacion[dfCalificacion$Kind == 'terrier', ]
df2 <- df2 %>% select(Player, GradingD, Exp)
colnames(df2) <- c('Player', 'Grading', 'Exp')
dfH <- rbind(df1, df2)

df <- rbind(dfT, dfH)

mSingle <- mean(df$Grading[df$Exp=="Single"])
mPair <- mean(df$Grading[df$Exp=="Pairs"])

# Density plot
g1 <- ggplot(df, aes(Grading, group=Exp, color=Exp)) +
  geom_density(size=1) +
  scale_colour_manual(values = c("Pairs" = "#E69F00", "Single" = "#56B4E9")) +  
  #  scale_y_continuous(limits = c(0, 5)) + 
  labs(color = "Condition") +
  ggtitle("Novices\' understanding") +
  theme_bw() + 
  theme(legend.position="bottom")

g1 <- g1 + geom_vline(xintercept = mSingle, linetype="dotted", 
                      color = "#56B4E9", size=0.8)

g1 <- g1 + geom_vline(xintercept = mPair, linetype="dotted", 
                      color = "#E69F00", size=0.8)

g1

legend <- get_legend(g1)
g1 <- g1 + theme(legend.position="none")
g2 <- g2 + theme(legend.position="none")


p <- grid.arrange(g1, g2, nrow=1, bottom=legend)



