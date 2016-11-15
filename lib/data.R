fix(lyr)
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
library(rhdf5)
setwd("C:\\Users\\Jackie\\Documents\\Data Science\\Project4")
mydata = read.table("common_id.txt")
song_ex_f1 = h5read("data\\A\\B\\C\\TRABCKL128F423A778.h5","/analysis")
song_ex_f2 = h5read("data\\A\\A\\A\\TRAAABD128F429CF47.h5","/analysis")
names(song_ex_f2)
head(song_ex_f$segments_pitches,5)
length(song_ex_f$segments_timbre)
dim(song_ex_f$segments_pitches)[2]
song_ex_f$segments_timbre
devtools::install_github("cpsievert/LDAvisData")
data(reviews, package = "LDAvisData")
install.packages("devtools")
install.packages("tm")
install.packages("slam")
install.packages("lda")
install.packages("LDAvis")
library(slam)
library(tm)
library(NLP)
library(tm)
library(lda)
library(LDAvis)
stop_words <- stopwords("SMART")
head(stop_words,5)

# pre-processing:
reviews <- gsub("'", "", reviews)  # remove apostrophes
reviews <- gsub("[[:punct:]]", " ", reviews)  # replace punctuation with space
reviews <- gsub("[[:cntrl:]]", " ", reviews)  # replace control characters with space
reviews <- gsub("^[[:space:]]+", "", reviews) # remove whitespace at beginning of documents
reviews <- gsub("[[:space:]]+$", "", reviews) # remove whitespace at end of documents
reviews <- tolower(reviews)  # force to lowercase

# tokenize on space and output as a list:
doc.list <- strsplit(reviews, "[[:space:]]+")
length(doc.list)       # Length: number of documents
length(doc.list[[2]]) 
head(doc.list,1)
# compute the table of terms:
term.table <- table(unlist(doc.list))
term.table <- sort(term.table, decreasing = TRUE)
head(term.table,10) 

# remove terms that are stop words or occur fewer than 5 times:
del <- names(term.table) %in% stop_words | term.table < 5
term.table <- term.table[!del]
vocab <- names(term.table)
head(vocab)

get.terms <- function(x) {
  index <- match(x, vocab)
  index <- index[!is.na(index)]
  rbind(as.integer(index - 1), as.integer(rep(1, length(index))))
}

documents <- sapply(doc.list, get.terms)
documents[1]
head(documents,5)

K <- 20
G <- 5000
alpha <- 0.02
eta <- 0.02
library(lda)
set.seed(357)
t1 <- Sys.time()
fit <- lda.collapsed.gibbs.sampler(documents = documents, K = K, vocab = vocab, 
                                   num.iterations = G, alpha = alpha, 
                                   eta = eta, initial = NULL, burnin = 0,
                                   compute.log.likelihood = TRUE)
t2 <- Sys.time()
t2 - t1  # about 24 minutes on laptop
theta <- t(apply(fit$document_sums + alpha, 2, function(x) x/sum(x)))
phi <- t(apply(t(fit$topics) + eta, 2, function(x) x/sum(x)))
head(theta,5)
t= fit$document_sums
head(t,1)
doc.length <- sapply(documents, function(x) sum(x[2, ]))  # number of tokens per document [312, 288, 170, 436, 291, ...]
term.frequency <- as.integer(term.table)  # frequencies of terms in the corpus [8939, 5544, 2411, 2410, 2143, 

MovieReviews <- list(phi = phi,
                     theta = theta,
                     doc.length = doc.length,
                     vocab = vocab,
                     term.frequency = term.frequency)
head(MovieReviews,1)

example <- c("I am am am the very very model of a modern major general",
             "I have a major headache")
corpus <- lexicalize(example, lower=TRUE)
documents2 = corpus$documents
fit$topics
fit2 <- lda.collapsed.gibbs.sampler(documents = documents2, K = K, vocab = vocab, 
                                   num.iterations = G, alpha = alpha, 
                                   eta = eta, initial = NULL, burnin = 0,
                                   compute.log.likelihood = TRUE)
fit2$topics

