arr=c("./cover.csv","./leg.csv","./pull.csv","./scoop.csv","./straight.csv")
data <- read.csv(arr[1])
for (i in arr[-1] )
{
  data2 <- read.csv(i,head=TRUE,sep=",");
  data <- rbind(data,data2);
}
set.seed(153)
## remove -ve data
data2 <- data[1:52]
data2[data2 <0] <- NA
data2[53]<- data[53]
data2= na.omit(data2)
data<- data2

library(caTools)
set.seed(153)
split= sample.split(data,SplitRatio=0.7)

training <- subset(data, split==TRUE)

testing <- subset(data,split==FALSE)
library(randomForest)
par(mar=c(1,1,1,1))
training$shotType <- as.factor(training$shotType)

bestMtr <-tuneRF(training,training$shotType,stepFactor =1.12,improve = 0.000001,trace =T,plot = T)

forest <- randomForest(shotType~.,data= training,mtry=bestMtr ,ntree=7000)
varImpPlot(forest)

pred <- predict(forest,newdata = testing,shotType = "class")


library(caret)

print(confusionMatrix(table(pred,testing$shotType)))
