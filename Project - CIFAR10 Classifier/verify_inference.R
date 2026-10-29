library(EBImage)
library(keras3)

setwd("D:/DOCS/VIT Ebooks/Fourth Year/Sem 7/R/Lab/Project - CIFAR10 Classifier")

model <- load_model("model/cifar10_model.keras")
classes <- c("airplane", "automobile", "bird", "cat", "deer", 
             "dog", "frog", "horse", "ship", "truck")

test_files <- c(
  "Dataset/train/airplane/airplane_132.jpg",
  "Dataset/train/automobile/automobile_30.jpg",
  "Dataset/train/bird/bird_95.jpg",
  "Dataset/train/cat/cat_246.jpg",
  "Dataset/train/deer/deer_186.jpg",
  "Dataset/train/dog/dog_264.jpg",
  "Dataset/train/frog/frog_252.jpg",
  "Dataset/train/horse/horse_220.jpg",
  "Dataset/train/ship/ship_137.jpg",
  "Dataset/train/truck/truck_261.jpg"
)

cat("Evaluating Model on Actual Dataset Images from Dataset/train/:\n\n")

correct_count <- 0
for (f in test_files) {
  img <- readImage(f)
  img_resized <- resize(img, 32, 32)
  img_hwc <- aperm(img_resized, c(2, 1, 3))
  
  input_tensor <- array(0, dim = c(1, 32, 32, 3))
  input_tensor[1, , , ] <- as.array(img_hwc)
  
  probs <- as.numeric(model %>% predict(input_tensor, verbose = 0))
  best_class <- classes[which.max(probs)]
  conf <- max(probs) * 100
  
  expected <- basename(dirname(f))
  is_match <- ifelse(best_class == expected, "[CORRECT]", "[MISMATCH]")
  if (best_class == expected) correct_count <- correct_count + 1
  
  cat(sprintf("File: %-42s -> Predicted: %-12s (Conf: %5.2f%%) %s\n", 
              f, best_class, conf, is_match))
}

cat(sprintf("\nTotal Accuracy: %d / %d (%.1f%%)\n", 
            correct_count, length(test_files), (correct_count / length(test_files)) * 100))
