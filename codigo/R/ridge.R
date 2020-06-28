library(glmnet)


d_in <- read.csv("../../data/inputs.csv")
d_target <- read.csv("../../data/target.csv")

d_tree <- cbind(d_in[,-1],d_target)

d_sub <- d_tree[,-c(1:3,41)]
X = model.matrix(cumulative_cases~.,d_sub)[,-37]
y = d_tree$cumulative_cases

grid=10^seq(10,-2,length=100)

ridge.mod=glmnet(X,y,alpha=0.5,lambda=grid)

mean(abs(predict(ridge.mod,newx = X)-y))