# R_code_land_cover.r

# LAND-COVER
# DAY 1
#working directory 
setwd("C:/lab/")
#librerie
require(raster)
require(RStoolbox)
require(ggplot2) #ovviamente va prima installato

defor1 <- brick("defor1.jpg")
defor2 <- brick("defor2.jpg")
# banda1: NIR, banda2: RED, banda3: GREEN
plotRGB(defor1, r = 1, g = 2, b = 3, stretch = 'lin')
plotRGB(defor2, r = 1, g = 2, b = 2, stretch = 'lin')

#ggplot functions
# è più accattivante, più cool! Mi da le coordinate spaziali del mio oggetto
ggRGB(defor1, r = 1, g = 2, b = 3, stretch = 'lin') 
ggRGB(defor2, r = 1, g = 2, b = 3, stretch = 'lin')

par(mfrow=c(1,2))
plotRGB(defor1, r=1, g=2, b=3, stretch="lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="lin")

#installiamo un altro pezzettino per fare il multiframe con ggplot2 e gridExtra
require(gridExtra)
p1 <- ggRGB(defor1, r=1, g=2, b=3, stretch="lin")
p2 <- ggRGB(defor2, r=1, g=2, b=3, stretch="lin")
grid.arrange(p1, p2, nrow = 2) # li mettiamo su due righe

# -- E N D ---
