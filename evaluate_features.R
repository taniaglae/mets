#To evaluate features
require(psych)
library(e1071)
library(FSelector)
library(caret)
library(pROC)

semillas<-c(33833,90,2940,86203,123,789,67554,6094,47053,2098,819,8,70090,3293,110,70988,44550,110923,99099,16,19023,7007,504,222,32,3000,4593,10203,309485,909653)
resultados<-matrix(nrow=31,ncol=20)
promBalancedAccuracy<-0
for(i in 1:30){
  cat(semillas[i],"\n")
  set.seed(semillas[i])
  
  
  filter <- randomForest (f, 
                          data=train, 
                          mtry=1,
                          ntree=500)
  
  
  resultado_filter <- predict(filter,test)
  
  (cm<-confusionMatrix(table(resultado_filter, test$SM_ATPIII)))
  BalancedAccuracy<-cm$byClass[11]
  cat(BalancedAccuracy,"\n")
  resultados[i,1]<-semillas[i]
  resultados[i,2]<-cm$overall[1] #Acc
  resultados[i,3]<-cm$byClass[11]#balanced acc
  resultados[i,4]<-cm$byClass[1] #Sensitivity
  resultados[i,5]<-cm$byClass[2] #Specificity
  resultados[i,6]<-cm$overall[2]
  miROC<-roc(as.numeric(test$SM) ~ as.numeric(resultado_filter))
  resultados[i,7]<-miROC$auc
  resultados[i,8]<-cm$byClass[3]
  resultados[i,9]<-cm$byClass[4]
  resultados[i,10]<-cm$byClass[5]
  resultados[i,11]<-cm$byClass[6]
  resultados[i,12]<-cm$byClass[7]
  resultados[i,13]<-cm$byClass[8]
  resultados[i,14]<-cm$byClass[9]
  resultados[i,15]<-cm$byClass[10]
  resultados[i,16]<-cm$overall[3]
  resultados[i,17]<-cm$overall[4]
  resultados[i,18]<-cm$overall[5]
  resultados[i,19]<-cm$overall[6]
  resultados[i,20]<-cm$overall[7]
  promBalancedAccuracy<-promBalancedAccuracy + BalancedAccuracy
}
cat(promBalancedAccuracy/30,"\n")
# transform the matrix into a data frame
resultadosDF<-data.frame(resultados)
# save the data frame in a csv file
# In the csv you calculate the averages and deviation of each variable (column)
write.csv(resultadosDF,"men_resulting.csv")

