# Global parameters

training_images<- 0
testing_images<- 0

image_width <- 100

image_height<-100
no_classes<-5

# loading multiple images

 
library(EBImage)
library(keras)
ans<-c()
p<--1
dir<- list.dirs(path = "/home/puneet/Downloads/data1-20191031T043406Z-001/data_cleaned/shots1",full.names = T)
dir<- dir[1:no_classes+1]
final_matrix<-c()

all <- lapply(dir,function(Cpath)
  {
  p<<-p+1
  files <- list.files(path=Cpath,
                      pattern=".jpg",all.files=T, full.names=T, no.. = T)
  
  list_of_images <<- lapply(files, function(image){
    x<- readImage(image)
    training_images<<-training_images+1;
    x<- EBImage::resize(x,w=image_width,h=image_height)
    ans<<-append(ans,p)
    return (x)
  })
  print("First Dir")
  image_matrix <- do.call('rbind', lapply(list_of_images, as.matrix))
  print(dim(image_matrix))
  final_matrix<<-rbind(image_matrix,final_matrix)
  print(dim(final_matrix))
})
dim(final_matrix)<-c(training_images,image_width,image_height,3)
ans<-as.factor(ans)
ans<-to_categorical(ans)


# Building the model

model<-keras_model_sequential()

model %>% layer_conv_2d(filter=32 ,kernel_size = c(3,3),padding = "same",
                        input_shape = c(image_width,image_height,3))%>%
  layer_activation("relu")%>%  
  layer_max_pooling_2d(pool_size = c(2,2))%>%
  layer_dropout(0.25)%>%
  #another 2-D convolution layer
  layer_conv_2d(filter=64,kernel_size = c(3,3))%>%
  layer_activation("relu") %>%
  
  #defining pooling layer to reduce dimentions
  layer_max_pooling_2d(pool_size = c(2,2))%>%
  
  #dropout to avoid overfitting
  layer_dropout(0.25)%>%
  
  layer_conv_2d(filter=128, kernel_size = c(3,3),padding = "same")%>%
  layer_activation("relu")%>%
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_dropout(0.25) %>%
  
  #flatten the input
  layer_flatten()%>%
  
  layer_dense(128)%>%
  layer_activation("relu")%>%
  
  layer_dropout(0.5)%>%
  
  #output layer with 10 classes
  layer_dense(no_classes)%>%
  
  #applying softmax activation at output layer to calculate cross entropy
  
  layer_activation("softmax")

print(summary(model))

opt <- optimizer_adam(lr=0.0001, decay = 1e-6)


model %>%compile(
  loss="categorical_crossentropy",
  optimizer=opt,
  metrics="accuracy"
)
model %>% fit( x=final_matrix,y=ans ,epochs=30,verbose=1,shuffle=TRUE)



# Predicting Output

test_ans<-c()
p<--1
dir<- list.dirs(path = "/home/puneet/Downloads/testing",full.names = T)
dir<- dir[1:number_classes+1]
test_matrix<-c()
all <- lapply(dir,function(Cpath)
{
  p<<-p+1
  files <- list.files(path=Cpath,
                      pattern=".jpg",all.files=T, full.names=T, no.. = T)
  
  list_of_images <<- lapply(files, function(image){
    x<- readImage(image)
    x<- EBImage::resize(x,w=image_width,h=image_height)
    test_ans<<-append(test_ans,p)
    testing_images<<- testing_images+1
    return (x)
  })
  print("First Dir")
  image_matrix <- do.call('rbind', lapply(list_of_images, as.matrix))
  print(dim(image_matrix))
  test_matrix<<-rbind(image_matrix,test_matrix)
  print(dim(test_matrix))
})
test_ans<-as.factor(test_ans)
test_ans<-to_categorical(test_ans)

dim(test_matrix)<-c(testing_images,image_width,image_height,3)
pred<- model%>%predict(test_matrix)

temp<-apply(pred,1,function(x) which(x==max(x)))
test_ans<-apply(test_ans,1,function(x) which(x==max(x)))

library(caTools)
library(caret)

print(confusionMatrix(table(temp,test_ans)))

