## Welcome to `contributr` a Shiny app for swiping through beginner GitHub issues!

## Starting guide to run locally

To run this locally, you will need the following packages that are not currently on CRAN:

* https://github.com/nstrayer/shinyswipr
* https://github.com/MarkEdmondson1234/googleID

```
devtools::install_github("nstrayer/shinyswipr")
devtools::install_github("MarkEdmondson1234/googleID")
```

You will also need a Dropbox token saved in the same folder as the app called `contributr-drop.rds`. To generate this token, run the following:
```
library(rdrop2)
token <- drop_auth()
saveRDS(token, "contributr-drop.rds")
```
This will open a browser that will request access to your dropbox account.
