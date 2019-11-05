
arr=c("./cut.csv","./cover.csv","./leg.csv","./pull.csv","./scoop.csv","./straight.csv")
data <- read.csv(arr[1])
for (i in arr[-1] )
  {
  data2 <- read.csv(i,head=TRUE,sep=",");
  data <- rbind(data,data2);
}

data2 <- data[1:52]
data2[data2 <0] <- NA
data2[53]<- data[53]
data2= na.omit(data2)
data<- data2

library(caTools)
library(caret)
split=sample.split(data,SplitRatio = 0.8)
training <- subset(data, split== TRUE)
testing <- subset(data ,split == FALSE)
model=nnet::multinom(shotType~.,training,family ="binomial");


predicted.classes <- predict(model,testing)
summary(predicted.classes)
# should be changed to 0.5 I think
# Accuracy = sum of right digonal / sum of all values.

print(confusionMatrix(testing$shotType,predicted.classes))

