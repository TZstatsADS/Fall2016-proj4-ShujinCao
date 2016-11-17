setwd("C:\\Users\\Asus\\Documents\\DataScience\\Project4\\Project4_data")
install.packages("rhdf5")
library(rhdf5)

paths = Sys.glob("*\\*\\*\\*\\*\\*.h5")
songf = lapply(paths, function(x){h5read(x,"/analysis")})

##extract segments_pitches features
t1 <- Sys.time()
mat_total = matrix(NA, ncol = 1, nrow = 12)
for (i in 1:length(songf)){
  mat = songf[[i]]$segments_pitches
  mat_total = cbind(mat_total, mat)
}
t2 <- Sys.time()
t2-t1

mat_t = mat_total[,-1]
matT_pitches = t(mat_t)
save(matT_pitches,file = "matT_pitches.RData")

t1 <- Sys.time()
kmean_pitches = kmeans(matT_pitches,500)
t2 <- Sys.time()
t2-t1
idx= kmean_pitches$cluster
save(idx,file = "idx.RData")

t1 <- Sys.time()
mat_f_pitches = matrix(NA,ncol = 500, nrow =length(songf))

# N = 0
# n = 0
# for (i in 1:length(songf)){
#   N = N+n
#   n = dim(songf[[i]]$segments_pitches)[2]
#   for (k in 1:500){
#     mat_f_pitches[i,k] = sum(idx[N+1:N+n] == k)/n
#   }}
# t2 <- Sys.time()
# t2-t1

N = 0
n = 0
id <- matrix(NA, nrow = length(idx), ncol = 1)
for (i in 1:length(songf)){
  N = N+n
  n = dim(songf[[i]]$segments_pitches)[2]
  id[N+1:N+n] <- rep(i,n)
}

t1 <- Sys.time()
cluster_i = 0
for (i in 1:length(songf)){
  n <- dim(songf[[i]]$segments_pitches)[2]
  for (k in 1:500){
    for (t in N+1:N+n){
      if (idx[t] == k){
        cluster_i <- cluster_i+1
      }
    }
    mat_f_pitches[i,k] <- cluster_i/n
  }
}
t2 <- Sys.time() 
t2-t1 
save(mat_f_pitches,file = "mat_f_pitches.RData")
load("mat_f_pitches.RData")


##extract segments_timbre features
t1 <- Sys.time()
mat_total = matrix(NA, ncol = 1, nrow = 12)
for (i in 1:length(songf)){
  mat = songf[[i]]$segments_timbre
  mat_total = cbind(mat_total, mat)
}
t2 <- Sys.time()
t2-t1

mat_t = mat_total[,-1]
matT_timbre = t(mat_t)
save(matT_timbre,file = "matT_timbre.RData")

t1 <- Sys.time()
kmean_timbre = kmeans(matT_timbre,500)
t2 <- Sys.time()
t2-t1
idx_timbre= kmean_timbre$cluster
save(idx_timbre,file = "idx_timbre.RData")

t1 <- Sys.time()
mat_f_timbre = matrix(NA,ncol = 500, nrow =length(songf))

N = 0
n = 0
for (i in 1:length(songf)){
  N = N+n
  n = dim(songf[[i]]$segments_timbre)[2]
  for (k in 1:500){
    mat_f_timbre[i,k] = sum(idx_timbre[N+1:N+n] == k)/n
  }}
t2 <- Sys.time()
t2-t1

N = 0
n = 0
id <- matrix(NA, nrow = length(idx_timbre), ncol = 1)
for (i in 1:length(songf)){
  N = N+n
  n = dim(songf[[i]]$segments_timbre)[2]
  id[N+1:N+n] <- rep(i,n)
}

t1 <- Sys.time()
cluster_i = 0
for (i in 1:length(songf)){
  n <- dim(songf[[i]]$segments_timbre)[2]
  for (k in 1:500){
    for (t in N+1:N+n){
      if (idx_timbre[t] == k){
        cluster_i <- cluster_i+1
      }
    }
    mat_f_timbre[i,k] <- cluster_i/n
  }
}
t2 <- Sys.time() 
t2-t1 

