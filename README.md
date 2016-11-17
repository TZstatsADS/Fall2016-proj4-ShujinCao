# Project: Words 4 Music

### [Project Description](doc/Project4_desc.md)

![image](http://cdn.newsapi.com.au/image/v1/f7131c018870330120dbe4b73bb7695c?width=650)

Term: Fall 2016

+ [Data link](https://courseworks2.columbia.edu/courses/11849/files/folder/Project_Files?preview=763391)-(**courseworks login required**)
+ [Data description](doc/readme.html)
+ Contributor's name:Shujin Cao UNI:SC3977
+ Projec title: WORDS RANKING COMPETITION IN THE MUSIC WORLD
+ Project summary: A dictionary of 5000 words and the h5-analysis features of the 100 unknown songs are given, and the target is to find the rank of frequency of each word appearing in each song. 
  Topic modeling is used here to develop the relationship between words and songs by associating them with 17 different topics. Please refer to the R file(lib/Topics.R). 
  Random Forest and Multinomial Log-Linear Models are tried to predict the distribution of topics for each song based on the song features as the predictors.Please refer to the R files(lib/randomForest.R)(lib/nnet.R).
  The final ranking is 
	
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


