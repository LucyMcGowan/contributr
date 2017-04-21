## Welcome to `contributr` a Shiny app for swiping through beginner GitHub issues!

## User guide

The app is hosted at [ropensci.shinyapps.io/contributr](https://ropensci.shinyapps.io/contributr/)

## Starting guide to run locally

### Packages
To run this locally, you will need the following packages that are not currently on CRAN:

* https://github.com/nstrayer/shinyswipr
* https://github.com/MarkEdmondson1234/googleID

```
devtools::install_github("nstrayer/shinyswipr")
devtools::install_github("MarkEdmondson1234/googleID")
```

### Dropbox Token
You will also need a Dropbox token saved in the same folder as the app called `contributr-drop.rds`. To generate this token, run the following:
```
library(rdrop2)
token <- drop_auth()
saveRDS(token, "contributr-drop.rds")
```
This will open a browser that will request access to your dropbox account. *Make sure to put `contributr-drop.rds` in your `.gitignore`*

### Google Credentials
You will need google credentials for the login button to work. Create a [Google API Project](https://console.developers.google.com/iam-admin/projects), then [Enable the API](https://console.developers.google.com/iam-admin/projects). Click `Credentials` & create credentials. I save mine in my `.Rprofile` like so:
```
options("googleAuthR.webapp.client_id" = "MY_CLIENT_ID")
options("googleAuthR.webapp.client_secret" = "MY_CLIENT_SECRET")
```
Again, *make sure to put `.Rprofile` in your `.gitignore`.*