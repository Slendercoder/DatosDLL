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
# Analyzing confidence
##########################################################################

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
  labs(y="Confidence in understanding", 
       x = "Expertise", 
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
  labs(y="Confidence in understanding", 
       x = "Expertise", 
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
  labs(y="Confidence in understanding", 
       x = "Expertise", 
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
  labs(y="Confidence in understanding", 
       x = "Expertise", 
       fill = "Condition") +
  theme_classic() +
  theme(legend.position="bottom")               # Position legend in bottom right

legend <- get_legend(gD)
gA <- gA + theme(legend.position="none")
gB <- gB + theme(legend.position="none")
gC <- gC + theme(legend.position="none")
gD <- gD + theme(legend.position="none")

gGradingTerriers <- grid.arrange(gA, gC, nrow = 1, bottom=legend)
gGradingHounds <- grid.arrange(gB, gD, nrow = 1, bottom=legend)
gGrading <- grid.arrange(gA, gB, gC, gD, nrow = 2, bottom=legend)

