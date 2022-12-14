ligue <- read.csv(
    file = "ligue1_17_18.csv",
    header = TRUE,  sep = ";",
    row.names = 1,
    stringsAsFactors = FALSE
)

print(ligue[1:2, ])

points_cards <- data.frame(
    points = ligue$Points,
    yellow_cards = ligue$yellow.cards
)

set.seed(1383)
km_2 <- stats::kmeans(
    x = points_cards,
    centers = 2
)

print(km_2)
print(km_2$centers)

factoextra::fviz_cluster(
    km_2,
    data = points_cards,
    geom = c("point"),
    ellipse.type = "euclid",
    main = "Clustering with 2 centroids"
)

factoextra::fviz_cluster(
    km_2,
    data = ligue[, c("Points", "yellow.cards")],
    geom = c("point", "text"),
    ellipse.type = "euclid",
    show.clust.cent = TRUE,
    main = "Clustering with 2 centroids"
)

km_3 <- stats::kmeans(
    x = points_cards,
    centers = 3
)

print(km_3)
print(km_3$centers)

factoextra::fviz_cluster(
    km_3,
    data = points_cards,
    geom = c("point"),
    ellipse.type = "euclid",
    main = "Clustering with 3 centroids"
)

factoextra::fviz_cluster(
    km_3,
    data = ligue[, c("Points", "yellow.cards")],
    geom = c("point", "text"),
    ellipse.type = "euclid",
    show.clust.cent = TRUE,
    main = "Clustering with 3 centroids"
)

km_4 <- stats::kmeans(
    x = points_cards,
    centers = 4
)

print(km_4)
print(km_4$centers)

factoextra::fviz_cluster(
    km_4,
    data = points_cards,
    geom = c("point"),
    ellipse.type = "euclid",
    main = "Clustering with 4 centroids"
)

factoextra::fviz_cluster(
    km_4,
    data = ligue[, c("Points", "yellow.cards")],
    geom = c("point", "text"),
    ellipse.type = "euclid",
    show.clust.cent = TRUE,
    main = "Clustering with 4 centroids"
)

print(km_2$withinss)
print(km_3$withinss)
print(km_4$withinss)

print(km_2$betweenss / km_2$totss)
print(km_3$betweenss / km_3$totss)
print(km_4$betweenss / km_4$totss)

ligue1_scaled <- data.frame(
    scale(ligue)
)

km_ligue <- stats::kmeans(
    ligue,
    centers = 3,
    iter.max = 20L
)

km_ligue_scaled <- stats::kmeans(
    ligue1_scaled,
    centers = 3,
    iter.max = 20L
)

print(table(km_ligue$cluster))
print(table(km_ligue_scaled$cluster))

pca_ligue1 <- FactoMineR::PCA(ligue)

factoextra::fviz_pca_biplot(
    pca_ligue1,
    axes = c(1, 2),
    geom = c("point", "text")
)

