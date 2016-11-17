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
dim(lyr)[1]
vocab <- names(lyr_words)
head(vocab)
n = ncol(lyr_words)

lyr_words <- as.matrix(lyr_words)
save(lyr_words,file = "lyr_words.RData")
dim(lyr_words)
lyr_words[1,]
lyr_words <- as.integer(lyr_words)
lyr_words <- matrix(lyr_words, nrow = nrow(lyr), length(lyr_words)/nrow(lyr))
dim(lyr_words)
anyNA(lyr_words)
which(is.na(lyr_words), arr.ind=TRUE)
lyr_words <- lyr_words[,-1]
class(lyr_words[1:10])
lyr_words <- lyr_words[rowSums(lyr_words !=0)>0,]
# lyr_words <- lyr_words[, colSums(lyr_words != 0) > 0]
#Build the topic model using package"topicmodels"
LDA_fit <- LDA(lyr_words, 17)
dist_topics <- posterior(LDA_fit,lyr_words)
doc_topics <- dist_topics$topics
doc_topics2 <- LDA_FIT@gamma



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
mat_topics = t(fit_lda$document_sums)
mat_topics_scaled <- plogis(mat_topics)*2-1
save(mat_topics_scaled,file = "mat_topics_scaled.RData")
save(mat_topics, file = "mat_topics.RData")

##Ranking Prediciton PART
pred_topW = predictive.distribution(fit_lda$document_sums,fit_lda$topics,0.1,0.1)
dim(pred_topW)
pred_top_word_mat <- t(pred_topW)
head(pred_top_word_mat)
pred_top_word_mat_negative <- -pred_top_word_mat

mat_rank <- matrix(NA, nrow = nrow(pred_top_word_mat), ncol = ncol(pred_top_word_mat))
for (i in 1:nrow(pred_top_word_mat)){
  mat_rank[i,] = rank(pred_top_word_mat_negative[i,])
}
dim(mat_rank)
##Evaluation1
r_mean <- sum()
pred_rank_sum <- vector()
min<-vector()
differ <- vector()
pred_rank <- 0
for (i in 1:100){
  NofW = sum(lyr_words[i,]!=0)
  r_mean = sum(mat_rank[i,])/nrow(mat_rank)
  for (k in 1:ncol(mat_rank)){
    idx = lyr_words[i,k]
    if (idx =! 0) pred_rank <- pred_rank + rank_mat[i,k]
  }
  pred_rank_sum[i] <- pred_rank/(r_mean*NofW)
  min[i] <- (1+m)/2/r_mean
  differ[i] <- pred_rank_sum[i] - min[i]
  print(differ[i])
}

print(mean(differ))

##Evaluation2

for (i in 1:100){
  r_bar[i] = sum(mat_rank[i,])/length(vocab)
}
i = 1
k = 3
error <- 0
for(i in 1:nrow(mat_rank)){ 
  NofW = sum(lyr_words[i+1,]!=0)-1
  for(k in 1:ncol(mat_rank)){
    idx = lyr_words[i+1,k+1]
    ifelse (idx != 0 && mat_rank[i,k] > NofW, error <- error + 1, error <- error) 
    ifelse (idx == 0 && mat_rank[i,k] < NofW, error <- error + 1, error <- error) 
  }
}
error_rate <- error/(ncol(mat_rank)*nrow(mat_rank))
print(error_rate)

dim(mat_rank)
dim()
