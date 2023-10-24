ALEPlot <- function(X, X.model, pred.fun, J, K) {
  xmin = min(X[,J])    
  xmax = max(X[,J])
  
  # Find the vector of z values corresponding to the quantiles of X[,J]
  z = unique(c(xmin, as.numeric(quantile(X[,J],seq(1/K,1,length.out=K), type=1)))) # Vector of K+1 z values
  K = length(z) - 1 # Reset K to the number of unique quantile points
  x = seq(xmin, xmax, length.out=K)
  
  # Group training rows into bins based on z
  a1 = as.numeric(cut(X[,J], breaks=z, include.lowest=TRUE)) # N-length index vector indicating into which z-bin the training rows fall
  
  # Clone the datasets for calculation
  X1 = X
  X2 = X
  X1[,J] = z[a1]
  X2[,J] = z[a1+1]
  
  # Prediction difference
  Delta = pred.fun(X.model=X.model, newdata = X2) - pred.fun(X.model=X.model, newdata = X1)  # N-length vector of individual local effect values
  
  # Accumulated difference
  uncentered = cumsum(as.numeric(tapply(Delta, a1, mean))) # K-length vector of averaged local effect values
  
  list(x.values = x, f.values = uncentered)
}

