

# Load packages -----------------------------------------------------------

library(shiny)
library(keras)
library(reticulate)
library(jpeg)
library(raster)


# Define variables --------------------------------------------------------

# pretrained_nn <- c("ResNet50", "VGG16", "VGG19", "InceptionV3")
pretrained_nn <- c("ResNet50", "VGG16")
resnet50 <- load_model_hdf5("python/resnet50.h5")
vgg16 <- load_model_hdf5("python/vgg16.h5")
# vgg19 <- load_model_hdf5("python/vgg19.h5")
# inceptionv3 <- load_model_hdf5("python/inceptionv3.h5")

# Define user interface ---------------------------------------------------

ui <- fluidPage(
  
  titlePanel("Application de reconnaissance d'images"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file_image", "Choisir une image JPEG",
                accept = c(
                  "image/jpg"
                  )
      ),
      selectInput(inputId = "model", label = "Choisir un réseau de neurones", choices = pretrained_nn, selected = pretrained_nn[1], multiple = FALSE, selectize = TRUE),
      actionButton("predict", "Prédire")
    ),
    
    
    mainPanel(
      fluidRow(
        h3("Image importée:"),
        column(8, align="center",
               uiOutput('images')
        )
      ),
      hr(),
      fluidRow(
        column(8, align="center",
               tableOutput("predictions")
        )
      )
    )
  )
)


# Definer server function -------------------------------------------------

server <- function(input, output, session){
  
  model_selected <- reactive({
    input$model
  })
  
  # Create reactive neural net
  model <- reactive({
    if (model_selected() == "ResNet50"){
      model <- resnet50
    } else if (model_selected() == "VGG16"){
      model <- vgg16
    } else if (model_selected() == "VGG19"){
      model <- vgg19
    } else if (model_selected() == "InceptionV3"){
      model <- inceptionv3
    }
    model
  })
  
  output$images <- renderUI({
    if(is.null(input$file_image)) return(NULL)
    imageOutput("image_importer")
  })
  
  observe({
    if(is.null(input$file_image)) return(NULL)
        output[["image_importer"]] <- 
          renderImage({
            list(src = input$file_image$datapath,
                 alt = "Image failed to render")
          }, deleteFile = FALSE)
  })
  
  preds <- eventReactive(input$predict, {
    if(is.null(input$file_image)) return(NULL)
    
    # # Preprocess the image
    image_test <- image_load(path = input$file_image$datapath, target_size = c(224, 224))
    image_test <- image_to_array(image_test)
    image_test <- array_reshape(image_test, c(1, dim(image_test)))
    image_test <- imagenet_preprocess_input(image_test)
    
    # # Predict the image
    preds <- model() %>% predict(image_test)
    preds_table <- imagenet_decode_predictions(preds, top = 3)[[1]]
    preds_table
  })
  
  output$predictions <- renderTable({
    preds()
  })
  
}


# Run the app -------------------------------------------------------------

shinyApp(ui = ui, server = server)