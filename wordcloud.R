# Load up the text_dump.txt file and process it to create a word cloud in R

# Based on instructions from: https://georeferenced.wordpress.com/2013/01/15/rwordcloud/
# See also: http://onertipaday.blogspot.cl/2011/07/word-cloud-in-r.html

library(tm)
library(wordcloud)

# Load up the data
setwd('~/software/r/bloggerapi/')
textdata <- Corpus(VectorSource(newdata$content))

# Tidying up the text data
textdata <- tm_map(textdata, stripWhitespace)
textdata <- tm_map(textdata, content_transformer(tolower))
#textdata <- tm_map(textdata, tolower) # this caused errors
textdata <- tm_map(textdata, removeWords, stopwords("english"))
textdata <- tm_map(textdata, removePunctuation)

# Make the word cloud!
png('wordcloud_1.png', width=600, height=600)
wordcloud(textdata, scale=c(6,0.2), max.words=200, random.order=F, 
          rot.per=0.1, use.r.layout=F, colors=brewer.pal(8, "Dark2"))
dev.off()
