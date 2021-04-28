library(caret)
require(psych)
library(RWeka)
library(FSelector)
library(caret)
library(pROC)
library(rJava)
library(party)
library(FSelector)

#Read mujeres or hombres
datos<-read.csv("mujeres.csv")
datos<-read.csv("hombres.csv")

cols<-c(1:15)
datos[,cols] = apply(datos[,cols], 2, function(x) as.numeric(as.character(x)))
datos <- na.omit(datos)
datos$SM<-as.factor(datos$SM)
sapply(datos[1,],class)

datosPrueba=datos

#chi.squared
(weights <- chi.squared(SM~., datosPrueba))
(subset <- cutoff.k(weights, 8))
(Sbest<-c(subset,"SM"))
datosPrueba<-datosPrueba[,Sbest]


#C45
semillas<-c(33833,90,2940,86203,123,789,67554,6094,47053,2098,819,8,70090,3293,110,70988,44550,110923,99099,16,19023,7007,504,222,32,3000,4593,10203,309485,909653)
promAccuracy<-0
promBalancedAccuracy<-0
resultados<-matrix(nrow=30,ncol=20)
for(i in 1:30){
  cat(semillas[i],"\n")
  set.seed(semillas[i])
  inTrain = createDataPartition(datosPrueba$SM,p = 2/3,list=FALSE)
  trainingdatosPrueba = datosPrueba[ inTrain,]
  testingdatosPrueba = datosPrueba[-inTrain,]
  (treev28LCR = J48(SM~., data = trainingdatosPrueba))
  resultado<-predict(treev28LCR,testingdatosPrueba, type="class")
  (cm<-confusionMatrix(table(resultado, testingdatosPrueba$SM)))
  Accuracy<-cm$overall[1]
  BalancedAccuracy<-cm$byClass[11]
  cat(BalancedAccuracy,"\n")
  resultados[i,1]<-semillas[i]
  resultados[i,2]<-cm$overall[1]
  resultados[i,3]<-cm$byClass[11]
  resultados[i,4]<-cm$byClass[1]
  resultados[i,5]<-cm$byClass[2]
  resultados[i,6]<-cm$overall[2]
  miROC<-roc(as.numeric(testingdatosPrueba$SM) ~ as.numeric(resultado))
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
  promAccuracy<-promAccuracy + Accuracy
}
cat(promAccuracy/30,"\n")
cat(promBalancedAccuracy/30,"\n")
resultadosDF<-data.frame(resultados)
write.csv(resultadosDF,"C45_chi_h_SM_Cuestionario_datasetSep2020.csv")
