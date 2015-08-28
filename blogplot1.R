# Make some plots of the data

library(ggplot2)
library(scales) # for date_time scales

# Use the newdata from blogmod2.R
#source('~/software/r/bloggerapi/blogmod2.R')

# ========================================================================
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

# ========================================================================
# Histogram of what time I publish my posts
newdata <-
    newdata %>%
    mutate(times=strftime(published, '%T %z')) %>% # first as a character
    mutate(times=as.POSIXct(times, format='%T %z')) # now as a POSIXct date object

# Make the plot
bin <- 3600 # seconds in an hour

p <- ggplot(newdata, aes(times, ..count..)) + 
    geom_histogram(fill='darkred', col='white', binwidth=bin) +
    labs(x='Time of Day (CLT)', y='Number of Posts') + 
    theme_bw() + 
    scale_x_datetime(breaks = date_breaks("1 hour"),
                     labels = date_format("%H:%M"),
                     limits = c(as.POSIXct("00:00:00 -0300", format='%T %z'),
                                as.POSIXct("23:59:59 -0300", format='%T %z') )) +
    theme(axis.text.x = element_text(angle=90))

print(p)
ggsave('posttimes1.png')

# ========================================================================
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

# ========================================================================
# Histogram of what weekday I publish my posts
newdata <-
    newdata %>%
    mutate(weekday=factor(weekdays(published))) # get the weekdays of my posts

summary1 <-
    newdata %>%
    group_by(weekday) %>%
    summarize(count=n())

# Manually setting the proper order and resetting the factors
lvls <- c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')
summary1 <-
    summary1 %>%
    mutate(weekday=as.character(weekday)) %>%
    mutate(weekday=factor(weekday, lvls))

# Make a bar plot
p <- ggplot(summary1, aes(weekday, count)) + 
    geom_bar(fill='darkgreen', col='white', stat="identity") +
    labs(x='Day of the Week', y='Number of Posts') + 
    theme_bw()

print(p)
ggsave('postdays1.png')