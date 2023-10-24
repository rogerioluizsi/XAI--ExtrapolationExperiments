library(fastshap)
library(dplyr)
library(tidyr)
grid_SHAP <- function(X, X.model, pred.fun, K) {
  
  shapley_values <- explain(X.model, X = X, pred_wrapper = pred.fun, nsim = 100, adjust = TRUE, shap_only = FALSE)
  baseline = shapley_values$baseline
  
  x.values <- vector("list", length = ncol(X))
  averages <- vector("list", length = ncol(X))
  
  for (j in seq_along(X)) {
    xmin = min(X[,j])    
    xmax = max(X[,j])
    z= unique(c(xmin, as.numeric(quantile(X[,j], seq(1/K, 1, length.out=K), type=1)))) #vector of breaks K+1 length
    K = length(z) - 1
    x = seq(xmin, xmax, length.out = K)
    
    sv_J = shapley_values$shapley_values[,j]
    sv_uncentered_J <- sv_J +  baseline + mean(sv_J)
    a1 <- as.numeric(cut(X[,j], breaks = z, include.lowest = TRUE)) # vector of length equal to n with K unique values
    
    averages[[j]] <- tapply(sv_uncentered_J, a1, mean, na.rm = TRUE)
    x.values[[j]] <- x
  }
  
  return(list('x.values' = x.values , 'f.values' = averages))
}

