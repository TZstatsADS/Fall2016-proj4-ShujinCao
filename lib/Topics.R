library(slam)
library(tm)
library(NLP)
library(tm)
library(lda)
library(LDAvis)
library(topicmodels)

#clean data
load("lyr.RData")
lyr_words <- lyr[,-c(1:30)]
vocab <- names(lyr_words)
head(vocab)
n = ncol(lyr_words)
lyr_words <- as.matrix(lyr_words)


#Below using package"lda" for topic modeling
#prepare documents for lda modeling

t1 <- Sys.time() 
for (i in 1:dim(lyr_words)[1]){  
  j = 0
  d <- matrix(NA,nrow = 2, ncol = sum(lyr_words[i,]!=0))
  for (k in 1:n){
    idx = lyr_words[i,k] 
    if(idx != 0){
      j = j+1
      d[1,j] <- as.integer(k-1)
      d[2,j] <- as.integer(idx)
    }
  }
  if(i==1) d_l <- list(d) else 
    d_l <- c(d_l,list(d))
}  
t2 <- Sys.time()
t2-t1
head(d_l,10)
length(d_l2)

save(d_l,file = "d_l.RData")
load("d_l.RData")

#Build the lda model
K <- 17
G <- 1000
alpha <- 0.1
eta <- 0.1
t1 <- Sys.time()
fit_lda <- lda.collapsed.gibbs.sampler(d_l, K = K, vocab = vocab, 
                                       num.iterations = G, alpha = alpha, 
                                       eta = eta, initial = NULL, burnin = 0,
                                       compute.log.likelihood = TRUE)
t2 <- Sys.time()
t2 - t1
head(mat_topics)
mat_topics <- t(fit_lda$document_sums)

mat_words <- fit_lda$topics
dim(mat_topics)
dim(mat_words)

tp_dist_doc <- matrix(NA, nrow = nrow(mat_topics), ncol = ncol(mat_topics))
wd_dist_tp <- matrix(NA, nrow = nrow(mat_words), ncol = ncol(mat_words))
for (i in 1:dim(mat_topics)[1]){
  total <- sum(mat_topics[i,])
  for (k in 1:dim(mat_topics)[2]){
    tp_dist_doc[i,k] <- mat_topics[i,k]/total}
}
for (i in 1:dim(mat_words)[1]){
  total <- sum(mat_words[i,])
  for (k in 1:dim(mat_words)[2]){
    wd_dist_tp[i,k] <- mat_words[i,k]/total}
}

save(mat_topics, file = "mat_topics.RData")
save(wd_dist_tp,file = "wd_dist_tp.RData")
save(tp_dist_doc,file = "tp_dist_doc.RData")
save(mat_words,file = "mat_words.RData")
load("mat_topics.RData")

# lyr_words <- as.integer(lyr_words)
# lyr_words <- matrix(lyr_words, nrow = nrow(lyr), length(lyr_words)/nrow(lyr))
# dim(lyr_words)
# anyNA(lyr_words)
# which(is.na(lyr_words), arr.ind=TRUE)
# lyr_words <- lyr_words[,-1]
# class(lyr_words[1:10])
# lyr_words <- lyr_words[rowSums(lyr_words !=0)>0,]
# # lyr_words <- lyr_words[, colSums(lyr_words != 0) > 0]
# #Build the topic model using package"topicmodels"
# LDA_fit <- LDA(lyr_words, 17)
# dist_topics <- posterior(LDA_fit,lyr_words)
# doc_topics <- dist_topics$topics
# doc_topics2 <- LDA_FIT@gamma


##Ranking Prediciton PART
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


##Evaluation
i = 1
k = 3
error <- 0
for(i in 1:nrow(mat_rank)){ 
  NofW = sum(lyr_words[i+1,]!=0)-1
  for(k in 1:ncol(mat_rank)){
    idx = lyr_words[i,k]
    ifelse (idx != 0 && mat_rank[i,k] > NofW, error <- error + 1, error <- error) 
    ifelse (idx == 0 && mat_rank[i,k] < NofW, error <- error + 1, error <- error) 
  }
}
error_rate <- error/(ncol(mat_rank)*nrow(mat_rank))
print(error_rate)

dim(mat_rank)
dim()

##Evaluation
# 
# pred_rank_sum <- vector()
# min<-vector()
# differ <- vector()
# pred_rank <- 0
# for (i in 1:100){
#   NofW = sum(lyr_words[i,]!=0)
#   for (k in 1:ncol(mat_rank)){
#     idx = lyr_words[i,k]
#     ifelse(idx != 0, pred_rank <- pred_rank + mat_rank[i,k], pred_rank <- pred_rank)
#   }
#   pred_rank_sum[i] <- pred_rank
#   print(pred_rank)
#   min[i] <- (1+NofW)*NofW/2
#   print(min[i])
#   differ[i] <- pred_rank_sum[i] - min[i]
#   print(differ[i])
# }
# print(mean(differ))