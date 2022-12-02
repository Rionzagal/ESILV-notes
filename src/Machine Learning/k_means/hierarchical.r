data(iris)

attr_data <- dplyr::select(
    iris,
    Sepal.Length,
    Sepal.Width,
    Petal.Length,
    Petal.Width
)
head(attr_data)

scaled_data <- scale(attr_data)
distances <- dist(scaled_data)

hc_model <- stats::hclust(distances, method = "complete")
print(hc_model)

plot(hc_model)

stats::rect.hclust(hc_model, k = 3, border = 2:5)

hc_clusters <- stats::cutree(hc_model, k = 3)

factoextra::fviz_cluster(list(data = scaled_data, clusters = hc_clusters))
