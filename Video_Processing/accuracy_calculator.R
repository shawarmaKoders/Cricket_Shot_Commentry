x <-list.files("./metrics",full.names = T)
y<- read.csv("./metrics/cover1.csv")
data<-which.max(as.matrix(y[2,2:7]))
pred<-data.frame("cover"=c(0,0,0,0,0,0),
                 "cut"=c(0,0,0,0,0,0),
                 "leg"=c(0,0,0,0,0,0),
                 "pull"=c(0,0,0,0,0,0),
                 "scoop"=c(0,0,0,0,0,0),
                 "straight"=c(0,0,0,0,0,0))

actual<-data.frame("cover"=0,"cut"=0,"leg"=0,"pull"=0,"scoop"=0,"straight"=0)

temp_actual <- vector()
temp_pred <- vector()

lapply(x, function(file){
  data <- read.csv(file)
  subset <- substr(file,11,12)
  if(subset=="co")
  {
    temp_actual<<-append(temp_actual,"cover")
    
  }else if(subset=="cu")
  {
    temp_actual<<-append(temp_actual,"cut")
  }else if(subset=="pu")
  {
    temp_actual<<-append(temp_actual,"pull")
  }
  else if(subset=="sc")
  {
    temp_actual<<-append(temp_actual,"scoop")
    
  }else if(subset=="st")
  {
    temp_actual<<-append(temp_actual,"straight")
    
  }
  else if(subset=="le")
  {
    temp_actual<<-append(temp_actual,"leg")
  }
  
  data<-which.max(as.matrix(data[2,2:7]))
  
  
  if(data==1)
  {
    temp_pred<<-append(temp_pred,"cover")
    
  }else if(data==2)
  {
    temp_pred<<-append(temp_pred,"cut")
  }  else if(data==3)
  {
    temp_pred<<-append(temp_pred,"leg")
  }else if(data==4)
  {
    temp_pred<<-append(temp_pred,"pull")
  }
  else if(data==5)
  {
    temp_pred<<-append(temp_pred,"scoop")
  }else if(data==6)
  {
    temp_pred<<-append(temp_pred,"straight")
  }
})
print(table(temp_actual,temp_pred))
