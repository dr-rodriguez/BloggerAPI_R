# BloggerAPI_R
Some scripts for accessing the blogger API with R.
Also has some plots created from information in my blog.

# Initial Requirements
- You'll need access to the Google Developer Console. You need to create a project and set up the Blogger API (under APIs and auth)
- You then need proper credentials with OAuth2.0. On the Google Developer Console. This is created under the Credentials tab on the left (which is under APIs and auth). You'll want to create one for an 'Installed application - Other' so you can use this R code from your machine. 
- After that's set up, it's just a manner of putting the correct blog ID and your oath2.0 information to access you blog.

# File list
- blogdata.Rda : example data from my blog
- bloggerapi.R : script to access the Blogger API with OAuth2.0 and grab all the posts in the specified blog. This is saved to a file (blogdata.Rda)
- blogmod2.R : script to read in the blogdata.Rda file and output some statistics