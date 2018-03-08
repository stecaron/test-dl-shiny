
# Load packages
library(keras)
library(reticulate)
library(jpeg)
library(raster)

# Importer le model pre-trained
model <- load_model_hdf5("python/model")

# Importer l'image
image_test <- image_load(path = "python/figure-house.jpg", target_size = c(224, 224))
image_test <- image_to_array(image_test)
image_test <- array_reshape(image_test, c(1, dim(image_test)))
image_test <- imagenet_preprocess_input(image_test)

preds <- model %>% predict(image_test)
imagenet_decode_predictions(preds, top = 3)[[1]]
