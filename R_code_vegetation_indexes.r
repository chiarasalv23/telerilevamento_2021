# R_code_vegetation_indexes.r
library(raster)
setwd("C:/lab/")

# DAY 1

#carichiamo i dati defor1.jpg e defor2.jpg
defor1 <- brick("defor1.jpg")
defor2 <- brick("defor2.jpg")

#facciamo un par per plottare le due immagini per vedere i cambiamenti nell'area
par(mfrow = c(2,1))
plotRGB(defor1, r = 1, g = 2, b = 3, stretch = 'lin')
plotRGB(defor2, r = 1, g = 2, b = 3, stretch = 'lin')
