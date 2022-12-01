data(iris)
attr_data <- dplyr::select(
    iris,
    Sepal.Length,
    Sepal.Width,
    Petal.Length,
    Petal.Width
)
head(attr_data)

km_model <- stats::kmeans(attr_data, 3)
print(km_model)
