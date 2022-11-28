# Create a function to return the binomial accuracy from two vectors.
binomial_accuracy <- function(real, prediction) {
    conf <- table(real, prediction)
    return(
        (conf[1, 1] + conf[2, 2]) /
        (conf[1, 1] + conf[1, 2] + conf[2, 1] + conf[2, 2])
    )
}
# Import the SPAM dataset and explore it.
library(kernlab)
data(spam)
summary(spam)
head(spam)
# There is a type variable that defines if the observation is spam or not.
#
# Split the dataset into training and test sets using a random seed.
set.seed(13)
spam_samples <- caret::createDataPartition(
    spam$type,
    p = 0.7,
    list = FALSE
)
spam_train <- spam[spam_samples, ]
spam_train_scaled <- data.frame(
    scale(spam_train[, 1:57]),
    type = ifelse(spam_train$type == "spam", 1, 0)
)
spam_test <- spam[-spam_samples, ]
spam_test_scaled <- data.frame(
    scale(spam_test[, 1:57]),
    type = ifelse(spam_test$type == "spam", 1, 0)
)
# Generate a results dataset using the type variable for future prediction
# results storing.
spam_results <- data.frame(real_value = spam_test$type)
# Fit a logistic regression model using the training set.
par(mfrow = c(1, 1))
spam_log <- glm(
    type ~ .,
    data = spam_train_scaled,
    family = "binomial"
)
summary(spam_log)
spam_results$logistic <- ifelse(
    test = predict(
        object = spam_log,
        newdata = spam_test_scaled,
        type = "response"
    ) >= 0.5,
    yes = 1,
    no = 0
)
# Fit a classification tree using the training set.
spam_tree <- rpart::rpart(type ~ ., spam_train_scaled)
summary(spam_tree)
rpart.plot::rpart.plot(spam_tree)
spam_results$tree <- ifelse(
    test = predict(
        object = spam_tree,
        newdata = spam_test_scaled
    ) >= 0.5,
    yes = 1,
    no = 0
)
# Fit a Bagging model using the training set.
spam_bag <- ipred::bagging(type ~ ., spam_train_scaled)
summary(spam_bag)
spam_results$bag <- ifelse(
    test = predict(
        object = spam_bag,
        newdata = spam_test_scaled
    ) >= 0.5,
    yes = 1,
    no = 0
)
# Fit a random forest model using the training set.
spam_forest <- randomForest::randomForest(type ~ ., spam_train_scaled)
summary(spam_forest)
spam_results$forest <- ifelse(
    test = predict(
        object = spam_forest,
        newdata = spam_test_scaled
    ) >= 0.5,
    yes = 1,
    no = 0
)
# Fit a Boosting model using the training set.
spam_gbm <- gbm::gbm(type ~ ., data = spam_train_scaled)
summary(spam_gbm)
spam_results$gbm <- ifelse(
    test = predict(
        object = spam_gbm,
        newdata = spam_test_scaled
    ) >= 0.5,
    yes = 1,
    no = 0
)
# Evaluate the performance of each model using the binomial_accuracy function.
spam_acc <- c(
    "logistic model" = binomial_accuracy(
        spam_results$real_value,
        spam_results$logistic
    ),
    "classification tree" = binomial_accuracy(
        spam_results$real_value,
        spam_results$tree
    ),
    "bagging tree" = binomial_accuracy(
        spam_results$real_value,
        spam_results$bag
    ),
    "random forest" = binomial_accuracy(
        spam_results$real_value,
        spam_results$forest
    ),
    "gradient boosting" = binomial_accuracy(
        spam_results$real_value,
        spam_results$gbm
    )
)
spam_acc
# Tune each of the models applied into the dataset.
spam_ftrain_scaled <- data.frame(
    scale(spam_train[, 1:57]),
    type = spam_train$type
)
spam_ftest_scaled <- data.frame(
    scale(spam_test[, 1:57]),
    type = spam_test$type
)

spam_glm_tuned <- caret::train(
    form = type ~ .,
    data = spam_ftrain_scaled,
    trControl = caret::trainControl(method = "cv", number = 5),
    method = "glm",
    family = "binomial"
)