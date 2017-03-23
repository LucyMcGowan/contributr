library(shiny)
library(shinyswipr)
library(shinythemes)

navbarPage(theme = shinytheme("readable"),
  title = "contributr 🌻",
  tabPanel(
    "Profile",
    fluidPage(
      shinyjs::useShinyjs(),
      HTML(markdown::markdownToHTML(text = "")),
      h3("Welcome to Contributr"),
      em(
        "Have you never contributed to an R package? With this app you can - we'll help you find a package that needs your help! Enter your information below and click on the “Find Issues” tab to begin finding GitHub issues to contribute to. Then check our starting guide and then get started."
      ),
      hr(),
      p(textOutput("display_username")),
      p(googleAuthR::googleAuthUI("gauth_login")),
      em("Logging in here will ensure if you come back, we won't show you the same issues you've already seen."),
      hr(),
      p(
        "Consider entering your name & twitter handle so we can link you with other users"
      ),
      textInput("name", "Name"),
      textInput("twitter", "Twitter handle"),
      hr()
    )
  ),
  #end fluidpage,
  tabPanel("Find Issues",
           sidebarLayout(
             sidebarPanel(
               h3("Read the issue on the right & swipe according to the schema below"),
               hr(),
               HTML(
                 "<table style='line-height:1.5em;'>
                 <tr>
                 <td style='font-weight:normal;'><img src = 'images/swipe_right.png', style='height: 40px'></td>
                 <td style='font-weight:normal;'> interesting and doable
                 </td>
                 </tr>
                 <tr>
                 <td><img src = 'images/swipe_up.png', style='height: 40px'></td>
                 <td> interesting but too hard
                 </td>
                 </tr>
                 <tr>
                 <td><img src = 'images/swipe_down.png', style='height: 40px'></td>
                 <td> not interesting but doable
                 </td>
                 </tr>
                 <tr>
                 <td><img src = 'images/swipe_left.png', style='height: 40px'></td>
                 <td> not interesting and too hard
                 </td>
                 </tr>
                 </table>"
               ),
               hr(),
               h3("Download your issues:"),
               p(
                 'You can download all the issues that you\'ve deemed "interesting and doable" and dive into them! Happy contributing 👯'
               ),
               downloadButton("download_data", "Download")
               #h3("Tell someone about papr:"),
               # a(href = "https://twitter.com/intent/tweet?text=Check%20out%20papr%20its%20like%20Tinder%20for%20preprints%20https://jhubiostatistics.shinyapps.io/papr", icon("twitter")),
               #a(href = "https://www.facebook.com/sharer/sharer.php?u=https%3A//jhubiostatistics.shinyapps.io/papr", icon("facebook"))
               ),
             mainPanel(fluidPage(
               # Application title
               shinyswiprUI(
                 "my_swiper",
                 h3(textOutput("title")),
                 hr(),
                 uiOutput("body"),
                 hr(),
                 h4("start working on this issue now!"),
                 uiOutput("link")
               )
             ))
             )),
  tabPanel("Starting Guide",
           includeMarkdown("./starting_guide.md")),
  tabPanel("About",
           includeMarkdown("./about.md")))
  