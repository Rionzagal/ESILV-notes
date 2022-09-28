set.seed(013) # Set randomizer seed for random repeatability.

# Data acquisition
data <- read.csv(
    file = "dataset.csv",
    header = TRUE,
    sep = ","
)
View(data)

# Change the _NA_ value in Age and Salary columns to the average of each columns
data$Age[is.na(data$Age)] <- mean(na.omit(data$Age))
data$Salary[is.na(data$Salary)] <- mean(na.omit(data$Salary))

View(data)

# Generate encoded data for country
countries <- unique(data$Country)

encoded_data <- data.frame(data)
for (country in countries) {
    encoded_data[encoded_data == country] <- as.integer(
        which(country == countries)
    )
}

encoded_data$Purchased <- ifelse(encoded_data$Purchased == "Yes", 1, 0)

View(encoded_data)

# Get the number of rows of the dataset and split into training and test sets
# install.packages("caret")    # nolint
data_samples <- caret::createDataPartition(data$Country, p = 0.6, list = FALSE)
data_train <- encoded_data[data_samples, ]
data_test <- encoded_data[-data_samples, ]

# Use Standarization scale method to scale both sets
std <- function(x) (x - mean(x)) / sd(x)

data_train_std <- data.frame(
    data_train[c("Country", "Purchased")],
    apply(data_train[c("Age", "Salary")], 2, std)
)

data_test_std <- data.frame(
    data_test[c("Country", "Purchased")],
    apply(data_test[c("Age", "Salary")], 2, std)
)

View(data_train_std)
View(data_test_std)

#### First Machine Learning Project in R Step-By-Step ####

library(datasets)
data(iris)
summary(iris)

# Separate between test and train sets of iris
iris_samples <- caret::createDataPartition(
    iris$Species,
    p = 0.8,
    list = FALSE
)

iris_train <- iris[iris_samples, ]
iris_test <- iris[-iris_samples, ]

iris_train <- iris_train[sample(seq_len(nrow(iris_train))), ]
iris_test <- iris_test[sample(seq_len(nrow(iris_test))), ]

# Summarize the data training set
dim(iris_train)
summary(iris_train)
head(iris_train)
levels(iris_train$Species)
prop.table(table(iris_train$Species))

# Visualize iris train set data
boxplot(iris_train$Sepal.Length, main = "SEPAL LENGTH", ylab = "cm")
boxplot(iris_train$Sepal.Width, main = "SEPAL WIDTH", ylab = "cm")
boxplot(iris_train$Petal.Length, main = "PETAL LENGTH", ylab = "cm")
boxplot(iris_train$Petal.Width, main = "PETAL WIDTH", ylab = "cm")

barplot(table(iris_train$Species), main = "SPECIES COUNT")

plot(
    iris_train$Sepal.Length,
    iris_train$Sepal.Width,
    main = "SEPAL LENGTH VS SEPAL WIDTH",
    xlab = "cm",
    ylab = "cm"
)

plot(
    iris_train$Sepal.Length,
    iris_train$Petal.Length,
    main = "SEPAL LENGTH VS PETAL LENGTH",
    xlab = "cm",
    ylab = "cm"
)

plot(
    iris_train$Petal.Length,
    iris_train$Petal.Width,
    main = "PETAL LENGTH VS PETAL WIDTH",
    xlab = "cm",
    ylab = "cm"
)

plot(
    iris_train$Sepal.Width,
    iris_train$Petal.Width,
    main = "SEPAL WIDTH VS PETAL WIDTH",
    xlab = "cm",
    ylab = "cm"
)

# install.packages("AppliedPredictiveModeling")     #nolint
AppliedPredictiveModeling::transparentTheme(trans = 0.4)
caret::featurePlot(
    iris_train[, 1:4],
    as.factor(iris_train$Species),
    plot = "ellipse",
    auto.label = list(columns = 3)
)

# Cross validate and generate ML models
train_control <- caret::trainControl(
    method = "repeatedcv",
    p = 0.9,
    number = 10,
    repeats = 3
)

knn_fit <- caret::train(
    Species ~ .,
    data = iris_train,
    method = "knn",
    trControl = train_control,
    tuneLength = 20,
    preProcess = c("center", "scale")
)

svm_linear_fit <- caret::train(
    Species ~ .,
    data = iris_train,
    method = "svmLinear",
    trControl = train_control,
    preProcess = c("center", "scale"),
    tuneGrid = expand.grid(C = seq(1, 2, length = 20))
)

rf_fit <- caret::train(
    Species ~ .,
    data = iris_train,
    method = "rf",
    trControl = train_control,
    tuneLength = 20,
    metric = "Accuracy",
    preProcess = c("center", "scale")
)

# Report the accuracy and performance of each model
created_models <- list(knn_fit, svm_linear_fit, rf_fit)
View(created_models)
plot(knn_fit)
plot(svm_linear_fit)
plot(rf_fit)

# Predict something with the best of the three methods (svm_linear_fit)
input_data <- head(iris_test)
pred_data <- predict(
    object = svm_linear_fit,
    newdata = input_data
)

comparison <- data.frame(
    input_data$Species,
    pred_data,
    ifelse(input_data$Species == pred_data, "Success", "Failure")
)
colnames(comparison) <- c("Real", "Prediction", "Status")
View(comparison)
