library(quantreg)

rqfit <- rq(cumulative_cases ~., data=d_sub)