# R_code_project.r

# Progetto esame

# Librerie
require(raster)
require(RStoolbox)
require(ggplot2) 

# Working Directory 
setwd("C:/lab/lake/")

# Import dei dati (scaricati dall'earth observer della nasa)
vik1 <- brick("lakevictoria1.jpg")
vik2 <- brick("lakevictoria2.jpg")

# vediamo cosa vik1 e vik2 ci dicono...
vik1 
# class      : RasterBrick 
# dimensions : 2634, 3758, 9898572, 3  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 3758, 0, 2634  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/lab/lake/lakevictoria1.jpg 
# names      : lakevictoria1.1, lakevictoria1.2, lakevictoria1.3 --> sono le bande
# min values :               0,               0,               0 
# max values :             255,             255,             255 

vik2
# class      : RasterBrick 
# dimensions : 2634, 3758, 9898572, 3  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 3758, 0, 2634  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/lab/lake/lakevictoria2.jpg 
# names      : lakevictoria2.1, lakevictoria2.2, lakevictoria2.3 --> sono le bande
# min values :               0,               0,               0 
#max values :             255,             255,             255

# con ggplot creo un "par" più figo delle due immagini... 
p1 <- ggRGB(vik1, r = 1, g = 2, b = 3, stretch = 'lin') + ggtitle("Lake Victoria May 8, 2013")
p2 <- ggRGB(vik2, r = 1, g = 2, b = 3, stretch = 'lin') + ggtitle("Lake Victoria May 27, 2021")
grid.arrange(p1, p2, ncol = 2) 

# Adesso procediamo con la classificazione ? BOH? Non lo so ancora...

vik1_1 <- vik1$lakevictoria1.1
vik2_1 <- vik2$lakevictoria2.1

par(mfrow = c(1, 2))
plot(vik1_1, col = cl, main = 'Lake Victoria 1 band 1') 
plot(vik2_1, col = cl, main = 'Lake Victoria 2 band 1')

