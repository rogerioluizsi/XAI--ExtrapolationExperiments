library(pracma)  # for numerical integration
library(dplyr)   # for data manipulation


compute_area <- function(df) {
  areas <- c()
  var = unique(df$var)
  data = unique(df$data_func)
  
  for (iter in unique(df$inter)) {
    xvalues <- df[df$inter == iter, 'x.values'] 
    fvalues <- df[df$inter == iter, 'f.values']
    
    if (data == "data1"){
      if (var == 1) {
        y_theoretical <- xvalues
      } else {
        y_theoretical <- rep(0, length(xvalues))
      }
    }
    
    if (data == "data2"){
      if (var == 1) {
        y_theoretical <- xvalues
      } else {
        y_theoretical <- xvalues
      }
    }
    
    if (data == "data3"){
      if (var == 1) {
        y_theoretical <- xvalues
      } else {
        y_theoretical <- xvalues^2
      }
    }
    
    if (data == "data4"){
      if (var == 1) {
        y_theoretical <- xvalues
      } else {
        y_theoretical <- xvalues - 0.9*xvalues**3 
      }
    }
    
    interp_theoretical <- approxfun(xvalues, y_theoretical)
    interp_computed <- approxfun(xvalues, fvalues)
    diff_interp <- function(x) {abs(interp_theoretical(x) - interp_computed(x))}
    area <- integral(diff_interp, 0, 1)
    areas <- c(areas, area)
  }
  
  average_area <- mean(areas, na.rm = TRUE)
  df$average_area <- average_area
  return(df)
}


results <- by(big_table, list(big_table$model, big_table$data_func, big_table$datapoints, big_table$technique, big_table$var), compute_area)
#big_table <- dplyr::bind_rows(results)
big_table <- do.call(rbind, results)

summary <- big_table %>%
  group_by(model, var, data_func, datapoints, technique) %>%
  summarise(average_area = mean(average_area))

wide_dataset <- summary %>%
  pivot_wider(id_cols = c("model", "var", "data_func", "datapoints"),
              names_from = "technique",
              values_from = "average_area")

print(wide_dataset)
#write.csv(wide_dataset, "wide_dataset_all.csv")
