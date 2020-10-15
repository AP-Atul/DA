# Title     : Classification on Pima Indians Diabetes
# Objective : Naive Bayes classification on dataset
# Created by: @github/AP-Atul
# Created on: 14/10/20

# installing and using ggplot
# install.packages("ggplot2")
# install.packages("e1071")
# install.packages("caret")
library(ggplot2)
library(e1071)
library(caret)
library(ModelMetrics)
options(warn = -1)

# reading the dataset file
filePath <- "./datasets/diabetes.csv"
df <- read.table(file = filePath, sep = ",", header = TRUE)
df$Outcome <- factor(df$Outcome, levels = c(0, 1), labels = c("False", "True"))

# column names
names(df)

# summary for the data frame
# Glucose, Bloodpressure, Skinthickness, Insulin and BMI are 0
summary(df)

# type checking
str(df)

# changing the missing vars to NA
df[, 2:7][df[, 2:7] == 0] <- NA
df <- na.omit(df)

# checking NAs
sum(is.na(df))
colSums(is.na(df))

# plotting data
# Plot 1
ggplot(df, aes(Age, colour = Outcome)) +
  geom_freqpoly(binwidth = 1) +
  labs(title = "Age Distribution by Outcome")

# Plot 2
ggplot(df, aes(x = Pregnancies, fill = Outcome, color = Outcome)) +
  geom_histogram(binwidth = 1) +
  labs(title = "Pregnancy Distribution by Outcome", xlab("Something"))

# Plot 3
ggplot(df, aes(x = BMI, fill = Outcome, color = Outcome)) +
  geom_histogram(binwidth = 1) +
  labs(title = "BMI Distribution by Outcome")

# Plot 4
ggplot(df, aes(Glucose, colour = Outcome)) +
  geom_freqpoly(binwidth = 1) +
  labs(title = "Glucose Distribution by Outcome")

# Splitting into test and train
# 75% training samples
sampleSize <- floor(0.75 * nrow(df))

# getting the set
set.seed(123)
trainIndex <- sample(seq_len(nrow(df)), size = sampleSize)

# training and test sets
trainData <- df[trainIndex,]
testData <- df[-trainIndex,]

# summaries
summary(trainData)
summary(testData)

# sizes
print(c("The taining set size :: ", nrow(trainData)))
print(c("The testing set size :: ", nrow(testData)))

# model building
x <- trainData[, -9]
y <- trainData$Outcome

# prediction and accuracy cal
model <- train(x, y, 'nb', trainControl = trainControl(method = 'cv', number = 10))
predict <- predict(model, newdata = testData)
confusionMatrix(predict, testData$Outcome)
rmse(actual = testData$Outcome, predicted = predict)

# importance of each feature
dataImp <- varImp(model)
plot(dataImp)