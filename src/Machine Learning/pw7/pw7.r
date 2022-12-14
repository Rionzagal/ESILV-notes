# Load the demo data sets decathlon2 from the factoextra
# package using the data operator and show its first lines using head
library(factoextra)
data(decathlon2)
head(decathlon2)
# Use str function to describe your data. Notice that its describes athletes
# performance during two sporting events (Desctar and Olympic Games).
# It contains 27 individuals (athletes) described by 13 variables.
str(decathlon2)
# Extract only active individuals and variables.
active_variables <- dplyr::select(
    decathlon2, -c("Rank", "Points", "Competition")
)
supp_variables <- decathlon2[, c("Rank", "Points", "Competition")]
supp_rows <- c("KARPOV", "WARNERS", "Nool", "Drews")
active_data <- active_variables[!(row.names(active_variables) %in% supp_rows), ]
supp_data <- supp_variables[supp_rows, ]
# Use the function PCA() from the FactoMineR package to construct a PCA on a
# sclaed version of the decathlon2 data.
pca_data <- FactoMineR::PCA(scaled_active_data, scale.unit = TRUE)
print(pca_data)
# Examine the eigenvalues to determine the number of principal components to be
# considered using the function get_eigenvalue() from the factoextra package.
eig_values <- factoextra::get_eigenvalue(pca_data)
# Show the scree plot using the function fviz_eig() and discuss how many
# principal components are enough.
factoextra::fviz_eig(pca_data, addlabels = TRUE, ylim = c(0, 50))
#Plot the correlation circle using the fviz_pca_var function.
var <- factoextra::get_pca_var(pca_data)
var

factoextra::fviz_pca_var(pca_data, col.var = "black")

corrplot::corrplot(var$cos2, is.corr = FALSE)

corrplot::corrplot(var$cos2, is.corr = FALSE)

pca_ind <- factoextra::get_pca_ind(pca_data)

factoextra::fviz_pca_ind(pca_data)

pca_supp <- FactoMineR::PCA(
    decathlon2,
    quanti.sup = 11:12,
    quali.sup = 13,
    ind.sup = 24:27,
    scale = TRUE
)

predict(
    pca_supp,
    newdata = decathlon2[supp_rows, ],
    Competition ~ .
)
