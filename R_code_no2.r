# R.code_no2.r
# Fase 0: importiamo le librerie di cui abbiamo bisogno
# i pacchetti li mettiamo sempre all'inizio
require(raster) 
require(RStoolbox)

# Fase 1: set della working directory sulla cartella EN (dove sono stati messi i dati)
setwd("C:/lab/EN")

# Fase 2: importiamo i dati
# vogliamo selezionare il primo strato dell'immagine
EN_0001 <- raster("EN_0001.png")

# Fase 3: plottiamo l'immagine con la colorRampPalette
cl <- colorRampPalette(c("blue", "cyan", "yellow", "orange", "red")) (200) # colorRampPalette
plot(EN_0001, col = cl) # plottaggio del dato con la colorRampPalette

# Fase 4: importiamo la tredicesima immagine e la plottiamo con la precedente colorRampPalette
EN_0013 <- raster("EN_0013.png") # import...
plot(EN_0013, col = cl) # plot

# Si nota come i livelli di No2 siano inferiori. La situazione è migliorata.

# Fase 5: Fare la differenza delle due immagini, la associamo ad un ogg e la plottiamo. 
diff_no2 <- EN_0001 - EN_0013
plot(diff_no2, col = cl)

# Fase 6: fare il par
par(mfrow = c(1, 3))
>plot(EN_0001, col = cl, main = "No2 in January")
plot(EN_0013, col = cl, main = "No2 in March")
plot(diff_no2, col = cl, main = "Difference (January - March)")

# Fase 7: importare sempre la prima banda di tutto il set
# uso list.files() e un pattern
# 7.1
rlist <- list.files(patter = "EN")
rlist
# [1] "EN_0001.png" "EN_0002.png" "EN_0003.png" "EN_0004.png"
# [5] "EN_0005.png" "EN_0006.png" "EN_0007.png" "EN_0008.png"
# [9] "EN_0009.png" "EN_0010.png" "EN_0011.png" "EN_0012.png"
# [13] "EN_0013.png"
# 7.2
import <- lapply(rlist,raster)
# 7.3
EN <- stack(import)
plot(EN, col = cl)

# Fase 8: replicare il plot delle immagini 1 e 13 utilizzando lo stack
par(mfrow = c(2,1))
plot(EN$EN_0001, col = cl)
plot(EN$EN_0013, col = cl)

# Fase 9: andiamo a fare la PCI sulle 13 immagini 
# Fare la PCA sullo stack
# Fare plot RGB con le prima 3 componenti
en_pca <- rasterPCA(EN)
plotRGB(en_pca$map, r = 1, g = 2, b = 3, stretch = 'lin')
# dove è più rosso è dove la situazione si è mantenuta più stabile
summary(en_pca$model) # vedo le statistiche delle componenti, come sono spiegate

# Fase 10: calcolare la variabilità (dev. st. locale - moving windown) della prima componente
pc1sd <- focal(en_pca$map$PC1, w = matrix(1/9, nrow = 3, ncol = 3), fun = sd) 
plot(pc1sd, col = cl)

# ----- FINE -----

