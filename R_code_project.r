# R_code_project.r

# Progetto esame
# 0)
# Librerie
require(raster)
require(RStoolbox)
require(ggplot2) 
require(gridExtra)


# Working Directory 
setwd("C:/lab/canada/")

# 1)
# Creo delle liste con tutti i files contententi il pattern '2017' e poi '2020'. 
# Così in queste liste ci saranno tutti i file del 2017 (bande singole)
list_2017 <- list.files(pattern = "2017")
list_2020 <- list.files(pattern = '2020')

# Usiamo lapply() per applicare la funzione raster() a tutti i dati dentro la lista
import_2017 <- lapply(list_2017, raster)
import_2020 <- lapply(list_2020, raster)

# Creo degli stack con che tutti i file delle liste a cui è stata applicata la funzione raster()
stack_2017 <- stack(import_2017)
stack_2020 <- stack(import_2020)

# 2)
# BANDE LANDSAT 8 
# Adesso creo delle variabili per ogni sigola banda che richiamo direttamente dallo stack.
# Bande 2017
cost_2017 <- stack_2017$X046017_2017_B1
blue_2017 <- stack_2017$X046017_2017_B2
green_2017 <- stack_2017$X046017_2017_B3
red_2017 <- stack_2017$X046017_2017_B4
nir_2017 <- stack_2017$X046017_2017_B5
swir_2017 <- stack_2017$X046017_2017_B6
# Bande 2020
cost_2020 <- stack_2020$X046017_2020_B1
blue_2020 <- stack_2020$X046017_2020_B2
green_2020 <- stack_2020$X046017_2020_B3
red_2020 <- stack_2020$X046017_2020_B4
nir_2020 <- stack_2020$X046017_2020_B5
swir_2020 <- stack_2020$X046017_2020_B6

# 3)
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

# 4)
# NDVI - Indice di vegetazione normalizzato
# Creo una palette che spieghi questo indice di vegetazione. 
cl_ndvi <- colorRampPalette(c("dark red", "red", "orange", "yellow","lime green", "green", "dark green"))(500)) # Palette per NDVI
ndvi_2017 <- (nir_2017 - red_2017) / (nir_2017 + red_2017)
ndvi_2020 <- (nir_2020 - red_2020) / (nir_2020 + red_2020)

par(mfrow = c(1,2))
plot(ndvi_2017, col = cl_ndvi, main = 'Great Slave Lake, 31/8/2017 NDVI')
plot(ndvi_2020, col = cl_ndvi, main = 'Great Slave Lake, 20/6/2020 NDVI')

# Differenza tra i due NDVI
diff_ndvi <- ndvi_2017 - ndvi_2020
plot(diff_ndvi, col = cl_ndvi, main = 'Difference NDVI from 2017 to 2020')


# 5)
# PCA - Analisi delle componenti principali
# Creo una palette
# Palette più bella mai creata!
cl_pca <- colorRampPalette(c('darkblue', 'aquamarine', 'yellow', 'red')) (300)

# Faccio la PCA sull'immagine a colori naturali.
pca_2017 <- rasterPCA(nci_2017)
pca_2020 <- rasterPCA(nci_2020)

# se plotto mi escono tutte e tre le componenti...
# non serve che plotto...
# vediamo le statistiche sulle componenti

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

# Adesso faccio la PCA usando l'immagine fci
pca_fci_2017 <- rasterPCA(fci_2017)
pca_fci_2020 <- rasterPCA(fci_2020)

# statistiche sulle componenti...
summary(pca_fci_2017$model)
# Importance of components:
#                              Comp.1       Comp.2       Comp.3
# Standard deviation     3238.3716046 1.012720e+03 1.669215e+02
# Proportion of Variance    0.9087159 8.886973e-02 2.414346e-03
# Cumulative Proportion     0.9087159 9.975857e-01 1.000000e+00

# la componente 1 spiega il 90,87% delle informazioni.

summary(pca_fci_2020$model)
# Importance of components:
#                              Comp.1       Comp.2       Comp.3
# Standard deviation     3337.0064542 1330.5238924 2.335836e+02
# Proportion of Variance    0.8591984    0.1365918 4.209824e-03
# Cumulative Proportion     0.8591984    0.9957902 1.000000e+00

# la componente 1 spiega l'85,91% delle informazioni.

# creo delle variabili e gli assegno SOLO la PC1 di ogni anno
pc1_2017 <- pca_2017$map$PC1
pc1_2020 <- pca_2020$map$PC1

# lo faccio anche per fci
pc1_fci_2017 <- pca_fci_2017$map$PC1
pc1_fci_2020 <- pca_fci_2020$map$PC1

# faccio un par() e plotto le pc1...
par(mfrow = c(1, 2))
plot(pc1_2017, col = cl_pca, main = 'PC1 2017')
plot(pc1_2020, col = cl_pca, main = 'PC1 2020')

# stessa cosa per fci
par(mfrow = c(1,2))
plot(pc1_fci_2017, col = cl_pca, main = 'PC1 FCI 2017')
plot(pc1_fci_2020, col = cl_pca, main = 'PC1 FCI 2020')

# 6)
# Calcoliamo la deviazione standard sulla pc1 per entrambi gli anni!
# La variabilità spaziale è un indicatore della biodiversità. 
# Più il valore è alto, maggiore sarà la variabilità spaziale.
# Faccio passare la moving window 3x3 sulla pc1 2017 e poi 2020.
# Uso questa palette:
cl_sd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow')) (200)
# 6.1) per dato nci
# funzione focal():
pc1_2017_sd3 <- focal(pc1_2017, w = matrix(1/9, nrow = 3, ncol = 3), fun = sd)
pc1_2020_sd3 <- focal(pc1_2020, w = matrix(1/9, nrow = 3, ncol = 3), fun = sd)
# plot():
par(mfrow = c(1,2))
plot(pc1_2017_sd3, col = cl_sd, main = '2017')
plot(pc1_2020_sd3, col = cl_sd, main = '2020')


# stessa cosa per fci
pc1_fci_2017_sd3 <- focal(pc1_fci_2017, matrix(1/9, nrow = 3, ncol = 3), fun = sd)
pc1_fci_2020_sd3 <- focal(pc1_fci_2020, matrix(1/9, nrow = 3, ncol = 3), fun = sd)
# plot()
par(mfrow = c(1,2))
plot(pc1_fci_2017_sd3, col = cl_sd, main = 'PC1 fci 2017')
plot(pc1_fci_2020_sd3, col = cl_sd, main = 'PC1 fci 2020')


# 7) Firme spettrali
# Estrazione delle firme spettrali con funzione click()
# prima plotto il dato da cui voglio estrarre la firma e poi uso la funzione 
# click() per cliccare direttamente sull'immagine il pixel da cui voglio estrarre la firma.

# Estraggo le firme spettrali dall'immagine true colors (nci)
# 2017
plotRGB(nci_2017, axes = TRUE, stretch = 'lin', main = 'Natural color image 2017')
click(nci_2017, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'red')
# x       y     cell X046017_2017_B4 X046017_2017_B3 X046017_2017_B2
# 1 705750 6833640 28407248            9290            9654            8322
# 2 608130 6810840 34515154            7352            7570            7475
------------------------------------------------------------------------------
# 3 548340 6807630 35373548            9531            9492            8776
# 4 661050 6753810 49802859            8418            8527            7768
# 5 683400 6722790 58117998            8265            8033            7720

# 2020
plotRGB(nci_2020, axes = TRUE, stretch = 'lin', main = 'Natural color image 2020')
click(nci_2020, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'red')

# x       y     cell X046017_2020_B4 X046017_2020_B3 X046017_2020_B2
# 1 687570 6829710 29577143           10543           10283            8779
# 2 591630 6807330 35579991            7499            7935            7691
------------------------------------------------------------------------------
# 3 547320 6816900 33010245            9431            9884            8308
# 4 623160 6732420 55684389            9305            9266            8351
# 5 688920 6716430 59977764            8804            9061            8248

# inizio creando dei dataframes...
# 2017
band_nci <- c(4, 3, 2)
water_1_nci_2017 <- c(9290, 9654, 8322)
water_2_nci_2017 <- c(7352, 7570, 7475)
# 2020 
water_1_nci_2020 <- c(10543, 10283, 8779)
water_2_nci_2020 <- c(7499, 7935, 7691)

spect_water_nci_2017 <- data.frame(band_nci, water_1_nci_2017, water_2_nci_2017)
spect_water_nci_2017
#   band_nci water_1_nci_2017 water_2_nci_2017
# 1        4             9290             7352
# 2        3             9654             7570
# 3        2             8322             7475

spect_water_nci_2020 <- data.frame(band_nci, water_1_nci_2020, water_2_nci_2020)
spect_water_nci_2020
#   band_nci water_1_nci_2020 water_2_nci_2020
# 1        4            10543             7499
# 2        3            10283             7935
# 3        2             8779             7691

# plotto le firme spettrali 2017...
ggplot(spect_water_nci_2017, aes(x = band_nci)) +
geom_line(aes(y = water_1_nci_2017), color = 'blue') +
geom_line(aes(y = water_2_nci_2017), color = 'dark blue') +
labs(x = "bands",y = "reflectance")

#...e 2020!
ggplot(spect_water_nci_2020, aes(x = band_nci)) +
geom_line(aes(y = water_1_nci_2020), color = 'blue') +
geom_line(aes(y = water_2_nci_2020), color = 'dark blue') +
labs(x = "bands",y = "reflectance")

# *****
# Adesso voglio provare ad estrarre le firme spettrali della vegetazione dall'immagine fci
plotRGB(fci_2017, axes = TRUE, stretch = 'lin', main = 'False color image 2017')
click(fci_2017, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'red')

#  x       y     cell        X046017_2017_B5 X046017_2017_B4 X046017_2017_B3
# 1 683760 6740130 53470312           11731            8020            8227
# 2 581190 6855690 22492961           13257            8253            8473

plotRGB(fci_2020, axes = TRUE, stretch = 'lin', main = 'False color image 2020')
click(fci_2020, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'red')

#       x       y     cell   X046017_2020_B5 X046017_2020_B4 X046017_2020_B3
# 1 658710 6743550 52698653           13694            8807            9066
# 2 582060 6873750 17754758           14830            8601            8961

# dataframe...
band_fci <- c(5, 4, 3)
land_1_fci_2017 <- c(11731, 8020, 8227)
land_2_fci_2017 <- c(13257, 8253, 8473)
# con data frame creo la tabella...
spect_land_fci_2017 <- data.frame(band_fci, land_1_fci_2017, land_2_fci_2017)
spect_land_fci_2017

#    band_fci land_1_fci_2017 land_2_fci_2017
# 1        5           11731           13257
# 2        4            8020            8253
# 3        3            8227            8473

#adesso uso il dato fci 2020!!!
land_1_fci_2020 <- c(13694, 8807, 9066)
land_2_fci_2020 <- c(14830, 8601, 8961)
spect_land_fci_2020 <- data.frame(band_fci, land_1_fci_2020, land_2_fci_2020)
spect_land_fci_2020

#   band_fci land_1_fci_2020 land_2_fci_2020
# 1        5           13694           14830
# 2        4            8807            8601
# 3        3            9066            8961

# 2017
ggplot(spect_land_fci_2017, aes(x = band_fci)) +
geom_line(aes(y = land_1_fci_2017), color = 'dark green') +
geom_line(aes(y = land_2_fci_2017), color = 'green') +
labs(x = "bands",y = "reflectance")

# 2020
ggplot(spect_land_fci_2020, aes(x = band_fci)) +
geom_line(aes(y = land_1_fci_2020), color = 'dark green') +
geom_line(aes(y = land_2_fci_2020), color = 'green') +
labs(x = "bands",y = "reflectance")


# PROVA QUASI FALLIMENTARE - valutazione qualità dell'acqua.
lwq_2017 <- brick("c_gls_LWQ1km_201709010000_GLOBE_OLCI_V1.2.nc")
lwq_2018 <- brick("c_gls_LWQ1km_201806210000_GLOBE_OLCI_V1.2.nc")

# crop() 
ext <- extention(-117, -122, 60, 63)
ext
# class      : Extent 
# xmin       : -117 
# xmax       : -112 
# ymin       : 60 
# ymax       : 63 
lwq_extent_2017 <- crop(lwq_2017, ext)
lwq_extent_2020 <- crop(lwq_2020, ext)

# plot
par(mfrow = c(1, 2))
plot(lwq_extent_2017, col = cl_turb, main = 'Lake water quality 2017')
plot(lwq_extent_2018, col = cl_turb, main = 'Lake water quality 2018')

diff_lwq <- lwq_extent_2018 - lwq_extent_2017
plot(diff_lwq, col = cl_turb, main = 'LWQ difference from 2017 to 2018')

# ---------- END -----------   
