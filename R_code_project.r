# R_code_project.r

# Progetto esame

# Librerie
require(raster)
require(RStoolbox)
require(ggplot2) 
require(gridExtra)

# Working Directory 
setwd("C:/lab/desert/")

# Import dei dati (scaricati dall'earth observer della nasa)
desert <- brick("namibia.jpg")

# visualizziamo informazioni relative al dato
desert
# class      : RasterBrick 
# dimensions : 3618, 5427, 19634886, 3  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 5427, 0, 3618  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/lab/desert/namibia.jpg 
# names      : namibia.1, namibia.2, namibia.3  --> bande (rosse, verde, blue)
# min values :         0,         0,         0 
# max values :       255,       255,       255

# Plot RGB
plotRGB(desert, r = 1, g = 2, b = 3, stretch = 'lin')

# ricavo le firme spettrali...
click(desert, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'green')

# x      y     cell namibia.1 namibia.2 namibia.3
# 1  611.5  812.5 15223347       225       154        72
# 2 3995.5 2850.5  4166505       165       130        88
# 3 1506.5 1218.5 13020880        79        58        29

# creo un dataframe con le percentuali di copertura...
spectrals <- data.frame(bandz, dune, northarea, river)
spectrals
# bandz dune northarea river
# 1     1  225       165    79
# 2     2  154       130    58
# 3     3   72        88    29
