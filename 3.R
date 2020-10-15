# Title     : Classification on Big mart sales data
# Objective : Multiple classifiers (
# Created by: @github/AP-Atul
# Created on: 15/10/20

# packages
library(ggplot2)
library(e1071)
library(caret)
library(pls)
library(ModelMetrics)
library(plyr)
library(dplyr)
library(randomForest)

######################### EXPLORATORY ANALYSIS #########################
# reading the dataset
train <- read.csv(file = "./datasets/bigmart/train.csv", sep = ",")
names(train)
dim(train)

# doesnt have the final col
test <- read.csv(file = "./datasets/bigmart/test.csv", sep = ",")
names(test)
dim(test)

# output for the test
submission <- read.csv(file = "./datasets/bigmart/submission.csv", sep = ",")
names(submission)
dim(submission)

# data types
str(train)

# null data check
sum(is.na(train))
sum(is.na(test))

# which col has null value
# OP: Item_Weight has null
colSums(is.na(train))
colSums(is.na(test))

# plots
ggplot(train, aes(Item_Visibility, Item_Outlet_Sales)) +
  geom_point(size = 2.5, color = "navy") +
  labs(title = "Item Visibility vs Item Outlet Sales")

ggplot(train, aes(Item_Weight, Item_Outlet_Sales)) +
  geom_point(size = 2.5, color = "navy") +
  labs(title = "Item Weight vs Item Outlet Sales")

ggplot(train, aes(Item_MRP, Item_Outlet_Sales)) +
  geom_point(size = 2.5, color = "navy") +
  labs(title = "Item MRP vs Item Outlet Sales")

ggplot(train, aes(Outlet_Identifier, Item_Outlet_Sales)) +
  geom_bar(stat = "identity", color = "purple") +
  labs(title = "Outlet Identifier vs Item Outlet Sales")

ggplot(train, aes(Item_Type, Item_MRP)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 70, vjust = 0.5, color = "green")) +
  xlab("Item Type") +
  ylab("Item MRP") +
  labs(title = "Item Type vs Item MRP")

######################### DATA PREPROCESSING #########################
# operations on null values
# combining test and train
test$Item_Outlet_Sales <- 1
combination <- rbind(train, test)
dim(combination)

# replacing the values in Item_Weight with median vals
combination$Item_Weight[is.na(combination$Item_Weight)] <- median(combination$Item_Weight, na.rm = TRUE)
sum(is.na(combination))

# replacing the categorical data
# making values same
combination$Item_Fat_Content <- revalue(combination$Item_Fat_Content, c("LF" = "Low Fat", "reg" = "Regular"))
combination$Item_Fat_Content <- revalue(combination$Item_Fat_Content, c("low fat" = "Low Fat"))
combination$Item_Fat_Content = factor(combination$Item_Fat_Content, levels = c("Low Fat", "Regular"), labels = c(0, 1))

# items
perishable <- c("Breads", "Breakfast", "Dairy", "Fruits and Vegetables", "Meat", "Seafood")
nonPerishable <- c("Baking Goods", "Canned", "Frozen Foods", "Hard Drinks", "Health and Hygiene", "Household", "Soft Drinks")
combination$Item_Type <- ifelse(combination$Item_Type %in% perishable, "perishable",
                                ifelse(combination$Item_Type %in% nonPerishable, "non_perishable", "not_sure"))
combination$Item_Type = factor(combination$Item_Type, levels = c("perishable", "non_perishable", "not_sure"), labels = c(0, 1, 2))

# shop size
combination$Outlet_Size <- ifelse(combination$Outlet_Size == "Small", 0,
                                  ifelse(combination$Outlet_Size == "Medium", 1, 2))

# location
combination$Outlet_Location_Type <- ifelse(combination$Outlet_Location_Type == "Tier 3", 0,
                                           ifelse(combination$Outlet_Location_Type == "Tier 2", 1, 2))

# shop type
combination$Outlet_Type <- ifelse(combination$Outlet_Type == "Grocery Store", 0,
                                  ifelse(combination$Outlet_Type == "Supermarket Type1", 1,
                                         ifelse(combination$Outlet_Type == "Supermarket Type3", 2, 3)))

# removing not needed columns
combination <- select(combination, -c(Item_Identifier, Outlet_Identifier))

# checking for na
sum(is.na(combination))
colSums(is.na(combination))

# splitting the train and test
trainData <- combination[seq_len(nrow(train)),]
testData <- combination[-(seq_len(nrow(train))),]
dim(trainData)
dim(testData)
dim(train)
dim(test)

######################### CLASSIFICATION #########################
# 1. Linear model
linearModel <- lm(Item_Outlet_Sales ~ ., data = trainData)
plot(linearModel)

# predictions
# rmse OP: 341.5525
predictions <- predict(linearModel, testData)
submission$Item_Outlet_Sales_Pred <- predictions
rmse(actual = submission$Item_Outlet_Sales, predicted = submission$Item_Outlet_Sales_Pred)

# 2. Random Forest
randomForestModel <- randomForest::randomForest(Item_Outlet_Sales ~ ., data = trainData)
plot(randomForestModel)

# predictions
# rmse OP: 244.8039
predictions <- predict(randomForestModel, testData)
submission$Item_Outlet_Sales_RPred <- predictions
rmse(actual = submission$Item_Outlet_Sales, predicted = submission$Item_Outlet_Sales_RPred)
write.csv(submission, "./datasets/bigmart/submission_pred.csv", row.names = F)