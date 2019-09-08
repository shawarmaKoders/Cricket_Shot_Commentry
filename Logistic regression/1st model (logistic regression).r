
data <- read.csv("./../shot.csv",head=TRUE,sep=",");
library(caTools)
library(caret)
split=sample.split(data,SplitRatio = 0.8)
training <- subset(data, split== TRUE)
testing <- subset(data ,split == FALSE)
model=nnet::multinom(shotType~. -score -nose.score -leftEye.score -rightEye.score -leftEar.score
                     -rightEar.score -leftShoulder.score-rightShoulder.score-leftElbow.score
                     -rightElbow.score-leftWrist.score-rightWrist.score-leftHip.score-rightHip.score
                    -leftKnee.score-rightKnee.score-leftAnkle.score-rightAnkle.score
                     ,training,family ="binomial");


predicted.classes <- predict(model,testing)
summary(predicted.classes)
# should be changed to 0.5 I think
# Accuracy = sum of right digonal / sum of all values.

print(confusionMatrix(testing$shotType,predicted.classes))

