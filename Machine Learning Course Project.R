setwd("~/Desktop")
fileUrl_train <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
fileUrl_test<-"https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(fileUrl_train, destfile = "./data/train.csv", method = "curl")
download.file(fileUrl_test, destfile = "./data/test.csv", method = "curl")
list.files("./data")
train <- read.csv("./data/train.csv")
test <- read.csv("./data/test.csv")
set.seed(1965)
sm_test<-test[,-c(1:7,12:36,49:59,69:83, 87:101,103:112,125:139,141:150,160)]
sm_train<-train[,-c(1:7,12:36,49:59,69:83, 87:101,103:112,125:139,141:150)]
library("caret", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")
inTrain<-createDataPartition(sm_train$classe, p=0.75, list=FALSE)
final_train<-sm_train[inTrain,]
final_validation<-sm_train[-inTrain,]
modelFit<-train(classe~.,data=final_train, method="rf")
pred_final_validation<-predict(modelFit,final_validation)
table(pred_final_validation,final_validation$classe)
pred_final_test<-predict(modelFit,final_validation)
pml_write_files = function(x){
        n = length(x)
        for(i in 1:n){  
                filename = paste0("problem_id_",i,".txt")
                write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
        } 
}
        
pml_write_files(pred_final_test)