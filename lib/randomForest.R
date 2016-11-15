

colnames(mat_topics) =  paste("topic",1:K, sep = "")


subset = 1:100
cv.train = train_data[-subset,]
cv.test = train_data[subset,]

#rfsrc(Multivar(y1, y2, ..., yd) ~ . , my.data, ...)
#rfsrc(cbind(y1, y2, ..., yd) ~ . , my.data, ...)
fit_rf = rfsrc(mat_topics, data = cv_train)

predict_rf_topic = predict(fit_rf, newdata = cv.test[,-c(1:K], type = "probability")

