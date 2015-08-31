# BloggerAPI_R
Some scripts for accessing the blogger API with R.
Also has some plots created from information in my blog.

# Initial Requirements
- You'll need access to the Google Developer Console. You need to create a project and set up the Blogger API (under APIs and auth)
- You then need proper credentials with OAuth2.0. On the Google Developer Console. This is created under the Credentials tab on the left (which is under APIs and auth). You'll want to create one for an 'Installed application - Other' so you can use this R code from your machine (http://localhost). 
- After that's set up, it's just a manner of putting the correct blog ID and your OAuth2.0 information to access your blog.

# File list
- bloggerapi.R : script to access the Blogger API with OAuth2.0 and grab all the posts in the specified blog. This is saved to a file (blogdata.Rda). A version of the script without my key/ID is supplied (anon_bloggerapi.R)
- blogmod2.R : script to read in the blogdata.Rda file and output some statistics
- blogmod1.R : outdated script that does the similar work as blogmod2.R. It still works, but I prefer using the dplyr package
- blogplot1.R : script to generate plots from the data
- wordcloud.R : script to generate the word cloud from the data

# Figures
- postfreq1.png : frequency of posts over time, original version
- postfreq2.png : frequency of posts over time. recent as of Aug 30, 2015
- postdays1.png : number of posts over weekday. recent as of Aug 30, 2015
- posttimes1.png : number of posts over time of day. recent as of Aug 30, 2015
- wordvstime1.png : word cloud of all content in posts. recent as of Aug 30, 2015