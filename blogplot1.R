# Make some plots of the data

library(ggplot2)
library(scales)

# Use the newdata from blogmod2.R
#source('~/software/r/bloggerapi/blogmod2.R')

# Histogram of when I published the data
p <- ggplot(newdata, aes(published, ..count..)) + 
    geom_histogram(fill='blue', col='black') +
    labs(x=NULL, y='Number of Posts') + 
    scale_x_datetime(breaks = date_breaks("4 months"),
                     labels = date_format("%Y-%b"),
                     limits = c(as.POSIXct("2012-01-01"), 
                                as.POSIXct(Sys.Date())) )

#png('postfreq1.png', width=600)
print(p)
ggsave('postfreq1.png') # streches the image more nicely
#dev.off()

# Number of words through time
#quantile(newdata$numimgs, probs=seq(0, 1, 0.25))
quantile(newdata$numimgs, probs=c(0,0.5,0.75,0.9,0.95,0.99,1))
# 75%-ile is 4 images
lvls <- c(0,2,6,10,21)
cutlvls <- cut(newdata$numimgs, lvls, include.lowest = T)
p <- ggplot(newdata, aes(published, numwords, col=cutlvls)) +
    geom_point(size=4) +
    coord_cartesian() + 
    labs(x='Date Published', y='Number of Words') + 
    scale_color_discrete(name='Number of Images', labels=c('0-2','3-6','7-10','11-21'))

print(p)
ggsave('wordvstime1.png')
