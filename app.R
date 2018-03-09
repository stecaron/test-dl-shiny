

# Load packages -----------------------------------------------------------

library(shiny)
library(keras)
library(reticulate)
library(jpeg)
library(raster)


# Define user interface ---------------------------------------------------

ui <- fluidPage(
  
  titlePanel("Application de reconnaissance d'images"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file_image", "Choisir une image JPEG",
                accept = c(
                  "image/jpg"
                  )
      )
    ),
    
    
    mainPanel(
      uiOutput('images')
    )
  )
)


# Definer server function -------------------------------------------------

server <- function(input, output, session){
  
  output$files <- renderTable(input$files)
  
  files <- reactive({
    files <- input$file_image
    files$datapath <- gsub("\\\\", "/", files$datapath)
    files
  })
  
  
  output$images <- renderUI({
    if(is.null(input$file_image)) return(NULL)
    # imagename = paste0("image", 1)
    image_output_list <- imageOutput("image_importer")
    #   lapply(1:nrow(files()),
    #          function(i)
    #          {
    #            imagename = paste0("image", i)
    #            imageOutput(imagename)
    #          })
    # 
    # do.call(tagList, image_output_list)
  })
  
  # output$images <- renderUI({
  #   if(is.null(input$file_image)) return(NULL)
  #   image_output_list <- 
  #     lapply(1:nrow(files()),
  #            function(i)
  #            {
  #              imagename = paste0("image", i)
  #              imageOutput(imagename)
  #            })
  #   
  #   do.call(tagList, image_output_list)
  # })
  
  # observe({
  #   if(is.null(input$file_image)) return(NULL)
  #   for (i in 1:nrow(files()))
  #   {
  #   local({
  #   my_i <- i
  #   imagename = paste0("image", my_i)
  #       output[[imagename]] <- 
  #         renderImage({
  #           list(src = files()$datapath,
  #                alt = "Image failed to render")
  #         }, deleteFile = FALSE)
  #     })
  #   }
  # })
  
  observe({
    if(is.null(input$file_image)) return(NULL)
    # for (i in 1:nrow(files()))
    # {
    #   local({
    #     my_i <- i
        # imagename = paste0("image", 1)
        output[["image_importer"]] <- 
          renderImage({
            list(src = files()$datapath,
                 alt = "Image failed to render")
          }, deleteFile = FALSE)
      # })
    # }
  })
  
}


# Run the app -------------------------------------------------------------

shinyApp(ui = ui, server = server)