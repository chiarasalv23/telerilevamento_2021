# R_code_variability.r

# Ghiacciaio del Similaun

# DAY 1

# librerie
require(raster)
require(RStoolbox)

# Set working directory
setwd("C:/lab/")

# Carichiamo sentinel.png
sent <- brick("sentinel.png")

# Plottaggio...
# NIR = 1, RED = 2, GREEN = 3
plotRGB(sent) # Stretch automatico lineare
#plotRGB(sent, r = 1, g = 2, b = 3, stretch = "lin")

plotRGB(sent, r = 2, g = 1, b = 3, stretch = "lin")
sent
# class      : RasterBrick 
# dimensions : 794, 798, 633612, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 798, 0, 794  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/lab/sentinel.png 
# names      : sentinel.1, sentinel.2, sentinel.3, sentinel.4 
# min values :          0,          0,          0,          0 
# max values :        255,        255,        255,        255 

# Assegnamo le singole bande a variabili per richiamarle più easy...
nir <- sent$sentinel.1
red <- sent$sentinel.2
ndvi = (nir - red) / (nir + red)
plot(ndvi)

# Cambio palette...
cl <- colorRampPalette(c('black', 'white', 'red', 'magenta', 'green')) (200)
plot(ndvi, col = cl)

# Adesso calcoliamo la variabilità dell'immagine!
#funzione focal() per usare la moving window
ndvisd3 <- focal(ndvi, w = matrix(1/9, nrow = 3, ncol = 3), fun = sd)
# Cambiamo la palette...
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow')) (200) 
plot(ndvisd3, col=clsd)

# calcoliamo la media della biomassa...
ndvimean3 <- focal(ndvi, w = matrix(1/9, nrow = 3, ncol = 3), fun = mean)
plot(ndvimean3, col = clsd)

# Cambiamo la grandezza della moving window...
# 13 x 13 Standard Deviation
ndvisd13 <- focal(ndvi, w = matrix(1/169, nrow = 13, ncol = 13), fun = sd)
plot(ndvisd13, col = clsd)
# 5 x 5 Standard Deviation
ndvisd5 <- focal(ndvi, w = matrix(1/25, nrow = 5, ncol = 5), fun = sd)
plot(ndvisd5, col = clsd)

# Facciamo l'analisi delle componenti principali
# PCA
sentpca <- rasterPCA(sent)
plot(sentpca$map)

# Per vedere quanta variabilità spiegano le singole componenti...
summary(sentpca$model)
# Importance of components:
#                           Comp.1     Comp.2      Comp.3
# Standard deviation     77.3362848 53.5145531 5.765599616
# Proportion of Variance  0.6736804  0.3225753 0.003744348  (Prop. di var. spiegata)
# Cumulative Proportion   0.6736804  0.9962557 1.000000000
#                       Comp.4
# Standard deviation          0
# Proportion of Variance      0
# Cumulative Proportion       1

# La prima PC spiega il 67.36% delle informazioni originali. 

# DAY 2

# Dichiaro nuovamente le librerie e setto la working directory
library(ggplot2)
library(gridExtra)
library(viridis) # serve per i colori, per colorare i plot di ggplot in modo automatico!
# sent <- brick("sentinel.png")
# sentpca <- rasterPCA(sent)
# plot(sentpca)
# summary(sentpca)
# sentpca per vedere tutte le variabilità (vedi day 1)
# PC1 --> ha più info all'interno dell'immagine
# Funzione focal per passare la moving window e calcolare la deviazione standard (variabilità di tutti i dati originali) e la riportavamo sul valore centrale. 
# Sposto la moving window e il processo riparte! 

sentpca$map$PC1 #seleziono solo la PC1...
# Calcoliamo la variabilità sulla pc1
# Moving window 3 x 3
pc1sd3 <- focal(pc1, w = matrix(1/9, nrow = 3, ncol = 3), fun = sd)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow')) (200) 
plot(pc1sd3, col=clsd) # come cambiano i valori su una singola banda
# Moving window 5 x 5 
pc1sd5 <- focal(pc1, w=matrix(1/25, nrow=5, ncol=5), fun=sd)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow')) (200) 
plot(pc1sd5, col=clsd)

# source() test!
source("source_test_lezione.r") # Per prendere e caricare un codice dall'esterno!

# Plottare i nostri dati tramite ggplot2
#ggplot() # mi crea una finestra vuota
ggolot() + 
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer))

ggplot() + 
+ geom_raster(pc1sd3, mapping = aes(x = x, y = y, fill = layer))

# Usando viridis!
ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) +
scale_fill_viridis()

ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) +
scale_fill_viridis()  +
ggtitle("Standard deviation of PC1 by viridis colour scale")

ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) +
scale_fill_viridis(option = "magma")  +
ggtitle("Standard deviation of PC1 by magma colour scale")

# grid arrange
# associamo ogni plottaggio ad un oggetto...
p1 <- ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) +
scale_fill_viridis()  +
ggtitle("Standard deviation of PC1 by viridis colour scale")

p2 <- ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) +
scale_fill_viridis(option = "magma")  +
ggtitle("Standard deviation of PC1 by magma colour scale")

p3 <- ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) +
scale_fill_viridis(option = "turbo")  +
ggtitle("Standard deviation of PC1 by turbo colour scale")

grid.arrange(p1, p2, p3, nrow = 1)

# ----- END -----

