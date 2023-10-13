import pandas as pd
import numpy as np
from sklearn.metrics import mean_squared_error, log_loss
from sklearn.tree import DecisionTreeRegressor
def get_tree_groups(X):
 # Initialize an empty DataFrame to store the final results
    index_df = pd.DataFrame(columns=['datapoint_index', 'leaf_index', 'target_variable'])

    for i in range(X.shape[1]):

        # Set the target variable y as the i-th column of X
        feature_exp = X[:, i]
        #print(feature_exp.shape)
        X_new = np.delete(X, i, axis=1)
        indices = list(range(len(X_new)))
        # Instantiate a DecisionTreeRegressor
        dtree = DecisionTreeRegressor(max_depth = 2)  # Limiting tree depth for simplicity

        # Train the DecisionTreeRegressor
        dtree.fit(X_new, feature_exp)
        #plt.figure(figsize=(20, 10))  # You can adjust the figsize as needed
        #from sklearn.tree import plot_tree
        #plot_tree(dtree, filled=True)
        #plt.show()


        # Determine which leaf node each datapoint in X_test falls into
        leaf_indices = dtree.apply(X_new)

        # Create a DataFrame where each row is [datapoint_index, leaf_index, target_variable]
        temp_df = pd.DataFrame({'datapoint_index': indices,
                                'leaf_index': leaf_indices,
                                'target_variable': [i]*len(indices)})

        # Append the DataFrame to the final result DataFrame
        index_df = pd.concat([index_df, temp_df], ignore_index=True)
        
    return index_df
def get_cs_pfi(model, X, y):
    #X = X.values

    index_df = get_tree_groups(X)
    # Group by 'target_variable' and 'leaf_index'
    grouped = index_df.groupby(['target_variable', 'leaf_index'])

    for name, group in grouped:
        # Get the indices of the datapoints in this group
        indices = group['datapoint_index'].values.astype(int)
        # Use the indices to select the corresponding datapoints from X
        datapoints = X[indices]
        target = y[indices]
        # Apply the function to the datapoints and store the result in 'group_value' column
        index_df.loc[group.index, 'pfi'] = pfi(model, datapoints, target, name[0])
        # Compute the size of each group defined by 'target_variable' and 'leaf_index'
    group_size = index_df.groupby(['target_variable', 'leaf_index']).size().reset_index(name='GroupSize')['GroupSize']
    total_size = index_df.groupby('target_variable')["target_variable"].size().reset_index(name='TotalSize')['TotalSize']
    index_df['group_proportion'] = group_size / total_size
    df = index_df.drop(columns=['datapoint_index'])
    df = df.drop_duplicates()
    df["cs_PFI"] = df["pfi"] * df ["group_proportion"]
    vector = df.groupby("target_variable")["cs_PFI"].mean().values
    #print("cs_PFI",vector)
    return vector

def pfi(model, X, y, feature_idx, k=10):
    len_y = np.unique(y).shape[0]

    if len_y > 2:
        #print(">2")
        y_pred = model.predict(X)
        baseline_error = mean_squared_error(y, y_pred)
        #print(baseline_error)
    else:
        #print("<2")
        y_pred = model.predict_proba(X)
        y_pred = adjust_predictions(y_pred)
        #print(len(y),len(y_pred))
        #print(y.mean(),y_pred.mean())
        baseline_error = log_loss(y, y_pred, labels = [0, 1])


    pfis = []
    for _ in range(k):
        # Permute the values of the feature column
        X_permuted = X.copy()
        np.random.shuffle(X_permuted[:, feature_idx])

        # Compute the prediction error after permutation
        if len_y >2:
            y_pred_permuted = model.predict(X_permuted)
            permuted_error = mean_squared_error(y, y_pred_permuted)
            #print(permuted_error)
        else:
            y_pred_permuted = model.predict_proba(X_permuted)
            y_pred_permuted = adjust_predictions(y_pred_permuted)
            permuted_error = log_loss(y, y_pred_permuted, labels = [0, 1])
            #permuted_error = mean_squared_error(y, y_pred_permuted)

        pfi_local = permuted_error - baseline_error
        #print("local",pfi_local)
        pfis.append(pfi_local)


    # Compute the average prediction error after permutation
    pfi = np.mean(pfis)
    return pfi

def adjust_predictions(y_pred, epsilon=1e-15):
  return np.clip(y_pred, epsilon, 1 - epsilon)