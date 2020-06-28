library(glmnet)


d_in <- read.csv("../../data/inputs.csv")
d_target <- read.csv("../../data/target.csv")

d_tree <- cbind(d_in[,-1],d_target)

d_tree$log_turismo_18 <- d_tree$log_turismo >= 17.58 
d_tree$int_1 <- d_tree$businesses_and_public_services_closure*d_tree$log_turismo_18

d_sub <- d_tree[,-c(1:3,59,61)]
X = model.matrix(cumulative_cases~.,d_sub)[,-60]
y = log(d_tree$cumulative_cases)

grid=10^seq(10,-2,length=100)

lin_fit <- lm(cumulative_cases ~.,data=d_sub)
mean(abs(predict(lin_fit)-y))

ridge.mod=glmnet(X,y,alpha=1,lambda=grid)

mae <- numeric(length(grid))

for (i in 1:length(grid)){
  mae[i]<-mean(abs(exp(predict(ridge.mod,newx = X,s = grid[i]))-exp(y)))
}

min_mae <- which(mae==min(mae))

coef(ridge.mod, s = grid[min_mae])
resultados<-data.frame(country=d$country,
                       y=exp(y),
                       y_bar=round(exp(predict(ridge.mod,newx = X,s = grid[min_mae]))))
resultados$err <- round(abs(resultados$y-resultados$X1))

resultados %>%
  arrange(err)

