# R_code_vegetation_indexes.r
library(raster)
setwd("C:/lab/")

# DAY 1

#carichiamo i dati defor1.jpg e defor2.jpg -> Earth Observatory NASA
defor1 <- brick("defor1.jpg")
defor2 <- brick("defor2.jpg")

#facciamo un par per plottare le due immagini per vedere i cambiamenti nell'area
par(mfrow = c(2,1))
plotRGB(defor1, r = 1, g = 2, b = 3, stretch = 'lin')
plotRGB(defor2, r = 1, g = 2, b = 3, stretch = 'lin')

# DAY 2
#richiamo i pacchetti che mi servono...
require(RStoolbox) #per usare alcune funzioni per gli indici di vedetazione
#setto la working directory...
#defor1 e defor2 -> sito in cui è stata fatta una forte deforestazione
#siamo a Rio Peixoto Brazil! 
#le carichiamo e le riplottiamo...

defor1 #vedo le info del file e le sue bande (vedere come si chiamano)
# NIR: defor1.1, RED: defor1.2, GREEN: defor1.3
#CALCOLO DVI per defor1 
#NIR - RED
dvi1 <- defor1$defor1.1 - defor1$defor1.2 #per ogni pixel prendiamo il valore NIR meno valore RED
#in uscita abbiamo una mappa formata da tanti pixel che sono la diffrenza dell'NIR e RED -> DVI difference vegetation index!
plot(dvi1)

#cambiano la palette di colori
#colorRampPalette
cl <- colorRampPalette(c('darkblue', 'yellow', 'red', 'black')) (200)
plot(dvi1, col = cl, main = 'DV1 at time 1')

#CALCOLO DVI per defor2
dvi2 <- defor2$defor2.1 - defor2$defor2.2
plot(dvi2, col = cl, main = 'DVI at time 2') 

#par per vederli insieme... 
par(mfrow = c(1, 2))
plot(dvi1, col = cl, main = 'DV1 at time 1')
plot(dvi2, col = cl, main = "DVI at time 2")

#Vedere l'andamento e cosa è cambiato da defor1 a defor2
difdvi <- dvi1 - dvi2 #differenza dei due momenti temporali
#creo una nuova colorRampPalette
cld <- colorRampPalette(c('blue', 'white', 'red')) (200)
plot(difdvi, col = cld, main = 'Difference DVI1 and DV2')

#CALCOLO NDVI1 e NDV2
# (NIR - RED) / (NIR + RED)
ndvi1 <- (defor1$defor1.1 - defor1$defor1.2) / (defor1$defor1.1 + defor1$defor1.2)
ndvi2 <- (defor2$defor2.1 - defor2$defor2.2) / (defor2$defor2.1 + defor2$defor2.2)

#plot con par
par(mfrow = c(1, 2))
plot(ndvi1, col = cl, main = 'NDVI at time 1')
plot(ndvi2, col = cl, main = "NDVI at time 2")

#Vedere l'andamento e cosa è cambiato da defor1 a defor2
difndvi <- ndvi1 - ndvi2
#plot
plot(difndvi, col = cld, main = 'Difference between NDVIs') #mostra le aree con maggior perdita di vegetazione :( 

#usiamo la funzione spectralindices() di RStoolbox...
#come usare r from scratch, ossia da 0
#per defor1
vi1<- spectralIndices(defor1, green = 3, red = 2, nir = 1)
plot(vi1, col = cl)
#per defor2
vi2<- spectralIndices(defor2, green = 3, red = 2, nir = 1)
plot(vi2, col = cl)

# DAY 3
# --- WORLD WIDE NDVI ---
# Pacchetto rasterdiv
install.packages("rasterdiv")
require(rasterdiv) #for world wide NDVI
#plottiamo il nostro set copNDVI che contiene NDVI medio per ogni 21 Giugno dal 1999 al 2017
plot(copNDVI)
#togliamo l'acqua...
#sovrascrivo il dataset senza i valori...
copNDVI <- reclassify(copNDVI, cbind(253:255, NA)) #ai valori NDVI da 253 a 255 assegnamo NA (non assigned)
plot(copNDVI)
#per usare levelplot dobbiamo prima...
require(rasterVis)
#cosa fa levelplot? mostra la media dei valori sulle righe e sulle colonne
levelplot(copNDVI)

# --- E N D --- 
