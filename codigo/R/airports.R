library(readr)


airports<- read_table("../../data/cia_num_airports.txt", col_names = F)

airports <- airports[,2:3]
colnames(airports) <- c("country","n_airports")


airports %>%
  arrange(country) %>%
  print(n=1000)

dd <- d %>%
  left_join(airports, by="country")
  

dd[is.na(dd$n_airports),c("country","n_airports")]

dd1 <- dd %>%
  select(country,country_code,iso,n_airports,population) %>%
  mutate(airports_per_pop = 1e6*n_airports/population) %>% #num airports por millon de hab
  select(-population)

write.csv(dd1,file = "../../data/num_airports.csv")
  