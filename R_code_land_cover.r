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

# DAY 2
#Caricare i pacchetti dell'altra volta... RStoolbox, raster, ggplot!
#anche library(gridExtra)
#set della working directory
setwd("C:/lab/")
#usiamo sempre i dati defor1.jpg e defor2.jpg
defor1 <- brick("defor1.jpg")
defor2 <- brick("defor2.jpg")
defor1 #vediamo come i dati processati perdono l'info SR
#uguale se vedo defor2

# UNSUPERVISED CLASSIFICATION
# Classi: 
# 1: Agricolo
# 2: Foresta Amazzonica
d1c <- unsuperclass(defor1, nClasses = 2)
d1c #vediamo le info...
plot(d1c$map)
#set.seed() per ottenere sempre lo stesso risultato
#facciamo la classificazione anche con defor2
d2c <- unsuperClass(defor2, nClasses = 2)
plot(d2c$map)

#facciamo la class con 3 classi per defor2...
d2c3 <- unsuperClass(defor2, nClasses = 3)
plot(d2c3$map)

#calcoliamo la frequenza dei pixel in una certa classe...
freq(d1c$map)
#     value  count
# [1,]     1 308393
# [2,]     2  32899

#calcoliamo la proporzione!
s1 <- 308393 + 32899
prop1 <- freq(d1c$map) / s1
prop1
#           value      count
# [1,] 2.930042e-06 0.90360454
# [2,] 5.860085e-06 0.09639546

s2 <- 342726
prop2 <- freq(d2c$map) / s2
prop2
#           value     count
# [1,] 2.917783e-06 0.4796776
#[2,] 5.835565e-06 0.5203224

#build a dataframe!
cover <- c("Forest", "Agriculture")
percent_1992 <- c(90.36, 9.63)
percent_2006 <- c(52.03, 47.96)
percentages <- data.frame(cover, percent_1992, percent_2006)
percentages
#     cover percent_1992 percent_2006
# 1      Forest        90.36        52.03
# 2 Agriculture         9.63        47.96

#  LET'S PLOT EM ALL! Using ggplot()
ggplot(percentages, aes(x = cover, y = percent_1992, color = cover)) + geom_bar(stat = "identitity", fill = "orange") # color = cover per distinguere le due classi...

#gridExtra!
#creo dei plottaggi
p1 <- ggplot(percentages, aes(x = cover, y = percent_1992, color = cover)) + geom_bar(stat = "identity", fill = "orange")
p2 <- ggplot(percentages, aes(x = cover, y = percent_2006, color = cover)) + geom_bar(stat = "identity", fill = "yellow")
#li metto dentro un grafico che mostra i cambiamenti multitemporali in forma di istogrammi
grid.arrange(p1, p2, nrow = 1) 

# --- E N D ---
