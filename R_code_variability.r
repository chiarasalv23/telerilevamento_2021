# R_code_variability.r

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
