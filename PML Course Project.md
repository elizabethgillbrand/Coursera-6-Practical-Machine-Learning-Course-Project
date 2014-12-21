Course Project for Practical Machine Learning
========================================================

Overview
-------------------------
Here are the steps that I took for this project:

1. **Groom data**  First I selected only the variables/columns that are summary measures) to reduce the number of variables from 160 to 68.  Then I reduced the number of rows to include only the rows that include values for the summary measures. This reduced the number of rows in the training set from from 19622 to 406.  I conducted these two data compression technics in order to allow the model fitting step to run more quickly versus using the full data set.

2. **Split data** I allocated 75% of the training data set to use for model building. I held back 25% of the training data to do cross validation

3. **Train the model** I used the Random Forest method to create my model.

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

sm_train<-train[,c(18:19,21:22,24:25,27:36,50:59,75:83,93:94,96:97,99:100,103:112,131:132,134:135,137:138,141:150,160)]   

sm_test<-test[,c(18:19,21:22,24:25,27:36,50:59,75:83,93:94,96:97,99:100,103:112,131:132,134:135,137:138,141:150,160)]   

index<-!sm_train$max_roll_belt=="NA"
index_2<-!is.na(index)
s_sm_train<-sm_train[index_2,]
sm_test<-sm_test[,-68]
```
Here is the code that I used to split the dataset (step 2 above)   
```
inTrain<-createDataPartition(s_sm_train$classe, p=0.75, list=FALSE)
final_train<-s_sm_train[inTrain,]
final_validation<-s_sm_train[-inTrain,]
```
   

Here is the command that I used to create the model (step 3 above), along with the associated output from that command.


```
modelFit<-train(classe~.,data=final_train, method="rf")
```

```
Random Forest 

307 samples
 67 predictor
  5 classes: 'A', 'B', 'C', 'D', 'E' 

No pre-processing
Resampling: Bootstrapped (25 reps) 

Summary of sample sizes: 307, 307, 307, 307, 307, 307, ... 

Resampling results across tuning parameters:

  mtry  Accuracy   Kappa      Accuracy SD  Kappa SD  
   2    0.7661585  0.7039798  0.03541543   0.04485759
  34    0.7609265  0.6977762  0.03257624   0.04060441
  67    0.7405003  0.6724544  0.03174584   0.03993815

Accuracy was used to select the optimal model using  the largest value.
The final value used for the model was mtry = 2. 
```
   
Here are the commands that I used to perform cross validation (step 4 above) and to estimate the error rate, along with the associated output from those command.

```
pred_final_validation<-predict(modelFit,final_validation)
table(pred_final_validation,final_validation$classe)
```

```
pred_final_validation  A  B  C  D  E
                    A 27  5  0  2  0
                    B  0 13  2  1  2
                    C  0  1 14  0  0
                    D  0  0  1 14  0
                    E  0  0  0  0 17
                                   
```
**Per the matrix above, 85 of the predictions were accurate (e.g. the ones along the diagonal) and 14 were inaccurate.  Thus the error rate on the validation sample is 14/99=14%.  We can use this as an estimate of our Out of Error Sample Rate.**


