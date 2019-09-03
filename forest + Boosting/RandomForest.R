set.seed(2322)
data <- read.csv("./datafiles/shot.csv")

library(caTools)
split= sample.split(data,SplitRatio=0.7)

training <- subset(data, split==TRUE)

testing <- subset(data,split==FALSE)

library(randomForest)
training$shotType <- as.factor(training$shotType)

bestMtr <-tuneRF(training,training$shotType,stepFactor =1.12,improve = 0.000001,trace =T,plot = T)

forest <- randomForest(shotType~.,data= training,mtry=bestMtr )
varImpPlot(forest)

pred <- predict(forest,newdata = testing,shotType = "class")


library(caret)

print(confusionMatrix(table(pred,testing$shotType)))
