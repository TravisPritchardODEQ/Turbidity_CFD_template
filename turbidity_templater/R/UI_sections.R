


ui_upload <- sidebarLayout(
  sidebarPanel(
    textInput("sheet", "Data Sheet", value = "Results"),
    fileInput("file", "Data", buttonLabel = "Upload..."),
  ),
  mainPanel(
    h3("Data Preview"),
    tableOutput("preview1")
  )
)


ui_clean <- sidebarLayout(
  sidebarPanel(
    checkboxInput("cont", "Continuous data"),
    actionButton("do",  "Format Data")
  ),
  mainPanel(
    h3("Template Preview"),
    tableOutput("preview2"),
    h3("Data Screen"),
    tableOutput("preview3")
  )
)



ui_download <- fluidRow(
  style = "margin-top: 20px;",
  column(width = 12, downloadButton("download", class = "btn-block"))
)




