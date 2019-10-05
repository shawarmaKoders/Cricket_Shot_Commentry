library(caret)
library(e1071)
arr=c("./cover.csv","./cut.csv","./straight.csv")
data <- read.csv(arr[1])
for (i in arr[-1] )
{
  data2 <- read.csv(i,head=TRUE,sep=",");
  data <- rbind(data,data2);
}
set.seed(189)
##code to omit all entries with negative valu
#data <- read.csv("old_shot.csv",sep = ",",header = T)
data2 <- data[1:52]
data2[data2 <0] <- NA
data2[53]<- data[53]
data2= na.omit(data2)
data<- data2

#set.seed(2301)
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
