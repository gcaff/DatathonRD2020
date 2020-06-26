d <- read.csv("../../data/data.csv")

dd <- d[,1:14]
pairs(dd[,7:14])