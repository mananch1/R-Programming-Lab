#Loading Required Packages
library(EBImage)
library(keras3)

#Importing images
setwd("D:\\DOCS\\VIT Ebooks\\Fourth Year\\Sem 7\\R\\Lab\\Assignment 4 - Car Classifier\\Dataset")

pics <- c(
  paste0("p",1:10,".jpg"),
  paste0("c",1:13,".jpg")
)

mypics <- list()

for (i in 1:23){
  print(i)
  mypics[[i]] <- readImage(pics[i])
}


#Exploring
print(mypics[1])
display(mypics[[1]])
hist(mypics[[1]])


# Resizing

for (i in 1:23){
  mypics[[i]] <- resize(mypics[[i]],28,28)
}

#Reshaping

for(i in 1:23){
  mypics[[i]] <- array_reshape(mypics[[i]],c(28,28,3))
}

str(mypics)

#RowBind

trainx <- NULL
for(i in 1:8){
  trainx <- rbind(trainx,mypics[[i]])
}
for(i in 11:21){
  trainx <- rbind(trainx,mypics[[i]])
}

str(trainx)

testx <- NULL

testx <- rbind(mypics[[9]],mypics[[10]],mypics[[22]],mypics[[23]])

trainy <- c(rep(0,8),rep(1,11))
testy <- c(rep(0,2),rep(1,2))

# One Hot Encoding
trainLabels <- to_categorical(trainy)
testLabels <- to_categorical(testy)



# Defining Model

model <- keras_model_sequential()
model %>%
  layer_dense(units = 256,activation = 'relu',input_shape=c(2352)) %>%
  layer_dense(units = 128,activation = 'relu')%>%
  layer_dense(units = 2,activation = 'softmax')

summary(model)

model %>%
  compile(loss = "binary_crossentropy",
          optimizer = optimizer_rmsprop(),
          metrics = c('accuracy'))


# Training

history <- model %>%
  fit(trainx,
      trainLabels,
      epochs = 50,
      batch_size = 32,
      validation_split = .2)
  
plot(history)


# Testing

model %>%
  evaluate(testx,testLabels)

pred <- model %>%
  predict(testx)

pred <- apply(pred, 1, which.max) - 1

table(Predicted = pred, Actual = testy)

