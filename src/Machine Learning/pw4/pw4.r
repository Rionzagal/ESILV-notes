data <- read.csv("Social_Network_Ads.csv")
str(data)
summary(data)

cor(data$Age, data$EstimatedSalary)

samples <- caTools::sample.split(data$Purchased, SplitRatio = 0.8, group = NULL)

train_set <- data[samples, ]
test_set <- data[!samples, ]

std <- function(x) (x - mean(x)) / sd(x)

scaled_train_set <- data.frame(
    train_set[, c("User.ID", "Gender", "Purchased")],
    Age = std(train_set$Age),
    EstimatedSalary = std(train_set$EstimatedSalary)
)
View(scaled_train_set)

scaled_test_set <- data.frame(
    test_set[, c("User.ID", "Gender", "Purchased")],
    Age = std(test_set$Age),
    EstimatedSalary = std(test_set$EstimatedSalary)
)
View(scaled_test_set)

age_model <- glm(Purchased ~ Age, data = scaled_train_set, family = "binomial")
summary(age_model)

