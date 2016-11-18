setwd("C:\\Users\\Asus\\Desktop\\TestSongFile100")
library(rhdf5)
library(lda)
paths = Sys.glob("*\\*.h5")
H5close()
songf_t = lapply(paths, function(x){h5read(x,"/analysis")})

##extract segments_pitches features
lengthe <- vector()
for (i in 1:length(songf_t)){
  lengthe[i] <- dim(songf_t[[i]]$segments_timbre)[2]}
median(lengthe)

t1 <- Sys.time()
in_length <- matrix(NA,ncol = 1, nrow = length(songf_t))
mat_total = matrix(NA, ncol = 1, nrow = 12)
for (i in 1:length(songf_t)){
  mat = songf_t[[i]]$segments_pitches
  n = dim(mat)[2]
  take_in = seq(1,n,by = round(n/min(lengthe)))
  in_length[i] = length(take_in)
  mat = mat[,take_in]
  mat_total = cbind(mat_total, mat)
}
dim(mat_total)

mat_t = mat_total[,-1]
matT_pitches = t(mat_t)
save(matT_pitches,file = "matT_pitches.RData")
t1 <- Sys.time()
kmean_pitches = kmeans(matT_pitches,500, iter.max = 20)
t2 <- Sys.time()
t2-t1
idx= kmean_pitches$cluster
save(idx,file = "idx.RData")
length(idx)

t1 <- Sys.time()
mat_f_pitches = matrix(NA,ncol = 500, nrow =length(songf_t))
N = 0
M = 0
for (i in 1:length(songf_t)){
  N = N+M
  M = in_length[i]
  for (k in 1:500){
    sum_ <- sum(idx[(N+1):(N+M)]==k)
    mat_f_pitches[i,k] = sum_/M
  }
}
t2 <- Sys.time()
t2-t1

dim(mat_f_pitches)

save(mat_f_pitches,file = "mat_f_pitches.RData")


##extract segments_timbre features
t1 <- Sys.time()
mat_total = matrix(NA, ncol = 1, nrow = 12)
for (i in 1:length(songf)){
  mat = songf_t[[i]]$segments_timbre
  n = dim(mat)[2]
  take_in = seq(1,n,by = round(n/min(lengthe)))
  mat = mat[,take_in]
  mat_total = cbind(mat_total, mat)
}
t2 <- Sys.time()
t2-t1

mat_t = mat_total[,-1]
matT_timbre = t(mat_t)
save(matT_timbre,file = "matT_timbre.RData")

t1 <- Sys.time()
kmean_timbre = kmeans(matT_timbre,500, iter.max = 20)
t2 <- Sys.time()
t2-t1
idx= kmean_timbre$cluster


t1 <- Sys.time()
mat_f_timbre = matrix(NA,ncol = 500, nrow =length(songf_t))
N = 0
M = 0
for (i in 1:length(songf_t)){
  N = N+M
  M = in_length[i]
  for (k in 1:500){
    sum_ <- sum(idx[(N+1):(N+M)]==k)
    mat_f_timbre[i,k] = sum_/M
  }
}
t2 <- Sys.time()
t2-t1
save(mat_f_timbre, file = "mat_f_timbre.RData")
anyNA(mat_f_timbre)
#Extract other features
t1 <- Sys.time()
bar_start <- matrix(NA, ncol = 2, nrow = length(songf_t))
beat_start<- matrix(NA, ncol = 2, nrow = length(songf_t))
section_start <- matrix(NA, ncol = 2, nrow = length(songf_t))
tatum_start <- matrix(NA, ncol = 2, nrow = length(songf_t))
for (i in 1:length(songf_t)){
  mat1 <- songf_t[[i]]$bars_start
  mat2 <- songf_t[[i]]$beats_start
  mat3 <- songf_t[[i]]$sections_start
  mat4 <- songf_t[[i]]$tatums_start
  bar_start[i,1] <- median(mat1)
  bar_start[i,2] <- sd(mat1)
  beat_start[i,1] <- median(mat2)
  beat_start[i,2] <- sd(mat2)
  section_start[i,1] <- median(mat3)
  section_start[i,2] <- sd(mat3)
  tatum_start[i,1] <- median(mat4)
  tatum_start[i,2] <- sd(mat4)
}
t2 <- Sys.time()
t2-t1

#finish all features extraction
all_feature <- cbind(mat_f_pitches,mat_f_timbre,bar_start,beat_start,section_start,tatum_start)
# all_feature2 <- na.omit(all_feature)
# dim(all_feature2)
# save(all_feature, file = "all_feature.RData")
# anyNA(all_feature)
# anyNA(mat_f_timbre)
# anyNA(mat_f_pitches)
# anyNA(bar_start)
# anyNA(beat_start)
# anyNA(tatum_start)
# which(is.na(tatum_start), arr.ind=TRUE)
# which(is.na(beat_start), arr.ind=TRUE)
# which(is.na(bar_start), arr.ind=TRUE)
# which(is.na(section_start), arr.ind=TRUE)


all_feature_round <- round(all_feature, digits = 6)
dim(mat_f_pitches)
feature.pca <- prcomp(all_feature_round,center = TRUE,scale. = TRUE)
plot(feature.pca, type = "l")
summary(feature.pca)
feature.x <- all_feature_round %*% feature.pca$rotation[,1:79]
dim(feature.x)
save(feature.x,file = "final_x.RData")
load("final_x.RData")
dim(feature.x)
##predict topic dist in each song using random Forest and svm

for (i in 1:17){
  fit <- randomForest(x = cv.train[,-c(1:17)], y = cv.train[,i], ntree=501, mtry=sqrt(ncol(all_feature2)))
  prediction <- predict(fit, newdata = feature.x)
  ifelse(i == 1, predict_tp <- prediction, predict_tp <- cbind(predict_tp,prediction))
}

##Ranking

dim(predict_tp)
predict_tp_t <- t(predict_tp)
load("mat_words.RData")
pred_topW = predictive.distribution(predict_tp_t,mat_words,0.1,0.1)
dim(pred_topW)
pred_top_word_mat <- t(pred_topW)
pred_top_word_mat_negative <- -pred_top_word_mat 
mat_rank <- matrix(NA, nrow = nrow(pred_top_word_mat), ncol = ncol(pred_top_word_mat))

for (i in 1:nrow(pred_top_word_mat)){
  mat_rank[i,] = rank(pred_top_word_mat_negative[i,])
}
dim(mat_rank)
write.csv(mat_rank,file = "mat_rank.csv")
max(mat_rank[100,])





