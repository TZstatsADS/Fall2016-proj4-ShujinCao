library(randomForestSRC)
library(randomForest)
mat_train <- cbind(mat_topics,mat_f_pitches)
subset = 1:100
cv.train = mat_train[-subset,]
cv.test = mat_train[subset,]

#rfsrc(Multivar(y1, y2, ..., yd) ~ . , my.data, ...)
#rfsrc(cbind(y1, y2, ..., yd) ~ . , my.data, ...)
colnames(cv.train) <- paste("feature",1:ncol(cv.train))
colnames(cv.test) <- paste("feature",1:ncol(cv.train))

# colnames(cv.train) <- letters[1:ncol(cv.train)]
data <- as.data.frame(cv.train)
cv.test <- as.data.frame(cv.test)

t1 <- Sys.time()
fit_rf = rfsrc(cbind(`feature 1`,`feature 2`,`feature 3`,`feature 4`,`feature 5`,
                     `feature 6`,`feature 7`,`feature 8`,`feature 9`,`feature 10`,
                     `feature 11`,`feature 12`,`feature 13`,`feature 14`,
                     `feature 15`,`feature 16`,
                     `feature 17`
                     )~., data = data)
t2 <- Sys.time()
t2 - t1 
predict_rf_topic = predict(fit_rf, newdata = cv.test[,-c(1:17)]), type = "probability")    
summary(fit_rf)                                                  
predict_rf_topic                                                
                      
t1 <- Sys.time()
fit_rf = randomForest(y = data$`feature 1`, x = data[,21:ncol(data)], ntree = 501 )
t2 <- Sys.time()
t2 - t1


