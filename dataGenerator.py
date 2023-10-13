import pandas as pd
import numpy as np
import time
from numpy.random import seed
def gen_data1():
  n=1000
  np.random.seed(int(time.time()))
  X = np.random.normal(size=(n, 5))
  X[:, 0] = X[:, 1] + np.random.normal(scale=0.1, size=(n,))
  X[:, 2] = X[:, 0] + np.random.normal(scale=0.1, size=(n,))
  X[:, 3] =   X[:, 1] + np.random.normal(scale=0.5, size=(n,))
  #y =  X[:, 0] + np.random.normal(scale=0.5, size=(n,))
  y =  (X[:, 0]>0).astype(int)
  X = pd.DataFrame(X)
  return (X,y)

def gen_data2():
  n=1000
  np.random.seed(int(time.time()))
  X = np.random.normal(size=(n, 5))
  X[:, 0] = X[:, 1] + np.random.normal(scale=0.1, size=(n,))
  X[:, 2] = X[:, 0] + np.random.normal(scale=0.1, size=(n,))
  X[:, 3] =   X[:, 1] + np.random.normal(scale=0.5, size=(n,))
  y =  X[:, 0] + np.random.normal(scale=0.5, size=(n,))
  #y =  (X[:, 0]>0).astype(int)
  X = pd.DataFrame(X)
  return (X,y)

def gen_data3():
  np.random.seed(int(time.time()))
  X = np.random.normal(size=(1000, 5))
  X[:, 0] = X[:, 1] + np.random.normal(scale=0.1, size=(1000,))
  X[:, 2] = X[:, 0] + np.random.normal(scale=0.1, size=(1000,))
  X[:, 3] =   X[:, 1] + np.random.normal(scale=0.5, size=(1000,))
  y = ( X[:, 0] * 5 * X[:, 1] >0).astype(int)
  X = pd.DataFrame(X)
  return (X,y)

def gen_data4():
  np.random.seed(int(time.time()))
  X = np.random.normal(size=(1000, 5))
  X[:, 0] = X[:, 1] + np.random.normal(scale=0.1, size=(1000,))
  X[:, 2] = X[:, 0] + np.random.normal(scale=0.1, size=(1000,))
  X[:, 3] =   X[:, 1] + np.random.normal(scale=0.5, size=(1000,))
  y = ( X[:, 0] * 5 * X[:, 1])  + np.random.normal(scale=0.5, size=(1000,))
  X = pd.DataFrame(X)
  return (X,y)

def gen_data5():
  n=1000
  np.random.seed(int(time.time()))
  X = np.random.normal(size=(n, 5))
  X[:, 0] = X[:, 1] + np.random.normal(scale=0.1, size=(n,))
  X[:, 2] = X[:, 0] + np.random.normal(scale=0.1, size=(n,))
  X[:, 3] =   X[:, 0] + np.random.normal(scale=0.5, size=(n,))
  X[:, 4] =   X[:, 0] + np.random.normal(scale=0.5, size=(n,))
  y =  (X[:, 0]>0).astype(int) 
  X = pd.DataFrame(X)
  return (X,y)

def gen_data6():
  n=1000
  np.random.seed(int(time.time()))
  X = np.random.normal(size=(n, 5))
  X[:, 0] = X[:, 1] + np.random.normal(scale=0.1, size=(n,))
  X[:, 2] = X[:, 0] + np.random.normal(scale=0.1, size=(n,))
  X[:, 3] =   X[:, 0] + np.random.normal(scale=0.5, size=(n,))
  X[:, 4] =   X[:, 0] + np.random.normal(scale=0.5, size=(n,))
  y =  X[:, 0] + np.random.normal(scale=0.5, size=(n,))
  X = pd.DataFrame(X)
  return (X,y)
class fund_data2:
  def __init__(self):
      pass

  def fit(self, X, y):
      # This function does nothing because we know the function form
      return self

  def predict(self, X):
      # This prediction method uses the known function form
      #X = X.values
      y_pred =  X[:, 0]
      return y_pred