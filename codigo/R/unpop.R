library(tidyr)
library(dplyr)

unpop <- read.csv("../../data/indicadores/WPP2019_PopulationByAgeSex_Medium.csv")


unpop_65 <- unpop %>%
  filter(Time == 2019) %>% # tomo 2019 pq 2020 es una proyeccion
  filter(AgeGrpStart >= 65) %>%
  mutate(country=Location) %>%
  group_by(country) %>%
  summarise(tot_65 = sum(PopTotal))

unpop_70 <- unpop %>%
  filter(Time == 2019) %>% # tomo 2019 pq 2020 es una proyeccion
  filter(AgeGrpStart >= 70) %>%
  mutate(country=Location) %>%
  group_by(country) %>%
  summarise(tot_70 = sum(PopTotal))

sum(is.na(dd$aged_65_older) | dd$aged_65_older==0)
sum(is.na(dd$aged_70_older) | dd$aged_70_older==0)

dd[is.na(dd$aged_65_older) | dd$aged_65_older==0,]
dd[is.na(dd$aged_70_older) | dd$aged_70_older==0,]


dd1 <- dd %>%
  left_join(unpop_65, by="country") %>%
  left_join(unpop_70, by="country") %>%
  mutate(aged_65_older = ifelse(is.na(aged_65_older) | aged_65_older==0,
                                 100*tot_65/population,
                                 aged_65_older),
         aged_70_older = ifelse(is.na(aged_70_older | aged_70_older==0),
                                100*tot_70/population,
                                aged_70_older))

sum(is.na(dd1$aged_65_older) | dd1$aged_65_older==0)
sum(is.na(dd1$aged_70_older) | dd1$aged_70_older==0)