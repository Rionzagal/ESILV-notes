## EXAMPLE 1
# Load the Boston dataset from the MASS library
library(MASS)
data(Boston)
View(Boston)
summary(Boston)

# Generate the train and test sets (70% ratio)
boston_samples <- caret::createDataPartition(
    Boston$crim,
    p = 0.2,
    list = FALSE
)
train_set <- Boston[boston_samples, c("lstat", "medv")]
test_set <- Boston[-boston_samples, c("lstat", "medv")]

# Check linearity between lstat and medv columns
model <- lm(medv ~ lstat, data = train_set)
summary(model)
plot(model, 1)

# Generate a regression model using the log() function
log_model <- lm(medv ~ log(lstat), data = train_set)
summary(log_model)
plot(log_model, 1)

# Predict values using the generated model
predict(log_model, newdata = data.frame(lstat = c(5)))
predict(log_model, newdata = data.frame(lstat = c(5, 10, 15)))

# Test the model using the test_set
prediction <- data.frame(
    pred_medv = predict(log_model, newdata = test_set),
    actual_medv = test_set$medv
)
View(prediction)

# Calculate Mean Square Error based on the prediction
mse <- mean((prediction$actual_medv - prediction$pred_medv)^2)
mse # MSE calculated from the test data
mean(log_model$residuals^2) # MSE calculated from the residuals of the model

## EXAMPLE 2
# Load marketing dataset and inspect it
data("marketing", package = "datarium")
summary(marketing)
sample(marketing)

plot(marketing[c("youtube", "sales")]) # TODO: Add a smoothed line

# Calculate correlation variables
corr <- cor(marketing$youtube, marketing$sales)
corr

# Generate a linear model and find the coefficients
sales_model <- lm(sales ~ youtube, data = marketing)
summ <- summary(sales_model) # sales = 8.44 + 0.048*youtube # nolint

# Add regression line to the scatter plot
library(ggplot2)
p <- ggplot(marketing, aes(youtube, sales)) +
    geom_point()
p + stat_smooth(method = lm)

coeff <- (sales_model$coefficients)
b1 <- coeff[names(coeff) == "youtube"] # The value is 0.0475
confidence_int <- confint(sales_model, param = youtube, level = 0.95)

rse <- sd(sales_model$residuals)
rse

percentage_error <- rse / mean(marketing$sales)
percentage_error

p_value <- pf(312.1, 1, 198, lower.tail = FALSE)
p_value
# F-value is highly significant because it provides a p-value which rejects the
# null hypotesis with at least 99% of confidence.

par(mfrow = c(1, 1))
plot(sales_model, 1)
# No special pattern found against the standard line,
# so we assume the relationship is linear

plot(sales_model, 2)
# Here, the residual/quantiles relationship nearly follows a straight line, so
# we can assume normality for this case.

plot(sales_model, 3)
# Here we can see that the variance of the residuals increases for higher
# predictor values, so we can say that this case is heteroscedastic.

plot(sales_model, 5)
# In the residuals / Leverage plot we can observe that for there are no outliers
# that are further than 3(standard deviations) from the RSE, so they do not
# contribute too much to the RSE.
# Also, there are no Leverage points further than .02, which explains that there
# is not a gigantic error between a predicted value against its residual value.
