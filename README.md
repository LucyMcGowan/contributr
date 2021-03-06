Welcome to `contributr` a Shiny app for swiping through beginner GitHub issues!
================

-   [User guide](#user-guide)
-   [Guidelines for maintainters](#guidelines-for-maintainters)
-   [Guidelines for writing beginner issues](#guidelines-for-writing-beginner-issues)
-   [Starting guide to run locally](#starting-guide-to-run-locally)

<!-- README.md is generated from README.Rmd. Please edit that file -->
`contributr` is a Shiny app for finding beginner GitHub issues to contribute to. In this README we'll give guidelines for participants in the program, and for potential contributors to the app. Participants are beginners wanting to contribute to repositories, and maintainers of repositories wishing to open issues for and guide beginners.

User guide
----------

The app is hosted at [ropensci.shinyapps.io/contributr](https://ropensci.shinyapps.io/contributr/)

If anything is unclear or you notice issues please post [here](https://github.com/LucyMcGowan/contributr/issues/new).

*Some guidelines for new users:*

-   Don't start working on an issue before being assigned to it. Express your interest in the issue thread.
-   Be reliable, if you get assigned to an issue do it in a timely manner and respond to comments timely too.
-   It might be helpful to write your due dates so that the maintainer knows when to hear back from you.
-   Don't break the package, continuous integration builds should not fail for your Pull request.
-   Have fun!

Guidelines for maintainters
---------------------------

**If you are interested in becoming a maintainer with beginner issues, please fill out this [form](https://docs.google.com/forms/d/e/1FAIpQLSe7xckeQ8khdmlxYSWXEqogF654y9LkBZpbPtNEHOssiqjt2g/viewform?usp=sf_link).**

-   Please respect the guidelines for writing issues.
-   Be nice and patient.
-   When a volunteer say they are interested, assign them to the issue.
-   When the issue get solved, ask the volunteer to add themselves as ctb in DESCRIPTION.
-   Be clear about your availability. (e.g. if you usually answer messages within a few days or longer)
-   Have fun!

Guidelines for writing beginner issues
--------------------------------------

-   Create a Beginner label whose color should be \#6ABF49
-   If the issue is urgent, or you would do it yourself if no one does it for a few months, write it down.
-   Please write as much context as possible for a newcomer to understand what you mean.
-   If you have any other preferred channel of communication about the package than the issue thread itself (e.g. a Slack team), please write it down.
-   Optional template
    -   Issue title (try to use verbs?)
    -   Problem/motivation.
    -   Steps (e.g. write new use cases, then add them in a vignette).
    -   Dependencies/tools one should know to solve the issue (e.g. if your package includes Rcpp code or R6 classes).
    -   Contributor rules if there are some.

Starting guide to run locally
-----------------------------

### Packages

To run this locally, you will need the following packages that are not currently on CRAN:

-   <https://github.com/nstrayer/shinysense>
-   <https://github.com/MarkEdmondson1234/googleID>

<!-- -->

    devtools::install_github("nstrayer/shinysense")
    devtools::install_github("MarkEdmondson1234/googleID")

### Dropbox Token

You will also need a Dropbox token saved in the same folder as the app called `contributr-drop.rds`. To generate this token, run the following:

    library(rdrop2)
    token <- drop_auth()
    saveRDS(token, "contributr-drop.rds")

This will open a browser that will request access to your dropbox account. *Make sure to put `contributr-drop.rds` in your `.gitignore`*

### Google Credentials

You will need google credentials for the login button to work. Create a [Google API Project](https://console.developers.google.com/iam-admin/projects), then [Enable the API](https://console.developers.google.com/iam-admin/projects). Click `Credentials` & create credentials. I save mine in my `.Rprofile` like so:

    options("googleAuthR.webapp.client_id" = "MY_CLIENT_ID")
    options("googleAuthR.webapp.client_secret" = "MY_CLIENT_SECRET")

Again, *make sure to put `.Rprofile` in your `.gitignore`.*
