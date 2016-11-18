# Project: Words 4 Music

### [Project Description](doc/Project4_desc.md)

![image](http://cdn.newsapi.com.au/image/v1/f7131c018870330120dbe4b73bb7695c?width=650)*

Term: Fall 2016

+ [Data link](https://courseworks2.columbia.edu/courses/11849/files/folder/Project_Files?preview=763391)-(**courseworks login required**)
+ [Data description](doc/readme.html)
+ Contributor's name:Shujin Cao UNI:SC3977
+ Projec title: WORDS RANKING COMPETITION IN THE MUSIC WORLD
+ Project summary: 
  * A dictionary of 5000 words and the h5-analysis features of the 100 unknown songs are given, and the target is to find the rank of frequency of each word appearing in each song. 
  * Topic modeling is used here to develop the relationship between words and songs by associating them with 17 different topics. Please refer to the [R file](lib/Topics.R). 
  Three models including Random Forest, Multinomial Log-Linear Models based on Feed-Forward nueral network and SVM are tried to predict the distribution of topics for each song based on the song features as the predictors. And the final prediction model is SVM. Please refer to the R files [RandomForest and SVM](lib/randomForest.R).
  The final ranking is calculated by the following function: Pr(Words|Topics)*Pr(Topics|Documents).
  
     MAIN PROCESS
  ** PLEASE REVIEW THE R FILES FOR TRAINING PROCESS IN THE FOLLOWING ORDER ** 
     [FEATURE PREPARATION - features.R](lib/features.R) -> [TOPIC MODELING - Topics.R](lib/Topics.R) -> [randomForest+SVM.R](random.Forest+SVM.R) -> [Ranking - prediction.R](prediction.R) 
     - For the testing process please see [test.R](lib/test.R) and here are all generated [RData files](data)
     * I. FEATURE PREPARATION
     The features chosen in the model are sd and median values of bars_start, beats_start, sections_start and tatums_start. Besides, a codebook is generated using KMEANS method for both segments_pitches(12 dimentions) and segments_timbre(12 dimentions). Notice here the codebook might not be necessary for this test, but in my case, it works well.
     PCA is used for dimention reduction from 2350*1008 matrix to 2350*79 finally for all x_features, the predictors in the multi regression model.
     * II. TOPIC MODELING
     There are two packages that can used in R for topic modeling, for this test "topicmodels" is more recommended since it gives the straightforward percentage and the lyr trainig data file can be used directly in the format LDA(lyr). However, when using the "lda" package, the documents are restricted in a two row list, which is not easy to work out unless we can get access to the original texts.
     The parameters are set as: 
     K <- 14;G <- 1000; alpha <- 0.1; eta <- 0.1, I read some papers and thought they should be reasonable to use in this case.
     One more thing to mention is about the function predictive.distribution() in the "lda" package, I used it to obtain the distribution of words for each song by input the distribution of topics for each song and the words distribution for each topic.
     * III. RANDOM FOREST
     This method is used to predit the topic distribution for each song based on the song features. I chose this by its lowest mean sqaure error rate obtained by using a 100 size testing set and 2239 size training set.
     
Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.
     
```
proj/
├── lib/
   -features.R
    -randomForest.R
    -nnet.R
    -Topics.R
├── data/
├── doc/
├── figs/
└── output/
```


