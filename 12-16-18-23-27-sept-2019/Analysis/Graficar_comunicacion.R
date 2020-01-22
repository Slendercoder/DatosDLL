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
head(dfCom)

comunicacion_summary <- dfCom %>% # the names of the new data frame and the data frame to be summarised
  group_by(Raza, Player, Round) %>%   # the grouping variable
  summarise(maxMessag = max(Contador)) # calculates the standard error of each group
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
  ggtitle("Communication vs. Expertise") +
  theme_bw() +
  theme(legend.position="bottom")

gComRaza

comunicacion_summary <- dfCom %>% # the names of the new data frame and the data frame to be summarised
  group_by(Kind, Player, Round) %>%   # the grouping variable
  summarise(maxMessag = max(Contador)) # calculates the standard error of each group
head(comunicacion_summary)

comunicacion_summary <- summarySE(comunicacion_summary, measurevar="maxMessag", groupvars=c("Kind", "Round"))
head(comunicacion_summary)

gComRaza <- ggplot(comunicacion_summary, aes(x = Round, y = maxMessag, color=Kind, group=Kind)) +
  geom_line(size=0.7) +
  geom_ribbon(aes(ymin = maxMessag - sd,
                  ymax = maxMessag + sd), alpha = 0.2) +
#  scale_colour_manual(values = c("A"="#F0E442", "B"="#E69F00", "C"="#56B4E9", "D"="#009E73", "" = "#CC79A7"),
#                      labels = c("Cairn Terrier", "Irish Wolfhound", "Norwich Terrier", "Scottish DeerHound", "Faltante")) + 
  labs(color = "Kind of dog") +
  xlab("Round") +
  ylab("Av. number of messages") +
  #  ylim(c(1,6)) + 
  ggtitle("Communication vs. Expertise") +
  theme_bw() +
  theme(legend.position="bottom")

gComRaza
