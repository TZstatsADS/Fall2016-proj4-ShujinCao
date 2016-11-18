library(randomForestSRC)
library(randomForest)
library(gbm)
library("kernlab")
library("e1071")
anyNA(all_feature)
mat_train <- cbind(tp_dist_doc,feature.x)
mat_topics2 <- mat_topics[-c(715,950,1375,1407,1417,2284),]
dim(mat_topics2)
mat_topics2 <- mat_topics2[-c(989,1110,1323,1653,1700),]
mat_topic1<- mat_topics2[-c(989,1323,1653,1417,1110,1700),]
dim(mat_topic1)
dim(feature.x)
mat_train <- cbind(mat_topics2,feature.x)
load("mat_topics.RData")
head(mat_train)

subset = 1:100
cv.train = mat_train[-subset,]
cv.test = mat_train[subset,]
which(is.na(cv.train), arr.ind=TRUE)
#rfsrc(Multivar(y1, y2, ..., yd) ~ . , my.data, ...)
#rfsrc(cbind(y1, y2, ..., yd) ~ . , my.data, ...)
colnames(data) <- paste("feature",1:ncol(data))
colnames(data_test) <- paste("feature",1:ncol(data))

# colnames(cv.train) <- letters[1:ncol(cv.train)]
cv.train <- as.data.frame(cv.train)
cv.test <- as.data.frame(cv.test)


summary(fit_rf)                                                  

save(predict_topics, file = "predict_topics.RData")
dim(predict_topics)
dim(pre_doc_topic)
pre_doc_topic <- as.integer(predict_topics)
pre_doc_topic <- matrix(pre_doc_topic, ncol <- ncol(predict_topics), nrow= nrow(predict_topics))
pre_doc_topic <- t(pre_doc_topic)
load("predict_topics.RData")

##
t1 <- Sys.time()
for (i in 1:17){
fit <- randomForest(x = cv.train[,-c(1:17)], y = cv.train[,i], ntree=501, mtry=sqrt(ncol(all_feature2)))
prediction <- predict(fit, newdata = cv.test[,-c(1:17)])
ifelse(i == 1, predict_tp <- prediction, predict_tp <- cbind(predict_tp,prediction))
}

# fit_svm = svm(x = cv.train[,-c(1:17)], y = cv.train[,1])
# prediction2 = predict(fit_svm, newdata = cv.test[,-c(1:17)])
# 
# pred <- as.integer(prediction)
# c <-pred-cv.test[,1]
# a <- c^2
# sum(a)/100  
  
  
predict_tp_<- as.integer(predict_tp)
predict_tp_ <- matrix(predict_tp_, nrow = nrow(predict_tp), ncol = ncol(predict_tp))
dim(predict_tp_)
dim(tp_dist_doc)
pr_tp <- matrix(NA, nrow = nrow(predict_tp_), ncol = ncol(predict_tp_))
for (i in 1:dim(predict_tp_)[1]){
  total <- sum(predict_tp_[i,])
  for (k in 1:dim(predict_tp_)[2]){
   pr_tp[i,k] <- predict_tp_[i,k]/total}
}

probability_word <- pr_tp %*% wd_dist_tp

# fit <- glm(`feature 1`~.,data = data,family = poisson())
# prediction4 <- predict(fit, newdata = data_test[,-1])
# round(prediction4)
# fit.model<-gbm.fit(x= cv.train[,-(1:17)], y = cv.train[,1],
#                    n.trees=501, 
#                    distribution=list(name="quantile",alpha=0.5), 
#                    interaction.depth=3,  
#                    bag.fraction = 0.5, 
#                    shrinkage = 0.1, 
#                    verbose=FALSE) 

t2 <- Sys.time()
t2 - t1
pred <- vector()
for (i in 1:length(prediciton)){
  pred[i] <- prediction[i]/(sum(prediction))
}

wd_dist_tp <- matrix(NA, nrow = nrow(mat_words), ncol = ncol(mat_words))
for (i in 1:dim(mat_topics)[1]){
  total <- sum(mat_topics[i,])
  for (k in 1:dim(mat_topics)[2]){
    tp_dist_doc[i,k] <- mat_topics[i,k]/total}
}

predict_tp <- predict_tp - 1
head(predict_tp)
dim(predict_tp)
predict_tp <- t(predict_tp)
save(predict_tp, file = "predict_tp.RData")
# t1 <- Sys.time()
# fit <- randomForest(x = cv.train[,-(1:17)], y = as.factor(cv.train[,1]))
# t2 <- Sys.time()
# t2 - t1


