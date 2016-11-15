library(slam)
library(tm)
library(NLP)
library(tm)
library(lda)
library(LDAvis)

stop_words <- stopwords("SMART")
load("lyr.RData")

lyr[,1]
lyr_words <- lyr[,-c(2,3,6:30)]
dim(lyr)[1]
# del <- names(lyr) %in% stop_words
# lyr_dic <- lyr_words[!del]
vocab <- names(lyr_words)
head(vocab)
n = ncol(lyr_words) - 1
lyr_words[1,]

sum(lyr_words[1,]!=0)


t1 <- Sys.time() 
for (i in 2:dim(lyr)[1]){  
  j = 0
  d_list <- matrix(NA,nrow = 2, ncol = sum(lyr_words[i,]!=0)-1)
  for (k in 2:n){
    idx = lyr_words[i,k] 
    if(idx != 0){
    j = j+1
    d_list[1,j] <- k-1
    d_list[2,j] <- idx
    }
  }
  if(i==2) d_l <- list(d_list) else 
    d_l <- c(d_l,list(d_list))
}  
t2 <- Sys.time()
t2-t1
print(d_l)

head(d_l)

class(d_l)
d_l[1]

##
t1 <- Sys.time() 
for (i in 2:3){  
  j = 0
  d <- matrix(NA,nrow = 2, ncol = sum(lyr_words[i,]!=0)-1)
  for (k in 2:n){
    idx = lyr_words[i,k] 
    if(idx != 0){
      j = j+1
      d[1,j] <- as.integer(k-1)
      d[2,j] <- as.integer(idx)
    }
  }
  if(i==2) d_l2 <- list(d) else 
    d_l3 <- c(d_l,list(d))
}  
t2 <- Sys.time()
t2-t1
head(d_l3,10)
length(d_l3)




demo(lda)
return
head(d_l)
save(d_l,file = "d_l_lda.RData")
load("d_l_lda.RData")
head(cora.documents)
d_l[1:3]
K <- 2
G <- 5000
alpha <- 0.02
eta <- 0.02
t1 <- Sys.time()

fit_lda <- lda.collapsed.gibbs.sampler(d_l, K = K, vocab = vocab, 
                                   num.iterations = G, alpha = alpha, 
                                   eta = eta, initial = NULL, burnin = 0,
                                   compute.log.likelihood = TRUE)
t2 <- Sys.time()
t2 - t1
fix(d_l)
mat_topics = t(fit_lda$document_sums)
length(d_l)

##Prediciton PART
pred_topW = predictive.distribution(fit_lda$document_sums,fit_lda$topics,0.1,0.1)

mat_rank = rank(-pred_topW)
# rownames(mat_rank) <- rownames(rank_sheet[,-1])
# colnames(mat_rank) <- colnames(rank_sheet[-1,])
for (i in 1:100){
r_bar[i] = sum(mat_rank[i,])/length(vocab)
}
