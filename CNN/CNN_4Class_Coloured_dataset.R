# Global parameters

training_images<- 0
testing_images<- 0

image_width <- 100

image_height<-100
image_filters <- 3   #3 for RGB, 1 for B/W
no_classes<-2
library(abind)
library(reticulate)
library(EBImage)
library(keras)


#Loading Training Data
ans<-c()
p<--1
dir<- list.dirs(path = "/home/puneet/Downloads/data1-20191031T043406Z-001/data_cleaned/shots1",full.names = T)
dir<- dir[1:no_classes+1]
final_matrix<-array(rep(1, 3500*image_width*image_height*image_filters),c(3500,image_width,image_height,image_filters))
flag=0
all <- lapply(dir,function(Cpath)
{
  p<<-p+1
  files <- list.files(path=Cpath,
                      pattern=".jpg",all.files=T, full.names=T, no.. = T)
   lapply(files, function(image){
    y<- readImage(image)
    training_images<<-training_images+1;
    y<- EBImage::resize(y,w=image_width,h=image_height)
    y<- imageData(y)
    if(is.na(dim(y)[3]))
    {
      final_matrix[training_images,1:image_width,1:image_height,1]<<- y[1:image_width,1:image_height]
      
      final_matrix[training_images,1:image_width,1:image_height,2]<<- y[1:image_width,1:image_height]
      
      final_matrix[training_images,1:image_width,1:image_height,3]<<- y[1:image_width,1:image_height]
    }else
    final_matrix[training_images,1:image_width,1:image_height,1:image_filters]<<- y[1:image_width,1:image_height,1:image_filters]
    # final_matrix<<- rbind(final_matrix,y, along = 1)
    ans<<-append(ans,p)
    print(training_images)
  })
})
final_matrix<- final_matrix[1:training_images,1:image_width,1:image_height,1:image_filters]

ans<-as.factor(ans)
ans<-to_categorical(ans)



# plotting an image
a<- test_matrix[50,1:100,1:100,1:3]
r <- a[,,1]
g <- a[,,2]
b <- a[,,3]
img <- rgbImage(r, g, b)
plot(img)



# Test Data
test_ans<-c()
p<--1
testing_images=0
dir<- list.dirs(path = "/home/puneet/Downloads/testing",full.names = T)
dir<- dir[1:no_classes+1]
test_matrix<-array(rep(1, 2000*image_width*image_height*image_filters),c(2000,image_width,image_height,image_filters))

all <- lapply(dir,function(Cpath)
{
  p<<-p+1
  files <- list.files(path=Cpath,
                      pattern=".jpg",all.files=T, full.names=T, no.. = T)
  
  list_of_images <<- lapply(files, function(image){
    x<- readImage(image)
    x<- EBImage::resize(x,w=image_width,h=image_height)
    print(p)
    test_ans<<-append(test_ans,p)
    testing_images<<- testing_images+1
    y<- imageData(x)
    if(is.na(dim(y)[3]))
    {
      test_matrix[testing_images,1:image_width,1:image_height,1]<<- y[1:image_width,1:image_height]
      
      test_matrix[testing_images,1:image_width,1:image_height,2]<<- y[1:image_width,1:image_height]
      
      test_matrix[testing_images,1:image_width,1:image_height,3]<<- y[1:image_width,1:image_height]
    }else
      test_matrix[testing_images,1:image_width,1:image_height,1:image_filters]<<- y[1:image_width,1:image_height,1:image_filters]
    # print(testing_images)
    return (x)
  })
})
test_matrix<-test_matrix[1:testing_images,1:image_width,1:image_height,1:image_filters]

test_ans<-as.factor(test_ans)
test_ans<-to_categorical(test_ans)




# Building the model

model<-keras_model_sequential()

model %>% layer_conv_2d(filter=64 ,kernel_size = c(3,3),padding = "same",
                        input_shape = c(image_width,image_height,image_filters))%>%
  layer_activation("relu")%>%  
  layer_max_pooling_2d(pool_size = c(2,2))%>%
  layer_dropout(0.25)%>%
  #another 2-D convolution layer
  layer_conv_2d(filter=128,kernel_size = c(3,3))%>%
  layer_activation("relu") %>%
  
  #defining pooling layer to reduce dimentions
  layer_max_pooling_2d(pool_size = c(2,2))%>%
  
  #dropout to avoid overfitting
  layer_dropout(0.25)%>%
  
  layer_conv_2d(filter=236, kernel_size = c(3,3),padding = "same")%>%
  layer_activation("relu")%>%
  layer_max_pooling_2d(pool_size=c(2,2)) %>%  
  layer_dropout(0.25) %>%
  
  #flatten the input
  layer_flatten()%>%
  
  layer_dense(200)%>%
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



# TRaining Our model
data_augmentation <- F 

if(!data_augmentation) {  
  model %>% fit( final_matrix,ans ,batch_size=32,
                 epochs=40,validation_data = list(test_matrix, test_ans),
                 shuffle=TRUE)
  
}else {  
  #Generating images
  
  gen_images <- image_data_generator(featurewise_center = TRUE,
                                     featurewise_std_normalization = TRUE,
                                     rotation_range = 20,
                                     width_shift_range = 0.30,
                                     height_shift_range = 0.30,
                                     horizontal_flip = TRUE  )
  #Fit image data generator internal statistics to some sample data
  gen_images %>% fit_image_data_generator(final_matrix)
  #Generates batches of augmented/normalized data from image data and #labels to visually see the generated images by the Model
  model %>% fit_generator(
    flow_images_from_data(final_matrix, ans,gen_images,
                          batch_size=32,save_to_dir="/home/puneet/Work/R-ML/neuralnet/cnn_output"),
    steps_per_epoch=as.integer(testing_images/32),epochs = 80,
    #validation_data = list(test_matrix, test_ans) 
    )
}

  ser_model <- serialize_model(model, include_optimizer = TRUE)

#unsearializing model

model<-unserialize_model(ser_model, custom_objects = NULL, compile = TRUE)



#predicting output manually
pred<- model%>%predict_classes(test_matrix)
pred=pred+1
x<-factor(apply(test_ans, 1, function(x) which(x == 1)))

library(caTools)
library(caret)
print(confusionMatrix(table(pred,x)))

