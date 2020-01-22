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
# Analyzing correctness
##########################################################################

dfPuntajeGroup = read.csv('paraK_group.csv')
head(dfPuntajeGroup)
dfPuntajeGroup$Stage <- factor(dfPuntajeGroup$Stage)
dfPuntajeGroup$Exp <- as.character("Paired")
head(dfPuntajeGroup)

dfPuntajeGroupTraining <- dfPuntajeGroup[dfPuntajeGroup$Stage == 1, ]
dfPuntajeGroupGame <- dfPuntajeGroup[dfPuntajeGroup$Stage == 2, ]

dfPuntajeSingle = read.csv('paraK_single.csv')
dfPuntajeSingle$Stage <- factor(dfPuntajeSingle$Stage)
dfPuntajeSingle$Exp <- as.character("Single")
head(dfPuntajeSingle)

dfPuntajeSingleTraining <- dfPuntajeSingle[dfPuntajeSingle$Stage == 5, ]
dfPuntajeSingleGame <- dfPuntajeSingle[dfPuntajeSingle$Stage == 6, ]


##########################################################################
# Analyzing Training rounds
##########################################################################

# Create single data frame from both conditions
df <- rbind(
  dfPuntajeGroupTraining[c('Dyad',
                           'Player',
                           'Raza',
                           'Stage',
                           'Round',
                           'Object',
                           'Kind',
                           'Correct',
                           'Exp')],
  dfPuntajeSingleTraining[c('Dyad',
                            'Player',
                            'Raza',
                            'Stage',
                            'Round',
                            'Object',
                            'Kind',
                            'Correct',
                            'Exp')]
)
df$Exp <- as.factor(df$Exp)
#df$Exp <- factor(df$Exp, levels = c('Paired', 'Single'))
head(df)

correct_summary <- df %>% # the names of the new data frame and the data frame to be summarised
  group_by(Exp, Raza, Player, Round) %>%   # the grouping variable
  summarise(pCor = sum(Correct)/n())  # calculates the proportion of correctness of each group
head(correct_summary)

dfCor <- summarySE(correct_summary, measurevar="pCor", groupvars=c("Exp", "Round"))
head(dfCor)

gTrainingCondition <- ggplot(dfCor, aes(x = Round, y = pCor, color=Exp, group=Exp)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = pCor - sd,
                  ymax = pCor + sd), alpha = 0.2) +
  scale_colour_manual(values = c("Paired" = "#999999", "Single" = "#E69F00")) + 
  labs(color = "Condition") +
  xlab("Round") +
  ylab("Av. correctness") +
  ylim(c(0, 1.2)) + 
  ggtitle("Training vs. Condition") +
  theme_bw() +
  theme(legend.position="bottom")

gTrainingCondition

dfCor <- summarySE(correct_summary, measurevar="pCor", groupvars=c("Raza", "Round"))
head(dfCor)

gTrainingRaza <- ggplot(dfCor, aes(x=Round, y=pCor, color=Raza, group=Raza)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = pCor - sd,
                  ymax = pCor + sd), alpha = 0.2) +
  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. correctness") +
  ylim(c(0, 1.2)) + 
  ggtitle("Training vs. Expertise") +
  theme_bw() +
  theme(legend.position="bottom")

gTrainingRaza

correct_summary <- df %>% # the names of the new data frame and the data frame to be summarised
  group_by(Exp, Raza, Player, Round, Kind) %>%   # the grouping variable
  summarise(pCor = sum(Correct)/n())  # calculates the proportion of correctness of each group
head(correct_summary)

dfCor <- summarySE(correct_summary, measurevar="pCor", groupvars=c("Round", "Kind"))
head(dfCor)

gTrainingLabel <- ggplot(dfCor, aes(x = Round, y = pCor, color=Kind, group=Kind)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = pCor - sd,
                  ymax = pCor + sd), alpha = 0.2) +
  scale_colour_manual(values = c("A"="#F0E442", "B"="#E69F00", "C"="#56B4E9", "D"="#009E73"),
                      labels = c("Cairn Terrier", "Irish Wolfhound", "Norwich Terrier", "Scottish DeerHound")) + 
  labs(color = "Kind of dog") +
  xlab("Round") +
  ylab("Av. correctness") +
#  ylim(c(0, 1.2)) + 
  ggtitle("Training vs. Kind of dog") +
  theme_bw() +
  theme(legend.position="bottom")

gTrainingLabel

gTraining <- grid.arrange(gTrainingCondition, gTrainingRaza, gTrainingLabel, nrow = 1, bottom=legend)

##########################################################################
# Analyzing Game rounds
##########################################################################

# Create single data frame from both conditions
df <- rbind(
  dfPuntajeGroupGame[c('Dyad',
                           'Player',
                           'Raza',
                           'Stage',
                           'Round',
                           'Object',
                           'Kind',
                           'Correct',
                           'Exp')],
  dfPuntajeSingleGame[c('Dyad',
                            'Player',
                            'Raza',
                            'Stage',
                            'Round',
                            'Object',
                            'Kind',
                            'Correct',
                            'Exp')]
)
df$Exp <- as.factor(df$Exp)
#df$Exp <- factor(df$Exp, levels = c('Paired', 'Single'))
head(df)

correct_summary <- df %>% # the names of the new data frame and the data frame to be summarised
  group_by(Exp, Raza, Player, Round) %>%   # the grouping variable
  summarise(pCor = sum(Correct)/n())  # calculates the proportion of correctness of each group
head(correct_summary)

dfCor <- summarySE(correct_summary, measurevar="pCor", groupvars=c("Exp", "Round"))
head(dfCor)

gGameCondition <- ggplot(dfCor, aes(x = Round, y = pCor, color=Exp, group=Exp)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = pCor - sd,
                  ymax = pCor + sd), alpha = 0.2) +
  scale_colour_manual(values = c("Paired" = "#999999", "Single" = "#E69F00")) + 
  labs(color = "Condition") +
  xlab("Round") +
  ylab("Av. correctness") +
  ylim(c(0, 1.2)) + 
  ggtitle("Game vs. Condition") +
  theme_bw() +
  theme(legend.position="bottom")

gGameCondition

dfCor <- summarySE(correct_summary, measurevar="pCor", groupvars=c("Raza", "Round"))
head(dfCor)

gGameRaza <- ggplot(dfCor, aes(x=Round, y=pCor, color=Raza, group=Raza)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = pCor - sd,
                  ymax = pCor + sd), alpha = 0.2) +
  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. correctness") +
  ylim(c(0, 1.2)) + 
  ggtitle("Game vs. Expertise") +
  theme_bw() +
  theme(legend.position="bottom")

gGameRaza

correct_summary <- df %>% # the names of the new data frame and the data frame to be summarised
  group_by(Exp, Raza, Player, Round, Kind) %>%   # the grouping variable
  summarise(pCor = sum(Correct)/n())  # calculates the proportion of correctness of each group
head(correct_summary)

dfCor <- summarySE(correct_summary, measurevar="pCor", groupvars=c("Round", "Kind"))
head(dfCor)

gGameLabel <- ggplot(dfCor, aes(x = Round, y = pCor, color=Kind, group=Kind)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = pCor - sd,
                  ymax = pCor + sd), alpha = 0.2) +
  scale_colour_manual(values = c("A"="#F0E442", "B"="#E69F00", "C"="#56B4E9", "D"="#009E73"),
                      labels = c("Cairn Terrier", "Irish Wolfhound", "Norwich Terrier", "Scottish DeerHound")) + 
  labs(color = "Kind of dog") +
  xlab("Round") +
  ylab("Av. correctness") +
  #  ylim(c(0, 1.2)) + 
  ggtitle("Game vs. Kind of dog") +
  theme_bw() +
  theme(legend.position="bottom")

gGameLabel

gGame <- grid.arrange(gGameCondition, gGameRaza, gGameLabel, nrow = 1, bottom=legend)
