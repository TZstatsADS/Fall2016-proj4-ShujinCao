##Ranking Prediciton PART
# predict_tp_t <- t(predict_tp)
# pred_topW = predictive.distribution(predict_tp_t,fit_lda$topics,0.1,0.1)
# pred_top_word_mat <- t(pred_topW)
# pred_top_word_mat_negative <- -pred_top_word_mat 
# mat_rank <- matrix(NA, nrow = nrow(pred_top_word_mat), ncol = ncol(pred_top_word_mat))



dim(fit_lda$document_sums)
dim(predict_tp)
predict_tp_t <- t(predict_tp)
pred_topW = predictive.distribution(predict_tp_t,fit_lda$topics,0.1,0.1)
dim(pred_topW)
pred_top_word_mat <- t(pred_topW)
pred_top_word_mat_negative <- -pred_top_word_mat 

mat_rank <- matrix(NA, nrow = nrow(pred_top_word_mat), ncol = ncol(pred_top_word_mat))
for (i in 1:nrow(pred_top_word_mat)){
  mat_rank[i,] = rank(pred_top_word_mat_negative[i,])
}
dim(mat_rank)

probability_word <- pr_tp %*% wd_dist_tp
dim(probability_word)
probabiltiy_word_neg <- -probability_word
mat_rank <- matrix(NA, nrow = nrow(probability_word), ncol = ncol(probability_word))

for (i in 1:nrow(probability_word)){
  mat_rank[i,] = rank(probabiltiy_word_neg[i,])
}
save(mat_rank, file = "mat_rank.csv")
##Evaluation1
median(mat_rank[1,])
sum(probability_word[2,])
sort(mat_rank[1,])[1:10]
  

pred_rank_sum <- vector()
min<-vector()
differ <- vector()
pred_rank <- 0
for (i in 1:100){
  NofW = sum(lyr_words[i,]!=0)
  for (k in 1:ncol(mat_rank)){
    idx = lyr_words[i,k]
    ifelse(idx != 0, pred_rank <- pred_rank + mat_rank[i,k], pred_rank <- pred_rank)
  }
  pred_rank_sum[i] <- pred_rank
  print(pred_rank)
  min[i] <- (1+NofW)*NofW/2
  print(min[i])
  differ[i] <- pred_rank_sum[i] - min[i]
  print(differ[i])
}
print(mean(differ))

pred_rank_sum <- vector()
min<-vector()
differ <- vector()
pred_rank <- 0
for (i in 1:100){
  NofW = sum(lyr_words[i,]!=0)
  for (k in 1:ncol(mat_rank)){
    idx = lyr_words[i,k]
    ifelse(idx != 0, pred_rank <- pred_rank + mat_rank[i,k], pred_rank <- pred_rank)
  }
  pred_rank_sum[i] <- pred_rank
  print(pred_rank)
  min[i] <- (1+NofW)*NofW/2
  print(min[i])
  differ[i] <- pred_rank_sum[i] - min[i]
  print(differ[i])
}
print(mean(differ))

##Evaluation2
i = 1
k = 
error <- 0
for(i in 1:nrow(mat_rank)){ 
  NofW = sum(lyr_words[i,]!=0)
  for(k in 1:ncol(mat_rank)){
    idx = lyr_words[i,k]
    ifelse (idx != 0 && mat_rank[i,k] > NofW, error <- error + 1, error <- error) 
    ifelse (idx == 0 && mat_rank[i,k] < NofW, error <- error + 1, error <- error) 
  }
}

print(error)
dim(mat_rank)

