setwd("C:\\Users\\Asus\\Documents\\DataScience\\Project4\\Project4_data")
library(rhdf5)
library(pcaPP)


paths = Sys.glob("data\\data\\*\\*\\*\\*.h5")
H5close()
songf = lapply(paths, function(x){h5read(x,"/analysis")})

##extract segments_pitches features
lengthe <- vector()
for (i in 1:length(songf)){
  lengthe[i] <- dim(songf[[i]]$segments_pitches)[2]}
for(i in 1:length(songf)){
  mat = songf[[i]]$segments_pitches
  n = dim(mat)[2]
  ifelse(n<100,print(i),n = n)
}
songf <- songf[-c(715,950,1375,1407,1417,2284)]

t1 <- Sys.time()
in_length <- matrix(NA,ncol = 1, nrow = length(songf))
mat_total = matrix(NA, ncol = 1, nrow = 12)
for (i in 1:length(songf)){
  mat = songf[[i]]$segments_pitches
  n = dim(mat)[2]
  take_in = seq(1,n,by = round(n/100))
  in_length[i] = length(take_in)
  mat = mat[,take_in]
  mat_total = cbind(mat_total, mat)
}
t2 <- Sys.time()
t2-t1

mat_t = mat_total[,-1]
matT_pitches = t(mat_t)
save(matT_pitches,file = "matT_pitches.RData")
dim(matT_pitches)
t1 <- Sys.time()
kmean_pitches = kmeans(matT_pitches,500, iter.max = 20)
t2 <- Sys.time()
t2-t1
idx= kmean_pitches$cluster
save(idx,file = "idx.RData")
length(idx)


t1 <- Sys.time()
mat_f_pitches = matrix(NA,ncol = 500, nrow =length(songf))
N = 0
M = 0
  for (i in 1:length(songf)){
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
anyNA(mat_f_pitches)

##extract segments_timbre features
t1 <- Sys.time()
mat_total = matrix(NA, ncol = 1, nrow = 12)
for (i in 1:length(songf)){
  mat = songf[[i]]$segments_timbre
  n = dim(mat)[2]
  take_in = seq(1,n,by = round(n/100))
  mat = mat[,take_in]
  mat_total = cbind(mat_total, mat)
}
t2 <- Sys.time()
t2-t1

mat_t = mat_total[,-1]
matT_timbre = t(mat_t)
save(matT_timbre,file = "matT_timbre.RData")

t1 <- Sys.time()
kmean_timbre = kmeans(matT_timbre,algorithm="Lloyd",500,iter.max = 500)
t2 <- Sys.time()
t2-t1
idx= kmean_timbre$cluster


t1 <- Sys.time()
mat_f_timbre = matrix(NA,ncol = 500, nrow =length(songf))
N = 0
M = 0
for (i in 1:length(songf)){
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

#Extract other features
t1 <- Sys.time()
bar_start <- matrix(NA, ncol = 2, nrow = length(songf))
beat_start<- matrix(NA, ncol = 2, nrow = length(songf))
section_start <- matrix(NA, ncol = 2, nrow = length(songf))
tatum_start <- matrix(NA, ncol = 2, nrow = length(songf))
for (i in 1:length(songf)){
  mat1 <- songf[[i]]$bars_start
  mat2 <- songf[[i]]$beats_start
  mat3 <- songf[[i]]$sections_start
  mat4 <- songf[[i]]$tatums_start
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
all_feature2 <- na.omit(all_feature)
dim(all_feature2)
save(all_feature, file = "all_feature.RData")
anyNA(all_feature)
anyNA(mat_f_timbre)
anyNA(mat_f_pitches)
anyNA(bar_start)
anyNA(beat_start)
anyNA(tatum_start)
which(is.na(tatum_start), arr.ind=TRUE)
which(is.na(beat_start), arr.ind=TRUE)
which(is.na(bar_start), arr.ind=TRUE)
which(is.na(section_start), arr.ind=TRUE)


load("mat_f_timbre.RData")
load("mat_f_pitches.RData")
load("all_feature.RData")
save(all_feature, file = "all_feature.RData")
all_feature_round <- round(all_feature2, digits = 6)
feature.pca <- prcomp(all_feature_round,center = TRUE,scale. = TRUE)
plot(feature.pca, type = "l")
a <- summary(feature.pca)
head(a,5)
a
feature.x <- feature.pca$x
dim(feature.x)

feature.x <- all_feature_round %*% feature.pca$rotation[,1:79]



