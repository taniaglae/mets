require(ROCR)
require(pROC)
library(FSelector)
library(mlbench)
library(caret)
library(randomForest)
require(psych)
library(e1071)

pima<-read.csv("dataset/men.csv",sep=",")
pima = pima[c(4,6,9:13,56,94,142,185)] #cols or variables selection
pima$SM_ATPIII <- as.factor(pima$SM_ATPIII)
table(pima$SM_ATPIII)
names(pima)

#****************DataPartition*************************
  set.seed(1000)
intrain <- createDataPartition(pima$SM_ATPIII, p = 0.7, list = FALSE)
train <- pima[intrain, ]
test <- pima[-intrain, ]
dim(test)
dim(train)
#**********************************************
 
library(rJava)
library(FSelector)
# Tune process (mtry and ntree) in RF
customRF <- list(type = "Classification", library = "randomForest", loop = NULL)
customRF$parameters <- data.frame(parameter = c("mtry", "ntree"), class = rep("numeric", 2), label = c("mtry", "ntree"))
customRF$grid <- function(x, y, len = NULL, search = "grid") {}
customRF$fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) {
  randomForest(x, y, mtry = param$mtry, ntree=param$ntree, ...)
}
customRF$predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
  predict(modelFit, newdata)
customRF$prob <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
  predict(modelFit, newdata, type = "prob")
customRF$sort <- function(x) x[order(x[,1]),]
customRF$levels <- function(x) x$classes

# Train and test process
control <- trainControl(method="repeatedcv", number=10, repeats=3)
metric <- "Accuracy"
tunegrid <- expand.grid(.mtry=c(1:10), .ntree=c(100, 200, 300, 500, 800, 1000))
set.seed(1000)

(custom <- train(SM_ATPIII~., 
                 data=train, 
                 method=customRF, 
                 tuneGrid=tunegrid, 
                 trControl=control))


# custom$finalModel (best model)
rf.predict.in <- predict(custom$finalModel, data=train)
confusionMatrix(rf.predict.in,train$SM_ATPIII)

# test set
rf.predict.in <- predict(custom$finalModel, test)
(confusionMatrix(rf.predict.in,test$SM_ATPIII))

# Variable importance 
(importance2 <- varImpPlot(custom$finalModel, scale=FALSE, n.var = 10, main = "Variable Importance"))
# Extraction of best variable importance
(varImpPlot2 <-cutoff.k(importance2,10))

# features
f <- as.simple.formula(varImpPlot2, "SM_ATPIII")
print(f)

# train and test process with best parameters and features selection
# mtry=custom$bestTune$mtry
# ntree=custom$bestTune$ntree
tunegrid <- expand.grid(.mtry=custom$bestTune$mtry, .ntree=custom$bestTune$ntree)
set.seed(2000)



(custom2 <- train(f, 
                  data=train, 
                  method=customRF, 
                  metric=metric, 
                  tuneGrid=tunegrid, 
                  trControl=control))
custom2


# test set with best parameters and features selection
resultado<-predict(custom2$finalModel,test, type="class")







