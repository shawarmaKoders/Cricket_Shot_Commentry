image_width<-100;
image_height<-100;


library(reticulate)
library(EBImage)
library(keras)
model<-unserialize_model(ser_model, custom_objects = NULL, compile = TRUE)
data <- read.csv("./../Video_Processing/fname.csv",header = F)
dim(data)
image_matrix<- as.matrix(data)
image_matrix=image_matrix/255

#dim(image_matrix)<-c((nrow(image_matrix)/100),100,100)
pred_matrix<-array(rep(1, nrow(data)*100),c((nrow(data)/100),100,100,3))

ind<-0
for(ind in 0:((nrow(data)/100)-1))
{
  pred_matrix[ind,1:image_width,1:image_height,1]<- image_matrix[((ind*100)+1):((ind*100)+image_width),1:image_height]
  
  pred_matrix[ind,1:image_width,1:image_height,2]<- image_matrix[((ind*100)+1):((ind*100)+image_width),1:image_height]
  
  pred_matrix[ind,1:image_width,1:image_height,3]<- image_matrix[((ind*100)+1):((ind*100)+image_width),1:image_height]
}




single_image <- pred_matrix[25,1:100,1:100,1]
#single_image <- image_matrix[1:100,1:100]

img <- rgbImage(single_image,single_image, single_image)
plot(img)


pred<- model%>%predict(pred_matrix)

colnames(pred) <- c('cover', 'cut', 'leg','pull','scoop','straight')

write.csv(pred,"./..video_processing/model_output.csv", row.names = FALSE,append = T)


