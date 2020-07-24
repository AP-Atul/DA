par(mar=c(7,5,1,1)) # more space to labels
boxplot(iris,las=2)
hist(iris$Petal.Length)

par(mfrow=c(1,3))