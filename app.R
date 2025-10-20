# Install if needed
# install.packages("palmerpenguins")
library(shiny)
library(palmerpenguins)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
  titlePanel("Penguin Measurements Scatterplot"),
  
  sidebarLayout(
    sidebarPanel(
      # Species selector
      selectInput("species", "Select Species:",
                  choices = c("All", as.character(unique(penguins$species))),
                  selected = "All"),
      
      # Sex selector
      selectInput("sex", "Select Sex:",
                  choices = c("All", as.character(unique(na.omit(penguins$sex)))),
                  selected = "All"),
      
      # X-axis selector
      selectInput("xvar", "X-axis:",
                  choices = c("bill_length_mm", "bill_depth_mm", 
                              "flipper_length_mm", "body_mass_g"),
                  selected = "bill_length_mm"),
      
      # Y-axis selector
      selectInput("yvar", "Y-axis:",
                  choices = c("bill_length_mm", "bill_depth_mm", 
                              "flipper_length_mm", "body_mass_g"),
                  selected = "bill_depth_mm")
    ),
    
    mainPanel(
      plotOutput("scatterPlot")
    )
  )
)

server <- function(input, output) {
  
  # Reactive filtered dataset
  filtered_data <- reactive({
    data <- penguins
    data$species <- as.character(data$species)
    data$sex <- as.character(data$sex)
    
    if(input$species != "All"){
      data <- data[data$species == input$species, ]
    }
    if(input$sex != "All"){
      data <- data[data$sex == input$sex, ]
    }
    
    data
  })
  
  # Render scatterplot
  output$scatterPlot <- renderPlot({
    data <- filtered_data()
    
    if(nrow(data) == 0){
      # Display message if no data
      plot.new()
      text(0.5, 0.5, "No data for this combination of species and sex", cex = 1.5)
    } else {
      ggplot(data, aes_string(x = input$xvar, y = input$yvar, color = "species")) +
        geom_point(size = 3, alpha = 0.7) +
        labs(x = input$xvar, y = input$yvar, color = "Species") +
        theme_minimal()
    }
  })
}

shinyApp(ui = ui, server = server)
