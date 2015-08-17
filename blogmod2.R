# Data modification from the Blogger API dataset
# This one uses dplyr

# Navigate to directory
setwd('~/software/r/bloggerapi/')

# Load the dat
alldata <- readRDS(file='blogdata.Rda')

# Convert
library(dplyr)
newdata <- tbl_df(alldata) 
rm('alldata')

# Adding Month-Year factor and approximate number of images
library(stringi)
newdata <-
    newdata %>%
    mutate(title = as.character(title), 
           slabels = sapply(labels, toString), # collabse the labels list to a string
           monyear = factor(format(published,'%Y-%b')),
           published = as.POSIXct(published), #POSIXlt does not work with dplyr
           numimgs = stri_count_fixed(as.character(content),'img')) #by tag 'img'

# Parse the content to remove the HTML coding. Then count characters and words
# Can use metacharacter and regular expressions to eliminate things
# gsub('<(.*?)>', '', x) will eliminate all html between < and > in chunks 
# throughout the text (so wont eliminate the real text)
my_replace <- function(x) {
    x <- gsub('<(.*?)>', '', x) # removing HTML code encapsulated within <>
    x <- gsub('\n',' ',x) # removing newline characters
    x <- gsub('&nbsp;',' ',x) # removing some extra HTML code
    x <- gsub('\"','',x) # removing explicit quotation marks
    x
}
newdata <- 
    newdata %>%
    mutate(content=sapply(content,my_replace), #this can take some time
           numchar = nchar(content), #number of characters in post
           numwords = stri_count(as.character(content),regex='\\S+')) #number of words

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
    summarize(counts=n(), mean_words=mean(numwords), mean_images=mean(numimgs)) %>%
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
print('Top 5 longest posts that are not related to astronomy, book, or chile')
newdata %>%
    filter(!books,!astronomy,!chile) %>%
    select(title, slabels, numwords:numimgs) %>%
    arrange(desc(numwords)) %>%
    print(n=5)


# Filter and check the type of books I read and review
print('Book post breakdown')
newdata %>%
    filter(books) %>%
    mutate(scifi=sapply(labels, function(x) {any(x %in% 'Science Fiction')}),
           fantasy=sapply(labels, function(x) {any(x %in% 'Fantasy')}),
           bookclub=sapply(labels, function(x) {any(x %in% 'Book Club')})) %>%
    group_by(scifi, fantasy, bookclub) %>%
    summarize(count=n()) %>%
    ungroup %>%
    arrange(desc(count)) %>%
        print

# Compact summary of the book types               
newdata %>%
    filter(books) %>%
    mutate(scifi=sapply(labels, function(x) {any(x %in% 'Science Fiction')}),
           fantasy=sapply(labels, function(x) {any(x %in% 'Fantasy')}),
           bookclub=sapply(labels, function(x) {any(x %in% 'Book Club')})) %>%
    group_by(scifi, fantasy, bookclub) %>%
    summarize(count=n()) %>%
    ungroup %>%
    mutate(allscifi=sum(scifi*count),
           allfantasy=sum(fantasy*count),
           allbookclub=sum(bookclub*count)) %>%
    select(allscifi:allbookclub) %>%
    unique %>%
        print

# Save all the text content of the blog posts to a separate file, for use elsewhere
cat(newdata$content, file='text_dump.txt')

# Open up the viewer to see part of the data (all rows, only select columns)
newdata %>%
    select(published, title, numchar:numimgs, labels) %>%
    View
