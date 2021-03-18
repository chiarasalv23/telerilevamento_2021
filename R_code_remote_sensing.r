# R for remote sensing!

#install.packages("raster") #raster è esterno a r

library(raster) #adesso è interno ad r

setwd("C:/lab/") #percorso windows
p224r63_2011 <- brick("p224r63_2011_masked.grd")
p224r63_2011 #richiamo l'oggetto 

#si può fare il plot di tutte le immagini
plot(p224r63_2011) #tante immagini quante sono le bande (dal blu al termico)

#colorRampPalette, funzione per cambiare la variazione dei colori
#colorRampPalette("black", "grey", "lightgrey")
#colorRampPalette(c("black", "grey", "lightgrey")) (100) #100 sono i lvl intermedi di colore
#assegno la palette ad un oggetto cl
cl <- colorRampPalette(c("black", "grey", "lightgrey")) (100)

#adesso eseguo di nuovo il plot ma con la nuova palette di colori!
plot(p224r63_2011, col = cl) #colore = alla palette creata da me

#color change! Da viola, magenta, arancione e giallo.
cl <- colorRampPalette(c("purple", "magenta", "orange", "yellow")) (100)
plot(p224r63_2011, col=cl) 
