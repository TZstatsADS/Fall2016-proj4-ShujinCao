install.packages("nnet")
##Multinomial Log-Linear Models, estimators based on Feed-Forward Neural Networks 
library(nnet)
mat_train <- cbind(mat_topics,mat_f_pitches)
subset = 1:100
cv.train = mat_train[-subset,]
cv.test = mat_train[subset,]

colnames(cv.train) <- paste("feature",1:ncol(cv.train))
colnames(cv.test) <- paste("feature",1:ncol(cv.train))

data <- as.data.frame(cv.train)
cv.test <- as.data.frame(cv.test)
attach(data)
t1 <- Sys.time()
class(v)
attach(cv.train)
v <- cbind(`feature 1`,`feature 2`,`feature 3`,`feature 4`,`feature 5`,
           `feature 6`,`feature 7`,`feature 8`,`feature 9`,`feature 10`,
           `feature 11`,`feature 12`,`feature 13`,`feature 14`,
           `feature 15`,`feature 16`,
           `feature 17`)
v <- cv.train[,1]
x <- cv.train[,-c(1:17)]
variables <- as.matrix(cbind(names(data)))
data_variable <- as.matrix(data[18:dim(data)[2]])
multinom( v~ x,  data = cv.train, MaxNWts = 10000)
t2 <- Sys.time()
t2 - t1 

library(VGAM)
vglmFitMN <- vglm(Ycateg ~ X1 + X2, family=multinomial(refLevel=1), data=dfMN)
dim(data_variable)
