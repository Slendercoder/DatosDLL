library(ggplot2)
library(gridExtra)
library(grid)
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
# Analyzing communication
##########################################################################

dfCom = read.csv('comunicacion.csv')
dfCom$Correctitud <- as.numeric(dfCom$Correctitud)
head(dfCom)

comunicacion_summary <- dfCom %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Raza, Player, Round) %>%   # the grouping variable
  dplyr::summarise(maxMessag = max(Contador)) # calculates the standard error of each group
head(comunicacion_summary)

comunicacion_summary <- summarySE(comunicacion_summary, measurevar="maxMessag", groupvars=c("Raza", "Round"))
head(comunicacion_summary)

gComRaza <- ggplot(comunicacion_summary, aes(x = Round, y = maxMessag, color=Raza, group=Raza)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = maxMessag - sd,
                  ymax = maxMessag + sd), alpha = 0.2) +
  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. number of messages") +
#  ylim(c(1,6)) + 
  ggtitle("Amount of communication per round") +
  theme_bw() +
  theme(legend.position="bottom")

gComRaza

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
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = mean_PL - sd_PL,
                  ymax = mean_PL + sd_PL), alpha = 0.2) +
  scale_colour_manual(values = c("terrier" = "#999999", "hound" = "#E69F00")) + 
  labs(color = "Expertise") +
  xlab("Round") +
  ylab("Av. number of correct answered messages") +
  ylim(c(0,1.25)) + 
  ggtitle("Correctness per round") +
  theme_bw() +
  theme(legend.position="bottom")

gComCorr

comunicacion_summary <- dfCom %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Round) %>%   # the grouping variable
  dplyr::summarise(maxMessag = max(Contador),
                   mean_Corr = mean(Correctitud, na.rm=TRUE)) # calculates the standard error of each group
head(comunicacion_summary)

g <- ggplot(comunicacion_summary, aes(x=mean_Corr, y=maxMessag)) +
  geom_point(color='blue') + 
  geom_smooth(method = "lm", se = TRUE) +
  theme_bw()

g

dfTerriers <- dfCom[dfCom$Raza == 'terrier', ]
dfTerriersB <- dfTerriers[dfTerriers$Rotulo == 'B', ]

comunicacion_summary <- dfTerriersB %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Rotulo, suposicion) %>%   # the grouping variable
  dplyr::summarise(n = n()) # calculates the standard error of each group
head(comunicacion_summary)

gB <- ggplot(comunicacion_summary, aes(suposicion, fill=suposicion)) + 
  geom_bar(aes(y = ..prop..), stat="count", position="dodge") +
  geom_text(aes(label = scales::percent(..prop..),
                 y= ..prop.. ), stat="count", vjust = -.5) +
  labs(y = "Percent", fill="Region") +
#  geom_col(aes(y=n)) +
  ggtitle("Guess before message asking is this B?") +
  theme_classic() +
  theme(legend.position="none")

gB

dfTerriers <- dfCom[dfCom$Raza == 'terrier', ]
dfTerriersD <- dfTerriers[dfTerriers$Rotulo == 'D', ]

comunicacion_summary <- dfTerriersD %>% # the names of the new data frame and the data frame to be summarised
  dplyr::group_by(Rotulo, suposicion) %>%   # the grouping variable
  dplyr::summarise(n = n()) # calculates the standard error of each group
head(comunicacion_summary)

gD <- ggplot(comunicacion_summary, aes(suposicion, fill=suposicion)) + 
  geom_col(aes(y=n)) +
  ggtitle("Guess before message asking is this D?") +
  theme_classic() +
  theme(legend.position="none")

gD

gExpertTerriers <- grid.arrange(gB, gD, nrow = 1, top="Terrier experts")