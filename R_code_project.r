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

list_2017 <- list.files(pattern = "2017")
list_2020 <- list.files(pattern = '2020')

import_2017 <- lapply(list_2017, raster)
import_2020 <- lapply(list_2020, raster)

stack_2017 <- stack(import_2017)
stack_2020 <- stack(import_2020)

# BANDE LANDSAT 8 
# B2: Blue, B3: Green, B4: Red, B5: NIR
# La B1 non mi serve in questo momento...

# Bande 2017
nir_2017 <- stack_2017$X046017_2017_B5
red_2017 <- stack_2017$X046017_2017_B4
green_2017 <- stack_2017$X046017_2017_B3
blue_2017 <- stack_2017$X046017_2017_B2
# Bande 2020
nir_2020 <- stack_2020$X046017_2020_B5
red_2020 <- stack_2020$X046017_2020_B4
green_2020 <- stack_2020$X046017_2020_B3
blue_2020 <- stack_2020$X046017_2020_B2

# NDVI 
cl_ndvi <- colorRampPalette(c("lightskyblue", "orange", "yellow"))(300) # Palette per NDVI
ndvi_2017 <- (nir_2017 - red_2017) / (nir_2017 + red_2017)
ndvi_2020 <- (nir_2020 - red_2020) / (nir_2020 + red_2020)

par(mfrow = c(1,2))
plot(ndvi_2017, col = cl_ndvi, main = 'Great Slave Lake, 31/8/2017 NDVI')
plot(ndvi_2020, col = cl_ndvi, main = 'Great Slave Lake, 20/6/2020 NDVI')

# True color images
# Creo degli stack con solo le bande VIS per ottenere delle immagini a colori naturali
nci_2017 <- stack(red_2017, green_2017, blue_2017)
nci_2020 <- stack(red_2020, green_2020, blue_2020)
# plot 
par(mfrow = c(1, 2))
plotRGB(nci_2017, axes = TRUE, stretch = 'lin', main = 'Natural color Great Slave Lake 2017')
plotRGB(nci_2020, axes = TRUE, stretch = 'lin', main = 'Natural color Great Slave Lake 2020')

# Differenza tra i due NDVI
diff_ndvi <- ndvi_2020 - ndvi_2017
plot(diff_ndvi, col = cl_ndvi)
