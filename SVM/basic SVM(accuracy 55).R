library(caret)

heart <- read.csv("./datafiles/shot.csv",sep=",",header = T)

library(caTools)
anyNA(heart)
heart <- na.omit(heart)

split <- sample.split(heart,SplitRatio = 0.8)

training <- subset(heart, split ==T)
training <- na.omit(training)
testing <- subset(heart ,split==F)

summary(heart)
trctrl= trainControl(method = "repeatedcv", number = 10,repeats = 3 )
svmLinear <- train(shotType ~. , data =heart,
                   method = "svmLinear",
                   trControl = trctrl,
                   preProcess= c("center","scale"),tuneLength=10)

pred <- predict(svmLinear,newdata = testing )
print(confusionMatrix(table(pred,testing$shotType)))
head(heart)
