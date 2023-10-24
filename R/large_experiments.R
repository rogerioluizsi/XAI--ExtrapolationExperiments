#Initialize data frames for storing results
source("~/projects/trends_framework/toyExample/ALEPlot.R")
source("~/projects/trends_framework/toyExample/MEPlot.R")
source("~/projects/trends_framework/toyExample/PDPlot.R")
source("~/projects/trends_framework/toyExample/grid_SHAP.R")
source("~/projects/trends_framework/toyExample/nnetOptimization.R")

datasets <- list("data1" = gen_data1, "data2" = gen_data2, "data3" = gen_data3, "data4" = gen_data4)
models <- list(
  nnet_model = list(
    fit_function = nnet,
    params = list(linout = TRUE, skip = FALSE, size = 10, decay = 0.0001, maxit = 1000, trace = FALSE),
    formula = y ~ .
  ),
  rf_model = list(
    fit_function = randomForest,
    params = list(ntree = 200, mtry = 2),
    formula = y ~ .
  )
)

interations = 1000
K = 50
n_datapoints = c(200, 500, 1000)

# Pre-allocate the list
df_list <- vector("list", length(names(models)) * length(names(datasets)) * length(n_datapoints) * interations)

idx <- 1
for(m in names(models)) {
  model <- models[[m]]
  
  for (gen_data in names(datasets)) {
    for (n in n_datapoints) {
      
      for (i in seq(interations)) {
        DAT = datasets[[gen_data]](n)
        fitted_model <- do.call(model$fit_function, c(list(formula = model$formula, data = DAT), model$params))
        yhat <- function(X.model, newdata) as.numeric(predict(X.model, newdata))
        
        # Compute GRID_SHAP only once per iteration, as SHAP is computed for all features at once
        GRID_SHAP <- grid_SHAP(DAT[,2:3], fitted_model, pred.fun = yhat, K)
        
        for (j in seq(ncol(DAT) - 1)) {
          ALE <- ALEPlot(DAT[,2:3], fitted_model, pred.fun = yhat, J=j, K)
          PD <- PDPlot(DAT[,2:3], fitted_model, pred.fun = yhat, J=j, K)
          ME <- MPlot(DAT[,2:3], fitted_model, pred.fun = yhat, J=j, K)
          
          len = length(c(ALE$x.values, PD$x.values, ME$x.values, GRID_SHAP$x.values[[j]]))
          df <- data.frame(
            x.values = c(ALE$x.values, PD$x.values, ME$x.values, GRID_SHAP$x.values[[j]]),
            f.values = c(ALE$f.values, PD$f.values, ME$f.values, GRID_SHAP$f.values[[j]]),
            var = rep(j, times = len),
            inter = rep(i, times = len),
            data_func = rep(gen_data, times = len),
            datapoints = rep(n, times = len),
            model = rep(m, times = len),
            technique = c(rep("ale", times = length(ALE$x.values)), 
                          rep("pd", times = length(PD$x.values)), 
                          rep("me", times = length(ME$x.values)),
                          rep("grid_shap", times = length(GRID_SHAP$x.values[[j]]))
            )
          )
          
          # Assign to list
          df_list[[idx]] <- df
          idx <- idx + 1
        } # end loop over variables
      } # end loop over iterations
    } # end loop over datapoints
  } # end loop over datasets
} # end loop over models

# Combine data frames in the list into one big data frame
big_table <- do.call(rbind, df_list)


source("~/projects/trends_framework/toyExample/areaComputation.R")


