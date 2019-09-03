data<- read.csv("./datafiles/shot.csv")
print("This would take 5 to 10 Minutes. Please Be patient")
library(caTools)
library(gbm)
split=sample.split(data,SplitRatio = 0.8)
training <- subset(data,split ==T)
testing <- subset(data,split ==F)
  boost.data = gbm (shotType~. , data=training,distribution = "multinomial",
                    n.trees=7000,shrinkage=0.01,interaction.depth=4)

print(summary(boost.data))

pred = predict.gbm(boost.data, newdata = testing, n.trees = 7000,type="response")
    dim(pred)
library(caret)
labels = colnames(pred)[apply(pred, 1, which.max)]
print(confusionMatrix(testing$shotType,as.factor(labels)))

