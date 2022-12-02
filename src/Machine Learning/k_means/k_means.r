wss_plot <- function(data, nc = 15, seed = 1234){
    wss <- (nrow(data) - 1) * sum(apply(data, 2, var))
    for (i in 2:nc){
        set.seed(seed)
        wss[i] <- sum(kmeans(data, centers = i)$withinwss)
    }
    plot(1:nc, wss, type = "b", xlab = "K", ylab = "WSS")
}

data(iris)
attr_data <- dplyr::select(
    iris,
    Sepal.Length,
    Sepal.Width,
    Petal.Length,
    Petal.Width
)
scaled_data <- scale(attr_data)
head(scaled_data)

km_model <- stats::kmeans(scaled_data, 2)
print(km_model)

wss_plot(scaled_data)

factoextra::fviz_cluster(
    km_model,
    data = scaled_data,
    geom = c("point"),
    ellipse.type = "euclid"
)
