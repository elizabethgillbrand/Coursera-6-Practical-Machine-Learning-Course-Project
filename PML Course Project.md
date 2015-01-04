Course Project for Practical Machine Learning
========================================================

Overview
-------------------------
Here are the steps that I took for this project:

1. **Groom data**  First I selected only the variables/columns that are *not* summary measures to reduce the number of variables from 160 to 51.  The summary measures are not populated in the test data set so there it is counter-productive to include them in when training the model.

2. **Split data** I allocated 75% of the training data set to use for model building. I held back 25% of the training data to do cross validation

3. **Train the model** I used the Random Forest method to create my model.  This took about 90 minutes!

4. **Cross Validate and Estimate Error Rate**  Then I used my model to predict the  outcome for each observation in the validation data set.  I compared my predicted "classe" values against actual in order to calculate the error rate.  The error rate that I calculated here is a good estimate of the "out of sample error".

5. **Make predictions for test cases** Finally, I used my model to predict outcomes for the 20 test cases.

Results
-------------------------
Here is the code that I used to compress the dataset (step 1 above)

```
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
```
Here is the code that I used to split the dataset (step 2 above)   
```
library("caret", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")
inTrain<-createDataPartition(sm_train$classe, p=0.75, list=FALSE)
final_train<-sm_train[inTrain,]
final_validation<-sm_train[-inTrain,]
```
   

Here is the command that I used to create the model (step 3 above), along with the associated output from that command.


```
modelFit<-train(classe~.,data=final_train, method="rf")
```

```
Random Forest 

14718 samples
   51 predictor
    5 classes: 'A', 'B', 'C', 'D', 'E' 

No pre-processing
Resampling: Bootstrapped (25 reps) 

Summary of sample sizes: 14718, 14718, 14718, 14718, 14718, 14718, ... 

Resampling results across tuning parameters:

  mtry  Accuracy   Kappa      Accuracy SD  Kappa SD   
   2    0.9896235  0.9868666  0.001494861  0.001891886
  26    0.9899270  0.9872531  0.002038228  0.002571430
  51    0.9827476  0.9781655  0.003699391  0.004677059

Accuracy was used to select the optimal model using  the largest value.
The final value used for the model was mtry = 26. 
```
   
Here are the commands that I used to perform cross validation (step 4 above) and to estimate the error rate, along with the associated output from those command.

```
pred_final_validation<-predict(modelFit,final_validation)
table(pred_final_validation,final_validation$classe)
```

```
pred_final_validation    A    B    C    D    E
                    A 1393   11    0    0    0
                    B    1  937    6    0    0
                    C    0    1  847    4    1
                    D    0    0    2  799    1
                    E    1    0    0    1  899
                                   
```
**Per the matrix above, 4875 of the predictions were accurate (e.g. the ones along the diagonal) and 29 were inaccurate.  Thus the error rate on the validation sample is 29/4875=0.6%%.  We can use this as an estimate of our Out of Error Sample Rate.**


