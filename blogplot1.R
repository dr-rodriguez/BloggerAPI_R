# Make some plots of the data

library(ggplot2)
library(scales)

# Use the newdata from blogmod2.R
#source('~/software/r/bloggerapi/blogmod2.R')

# Histogram of when I published the data
# Setting the binwidth to be 30 days in seconds
bin <- 30*24*3600 

p <- ggplot(newdata, aes(published, ..count..)) + 
    geom_histogram(fill='blue', col='white', binwidth=bin) +
    labs(x=NULL, y='Number of Posts') + 
    theme_bw() + 
    scale_x_datetime(breaks = "30 days",
                     labels = date_format("%Y-%b"),
                     limits = c(as.POSIXct("2012-03-01"),
                                as.POSIXct(Sys.Date())) ) +
    theme(axis.text.x = element_text(angle=90))
    
#png('postfreq2.png', width=600)
print(p)
ggsave('postfreq2.png') # streches the image more nicely
#dev.off()

# Number of words through time
#quantile(newdata$numimgs, probs=seq(0, 1, 0.25))
quantile(newdata$numimgs, probs=c(0,0.5,0.75,0.9,0.95,0.99,1)) # 75%-ile is 4 images
lvls <- c(0,1,3,6,17)
cutlvls <- cut(newdata$numimgs, lvls, include.lowest = T)
p <- ggplot(newdata, aes(published, numwords, col=cutlvls)) +
    geom_point(size=4) +
    coord_cartesian() + 
    labs(x='Date Published', y='Number of Words') + 
    scale_color_discrete(name='Number of Images', labels=c('0-1','2-3','4-6','7-17'))

print(p)
ggsave('wordvstime1.png')
