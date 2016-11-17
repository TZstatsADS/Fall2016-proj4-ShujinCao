kfunction <- function(linear =0, quadratic=0)
{
  k <- function (x,y)
  {
    linear*sum((x)*(y)) + quadratic*sum((x^2)*(y^2))
  }
  class(k) <- "kernel"
  k
}

library(randomForest)
require(verification)
library("kernlab")
library("e1071")
k = 5
n = floor(nrow(train_data)/k)
error.rate = rep(NA,k)
i = 1
s1 = ((i-1)*n+1)
s2 = (i*n)
subset = s1:s2
cv.train = train_data2[-subset,]
cv.test = train_data2[subset,]
fix(cv.train)
fix(train_data2)

#svm
colnames(train_data2)[464]
train_data3 = train_data2[,c(-2464,-464,-2251,-2929,-3075,-3325,-658,-4329)]
cv.train_svm = train_data3[-subset,]
cv.test_svm = train_data3[subset,]
fit_svm = svm(x = cv.train_svm[,-1], y = as.factor(cv.train_svm[,1]))
prediction = predict(fit_svm, newdata = cv.test_svm[,-1], type = "response")

pr <- as.vector(prediction)
pr <- as.numeric(pr)
print(pr)
pred.table<- table(pr, cv.test_svm[,1])
print(pred.table)
error.rate <- (pred.table[1,2]+pred.table[2,1])/dim(cv.test_svm)[1]
print(error.rate)


for(i in 1:k){
  s1 = ((i-1)*n+1)
  s2 = (i*n)
  subset = s1:s2
  cv.train_svm = train_data3[-subset,]
  cv.test_svm = train_data3[subset,]
  fit_svm = ksvm(x = cv.train_svm[,-1], y = as.factor(cv.train_svm[,1]), type="C-svc",kernel= "stringdot",C=1,scale = FALSE)
  prediction = predict(fit_svm, newdata = cv.test_svm[,-1], type = "response")
  pr <- as.vector(prediction)
  print(pr)
  pr <- as.numeric(pr)
  print(pr)
  pred.table<- table(pr, cv.test_svm[,1])
  print(pred.table)
  error.rate[i] <- (pred.table[1,2]+pred.table[2,1])/dim(cv.test_svm)[1]
  print(error.rate[i])
}
print(paste("Average er:", mean(error.rate)))

#randomForest
tune_RF = tuneRF(x = cv.train[,-1], y = as.factor(cv.train[,1]), ntreeTry = 801, improve = 0.05, trace = TRUE, plot = TRUE, doBest = TRUE)



fit = randomForest(x = cv.train[,-1], y = as.factor(cv.train[,1]))
prediction = predict(fit, newdata = cv.test[,-1], type = "response")
pr <- as.vector(prediction)
pr <- as.numeric(pr)
pred.table<- table(prediction, cv.test[,1])
print(pred.table)
error.rate <- (pred.table[1,2]+pred.table[2,1])/dim(cv.test)[1]
print(error.rate)
a = cv.test[,2]
fix(cv.test)
for(i in 1:k){
  s1 = ((i-1)*n+1)
  s2 = (i*n)
  subset = s1:s2
  cv.train = train_data2[-subset,]
  cv.test = train_data2[subset,]
  fit = randomForest(x = cv.train[,-1], y = as.factor(cv.train[,1]))
  prediction = predict(fit, newdata = cv.test[,-1], type = "response")
  pr <- as.vector(prediction)
  print(pr)
  pr <- as.numeric(pr)
  pred.table<- table(pr, cv.test[,1])
  print(pred.table)
  error.rate[i]= (pred.table[1,2]+pred.table[2,1])/dim(cv.test)[1]
  print(error.rate[i])
}
print(paste("Average er:", mean(error.rate)))

