library(slam)
library(tm)
library(NLP)
library(tm)
library(lda)
library(LDAvis)

stop_words <- stopwords("SMART")
lyr_words = load("lyr.RData")
dim(lyr_words)
lyr_words[,1]
lyr_words <- lyr_words[,-c(2,3,6:30)]
del <- names(lyr_words) %in% stop_words
lyr_dic <- lyr_words[!del]
vocab <- names(lyr_dic)
head(vocab)
n = ncol(lyr_words) - 1
d_list = list()
j = 0
for (i in 1:length(songf)){
  for (k in 1:n){
    idx = lyr_dic[i,k] 
    if(idx != 0){j = j+1
    d_list[[i]][1,j] = k-1
    d_list[[i]][2,j] = idx
    }  
  }
}


K <- 20
G <- 5000
alpha <- 0.02
eta <- 0.02
t1 <- Sys.time()
fit_lda <- lda.collapsed.gibbs.sampler(documents = d_list, K = K, vocab = vocab, 
                                   num.iterations = G, alpha = alpha, 
                                   eta = eta, initial = NULL, burnin = 0,
                                   compute.log.likelihood = TRUE)
t2 <- Sys.time()
t2 - t1

mat_topics = t(fit_lda$document_sums)


##Prediciton PART
pred_topW = predictive.distribution(fit_lda$document_sums,fit_lda$topics,0.1,0.1)

mat_rank = rank(-pred_topW)
# rownames(mat_rank) <- rownames(rank_sheet[,-1])
# colnames(mat_rank) <- colnames(rank_sheet[-1,])
for (i in 1:100){
r_bar[i] = sum(mat_rank[i,])/length(vocab)
}
