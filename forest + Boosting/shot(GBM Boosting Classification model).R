arr=c("./leg.csv","./pull.csv","./scoop.csv","straight.csv","./cover.csv")
data <- read.csv(arr[1])
par(mar=c(1,1,1,1))
for (i in arr[-1] )
{
  data2 <- read.csv(i,head=TRUE,sep=",");
  data <- rbind(data,data2);
}

set.seed(189)
data2 <- data[1:52]
data2[data2 <0] <- NA
data2[53]<- data[53]
data2= na.omit(data2)
data<- data2
print("This would take 5 to 10 Minutes. Please Be patient")
library(caTools)
library(gbm)
split=sample.split(data,SplitRatio = 0.8)
training <- subset(data,split ==T)
testing <- subset(data,split ==F)
  boost.data = gbm (shotType~. , data=training,distribution = "multinomial",
                    n.trees=7000,shrinkage=0.01,interaction.depth=6,n.cores=5)

print(summary(boost.data))

pred = predict.gbm(boost.data, newdata = testing, n.trees = 7000,type="response")
    dim(pred)
library(caret)
labels = colnames(pred)[apply(pred, 1, which.max)]

print(confusionMatrix(testing$shotType,as.factor(labels)))
