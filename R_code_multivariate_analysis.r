# R_code_multivariate_analysis.r

#ANALISI MULTIVARIATA - MULTIVARIATE ANALYSIS
# DAY 1
#Landsat data 
#nome immagini: p224r63_2011_masked.grd

library(raster)
library(RStoolbox)
setwd("C:/lab/")

#andiamo a caricare la prima immagine!
p224r63_2011 <- brick("p224r63_2011_masked.grd")

#Facciamo il plot selvaggggio!
plot(p224r63)

#visualizziamo le info relative all'immagine e le sue bande
p224r63_2011

#plottiamo la B1_sre con la B2_sre (blu e verde)
#  y: B2_sre, x: B1_sre
plot(p224r63_2011$B1_sre, p224r63_2011$B2_sre, col = "red", pch=19, cex = 2)
#  y: B1_sre, x: B2_sre
plot(p224r63_2011$B2_sre, p224r63_2011$B1_sre, col = "red", pch=19, cex = 2)

#pairs() mette in correlazione a due a due tutte le bande del dataset
pairs(p224r63_2011)

# DAY 2
#usiamo sempre le librerie raster e RStoolbox
#settiamo la solita working directory

#aggreghiamo i pixel con la funzione aggregate()
#fattore di ricampionamento: quante volte vogliamo aumentare la dimensione del pixel 
#usiamo la media per procedere con l'aggregazione

#Resampling con fact = 10 -> aumentiamo di 10 linearmente il nostro pixel
p224r63_2011_res <- aggregate(p224r63_2011, fact = 10)

#facciamo un par con le due immagini (originale e ricampionata)
par(mfrow = c(2,1))
plotRGB(p224r63_2011, r = 4, g = 3, b = 2, stretch = 'lin')
plotRGB(p224r63_2011_res, r = 4, g = 3, b = 2, stretch = 'lin')

#usiamo rasterPCA, ma con l'immagine che abbiamo ricampionato
p224r63_2011_res_pca <- rasterPCA(p224r63_2011_res)
#facciamo un summary del nostro modello
summary(p224r63_2011_res_pca$model)
#plottiamo la nostra $map
plot(p224r63_2011_res_pca$map)
#facciamo un plot delle 3 componenti principali...
plotRGB(p224r63_2011_res_pca$map, r = 1, g = 2, b = 3, stretch = 'lin')

# ----- END -----


