data <- read.csv("./datafiles/shot.csv",head=TRUE,sep=",");
library(caTools)
split=sample.split(data,SplitRatio = 0.8)
training <- subset(data, split== TRUE)
testing <- subset(data ,split == FALSE)

model=glm(shotType~. -score -nose.score -leftEye.score -rightEye.score -leftEar.score
                     -rightEar.score -leftShoulder.score-rightShoulder.score-leftElbow.score
                     -rightElbow.score-leftWrist.score-rightWrist.score-leftHip.score-rightHip.score
                    -leftKnee.score-rightKnee.score-leftAnkle.score-rightAnkle.score
                     ,training,family ="binomial");

print(summary(model))

res <- predict(model,testing,type="response")

# should be changed to 0.5 I think
print(table(ActualValue=testing$shotType,PredictedValue=res>0.4));
# Accuracy = sum of right digonal / sum of all values.

