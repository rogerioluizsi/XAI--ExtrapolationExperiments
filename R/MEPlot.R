MPlot <- function(X, X.model, pred.fun, J, K) {
  xmin = min(X[,J])    
  xmax = max(X[,J])
  
  # Find the vector of z values corresponding to the quantiles of X[,J]
  z = unique(c(xmin, as.numeric(quantile(X[,J],seq(1/K,1,length.out=K), type=1)))) # Vector of K+1 z values
  K = length(z) - 1 # Reset K to the number of unique quantile points
  x = seq(xmin, xmax, length.out=K)
  
  # Group training rows into bins based on z
  a1 = as.numeric(cut(X[,J], breaks=z, include.lowest=TRUE)) # N-length index vector indicating into which z-bin the training rows fall
  
  # Replace J column
  X[, J] = z[a1]
  
  # Calculate y.hat
  y.hat = pred.fun(X.model=X.model, newdata = X)
  uncentered = as.numeric(tapply(y.hat, a1, mean))
  
  # Vertically translate fJ, by subtracting its average (averaged across X[,J])
  b = as.numeric(table(a1)) # Frequency count vector of X[,J] values falling into x intervals
  average = sum(uncentered * b) / sum(b)
  fJ = uncentered - average
  
  # Summary metrics
  mean_val = mean(uncentered)
  max_val = max(uncentered)
  mem = uncentered[13] # Approximation of the first quartile
  std_val = sd(uncentered)
  sv = uncentered[25]
  
  list(K=K, x.values=x, f.values = uncentered,  mean=mean_val, max=max_val, mem=mem, std=std_val, sv=sv)    
}

  


