import numpy as np
import pandas as pd
import shap
from ALEScore import *
def get_shap(model, X):
  explainerShap = shap.Explainer(model.predict, X, )
  shap_values = explainerShap(X, feature_perturbation = "tree_path_dependent")
  vector = []
  for i in range(X.shape[1]):
    value = abs(shap_values.values[:, i]).mean()
    vector.append(value)
  #print(shap.summary_plot(shap_values, X, plot_type="bar"))
  return vector

def get_shapTreeRegressor(model, X):
  explainerTree = shap.TreeExplainer(model, feature_perturbation = "tree_path_dependent").shap_values(X)
  vector = []
  for i in range(X.shape[1]):
    value = abs(explainerTree[:, i]).mean()
    vector.append(value)
  #print(shap.summary_plot(explainerTree, X, plot_type="bar"))
  #print("shap",vector)
  return vector

def get_shapTreeClassifier(model, X):
  explainerTree = shap.TreeExplainer(model,feature_perturbation = "tree_path_dependent" ).shap_values(X)
  #vector = []
  #for i in range(X.shape[1]):
    #if name == "RandomForestClassifier":
      #value = abs(explainerTree[0][:, i]).mean()
      #vector.append(value)
    #else:
      #value = abs(explainerTree[0][i]).mean()
      #vector.append(value)
  vector = np.mean(np.abs(explainerTree[0]), axis=0)
  #print("shap",vector)
  #print(shap.summary_plot(explainerTree, X, plot_type="bar"))
  return  vector

def get_FeatImport(model, X):
  vector = model.feature_importances_
  #print(plt.bar(range(X.shape[1]),model.feature_importances_))
  #print("pfi",vector)
  return vector

def get_ALE_max(model, X, y, names):
  if np.unique(y).shape[0] > 2:
      proba_fun = model.predict
  else:
      proba_fun = model.predict_proba
  proba_ale = ALE(proba_fun, feature_names=names, target_names=["y"])
  proba_exp = proba_ale.explain(X)
  vector = []
  for i in range(X.shape[1]):
    value = abs(proba_exp.ale_values[i][:,0]).max()
    #value = np.mean(proba_exp.ale_values[i][:,0])
    vector.append(value)
  #print("ale_1", vector)
  return vector

def get_ale(model, X, y):
  #X = pd.DataFrame(X)
  if np.unique(y).shape[0] > 2:
      predict_fun = model.predict
      #print("predict")
  else:
      predict_fun = model.predict_proba
      #print("proba")
  vector = []
  for i in range(X.shape[1]):
    ale = ALE2(X, y,model, i)
    vector.append(ale)
 # print("ale_2",vector)
  return (vector)

def get_coef(model):
  coefficients = model.coef_[0]
  vector = np.array(coefficients)
  #print("coef",vector)
  return vector


def adjust_predictions(y_pred, epsilon=1e-15):
  return np.clip(y_pred, epsilon, 1 - epsilon)



