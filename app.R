library(shiny)
library(rsconnect)

rsconnect::setAccountInfo(name='bahar1994',
                          token='585BCD8818F5D301E90AC7BFF7ECE402',
                          secret='d4WWZy7Fofkp3dN7CZEB/hoxDRHFRuO0lpmEAyRw')

get_zodiac <- function(month, day) {
  if ((month == 3  & day >= 21) || (month == 4  & day <= 19)) return("Aries")
  if ((month == 4  & day >= 20) || (month == 5  & day <= 20)) return("Taurus")
  if ((month == 5  & day >= 21) || (month == 6  & day <= 20)) return("Gemini")
  if ((month == 6  & day >= 21) || (month == 7  & day <= 22)) return("Cancer")
  if ((month == 7  & day >= 23) || (month == 8  & day <= 22)) return("Leo")
  if ((month == 8  & day >= 23) || (month == 9  & day <= 22)) return("Virgo")
  if ((month == 9  & day >= 23) || (month == 10 & day <= 22)) return("Libra")
  if ((month == 10 & day >= 23) || (month == 11 & day <= 21)) return("Scorpio")
  if ((month == 11 & day >= 22) || (month == 12 & day <= 21)) return("Sagittarius")
  if ((month == 12 & day >= 22) || (month == 1  & day <= 19)) return("Capricorn")
  if ((month == 1  & day >= 20) || (month == 2  & day <= 18)) return("Aquarius")
  if ((month == 2  & day >= 19) || (month == 3  & day <= 20)) return("Pisces")
  return(NA)
}

ui <- fluidPage(
  
  titlePanel("⭐ Horoscope Finder App ⭐"),
  
  sidebarLayout(
    
    sidebarPanel(
      textInput("name", "Enter your name:", value = "Bahar"),
      
      numericInput("day", "Enter your birth day:", value = 1, min = 1, max = 31),
      
      numericInput("month", "Enter your birth month (1–12):", value = 1, min = 1, max = 12),
      
      numericInput("year", "Enter your birth year:", value = 2000, min = 1900, max = 2025),
      
      selectInput("color", "Choose your favorite color:",
                  choices = c("Red", "Blue", "Green", "Purple", "Pink", "Orange")),
      
      br(),
      actionButton("go", "Show My Horoscope", class = "btn-primary")
    ),
    
    mainPanel(
      h3("Your Horoscope Results:"),
      textOutput("summaryText"),
      br(),
      uiOutput("horoscopeColored"),
      br(),
      uiOutput("colorBox")
    )
  )
)

server <- function(input, output) {
  
  observeEvent(input$go, {
    
    output$summaryText <- renderText({
      paste("Hello", input$name, "!",
            "You were born on", paste(input$day, input$month, input$year, sep = "/"),
            "and your favorite color is", input$color, ".")
    })
    
    output$horoscopeColored <- renderUI({
      sign <- get_zodiac(input$month, input$day)
      if (is.na(sign)) return(NULL)
      HTML(paste0("<h2 style='color:", tolower(input$color),
                  "; font-weight:bold;'>Your zodiac sign is: ", sign, "</h2>"))
    })
    
    output$colorBox <- renderUI({
      div(style = paste("width:100px; height:50px; background-color:",
                        tolower(input$color), "; border-radius:10px;"))
    })
  })
}

shinyApp(ui = ui, server = server)
