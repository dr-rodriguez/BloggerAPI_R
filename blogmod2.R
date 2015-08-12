# Data modification from the Blogger API dataset
# This one uses dplyr

# Navigate to directory
setwd('/Users/strakul/Desktop/Coursera/bloggerapi/')

# Load the dat
alldata <- readRDS(file='blogdata.Rda')

# Convert
library(dplyr)
newdata <- tbl_df(alldata) # might not be necessary?
rm('alldata')

# Adding Month-Year factor and approximate number of characters, words, and images
library(stringi)
newdata <-
    newdata %>%
    mutate(monyear = factor(format(published,'%Y-%b')),
           published = as.POSIXct(published), #POSIXlt does not work with dplyr
           numchar = nchar(content), #number of characters in post
           numwords = stri_count(content,regex='\\S+'), #number of words
           numimgs = stri_count_fixed(content,'img')) #number of images by tag 'img'


# Now for some results

# Top longests posts by words
print('Longests posts by number of words')
newdata %>%
    arrange(desc(numwords)) %>%
    select(title, numchar, numwords, numimgs) %>%
        print(n=5)

# Bottom posts
print('Shortests posts by number of words')
newdata %>%
    arrange(numwords) %>%
    select(title, numchar, numwords, numimgs) %>%
        print(n=5)

# Top posts with largest number of embedded images
print('Posts with largest number of images')
newdata %>%
    arrange(desc(numimgs)) %>%
    select(title, numchar, numwords, numimgs) %>%
        print(n=5)

# Number of counts by the Month-Year factor, also get the mean number of words
print('Frequency of posts by month and year')
newdata %>%
    group_by(monyear) %>%
    summarize(counts=n(), words=mean(numwords), images=mean(numimgs)) %>%
    ungroup %>%
    arrange(desc(counts)) %>%
        print
        

# Add boolean columns for posts denoting them as Astronomy, 
# Book, or Life in Chile related posts
newdata <- 
    newdata %>%
    mutate(books=sapply(labels, function(x) {any(x %in% 'Books')}),
           astronomy=sapply(labels, function(x) {any(x %in% 'Astronomy')}),
           chile=sapply(labels, function(x) {any(x %in% 'Life in Chile')}))


# Get some counts for that
print('Type of posts')
newdata %>%
    group_by(books, astronomy, chile) %>%
    summarize(count=n()) %>%
    ungroup %>%
    arrange(desc(count)) %>%
        print


# Filter to return the misc posts
print('Top 5 posts that are not related to astronomy, book, or chile')
newdata %>%
    filter(!books,!astronomy,!chile) %>%
    select(title, numchar:numimgs, labels) %>%
    arrange(desc(numwords)) %>%
        print(n=5)


# Filter and check the type of books I read and review
print('Book post breakdown')
newdata %>%
    filter(books) %>%
    mutate(scifi=sapply(labels, function(x) {any(x %in% 'Science Fiction')}),
           fantasy=sapply(labels, function(x) {any(x %in% 'Fantasy')}),
           #malazan=sapply(labels, function(x) {any(x %in% 'Malazan')}),
           #discworld=sapply(labels, function(x) {any(x %in% 'Discworld')}),
           #wot=sapply(labels, function(x) {any(x %in% 'Wheel of Time')}),
           bookclub=sapply(labels, function(x) {any(x %in% 'Book Club')})) %>%
    group_by(scifi, fantasy, bookclub) %>%
    summarize(count=n()) %>%
    ungroup %>%
    arrange(desc(count)) %>%
        print
               
    

# Open up the viewer to see part of the data (all rows, only select columns)
newdata %>%
    select(published, title, numchar:numimgs, labels) %>%
    View

