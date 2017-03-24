library(shiny)
library(shinyswipr)
library(googleAuthR)
library(googleID)
library(gh)
library(dplyr)
library(purrr)
library(rdrop2)
library(readr)


          
repos <- c("scrubr","taxize","rdpla","lawn","rnoaa","nneo")
my_get <- function(repo) {
  tryCatch({
  gh("/repos/:owner/:repo/:filter",
             owner = "ropensci", 
             repo  = repo,
             filter = "issues?labels=Beginner&state=open",
             type  = "public") %>%
    map_df(`[`, c("id", "title", "html_url", "body"))
  },
  #if there are no beginner labels, output an empty data_frame
  error=function(e){data_frame(title = character(), html_url = character(), body = character())})
}

df <- map_df(repos, my_get)


shinyServer(function(input, output) {
  token <- readRDS("./contributr-drop.rds")
  session_id <- as.numeric(Sys.time())
  
  #set initial issue
  issue <- df[sample(nrow(df),1),]
  output$title <- renderText({issue$title})
  output$body <- renderUI({
    HTML(markdown::markdownToHTML(text = issue$body))
  })
  output$link <- renderUI({
    HTML(markdown::markdownToHTML(text = paste0("<a href = '", issue$html_url, "' target='_blank'> start working on this issue now! </a>")))
  })
  
  rv <- reactiveValues(
    login = FALSE,
    person_id = 12345,
    issue = issue,
    user_dat = data_frame(
      id = numeric(),
      title = character(),
      link = character(),
      result = character(),
      person = character()
    )
  )

  options(
    googleAuthR.scopes.selected = c(
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/userinfo.profile"
    )
  )
  
  #Create temp csv that we use to track session
  file_path <-
    file.path(tempdir(), paste0(round(session_id), ".csv"))
  write_csv(isolate(rv$user_dat), file_path)
  
  ## Authentication
  accessToken <- callModule(googleAuth,
                            "gauth_login",
                            login_class = "btn btn-primary",
                            logout_class = "btn btn-primary")
  #Goes into google's oauth and pulls down identity
  userDetails <- reactive({
    validate(need(accessToken(), "not logged in"))
    rv$login <- TRUE #Record the user as logged in
    details <-
      with_shiny(get_user_info, shiny_access_token = accessToken())  #grab the user info
   rv$person_id <-
      digest::digest(details$id) #assign the user id to our reactive variable
    if(isolate(rv$person_id) != 12345 & drop_exists(paste0("shiny/2016/papr/user_dat/user_dat_",isolate(rv$person_id),".csv"), dtoken = token)){
    }
    details #return user information
  })
  
  #let user download data
  output$download_data <- downloadHandler(
    filename = "my_issues.csv",
    content = function(file) {
      udat = rv$user_dat %>%
        filter(result == "right") %>%
        select(- id, - result, - person)
      write.csv(udat, file)
    }
  )
  
  observe({
    if (rv$login) {
      shinyjs::onclick("gauth_login-googleAuthUi",
                       shinyjs::runjs(paste0("window.location.href =", site, ";")))
    }
  })
  
  # Start datastore and display user's Google display name after successful login
  output$display_username <- renderText({
    validate(need(userDetails(), "getting user details"), message = "")
    paste("Welcome,", userDetails()$displayName) #return name after validation
  })
  
  card_swipe <- callModule(shinyswipr, "my_swiper")
  
  observeEvent( card_swipe(),{
    print(card_swipe()) #show last swipe result. 
    
    rv$user_dat <- rbind(
      data_frame(
      id      = rv$issue$id,
      title   = rv$issue$title,
      link    = rv$issue$html_url,
      result  = card_swipe(),
      person  = isolate(rv$person_id)
      ),
      rv$user_dat
    )
    if(sum(!(df$id %in% rv$user_dat$id)) > 1){
    ind <- sample(df$id[-which(df$id %in% rv$user_dat$id)],1)
    rv$issue <- df[df$id == ind,]
    print(sum(!(df$id %in% rv$user_dat$id)) > 1)
    #output issues to cards
    output$title <- renderText({rv$issue$title})
    output$body <- renderUI({
      HTML(markdown::markdownToHTML(text = rv$issue$body))
           })
    output$link <- renderUI({
      HTML(markdown::markdownToHTML(text = paste0("<a href = '", rv$issue$html_url, "' target='_blank'> start working on this issue now! </a>")))
    })
    
    write_csv(isolate(rv$user_dat), file_path) #write the csv
    drop_upload(file_path, "shiny/2017/contributr/", dtoken = token) #upload to dropbox too.
    
    file_path2 <-
      file.path(tempdir(), paste0("user_dat_",isolate(rv$person_id), ".csv"))
    write_csv(data.frame(name = isolate(input$name), twitter = isolate(input$twitter)), file_path2)
    drop_upload(file_path2,"shiny/2017/contributr/user_dat/", dtoken = token)
    
    #output$resultsTable <- renderTable({rv$user_dat})
    } else {
      output$title <- renderText({"There are no more issues with this tag - download your list & start working!"})
      output$body <- renderText({""})
      output$link <- renderText({""})
    }
    }) 
  
})
