#COLORS
# Pink: ff006a
# Red : f2374d
# Blue :37c3f2
# Orange : f25d37
# Greeen : 37f260

# read the dataset file
filePath <- "/home/atul/Projects/DataAnalyticsPrograms/datasets/iris.data"
df <- read.table( file = filePath, header = FALSE, sep = ",")
names(df) <- c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Class")

# Feature
names(df)

#Stats
summary(df)

# Histograms
# 1. Sepal.Length
hist(df$Sepal.Length, col="#ff006a")

# 2. Sepal.Width
hist(df$Sepal.Width, col="#f2374d")

# 3. Petal.Length
hist(df$Petal.Length, col="#37c3f2")

# 4. Petal.Width
hist(df$Petal.Width, col="#f25d37")

# Box plot
# 1. Sepal.Length
boxplot(df$Sepal.Length, col="#ff006a")

# 2. Sepal.Width
boxplot(df$Sepal.Width, col="#f2374d")

# 3. Petal.Length
boxplot(df$Petal.Length, col="#37c3f2")

# 4. Petal.Width
boxplot(df$Petal.Width, col="#f25d37")

# Mutiple BoxPlot
boxplot(df, col = "#37f260")
