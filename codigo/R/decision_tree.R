# Classification Tree with rpart
library(rpart)
library(tree)
library(dplyr)

d_in <- read.csv("../../data/inputs.csv")
d_target <- read.csv("../../data/target.csv")

d_tree <- cbind(d_in[,-1],d_target)

d_tree <- d_tree %>%
  select(-X)

d$date <- as.Date(as.character(d$date),format = "%d-%m-%y")
d$date2 <- as.numeric(d$date)

lmfit <- lm(cumulative_cases ~ ., data=d[,-c(1:3)])

summary(lmfit)
mean(abs(predict(lmfit)-d$cumulative_cases))

# grow tree 
fit <- tree(cumulative_cases ~ . - cumulative_cases, data=d_tree)

fit.cv <- cv.tree(fit)

summary(fit)
summary(fit.cv)
fit.cv

prune.fit <- prune.tree(fit,best=3)
text(fit,pretty=0)

predict(prune.fit)

plot(fit)
text(fit,pretty=0)

plot(fit)

printcp(fit) # display the results 
plotcp(fit) # visualize cross-validation results 
summary(fit) # detailed summary of splits

# plot tree 
plot(fit, uniform=TRUE, 
     main="Classification Tree for Kyphosis")
text(fit, use.n=TRUE, all=TRUE, cex=.8)

# create attractive postscript plot of tree 
post(fit, file = "c:/tree.ps", 
     title = "Classification Tree for Kyphosis")