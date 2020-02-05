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
# Analyzing score
##########################################################################

dfPuntajeGroup = read.csv('puntaje_group.csv')
head(dfPuntajeGroup)
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
                           'Raza',
                           'Stage',
                           'Round',
                           'Score',
                           'Exp')],
  dfPuntajeSingleTraining[c('Player',
                            'Raza',
                            'Stage',
                            'Round','Score',
                            'Exp')]
)
df$Exp <- as.factor(df$Exp)
#df$Exp <- factor(df$Exp, levels = c('Paired', 'Single'))
head(df)

dfScore <- summarySE(df, measurevar="Score", groupvars=c("Exp", "Round"))
head(dfScore)

gTrainingCondition <- ggplot(dfScore, aes(x = Round, y = Score, color=Exp, group=Exp)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = Score - sd,
                  ymax = Score + sd), alpha = 0.2) +
  scale_colour_manual(values = c("Paired" = "#999999", "Single" = "#E69F00")) + 
  labs(color = "Condition") +
  xlab("Round") +
  ylab("Av. Score") +
  ylim(c(1,6)) + 
  ggtitle("Training vs. Condition") +
  theme_bw() +
  theme(legend.position="bottom")
  
gTrainingCondition

dfScore <- df %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Round, Raza) %>%   # the grouping variable
  dplyr::summarise(meanCorrect = mean(Score, na.rm=TRUE),
                   sdCorrect = sd(Score, na.rm=TRUE),
                   nCorrect = n()) %>% # calculates the standard error of each group
  dplyr::mutate(seCorrect = sdCorrect / sqrt(nCorrect),
                ciCorrect = qt(1 - (0.05 / 2), nCorrect - 1) * seCorrect)
head(dfScore)

gTrainingRaza <- ggplot(dfScore, aes(x=Round, y=meanCorrect, color=Raza, group=Raza)) +
  geom_line(size=0.7) +
#  geom_ribbon(aes(ymin = meanCorrect - ciCorrect,
#                  ymax = meanCorrect + ciCorrect), alpha = 0.2) +
  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. Score") +
  ylim(c(1,6)) + 
  ggtitle("Performance in Training rounds per Expertise") +
  theme_bw() +
  theme(legend.position="bottom")

gTrainingRaza

gTraining <- grid.arrange(gTrainingCondition, gTrainingRaza, nrow = 1, bottom=legend)


# Create single data frame for game rounds
df <- rbind(
  dfPuntajeGroupGame[c('Player',
                       'Raza',
                       'Stage',
                       'Round',
                       'Score',
                       'Exp')],
  dfPuntajeSingleGame[c('Player',
                        'Raza',
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

gGameCondition <- ggplot(dfScore, aes(x = Round, y = Score, color=Exp, group=Exp)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = Score - sd,
                  ymax = Score + sd), alpha = 0.2) +
  scale_colour_manual(values = c("Paired" = "#999999", "Single" = "#E69F00")) + 
  labs(color = "Condition") +
  xlab("Round") +
  ylab("Av. Score") +
  ylim(c(1,6)) + 
  ggtitle("Game vs. Condition") +
  theme_bw() +
  theme(legend.position="bottom")

gGameCondition

dfScore <- summarySE(df, measurevar="Score", groupvars=c("Raza", "Round"))
head(dfScore)

gGameRaza <- ggplot(dfScore, aes(x = Round, y = Score, color=Raza, group=Raza)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = Score - sd,
                  ymax = Score + sd), alpha = 0.2) +
  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. Score") +
  ylim(c(1,6)) + 
  ggtitle("Game vs. Expertise") +
  theme_bw() +
  theme(legend.position="bottom")

gGameRaza

gGame <- grid.arrange(gGameCondition, gGameRaza, nrow = 1, bottom=legend)

#legend <- get_legend(g1)
#g1 <- g1 + theme(legend.position="none")
#g2 <- g2 + theme(legend.position="none")

#gScore <- grid.arrange(g1, g2, nrow = 1, bottom=legend)
