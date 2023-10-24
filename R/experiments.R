#library(nnet)
#library(tree)

##############################################
#Daniel documentation where PDP fails
#set.seed(123456)

ales =data.frame(var = numeric(), mean =numeric(), max=numeric(), std=numeric(), sv=numeric())
pds =data.frame(var = numeric(), mean =numeric(), max=numeric(), std=numeric(), sv=numeric())
mes=data.frame(var = numeric(), mean =numeric(), max=numeric(), std=numeric(), sv=numeric())

plot_ales = data.frame()
plot_pds = data.frame()
plot_mes = data.frame()


for (i in seq(30)){
  
  #DAT = data.frame(y, x1, x2)
  DAT = gen_data3(200)
  model <- nnet(y ~ ., data = DAT, linout = T, skip = F, size = 10,
                decay = 0.0001, maxit = 1000, trace = F)

  model = randomForest(DAT[, 2-3], DAT[, 1], ntree = 200, mtry = 2)
 # model <- tree(y~., data = DAT)
  ## Define the predictive function‘
  yhat <- function(X.model, newdata) as.numeric(predict(X.model, newdata))
  
  for (j in seq(dim(DAT)[2] -1)){
    
    
    ALE= ALEPlot(DAT[,2:3], model, pred.fun = yhat, J=j, K=50)
    PD= PDPlot(DAT[,2:3], model, pred.fun = yhat, J=j, K=50)
    ME= MPlot(DAT[,2:3], model, pred.fun = yhat, J=j, K=50)
    
    plot_ale = data.frame(x.values = ALE$x.values, f.values = ALE$f.values) 
    plot_ale$var= j
    plot_ale$inter = i
    plot_ales =rbind(plot_ales, plot_ale)
    
    plot_pd = data.frame(x.values = PD$x.values, f.values = PD$f.values) 
    plot_pd$var= j
    plot_pd$inter = i
    plot_pds =rbind(plot_pds, plot_pd)
    
    plot_me = data.frame(x.values = ME$x.values, f.values = ME$f.values) 
    plot_me$var= j
    plot_me$inter = i
    plot_mes =rbind(plot_mes, plot_me)

    
    
    }

}
#x^2 - (1/3+0.05^2)
#plots
library(patchwork)
library(ggplot2)
library(dplyr)
plot_ales = big_table%>%filter((technique=="ale") & (data_func =="data3") & (decay ==0.0001)& (datapoints ==200))
plot_pds = big_table%>%filter((technique=="pd") & (data_func =="data3")& (decay ==0.0001)& (datapoints ==200))
plot_mes = big_table%>%filter((technique=="me")& (data_func =="data3")& (decay ==0.0001)& (datapoints ==200))
x_df = as.data.frame(plot_ales%>%filter((inter ==1)&(var==1))%>%dplyr::select(f.values)%>%pull)

p1 =plot_ales%>%filter(var==1)
p11= ggplot()+
  geom_line(data= p1, aes(x.values, f.values +0.5, alpha = 0.1), show.legend = FALSE)+
  geom_function(data= x_df, fun = function(x) x, size=1.5)+
  coord_cartesian(xlim = c(0, 1), ylim = c(-1,1)) +  ylab("ALE function") + xlab("x_1") 

p2 =plot_ales%>%filter(var==2)
p22= ggplot()+
  geom_line(data= p2, aes(x.values, f.values, alpha = 0.1), show.legend = FALSE)+
  geom_function(data= x_df, fun = function(x) x**2  , size=1.5)+
  coord_cartesian(xlim = c(0, 1), ylim = c(-1,1)) +  ylab("ALE fucntion") + xlab("x_2") 

p3 =plot_pds%>%filter(var==1)
p3= ggplot()+
  geom_line(data= p3, aes(x.values, f.values, group = inter, color=var, alpha = 0.1), show.legend = FALSE)+
  geom_function(data= x_df, fun = function(x) x, size=1.5)+
  coord_cartesian(xlim = c(0, 1), ylim = c(-1,1)) +  ylab("PD function") + xlab("x_1") 

p4 =plot_pds%>%filter(var==2)
p4= ggplot()+
  geom_line(data= p4, aes(x.values, f.values, group = inter, color=var, alpha = 0.1), show.legend = FALSE)+
  geom_function(data= x_df, fun = function(x) x^2, size=1.5)+
  coord_cartesian(xlim = c(0, 1), ylim = c(-1,1)) +  ylab("PD function") + xlab("x_2") 

p5 =plot_mes%>%filter(var==1)
p5= ggplot()+
  geom_line(data= p5, aes(x.values, f.values, group = inter, color=var, alpha = 0.1), show.legend = FALSE)+
  geom_function(data= x_df, fun = function(x) x, size=1.5)+
  coord_cartesian(xlim = c(0, 1), ylim = c(-1,1)) +  ylab("ME function") + xlab("x_1") 

p6 =plot_mes%>%filter(var==2)
p6= ggplot()+
  geom_line(data= p6, aes(x.values, f.values, group = inter, color=var, alpha = 0.1), show.legend = FALSE)+
  geom_function(data= x_df, fun = function(x) x^2  , size=1.5)+
  coord_cartesian(xlim = c(0, 1), ylim = c(-1,1)) +  ylab("ME function") + xlab("x_2") 

p1+p3+p5+p2+p4+p6

#

#mes =mes%>%group_by(var)%>%summarise(mean_mean = mean(mean), std_mean = sd(mean), mean_max = mean(max), std_max = sd(max),
                                 #mean_std = mean(std), std_std= sd(std), mean_sv = mean(sv), std_sv = sd(sv))

#mes$tech = "mes"
#ales=ales%>%group_by(var)%>%summarise(mean_mean = mean(mean), std_mean = sd(mean), mean_max = mean(max), std_max = sd(max),
                                #mean_std = mean(std), std_std= sd(std), mean_sv = mean(sv), std_sv = sd(sv))
#ales$tech = "ales"
#pds=pds%>%group_by(var)%>%summarise(mean_mean = mean(mean), std_mean = sd(mean), mean_max = mean(max), std_max = sd(max),
                                #mean_std = mean(std), std_std= sd(std), mean_sv = mean(sv), std_sv = sd(sv))
#pds$tech = "pds"


#big_table = rbind(ales, mes, pds)
