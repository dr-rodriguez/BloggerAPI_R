# Load up necessary packages
library(httr) # to get the data from the API
library(jsonlite)
library(httpuv) # to authenticate
library(plyr) # to merge flattened JSON data

# Start up the OAuth process
oauth_endpoints("google")

# Supplying my credentials
myapp <- oauth_app("google",
                   key = "<YOUR-CLIENT-ID>",
                   secret = "<YOUR-CLIENT-SECRET>")

# Scope set to access blogger in read-only mode
google_token <- oauth2.0_token(oauth_endpoints("google"), myapp, 
                               scope = 'https://www.googleapis.com/auth/blogger.readonly')

# Access the Blogger API
blogid <- '<YOUR-BLOG-ID>'
baseurl <- 'https://www.googleapis.com/blogger/v3/blogs/'

url <- paste(baseurl,blogid,sep='') # basic info first

# Grab the data
home <- GET(url, config(token = google_token))
json1 <- content(home)
json1 <- jsonlite::fromJSON(toJSON(json1))

# Grab number of posts
totalposts <- json1$posts$totalItems

# Now to grab the actual blog posts
# Specifying extra flags to use
maxres <- '?maxResults=20' # maximum number of results is 20, have to use nextpage for more
fields <- '&fields=nextPageToken,items(title,content,labels,published)' # only grab some info
url0 <- paste(baseurl,blogid,'/posts',maxres,fields,sep='')

home <- GET(url0, config(token = google_token))
json1 <- content(home)
json2 <- jsonlite::fromJSON(toJSON(json1), flatten = T)

# For subsequent calls (more posts)
ptoken <- json2$nextPageToken
num <- ceiling((totalposts - 20)/20) # how many times to loop

# Lists to store items
pages <- list() 

# Store first element
pages[[1]] <- json2$items

# Set token and url
pagetoken <- paste('&pageToken=',ptoken,sep='')
url <- paste(url0,pagetoken,sep='')

# Loop through them
for(i in 1:num) {
    home <- GET(url, config(token = google_token))
    json1 <- content(home)
    json2 <- jsonlite::fromJSON(toJSON(json1), flatten = T)
    
    pages[[i+1]] <- json2$items
    
    # set new token and url
    ptoken <- json2$nextPageToken
    pagetoken <- paste('&pageToken=',ptoken,sep='')
    url <- paste(url0,pagetoken,sep='')
    
}

# Merge the data together
alldata <- rbind.fill(pages)

# Transform the published column to a date POSIXlt format
alldata <- transform(alldata, published=strptime(published, '%Y-%m-%dT%H:%M:%S'))

# Save the file to an .Rda so I don't have to re-run the API
# Can reload with varname <- readRDS(file='blogdata.Rda')
saveRDS(alldata, file='blogdata.Rda')
