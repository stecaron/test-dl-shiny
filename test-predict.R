
# Load packages
library(keras)
library(reticulate)
library(jpeg)
library(raster)

# Importer le model pre-trained
# model <- load_model_hdf5("python/model")
resnet50 <- application_resnet50(weights = 'imagenet')
save_model_hdf5(resnet50, "python/resnet50.h5")
vgg16 <- application_vgg16(weights = 'imagenet', include_top = FALSE)
save_model_hdf5(vgg16, "python/vgg16.h5")
vgg19 <- application_vgg19(weights = 'imagenet', include_top = FALSE)
save_model_hdf5(vgg19, "python/vgg19.h5")
inceptionv3 <- application_inception_v3(weights = 'imagenet', include_top = FALSE)
save_model_hdf5(inceptionv3, "python/inceptionv3.h5")

model <- load_model_hdf5(filepath = "python/resnet50.h5")

# Importer l'image
image_test <- image_load(path = "python/figure-house.jpg", target_size = c(224, 224))
image_test <- image_to_array(image_test)
image_test <- array_reshape(image_test, c(1, dim(image_test)))
image_test <- imagenet_preprocess_input(image_test)

preds <- model %>% predict(image_test)
preds_table <- imagenet_decode_predictions(preds, top = 3)[[1]]

data.table(preds_table)[, (c("class_description", "score")), with =  FALSE]
