# Make some plots of the data

library(ggplot2)
library(scales)

# Use the newdata from blogmod2.R
#source('~/Desktop/Coursera/bloggerapi/blogmod2.R')

# Histogram of when I published the data
p <- ggplot(newdata, aes(published, ..count..)) + 
    geom_histogram() +
    theme_bw() + xlab(NULL) +
    scale_x_datetime(breaks = date_breaks("4 months"),
                     labels = date_format("%Y-%b"),
                     limits = c(as.POSIXct("2012-01-01"), 
                                as.POSIXct(Sys.Date())) )

p