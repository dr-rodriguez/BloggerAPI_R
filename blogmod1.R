# Data modification from the Blogger API dataset
# This is now out-dated, use blogmod2.R

# Navigate to directory
setwd('/Users/strakul/Desktop/Coursera/bloggerapi/')

# Load the dat
alldata <- readRDS(file='blogdata.Rda')

# Adding Month-Year factor to the data set
alldata$monyear <- factor(format(alldata$published, '%B-%Y'))

# Number of characters per blog post
alldata$numchar <- nchar(alldata$content)

# Approximate number of words
library(stringi)
alldata$numwords <- stri_count(alldata$content,regex="\\S+")
# basically, these are delimited by spaces but HTML code would be counted as well

# Number of embedded images
alldata$numimgs <- stri_count_fixed(alldata$content, 'img')


# Top 5 longests posts by words
index <- order(alldata$numwords, decreasing=TRUE)
alldata <- alldata[index,]
head(alldata[,c(1,2,4:8)], n=5)
# Bottom 5 posts by words
tail(alldata[,c(1,2,4:8)], n=5)


# Top 5 posts with largest number of embedded images
index <- order(alldata$numimgs, decreasing=TRUE)
alldata <- alldata[index,]
head(alldata[,c(1,2,4:8)], n=5)


# Original order (decreasing by date)
index <- order(alldata$published, decreasing=TRUE)
alldata <- alldata[index,]
#head(alldata[,c(1,2,4:8)], n=5)

