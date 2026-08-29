# 🚗✈️ Car vs Plane Image Classifier (R + Keras)

## 📌 Project Title

**Binary Image Classification using R (Car vs Plane Classifier)**

------------------------------------------------------------------------

## 🎯 Objective

The objective of this project is to build a simple image classification
model using **R programming** that can distinguish between **car** and
**airplane** images.

------------------------------------------------------------------------

## 🧠 Problem Description

Given a dataset of images belonging to two classes: - **Planes (label =
0)** - **Cars (label = 1)**

The task is to: - Preprocess the images - Train a neural network model -
Evaluate its performance

------------------------------------------------------------------------

## 📂 Dataset Information

-   Total Images: **23**
    -   Plane Images: **10 (p1.jpg -- p10.jpg)**
    -   Car Images: **13 (c1.jpg -- c13.jpg)**
-   Image size after preprocessing: **28 × 28 × 3**

------------------------------------------------------------------------

## 🛠️ Libraries Used

-   `EBImage`
-   `keras3`

------------------------------------------------------------------------

## ⚙️ Workflow

### 1. Load Images

Images are loaded using `readImage()` and stored in a list.

### 2. Preprocessing

-   Resize to 28×28
-   Convert to array format

### 3. Data Split

-   Training: 8 planes + 11 cars
-   Testing: 2 planes + 2 cars

### 4. Encoding

-   Labels converted using one-hot encoding

### 5. Model

-   Dense Neural Network:
    -   Input: 2352
    -   Hidden: 256, 128 (ReLU)
    -   Output: 2 (Softmax)

### 6. Training

-   Epochs: 50
-   Batch size: 32

### 7. Evaluation

-   Predictions converted using `which.max`
-   Confusion matrix generated

------------------------------------------------------------------------

## ▶️ How to Run

1.  Install packages:

``` r
install.packages("EBImage")
install.packages("keras3")
```

2.  Set working directory and run script:

``` r
source("script.R")
```

------------------------------------------------------------------------

## 📊 Output

-   Model accuracy
-   Confusion matrix

------------------------------------------------------------------------

## ⚠️ Limitations

-   Small dataset
-   No CNN used
-   Possible overfitting

------------------------------------------------------------------------

## 🔮 Future Improvements

-   Use CNN
-   Increase dataset
-   Apply augmentation
