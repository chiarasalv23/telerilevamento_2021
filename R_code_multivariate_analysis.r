# R_code_multivariate_analysis.r

#ANALISI MULTIVARIATA - MULTIVARIATE ANALYSIS
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

# end #

