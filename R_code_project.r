# R_code_project.r

# Progetto esame

# Librerie
require(raster)
require(RStoolbox)
require(ggplot2) 
require(gridExtra)
require(lattice)

# Working Directory 
setwd("C:/lab/canada/")

# Creo delle liste con tutti i files contententi il pattern '2017'. 
# Così in queste liste ci saranno tutti i file del 2017 (bande singole)
list_2017 <- list.files(pattern = "2017")
list_2020 <- list.files(pattern = '2020')

# Usiamo lapply() per applicare la funzione raster() a tutti i dati dentro la lista
import_2017 <- lapply(list_2017, raster)
import_2020 <- lapply(list_2020, raster)

# Creo degli stack con che tutti i file delle liste a cui è stata applicata la funzione raster()
stack_2017 <- stack(import_2017)
stack_2020 <- stack(import_2020)

# BANDE LANDSAT 8 
# Adesso creo delle variabili per ogni sigola banda che richiamo direttamente dallo stack.
# Bande 2017
cost_2017 <- stack_2017$X046017_2017_B1
blue_2017 <- stack_2017$X046017_2017_B2
green_2017 <- stack_2017$X046017_2017_B3
red_2017 <- stack_2017$X046017_2017_B4
nir_2017 <- stack_2017$X046017_2017_B5
swir_2017 <- stack_2020$X046017_2017_B6
# Bande 2020
cost_2020 <- stack_2020$X046017_2020_B1
blue_2020 <- stack_2020$X046017_2020_B2
green_2020 <- stack_2020$X046017_2020_B3
red_2020 <- stack_2020$X046017_2020_B4
nir_2020 <- stack_2020$X046017_2020_B5
swir_2020 <- stack_2020$X046017_2020_B6

# True color images
# Creo degli stack con solo le bande VIS per ottenere delle immagini a colori naturali
# Nello stack ordino le bande secondo i canali R G B. 
# Nelle TCI nel canale del rosso mettiamo la banda del rosso, nel canale del verde mettiamo la banda del verde
# e nel canale del blu mettiamo la banda del blu.
# Così per le bande del 2017 e del 2020.
nci_2017 <- stack(red_2017, green_2017, blue_2017)
nci_2020 <- stack(red_2020, green_2020, blue_2020)
# plot 
# Uso plotRGB() per plottare l'immagine a colori naturali.
par(mfrow = c(1, 2))
plotRGB(nci_2017, axes = TRUE, stretch = 'lin', main = 'Natural color Great Slave Lake 2017')
plotRGB(nci_2020, axes = TRUE, stretch = 'lin', main = 'Natural color Great Slave Lake 2020')

# False color images
# Stessa logica per l'immagine a falsi colori: 
# R: NIR, G: banda del rosso, B: banda del verde.
fci_2017 <- stack(nir_2017, red_2017, green_2017)
fci_2020 <- stack(nir_2020, red_2020, green_2020)
# plotRGB()
par(mfrow = c(1,2))
plotRGB(fci_2017, axes = TRUE, stretch = 'lin', main = 'False color Great Slave Lake 2017')
plotRGB(fci_2020, axes = TRUE, stretch = 'lin', main = 'False color Great Slave Lake 2020')

# Bands combination for emphasizing land and water
# Usiamo questa combinazione di bande per mettere in risalto l'acqua e il suolo. 
# R: NIR, G: SWIR, B: banda del rosso.
land_water_comb_2017 <- stack(nir_2017, swir_2017, red_2017)
land_water_comb_2020 <- stack(nir_2020, swir_2020, red_2020)
# plotRB()
par(mfrow = c(1, 2))
plotRGB(land_water_comb_2017, axes = TRUE, stretch = 'lin', main = 'Bands combination for land and water 2017')
plotRGB(land_water_comb_2020, axes = TRUE, stretch = 'lin', main = 'Band combination for land and water 2020')


# NDVI - Indice di vegetazione normalizzato
# scrivi a che serve!
# Creo una palette che spieghi questo indice di vegetazione. 
cl_ndvi <- colorRampPalette(c("dark red", "red", "orange", "yellow","lime green", "green", "dark green"))(500)) # Palette per NDVI
ndvi_2017 <- (nir_2017 - red_2017) / (nir_2017 + red_2017)
ndvi_2020 <- (nir_2020 - red_2020) / (nir_2020 + red_2020)

par(mfrow = c(1,2))
plot(ndvi_2017, col = cl_ndvi, main = 'Great Slave Lake, 31/8/2017 NDVI')
plot(ndvi_2020, col = cl_ndvi, main = 'Great Slave Lake, 20/6/2020 NDVI')

# Differenza tra i due NDVI
diff_ndvi <- ndvi_2020 - ndvi_2017
plot(diff_ndvi, col = cl_ndvi, main = 'Cosa è cambiato?')

# Unsupervised classification con 5 classi
uns_class_2017 <- unsuperClass(stack_2017, nClasses = 5)
uns_class_2020 <- unsuperClass(stack_2020, nClasses = 5)

# plot che va rivisto...
par(mfrow = c(1, 2))
set.seed(5)
plot(uns_class_2017$map, col = cl_uns_class, main = 'Unsupervised Class. 2017')
plot(uns_class_2020$map, col = cl_uns_class, main = 'Unsupervised Class. 2020')

# Variability - Calcoliamo la variabilità dell'immagine
# su NDVI (2017 e 2020)
# utilizziamo la funzione focal() per far passare la moving window sull'immagine


# PCA - Analisi delle componenti principali
# Creo una palette
# Palette più bella mai creata!
cl_pca <- colorRampPalette(c('dark blue', 'aquamarine', 'yellow', 'orange')) (200)

# uso solo le tre bande del visibile, per ora (?)
pca_2017 <- rasterPCA(nci_2017)
pca_2020 <- rasterPCA(nci_2020)

# visualizzo le informazioni...
pca_2017$model
# Call:
# princomp(cor = spca, covmat = covMat[[1]])
# Standard deviations:
#    Comp.1    Comp.2    Comp.3 
# 1228.7888  202.1254  161.2625 
#  3  variables and  65220551 observations.

pca_2020$model
# Call:
# princomp(cor = spca, covmat = covMat[[1]])
# Standard deviations:
#    Comp.1    Comp.2    Comp.3 
# 1699.3247  330.2557  222.8458 
#  3  variables and  65382171 observations.

# Se però usiamo summary() otteniamo delle info più dettagliate circa la 
# variabilità che spiegano le diverse bande.
summary(pca_2017$model)
# Importance of components:
#                             Comp.1       Comp.2       Comp.3
# Standard deviation     1228.788848 202.12537869 161.26252473
# Proportion of Variance    0.957597   0.02591015   0.01649283 (prop di variabilità spiegata)
# Cumulative Proportion     0.957597   0.98350717   1.00000000

# La componente 1 spiega il 95,75% delle informazioni.

summary(pca_2020$model)
#Importance of components:
#                              Comp.1       Comp.2       Comp.3
# Standard deviation     1699.3247133 330.25574695 222.84584888
# Proportion of Variance    0.9478967   0.03580215   0.01630112
# Cumulative Proportion     0.9478967   0.98369888   1.00000000

# La componente 1 spiega il 94,78% delle informazioni.

# creo delle variabili e gli assegno SOLO la PC1 di ogni anno
pc1_2017 <- pca_2017$map$PC1
pc1_2020 <- pca_2020$map$PC1

# faccio un par() e plotto le pc1...
par(mfrow = c(1, 2))
plot(pc1_2017, col = cl_pca, main = 'PC1 2017')
plot(pc1_2020, col = cl_pca, main = 'PC1 2020')

# Calcoliamo la variabilità sulla pc1 per entrambi gli anni 
# Faccio passare la moving windown sulla pc1 2017 e poi 2020.
# Uso questa palette:
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow')) (200)
# funzione focal():
pc1_2017_sd3 <- focal(pc1_2017, w = matrix(1/9, nrow = 3, ncol = 3), fun = sd)
pc1_2020_sd3 <- focal(pc1_2020, w = matrix(1/9, nrow = 3, ncol = 3), fun = sd)
# plot():
par(mfrow = c(1,2))
plot(pc1_2017_sd3, col = cl_sd, main = '2017')
plot(pc1_2020_sd3, col = cl_sd, main = '2020')

#







