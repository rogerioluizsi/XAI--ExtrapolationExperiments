if (!require(caret)) install.packages("caret")
if (!require(nnet)) install.packages("nnet")

library(caret)
library(nnet)

gen_data1 <- function(n) {
  x <- runif(n, min = 0, max = 1)
  x1 <- x + rnorm(n, 0, 0.05)
  x2 <- x + rnorm(n, 0, 0.05)
  x1 <- pmax(pmin(x1, 1), 0)
  x2 <- pmax(pmin(x2, 1), 0)
  y = x1 + rnorm(n, 0, 0.1)
  data = data.frame(y, x1, x2)

  return(data)
}

gen_data2 <- function(n) {
  x <- runif(n, min = 0, max = 1)
  x1 <- x + rnorm(n, 0, 0.05)
  x2 <- x + rnorm(n, 0, 0.05)
  x1 <- pmax(pmin(x1, 1), 0)
  x2 <- pmax(pmin(x2, 1), 0)
  y = x1 + x2 + rnorm(n, 0, 0.1)
  data = data.frame(y, x1, x2)
  return(data)
}

gen_data3 <- function(n) {
  x <- runif(n, min = 0, max = 1)
  x1 <- x + rnorm(n, 0, 0.05)
  x2 <- x + rnorm(n, 0, 0.05)
  x1 <- pmax(pmin(x1, 1), 0)
  x2 <- pmax(pmin(x2, 1), 0)
  y = x1 + x2^2 + rnorm(n, 0, 0.1)
  data = data.frame(y, x1, x2)
  return(data)
}  
gen_data4 <- function(n) {
  x <- runif(n, min = 0, max = 1)
  x1 <- x + rnorm(n, 0, 0.05)
  x2 <- x + rnorm(n, 0, 0.05)
  x1 <- pmax(pmin(x1, 1), 0)
  x2 <- pmax(pmin(x2, 1), 0)
  y = x1 + (x2 - 0.9*x2**3) + rnorm(n, 0, 0.1)
  data = data.frame(y, x1, x2)
  return(data)
}
#metric <- "RMSE"

#datasets <- list("data1" = gen_data1, "data2" = gen_data2, "data3" = gen_data3, "data4" = gen_data4)
#ctrl <- trainControl(method = "cv", number = 10)
#grid <- expand.grid(size = c(1, 5, 10), decay = c(0,001, 0.0001))
#best_parameters <- data.frame(dataset = character(), size = numeric(), decay = numeric(), metric_value = numeric())

#for (gen_data in names(datasets)) {
#  data <- datasets[[gen_data]](200)
#  model <- train(y ~ ., data = data, method = "nnet", trControl = ctrl, tuneGrid = grid, metric = metric, trace = FALSE)
#  best_params <- model$bestTune
#  best_metric_value <- model$results[which.min(model$results$RMSE), metric]
#  best_parameters <- rbind(best_parameters, data.frame(dataset = gen_data, size = best_params$size, decay = best_params$decay, metric_value = best_metric_value))
#}


