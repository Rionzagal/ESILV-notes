# Create a function to return the RMSE from two vectors.
rmse <- function(vec_1, vec_2) sqrt(mean((vec_1 - vec_2)^2))
# Load Boston dataset and divide it in half for test and train datasets.
library(MASS)
data(Boston)
boston_shuffled <- Boston[sample(1 : nrow(Boston)), ]
boston_test <- boston_shuffled[1 : (nrow(Boston) / 2), ]
boston_train <- boston_shuffled[(1 + nrow(Boston) / 2) : nrow(Boston), ]
# Fit a regression tree to estimate the variable medv using the train dataset.
boston_tree <- rpart::rpart(medv ~ ., boston_train)
plot(boston_tree)
rpart.plot::rpart.plot(boston_tree)
summary(boston_tree)
rpart::printcp(boston_tree)
rpart::plotcp(boston_tree)
# Make a boston_results dataset to store the predictions and the real values.
boston_results <- data.frame(real_value = boston_test$medv)
# Make predictions using the regression tree in the test dataset.
boston_results$tree <- predict(
    object = boston_tree,
    newdata = boston_test
)
# Fit a linear model to compare its results against the regression tree.
boston_linear <- lm(medv ~ ., boston_train)
boston_results$linear <- predict(
    object = boston_linear,
    newdata = boston_test
)
# Plot the predictions to visualize graphically the results of the predictions.
plot(tree ~ real_value, data = boston_results)
plot(linear ~ real_value, data = boston_results)
#Fit a Bagged tree and compare its predictions against the others.
boston_bag <- ipred::bagging(medv ~ ., data = boston_train)
boston_results$bagging <- predict(
    object = boston_bag,
    newdata = boston_test
)
plot(bagging ~ real_value, data = boston_results)
# Fit a Random Forest and compare its predictions against the other models.
boston_forest <- randomForest::randomForest(medv ~ ., data = boston_train)
boston_results$forest <- predict(
    object = boston_forest,
    newdata = boston_test
)
# Retrieve the Random Forest predictors and order them by importance.
forest_predictors <- data.frame(
    randomForest::importance(boston_forest)
)
forest_predictors <- forest_predictors[
    order(-forest_predictors$IncNodePurity),
    , drop = FALSE
]
forest_predictors[1:3, , drop = FALSE]
randomForest::varImpPlot(boston_forest)
# Fit a Gradient Boosting model to the dataset and compare it
# against the other models.
boston_gbm <- gbm::gbm(medv ~ ., data = boston_train)
boston_results$gbm <- predict(boston_gbm, boston_test)
summary(boston_gbm)
# Compare the RMSE of all the models fitted into the dataset.
boston_rmse <- c(
    "regression tree" = rmse(
        boston_results$real_value,
        boston_results$tree
    ),
    "linear model" = rmse(
        boston_results$real_value,
        boston_results$linear
    ),
    "bagging model" = rmse(
        boston_results$real_value,
        boston_results$bagging
    ),
    "random forest" = rmse(
        boston_results$real_value,
        boston_results$forest
    ),
    "gradient boosting" = rmse(
        boston_results$real_value,
        boston_results$gbm
    )
)
# Make a final plot comparing all of the models fitted into the
# dataset.
boston_results <- boston_results[
    order(boston_results$real_value),
    , drop = FALSE
]
par(mfrow = c(3, 2))
plot(
    tree ~ real_value,
    data = boston_results,
    main = "Regression Tree model",
    xlab = "Real value",
    ylab = "Predictions"
)
plot(
    linear ~ real_value,
    data = boston_results,
    main = "Linear model",
    xlab = "Real value",
    ylab = "Predictions"
)
plot(
    bagging ~ real_value,
    data = boston_results,
    main = "Bagging model",
    xlab = "Real value",
    ylab = "Predictions"
)
plot(
    forest ~ real_value,
    data = boston_results,
    main = "Random Forest model",
    xlab = "Real value",
    ylab = "Predictions"
)
plot(
    gbm ~ real_value,
    data = boston_results,
    main = "GBM model",
    xlab = "Real value",
    ylab = "Predictions"
)
boston_rmse
