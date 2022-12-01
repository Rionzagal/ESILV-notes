library(factoextra)
data(decathlon2)

head(decathlon2)
str(decathlon2)

active_variables <- dplyr::select(
    decathlon2, -c("Rank", "Points", "Competition")
)

supp_rows <- c("KARPOV", "WARNERS", "Nool", "Drews")
active_data <- active_variables[!(row.names(active_variables) %in% supp_rows), ]

scaled_active_data <- scale(active_data, center = TRUE)
pca_data <- prcomp(scaled_active_data)

View(pca_data)

eig_values <- factoextra::get_eigenvalue(pca_data)
factoextra::fviz_eig(pca_data, addlabels = TRUE)

factoextra::fviz_pca_var(pca_data)
