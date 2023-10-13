
from ALEScore import *
from csPFI import *
from dataGenerator import *
from getScores import *
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier, RandomForestRegressor
from sklearn.linear_model import LogisticRegression

def experiment():
       
    count = 1
    n_iter = 1
    rf_regressor =RandomForestRegressor(n_estimators=200, random_state=0)
    rf_classifier =RandomForestClassifier(n_estimators=200, random_state=0)
    rl = LogisticRegression()
    # Create an empty list to store the feature importances of each iteration
    feature_imp_list = []
    models=[rl,rf_regressor,rf_classifier]
    datas = [gen_data1(),gen_data2(), gen_data3(), gen_data4(), gen_data5(), gen_data6()]
    #feature_imp_list = []
    # Create an empty dataframe to store the results
    feature_imp_df = pd.DataFrame(columns=["Iteration", "Algorithm", "Metric", "Data", "A", "B", "C", "D"])

    for model in models:
      name_classifier = type(model).__name__
      print(round(count/600, 2),"%")
      
      for i in range(n_iter):
                
          for idx, (X, y) in enumerate(datas, start=1):
              count = count+1
              len_y = np.unique(y).shape[0]
              #if len_y < 2:
              #print(len_y)
              # Generate a sample dataframe
              data = idx
              names = X.columns.tolist()
              X = X.values
              if (len_y > 2) & ((name_classifier == "RandomForestClassifier") | (name_classifier == "LogisticRegression")):
                    continue
              if (len_y < 3) & (name_classifier == "RandomForestRegressor"):
                    continue
              #print(name_classifier,np.unique(y).shape[0])
              model.fit(X, y)

              feature_imp_3 = get_cs_pfi(model, X, y)
              #print("cs-PFI", feature_imp_3)
              temp_df3 = pd.DataFrame({"Iteration": [i], "Algorithm": [name_classifier], "Metric": ["cs_PFI"],"Data":[idx],
                                        "A": [feature_imp_3[0]], "B": [feature_imp_3[1]],
                                        "C": [feature_imp_3[2]], "D": [feature_imp_3[3]],  "E": [feature_imp_3[4]]})
              feature_imp_df = pd.concat([feature_imp_df, temp_df3])

              # feature_imp_4 = get_ALE_max(model, X, y, names)
              # print("ale", feature_imp_4)
              # temp_df4 = pd.DataFrame({"Iteration": [i], "Algorithm": [name_classifier], "Metric": ["AUA1"],"Data":[idx],
              #                           "A": [feature_imp_4[0]], "B": [feature_imp_4[1]],
              #                           "C": [feature_imp_4[2]], "D": [feature_imp_4[3]]})
              # feature_imp_df = pd.concat([feature_imp_df, temp_df4])

              feature_imp_5 = get_ale(model, X,y)
              #print("ale2", feature_imp_5)
              temp_df5 = pd.DataFrame({"Iteration": [i], "Algorithm": [name_classifier], "Metric": ["AUA"],"Data":[idx],
                                        "A": [feature_imp_5[0]], "B": [feature_imp_5[1]],
                                        "C": [feature_imp_5[2]], "D": [feature_imp_5[3]], "E": [feature_imp_5[4]]})
              feature_imp_df = pd.concat([feature_imp_df, temp_df5])

              if name_classifier != "LogisticRegression":
                  if np.unique(y).shape[0] >2:
                    feature_imp_1 = get_shapTreeRegressor(model, X)
                  else:
                    feature_imp_1 = get_shapTreeClassifier(model, X)
                    #print("shap", feature_imp_1)
                    temp_df1 = pd.DataFrame({"Iteration": [i], "Algorithm": [name_classifier], "Metric": ["TreeShap"], "Data":[idx],
                                        "A": [feature_imp_1[0]], "B": [feature_imp_1[1]],
                                        "C": [feature_imp_1[2]], "D": [feature_imp_1[3]],  "E": [feature_imp_1[4]]})
                              
                    feature_imp_df = pd.concat([feature_imp_df, temp_df1])

                  feature_imp_2 = get_FeatImport(model, X)
                  #print("PFI", feature_imp_2)
                  temp_df2 = pd.DataFrame({"Iteration": [i], "Algorithm": [name_classifier], "Metric": ["PFI"], "Data":[idx],
                                      "A": [feature_imp_2[0]], "B": [feature_imp_2[1]],
                                      "C": [feature_imp_2[2]], "D": [feature_imp_2[3]],  "E": [feature_imp_2[4]]})
              
                  feature_imp_df = pd.concat([feature_imp_df, temp_df2])

            

              if name_classifier == "LogisticRegression":
                if np.unique(y).shape[0] >2:
                  continue
                  feature_imp_0 = get_coef(model)
                  #print("coef", feature_imp_0)
                  temp_df0 = pd.DataFrame({"Iteration": [i], "Algorithm": [name_classifier], "Metric": ["Coef"], "Data":[idx],
                                      "A": [feature_imp_0[0]], "B": [feature_imp_0[1]],
                                      "C": [feature_imp_0[2]], "D": [feature_imp_0[3]], "E": [feature_imp_0[4]]})
                  feature_imp_df = pd.concat([feature_imp_df, temp_df0])
    return(feature_imp_df)
          

