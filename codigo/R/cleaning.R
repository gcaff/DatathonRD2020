d <- read.csv("../../data/DATA_RETO_2.csv")

dd <- d[,1:14]
y <- d$cumulative_cases

# missing values & outliers
# primero los missing vals
dd[!complete.cases(dd),]

# hist
for (i in 7:ncol(dd)){
  hist(dd[,i])
}

# pairs con y
for (i in 7:ncol(dd)){
  plot(dd[,i],y)
  title(names(dd)[i])
}