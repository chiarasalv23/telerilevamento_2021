# R_code_spectral_signatures.r

# FIRME SPETTRALI

# Pacchetti:
require(raster)
require(rgdal) # serve per lavorare con punti e linee (vettori)
require(ggplot2)

# set della working directory:
setws("C:/lab/")

# Carico tutte le bande con brick()
defor2 <- brick("defor2.jpg") 

# vedo informazioni 
defor2

# class      : RasterBrick 
# dimensions : 478, 717, 342726, 3  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 717, 0, 478  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/lab/defor2.jpg 
# names      : defor2.1, defor2.2, defor2.3   -> NIR, RED, GREEN
# min values :        0,        0,        0 
# max values :      255,      255,      255


# Facciamo un plot RGB
plotRGB(defor2, r = 1, g = 2, b = 3, stretch = 'lin')

# Funzione per creare le firme spettrali: click() è una funzione dinamica
# bisogna aver dichiarato rgdal
# ci darà info relative alla riflettanza
# lasciare il plot aperto sennò da errore!
click(defor2, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'green')
# valori di riflettanza nelle diverse bande
#      x     y  cell defor2.1 defor2.2 defor2.3
# 1 197.5 370.5 76917      185      181      170   --> forest
#       x     y   cell defor2.1 defor2.2 defor2.3
# 1 344.5 328.5 107178      203       12       17  --> agriculture
#       x     y   cell defor2.1 defor2.2 defor2.3
# 1 128.5 224.5 181530      101       57       93   --> water

# creiamo dataframe con le percentuali di copertura
# creiamo una tabellina con 4 colonne
# definiamo i dati...

band <- c(1, 2, 3)
forest <- c(206, 6, 19)
water <- c(40, 99, 139)

# dataframe...
spectrals <- data.frame(band, forest, water)

# plot delle firme spettrali...
ggplot(spectrals, aes(x = band)) +  # apre il grafico
geom_line(aes(y = forest), color = "green") + # inserisce le geometrie (linee)
geom_line(aes(y=water), color="blue")

#      x     y   cell defor1.1 defor1.2 defor1.3
# 1 116.5 267.5 150057      219       13       33
#       x     y   cell defor1.1 defor1.2 defor1.3
# 1 125.5 159.5 227178      188       14       23
#       x     y   cell defor1.1 defor1.2 defor1.3
# 1 237.5 207.5 193018      204        8       22
#      x     y  cell defor1.1 defor1.2 defor1.3
# 1 238.5 414.5 45221      220       13       29
#       x     y  cell defor1.1 defor1.2 defor1.3
# 1 670.5 423.5 39227      211        0       17


#      x     y  cell defor2.1 defor2.2 defor2.3
# 1 78.5 439.5 27325      199       15       25
#       x     y   cell defor2.1 defor2.2 defor2.3
# 1 157.5 278.5 142841      206       11       28
#      x     y   cell defor2.1 defor2.2 defor2.3
# 1 87.5 200.5 198697      217       19       34
#       x     y   cell defor2.1 defor2.2 defor2.3
# 1 687.5 174.5 217939      193       10       15
#       x     y  cell defor2.1 defor2.2 defor2.3
# 1 625.5 433.5 32174      213       33       36

# definiamo le colonne del dataset...
band <- c(1, 2, 3)
time1 <- c(219, 13, 33)
time2 <- c(199, 15, 25)

spectrals_temp <- data.frame(band, time1, time2)

# plot the sepctral signatures
ggplot(spectrals_temp, aes(x=band)) +
+     geom_line(aes(y=time1), color="red") +
+     geom_line(aes(y=time2), color="gray") +
+     labs(x="band",y="reflectance")


# definiamo le colonne del dataset...
band <- c(1, 2, 3)
time1 <- c(219, 13, 33)
time1p2 <- c(188, 14, 23) # aggiungiamo il secondo pixel
time2 <- c(199, 15, 25) 
time2p2 <- c(206, 11, 28) # aggiungiamo il secondo pixel

spectrals_temp2 <- data.frame(band, time1, time2, time1p2, time2p2)

# plot the sepctral signatures
ggplot(spectralst, aes(x=band)) +
 geom_line(aes(y=time1), color="red") +
 geom_line(aes(y=time1p2), color="red") +
 geom_line(aes(y=time2), color="gray") +
 geom_line(aes(y=time2p2), color="gray") +
 labs(x="band",y="reflectance")
 
# proviamo con un'immagine dell'EO
# lakevictoria.jpg
 
eo <- brick("lakevictoria.jpg")
plotRGB(eo, r = 1, g = 2, b = 3, stretch = 'hist')

# x     y   cell lakevictoria.1 lakevictoria.2 lakevictoria.3
# 1 388.5  91.5 279749             71            129             45
# 2 384.5 145.5 240865            154            144             73
# 3 497.5 333.5 105618             78             96             44

band <- c(1, 2, 3)
water1 <- c(71, 129, 45)
water2 <- c(154, 144, 73)
water3 <- c(78, 96, 44)

ggplot(spectrals_w, aes(x = band)) +
+ geom_line(aes(y = water1), color = "blue") +
+ geom_line(aes(y = water2), color = "cyan") +
+ geom_line(aes(y = water3), color = "green") +
+ labs(x = "band",y = "reflectance")
