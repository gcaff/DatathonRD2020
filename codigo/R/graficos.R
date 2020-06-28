library(ggplot2)

rm(list=ls())

d <- read.csv("../../data/DATA_RETO_2.csv")

d$log_pop <- log(d$population)

p1 <- qplot(d$population, fill = "niveles") +
  theme_minimal()

p2 <- qplot(d$log_pop, fill = "log") +
  theme_minimal()

ggsave("../../img/pop_lvl.png",p1)
ggsave("../../img/pop_log.png",p2)