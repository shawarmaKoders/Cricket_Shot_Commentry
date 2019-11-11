  image_width<-100;
image_height<-100;


library(reticulate)
library(EBImage)
library(keras)

args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("At least one argument must be supplied", call.=FALSE)
}
filename = args[1]
filename<-substr(filename,1,nchar(filename)-4)

#building model
load("./ser_model.RData")
model<-unserialize_model(ser_model, custom_objects = NULL, compile = TRUE)
#generating data
path<-paste("image_frames_csvs/",filename,".csv" ,sep = "", collapse = NULL)
print(path)
data <- read.csv(path,header = F)
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

path<-paste("classification_csvs/",filename,".csv" ,sep = "", collapse = NULL)
write.csv(pred,path, row.names = FALSE,)


