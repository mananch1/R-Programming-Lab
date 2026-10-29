# ==============================================================================
# Project: CIFAR-10 Image Classifier (High-Accuracy Deep CNN)
# R Programming Lab Project: Multi-Class Image Classification
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Loading Required Packages
# ------------------------------------------------------------------------------
library(EBImage)
library(keras3)
library(reticulate)

set.seed(42)

# ------------------------------------------------------------------------------
# 2. Defining Classes and Loading Data
# ------------------------------------------------------------------------------
classes <- c("airplane", "automobile", "bird", "cat", "deer", 
             "dog", "frog", "horse", "ship", "truck")

cat("Loading 10,000 CIFAR-10 training images and 1,000 test images...\n")

# Load pre-indexed uncompressed CIFAR dataset (10,000 samples)
np <- import("numpy")
cifar_data <- np$load("data/cifar_10k.npz")

trainx <- cifar_data$f[["train_x"]] # shape: (10000, 32, 32, 3)
trainy <- as.numeric(cifar_data$f[["train_y"]])

testx  <- cifar_data$f[["test_x"]]  # shape: (1000, 32, 32, 3)
testy  <- as.numeric(cifar_data$f[["test_y"]])

cat(sprintf("Training set: %d images | Shape: [%s]\n", 
            nrow(trainx), paste(dim(trainx), collapse = ", ")))
cat(sprintf("Testing set:  %d images  | Shape: [%s]\n", 
            nrow(testx), paste(dim(testx), collapse = ", ")))

# ------------------------------------------------------------------------------
# 3. One-Hot Encoding and Shuffling
# ------------------------------------------------------------------------------
trainLabels <- to_categorical(trainy, num_classes = 10)
testLabels  <- to_categorical(testy, num_classes = 10)

# Shuffle training samples
shuffle_idx <- sample(dim(trainx)[1])
trainx      <- trainx[shuffle_idx, , , ]
trainLabels <- trainLabels[shuffle_idx, ]
trainy      <- trainy[shuffle_idx]

# ------------------------------------------------------------------------------
# 4. Defining High-Accuracy Deep CNN Architecture
# ------------------------------------------------------------------------------
# VGG-style Double Convolutional Blocks + BatchNorm + Dropout
model <- keras_model_sequential()
model %>%
  # Block 1
  layer_conv_2d(filters = 32, kernel_size = c(3, 3), padding = "same", 
                activation = "relu", input_shape = c(32, 32, 3)) %>%
  layer_batch_normalization() %>%
  layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_dropout(rate = 0.25) %>%
  
  # Block 2
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), padding = "same", 
                activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_dropout(rate = 0.25) %>%
  
  # Dense Classification Head
  layer_flatten() %>%
  layer_dense(units = 256, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = 0.5) %>%
  layer_dense(units = 10, activation = "softmax")

summary(model)

# ------------------------------------------------------------------------------
# 5. Compiling the Model
# ------------------------------------------------------------------------------
model %>%
  compile(
    loss = "categorical_crossentropy",
    optimizer = optimizer_adam(learning_rate = 0.001),
    metrics = c("accuracy")
  )

# ------------------------------------------------------------------------------
# 6. Training the Model
# ------------------------------------------------------------------------------
cat("\nTraining Deep CNN for 15 epochs on 10,000 images...\n")
history <- model %>%
  fit(
    trainx,
    trainLabels,
    epochs = 15,
    batch_size = 64,
    validation_split = 0.15,
    verbose = 1
  )

# ------------------------------------------------------------------------------
# 7. Evaluating on Test Set
# ------------------------------------------------------------------------------
cat("\nEvaluating Deep CNN on 1,000 Test Images:\n")
eval_results <- model %>% evaluate(testx, testLabels, verbose = 0)
cat(sprintf("Test Loss:     %.4f\n", eval_results[["loss"]]))
cat(sprintf("Test Accuracy: %.2f%%\n", eval_results[["accuracy"]] * 100))

# ------------------------------------------------------------------------------
# 8. Saving the Trained Model
# ------------------------------------------------------------------------------
if (!dir.exists("model")) dir.create("model")
save_model(model, "model/cifar10_model.keras", overwrite = TRUE)
cat("\nModel successfully saved to: model/cifar10_model.keras\n")
