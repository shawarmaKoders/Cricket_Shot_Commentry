library(caret)
library(e1071)
data <- read.csv("./../shot.csv",sep=",",header = T)

library(caTools)

split <- sample.split(data,SplitRatio = 0.8)

training <- subset(data, split ==T)
testing <- subset(data ,split==F)

svm1 <- svm(shotType~. , data= training, 
            method="C-classification",kernal="radial",
            gamma=0.1,cost=10)
summary(svm1)

pred <- predict(svm1,newdata = testing )
print(confusionMatrix(table(pred,testing$shotType)))
