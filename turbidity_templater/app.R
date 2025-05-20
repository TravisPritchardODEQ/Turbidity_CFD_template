library(bslib)
library(tidyverse)
library(markdown)


ui <- fluidPage(
  img(src = "logo.png"),
  tags$hr(style="border-color: black;"),
  titlePanel("DRAFT DO NOT USE YET!!!"),
  titlePanel("Oregon DEQ Turbidity Template Generator for AWQMS"),
  tags$hr(style="border-color: black;"),
  theme = bs_theme(),
  #theme = bs_theme(version = 5, bootswatch = "minty"),
  tabsetPanel(
    tabPanel("Import data", 
  ui_upload,
  ui_clean,
  ui_download
),
tabPanel("Instructions",
         includeMarkdown('R/Instructions.md'))  

))

server <- function(input, output, session) {

  # Upload ---------------------------------------------------------
  raw <- reactive({
    req(input$file)
   
    read_data(input$file$datapath, input$sheet)
    
  })
  output$preview1 <- renderTable(head(raw()))
  
  # Clean ----------------------------------------------------------
  tidied <- eventReactive(input$do, {
    out <- raw()
    
    if(input$cont){
      
      out <- summarize_data(out)
    }
    
    #Format the data into the template
    out <- format_data(out)
    
    #If continuous, add a comment
    if(input$cont){
      
      out <- add_comment(out)
    }
    
  
  out
  })
  output$preview2 <- renderTable(head(tidied()))
  

  
  # Download -------------------------------------------------------
  output$download <- downloadHandler(
    filename = function() {
      paste0(tools::file_path_sans_ext(input$file$name), "_AWQMS_Template.xlsx")
    },
    content = function(file) {
      openxlsx::write.xlsx(tidied(), file)
      #vroom::vroom_write(tidied(), file)
    }
  )
}
# Run the application 
shinyApp(ui = ui, server = server)
