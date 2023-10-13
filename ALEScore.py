import pandas as pd
import numpy as np
def ALE2(X, y,model,J):
    X = pd.DataFrame(data=X)
    xmin = X.iloc[:, J].min()
    xmax = X.iloc[:, J].max()
    K=10
    # Find the vector of z values corresponding to the quantiles of X.iloc[:, J]
    z = np.unique(np.concatenate(([xmin], np.quantile(X.iloc[:, J], np.linspace(1/K, 1, num=K), method='lower'))))
    K = len(z) - 1
    x = np.linspace(xmin, xmax, num=K)
    
    # Group training rows into bins based on z
    a1 = np.array(pd.cut(X.iloc[:, J], bins=z, include_lowest=True, labels=False))
    #print(a1)
    
    # Clone the datasets for calculation
    X1 = X.copy()
    X2 = X.copy()
    X1.iloc[:, J] = z[a1]
    X2.iloc[:, J] = z[a1 + 1]
    
    # Prediction difference
    if np.unique(y).shape[0]>2:
      Delta = np.array(model.predict(X2) - model.predict(X1))
      
    else:
      Delta = np.array(model.predict_proba(X2)[:,1] - model.predict_proba(X1)[:,1])
    
    
    # Compute the cumulative sum of the mean values
    uncentered =  np.bincount(a1, weights=Delta) / np.bincount(a1)
    uncentered = np.cumsum(uncentered)

    max = abs(uncentered).max()
    avg = np.mean(uncentered)
    return (avg)