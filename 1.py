import pandas as pd
from matplotlib import pyplot as plt

df = pd.read_csv("./iris.csv")
df.columns = ["SLength", "SWidth", "PLength", "PWidth", "Class"]

print(df.mean(), "\n")

print(df.median(), "\n")

print(df.describe(), "\n")

# all data points hist
df.hist()
plt.show()

# sepal length
df.iloc[:, 0].hist()
plt.show()

# sepal width
df.iloc[:, 1].hist()
plt.show()

# petal length
df.iloc[:, 2].hist()
plt.show()

# petal width
df.iloc[:, 3].hist()
plt.show()

# boxplot
df.boxplot()
plt.show()

# sepal length
df.boxplot(column=["SLength"])
plt.show()

# sepal width
df.boxplot(column=["SWidth"])
plt.show()

# petal length
df.boxplot(column=["PLength"])
plt.show()

# petal width
df.boxplot(column=["PWidth"])
plt.show()


