# R_code_project.r

# Progetto esame
# 0)
# Librerie
require(raster)
require(RStoolbox)
require(ggplot2) 
require(gridExtra)
require(lattice)

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



# 5)
# PCA - Analisi delle componenti principali
# Creo una palette
# Palette più bella mai creata!
cl_pca <- colorRampPalette(c('darkblue', 'aquamarine', 'yellow', 'red')) (300)

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

# Adesso faccio la PCA usando l'immagine fci
pca_fci_2017 <- rasterPCA(fci_2017)
pca_fci_2020 <- rasterPCA(fci_2020)

summary(pca_fci_2017$model)
# Importance of components:
#                              Comp.1       Comp.2       Comp.3
# Standard deviation     3238.3716046 1.012720e+03 1.669215e+02
# Proportion of Variance    0.9087159 8.886973e-02 2.414346e-03
# Cumulative Proportion     0.9087159 9.975857e-01 1.000000e+00

summary(pca_fci_2020$model)
# Importance of components:
#                              Comp.1       Comp.2       Comp.3
# Standard deviation     3337.0064542 1330.5238924 2.335836e+02
# Proportion of Variance    0.8591984    0.1365918 4.209824e-03
# Cumulative Proportion     0.8591984    0.9957902 1.000000e+00

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
# 5.1)
# e se sfruttassi anche la pc2? 
# creo le singole variabili per anno 2017 e 2020...
#...per nci...
pc2_2017 <- pca_2017$map$PC2
pc2_2020 <- pca_2020$map$PC2
#...e per fci!
pc2_fci_2017 <- pca_fci_2017$map$PC2
pc2_fci_2020 <- pca_fci_2020$map$PC2

# plot 4x4
par(mfrow = c(2, 2))
plot(pc2_2017, col = cl_pca, main = 'PC2 nci 2017')
plot(pc2_fci_2017, col = cl_pca, main = 'PC2 fci 2017')
plot(pc2_2020, col = cl_pca, main = 'PC2 nci 2020')
plot(pc2_fci_2020, col = cl_pca, main = 'PC2 fci 2020')

# 6)
# Calcoliamo la variabilità sulla pc1 per entrambi gli anni 
# Faccio passare la moving windown sulla pc1 2017 e poi 2020.
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

# prova a calcolare anche la media no?

# stessa cosa per fci
pc1_fci_2017_sd3 <- focal(pc1_fci_2017, matrix(1/9, nrow = 3, ncol = 3), fun = sd)
pc1_fci_2020_sd3 <- focal(pc1_fci_2020, matrix(1/9, nrow = 3, ncol = 3), fun = sd)
# plot()
par(mfrow = c(1,2))
plot(pc1_fci_2017_sd3, col = cl_sd, main = 'PC1 fci 2017')
plot(pc1_fci_2020_sd3, col = cl_sd, main = 'PC1 fci 2020')

# 6.3) 
# vedo con pairs() quanta correlazione c'è tra le bande...
pairs(nci_2017)
pairs(nci_2020)
pairs(fci_2017)
pairs(fci_2020)

# 7)
# Unsupervised classification con 5 classi
# su immagine a colori naturali (nci)
unscl_nci_2017 <- unsuperClass(nci_2017, nClasses = 5)
unscl_nci_2020 <- unsuperClass(nci_2020, nClasses = 5)

set.seed(23)
par(mfrow = c(1, 2))
plot(unscl_nci_2017$map, col = cl_uns_class, main = 'Uns. Class 2017')
plot(unscl_nci_2020$map, col = cl_uns_class, main = 'Uns. Class 2020')

# su immagine a falsi colori (fci)
unscl_fci_2017 <- unsuperClass(fci_2017, nClasses = 5)
unscl_fci_2020 <- unsuperClass(fci_2020, nClasses = 5)

set.seed(23)
par(mfrow = c(1, 2))
plot(unscl_fci_2017$map, col = cl_uns_class, main = 'Uns. Class 2017')
plot(unscl_fci_2020$map, col = cl_uns_class, main = 'Uns. Class 2020')

# proviamo se adesso funziona...
freq(unscl_nci_2017$map)
s_nci_2017 <- (1911633 + 13795822 + 14030951 + 10630775 + 411583 + 24439787)
prop_nci_2017 <- freq(unscl_nci_2017$map)/s_nci_2017
prop_nci_2017
# value       count
# [1,] 1.533259e-08 0.029310286
# [2,] 3.066518e-08 0.211525689
# [3,] 4.599777e-08 0.215130826
# [4,] 6.133036e-08 0.162997320
# [5,] 7.666295e-08 0.006310634
# [6,]           NA 0.374725246

# 8) Firme spettrali
# Estrazione delle firme spettrali con funzione click()
# prima plotto il dato da cui voglio estrarre la firma e poi uso la funzione 
# click() per cliccare direttamente sull'immagine il pixel da cui voglio estrarre la firma.
plotRGB(land_water_comb_2017, axes = TRUE, stretch = 'lin', main = 'Bands combination for land and water 2017')
click(land_water_comb_2017, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'red')

# mi da i valori di riflettanza nelle diverse bande...
#        x       y     cell X046017_2017_B5 X046017_2017_B6 X046017_2017_B4
# 1 717810 6824910 30747581            7696            7357            9845 # acqua bassa/torbida
# 2 627120 6815880 33164899            7249            7322            7340 # acqua profonda/limpida
# 3 572970 6856020 22404236           14236           13413            8991 # suolo verde chiaro
# 4 681720 6722040 58318967            9547           10400            8255 # suolo verde scuro
# 5 651930 6757230 48885881           12784           10261            8105 # suolo marrone 

plotRGB(land_water_comb_2020, axes = TRUE, stretch = 'lin', main = 'Bands combination for land and water 2020')
click(land_water_comb_2020, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'red')

#        x       y     cell X046017_2020_B5 X046017_2020_B6 X046017_2020_B4
# 1 688680 6825090 30817034            7849            7540           10521
# 2 617970 6824130 31072309            7192            7358            7736
# 3 557580 6845220 25410443            9220            9356           11108
# 4 697560 6741270 53311824           12457           13664            9697
# 5 649800 6746880 51804695           12882           10562            8289

par(mfrow = c(1, 2))
plotRGB(fci_2017, axes = TRUE, stretch = 'lin', main = 'False color Great Slave Lake 2017')
plotRGB(land_water_comb_2017, axes = TRUE, stretch = 'lin', main = 'False color Great Slave Lake 2017')
# questo mi dice che forse dovrei provare anche con fci...

plotRGB(fci_2017, axes = TRUE, stretch = 'lin', main = 'Fci 2017')
click(fci_2017, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'red')

# mi da i valori di riflettanza nelle diverse bande...
# x       y     cell X046017_2017_B5 X046017_2017_B4 X046017_2017_B3
# 1 714900 6827370 30088122            7665            9898            9863
# 2 607800 6819900 32086761            7245            7433            7767
# 3 658620 6751620 50389771           14715            8431            8604
# 4 639690 6751140 50517796           17359           15838           14300
# 5 697470 6716250 59871405            8610            8155            8090

plotRGB(fci_2020, axes = TRUE, stretch = 'lin', main = 'fci 2020')
click(fci_2020, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'red')

# x       y     cell X046017_2020_B5 X046017_2020_B4 X046017_2020_B3
# 1 683550 6816540 33111398            9584           11353           10512
# 2 610200 6827040 30291103            7143            7432            7946
# 3 638640 6725760 57472227           14117            8891            9158
# 4 639630 6750690 50781879           16718           12602           11797
# 5 696510 6730260 56266506           11252            9208            9180

# Voglio provare a creare un dataframe con le percentuali di copertura concentrandomi però sull'acqua...
# uso il dato fci 2017!!!
band_fci <- c(5, 4, 3)
water_1_fci_2017 <- c(7665, 9898, 9863)
water_2_fci_2017 <- c(7245, 7433, 7767)
# con data frame creo la tabella...
spect_water_fci_2017 <- data.frame(band_fci, water_1_fci_2017, water_2_fci_2017)
spect_water_fci_2017
# band_fci water_1_fci_2017 water_2_fci_2017
# 1        5             7665             7245
# 2        4             9898             7433
# 3        3             9863             7767

# plotto le firme spettrali dell'acqua
ggplot(spect_water_fci_2017, aes(x = band_fci)) +
geom_line(aes(y = water_1_fci_2017), color = 'blue') +
geom_line(aes(y = water_2_fci_2017), color = 'dark blue') +
labs(x = "bands",y = "reflectance")

#adesso uso il dato fci 2020!!!
water_1_fci_2020 <- c(9584, 11353, 10512)
water_2_fci_2020 <- c(7143, 7432, 7946)
spect_water_fci_2020 <- data.frame(band_fci, water_1_fci_2020, water_2_fci_2020)
spect_water_fci_2020
# band_fci water_1_fci_2020 water_2_fci_2020
# 1        5             9584             7143
# 2        4            11353             7432
# 3        3            10512             7946

# plotto le firme spettrali dell'acqua
ggplot(spect_water_fci_2020, aes(x = band_fci)) +
geom_line(aes(y = water_1_fci_2020), color = 'blue') +
geom_line(aes(y = water_2_fci_2020), color = 'dark blue') +
labs(x = "bands",y = "reflectance")

# Estraggo le firme spettrali dall'immagine true colors (nci)
# 2017
plotRGB(nci_2017, axes = TRUE, stretch = 'lin', main = 'Natural color image 2017')
click(nci_2017, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'red')
# x       y     cell X046017_2017_B4 X046017_2017_B3 X046017_2017_B2
# 1 705750 6833640 28407248            9290            9654            8322
# 2 608130 6810840 34515154            7352            7570            7475
# 3 548340 6807630 35373548            9531            9492            8776
# 4 661050 6753810 49802859            8418            8527            7768
# 5 683400 6722790 58117998            8265            8033            7720

# 2020
plotRGB(nci_2020, axes = TRUE, stretch = 'lin', main = 'Natural color image 2020')
click(nci_2020, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'red')

# x       y     cell X046017_2020_B4 X046017_2020_B3 X046017_2020_B2
# 1 687570 6829710 29577143           10543           10283            8779
# 2 591630 6807330 35579991            7499            7935            7691
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


# valutazione qualità dell'acqua...
lwq_2017 <- brick("c_gls_LWQ1km_201709010000_GLOBE_OLCI_V1.2.nc")
lwq_2018 <- brick("c_gls_LWQ1km_201806210000_GLOBE_OLCI_V1.2.nc")

# crop()
ext <- extention(-117, -122, 60, 63)
lwq_extent_2017 <- crop(lwq_2017, ext)
lwq_extent_2020 <- crop(lwq_2020, ext)

# plot
par(mfrow = c(1, 2))
plot(lwq_extent_2017, col = cl_turb, main = 'Lake water quality 2017')
plot(lwq_extent_2018, col = cl_turb, main = 'Lake water quality 2018')

diff_lwq <- lwq_extent_2018 - lwq_extent_2017
plot(diff_lwq, col = cl_turb, main = 'LWQ difference from 2017 to 2018')

# ---------- END ----------- 
