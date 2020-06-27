tourism <- read.csv("../../data/indicadores/tourism_num_arrivals.csv",skip = 4)

tourism <- tourism[,c(2,62:63)]

colnames(tourism) <- c("iso","tourism_2017","tourism_2018")

dd2 <- dd1 %>%
  left_join(tourism,by="iso") 

dd2 %>%
  write.csv(file = "../../data/otros_indicadores.csv")
  