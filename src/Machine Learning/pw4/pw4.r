data <- read.csv("Social_Network_Ads.csv")
str(data)
summary(data)

cor(data$Age, data$EstimatedSalary)

samples <- caTools::sample.split(data$Purchased, SplitRatio = 0.7, group = NULL)

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

# The equation is p = -0.945 + 1.953 * Age
# The logistic equation is sigma = exp(p)/(1 + exp(p))

# Feature age is significant because of its p value

# AIC value is 277.2

plot(scaled_train_set$Age, scaled_train_set$Purchased)
curve(predict(age_model, data.frame(Age = x), type = "response"), add = TRUE)

model_2 <- glm(
    Purchased ~ Age + EstimatedSalary,
    data = scaled_train_set,
    family = "binomial"
)
summary(model_2)

# Both of the predictors are significant given their p-values.
# New equation is p = -1.257 + 2.59 * Age + 1.36 * EstimatedSalary
# The AIC for model_2 is lower than in the age_model, so we can say
# it is better overall.

purchase_prob <- data.frame(
    predict(
        model_2,
        scaled_test_set,
        type = "response"
    )
)
colnames(purchase_prob) <- c("Probability")

purchase_pred <- ifelse(purchase_prob$Probability > .5, 1, 0)

conf_matrix <- table(test_set$Purchased, purchase_pred)
conf_matrix

true_positive <- conf_matrix[2, 2]
true_negative <- conf_matrix[1, 1]
false_positive <- conf_matrix[1, 2]
false_negative <- conf_matrix[2, 1]

model_accuracy <- (true_positive + true_negative) / nrow(test_set)
model_sensitivity <- (true_positive) / (true_positive + false_negative)
model_specificity <- (true_negative) / (true_negative + false_positive)
model_precision <- (true_positive) / (true_positive + false_positive)

roc_pred_ml2 <- ROCR::prediction(purchase_prob, test_set$Purchased)
roc_perf_ml2 <- ROCR::performance(roc_pred_ml2, "tpr", "fpr")

roc_pred_ml1 <- ROCR::prediction(
    data.frame(
        purchase_prob = predict(
            age_model,
            scaled_test_set,
            type = "response"
        )
    ),
    test_set$Purchased
)
roc_perf_ml1 <- ROCR::performance(roc_pred_ml1, "tpr", "fpr")

plot(roc_perf_ml2, col = "red", main = "Purchased models ROC curves")
plot(roc_perf_ml1, col = "blue", add = TRUE)
abline(a = 0, b = 1, lty = "dashed", col = "gray")
legend(
    x = "bottom",
    legend = c("model 1", "model 2"),
    fill = c("blue", "red"),
    bty = "n"
)

auc_ml1 <- (ROCR::performance(
    roc_pred_ml1,
    "auc"
))@y.values[[1]]
# AUC for model 1 is 0.890
auc_ml2 <- (ROCR::performance(
    roc_pred_ml2,
    "auc"
))@y.values[[1]]
# AUC for model 2 is 0.914

# Therefore, the model 2 is the best model out of the two, because it is
# considered to have the best performance according to the ROC curve.