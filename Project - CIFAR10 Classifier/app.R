# ==============================================================================
# R Programming Lab: Multi-Class Image Classifier
# CIFAR-10 Image Classifier & Softmax Probability Visualizer
# ==============================================================================

library(shiny)
library(EBImage)
library(keras3)

# ------------------------------------------------------------------------------
# 1. Classes & Pre-trained CNN Model
# ------------------------------------------------------------------------------
classes <- c("airplane", "automobile", "bird", "cat", "deer", 
             "dog", "frog", "horse", "ship", "truck")

model <- load_model("model/cifar10_model.keras")

# Helper function to preprocess an image into a 4D tensor (1, 32, 32, 3)
preprocess_image <- function(file_path) {
  img <- readImage(file_path)
  img_resized <- resize(img, 32, 32)
  
  # aperm converts EBImage (Width, Height, Channels) -> Keras (Height, Width, Channels)
  img_hwc <- aperm(img_resized, c(2, 1, 3))
  
  input_tensor <- array(0, dim = c(1, 32, 32, 3))
  input_tensor[1, , , ] <- as.array(img_hwc)
  return(input_tensor)
}

# ------------------------------------------------------------------------------
# 2. User Interface (UI)
# ------------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("CIFAR-10 Image Classifier & Softmax Probability Visualizer"),
  
  sidebarLayout(
    # Left: Dropdown to select test sample directly from the Dataset folder
    sidebarPanel(
      selectInput("sample_select", "Select Dataset Image:",
                  choices = c(
                    "Airplane"   = "Dataset/train/airplane/airplane_132.jpg",
                    "Automobile" = "Dataset/train/automobile/automobile_30.jpg",
                    "Bird"       = "Dataset/train/bird/bird_95.jpg",
                    "Cat"        = "Dataset/train/cat/cat_246.jpg",
                    "Deer"       = "Dataset/train/deer/deer_186.jpg",
                    "Dog"        = "Dataset/train/dog/dog_264.jpg",
                    "Frog"       = "Dataset/train/frog/frog_252.jpg",
                    "Horse"      = "Dataset/train/horse/horse_220.jpg",
                    "Ship"       = "Dataset/train/ship/ship_137.jpg",
                    "Truck"      = "Dataset/train/truck/truck_261.jpg"
                  ),
                  selected = "Dataset/train/automobile/automobile_30.jpg")
    ),
    
    # Right: Render image and probability bar plot
    mainPanel(
      imageOutput("image_preview", height = "160px"),
      plotOutput("probability_plot", height = "350px")
    )
  )
)

# ------------------------------------------------------------------------------
# 3. Server Logic
# ------------------------------------------------------------------------------
server <- function(input, output, session) {
  
  # Render the selected sample image directly from Dataset/train
  output$image_preview <- renderImage({
    list(src = input$sample_select,
         contentType = "image/jpeg",
         width = 150,
         height = 150,
         alt = "Selected Sample")
  }, deleteFile = FALSE)
  
  # Render the Softmax probability bar plot
  output$probability_plot <- renderPlot({
    input_tensor <- preprocess_image(input$sample_select)
    probs <- model %>% predict(input_tensor, verbose = 0)
    probs <- as.numeric(probs)
    
    # Highlight top predicted class in green, others in blue
    bar_cols <- rep("#93c5fd", 10)
    bar_cols[which.max(probs)] <- "#22c55e"
    
    par(mar = c(5, 6, 2, 2))
    bp <- barplot(
      probs * 100,
      names.arg = classes,
      las = 2,
      col = bar_cols,
      border = NA,
      ylab = "Softmax Probability (%)",
      ylim = c(0, max(probs * 100) * 1.25),
      main = "Softmax Probability Distribution"
    )
    
    # Draw percentage above each bar
    text(
      x = bp,
      y = probs * 100 + max(probs * 100) * 0.04,
      labels = sprintf("%.1f%%", probs * 100),
      cex = 0.9,
      font = 2
    )
    grid(nx = NA, ny = NULL, col = "gray85", lty = "dotted")
  })
}

# ------------------------------------------------------------------------------
# 4. Launch App
# ------------------------------------------------------------------------------
shinyApp(ui = ui, server = server)
