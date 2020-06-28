library(pls)

d_in <- read.csv("../../data/inputs.csv")
d_target <- read.csv("../../data/target.csv")

d_tree <- cbind(d_in[,-1],d_target)

d_sub <- d_tree[,-c(1:3,41)]

pcr.fit <- pcr(cumulative_cases ~., data=d_sub)

mean(abs(predict(pcr.fit)-y))