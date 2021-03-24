# R for remote sensing!

#install.packages("raster") #raster è esterno a r

library(raster) #adesso è interno ad r

setwd("C:/lab/") #percorso windows
p224r63_2011 <- brick("p224r63_2011_masked.grd") #assegnazione ad una variabile di un dataset
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
cls <- colorRampPalette(c("purple", "magenta", "orange", "yellow")) (100)
plot(p224r63_2011, col=cls) 

#DAY3
library(raster) #richiamo la libreria raster
#loading pacchetto sp -> pacchetto con classi e metodi per dati spaziali!
setwd("c:/lab/") #dico al sistema dove sono i dati con cui devo lavorare...
p223r63_2011 <- brick("p224r63_2011_masked.grd") #virgolette perché il dataset è esterno ad r

#plottaggio del dataset con la colorramppalette
cls <- colorRampPalette(c("purple", "magenta", "orange", "yellow")) (100)
plot(p224r63_2011, col=cls) 

#voglio vedere le info relative al dataset con cui sto lavorando
p224r63_2011 #mi escono tutte le info relative alle bande che compongono la mia immagine 

#Bande landsat
#B1: blu, B2: verde, B3: rosso, B4: NIR, B5: MIR, B6: TIR (FAR), B7: MIR

#plottaggio della singola banda
#ripulisco la mia finestra del grafico
dev.off()

#voglio plottare solo la banda B1_sre (blu)
plot(p224r63_2011$B1_sre) #lego la singola banda al dataset totale
#il plottaggio avviene con la palette di default di r
#plottaggio B1_sre con palette personalizzata

clb <- colorRampPalette(c("blue", "orange", "green")) (200)
plot(p224r63_2011$B1_sre, col=clb)

dev.off() #puliamo again...

#funzione par() per righe
#una riga, due colonne
par(mfrow = c(1, 2))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
dev.off()
#due righe, una colonna
par(mfrow = c(2, 1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
dev.off()
#funzione par() per colonne
#una riga, due colonne
par(mfcol = c(1, 2))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
dev.off()
#due righe, una colonna
par(mfcol = c(2, 1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
dev.off()
#plottare le prime 4 bande landsat B1, B2, B3, B4
#SU 4 RIGHE E 1 COLONNA
par(mfrow = c(4, 1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)
dev.off()
#anche se così viene un po' brutto...
#adesso mettiamole 2x2 che è più ordinato...
par(mfrow = c(2,2))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)
dev.off()

#due righe e due colonne creando delle palette che richiamino i colori delle diverse bande...
par(mfrow = c(2,2))
#Blu 
clblu <- colorRampPalette(c("dark blue", "blue", "light blue")) (200)
plot(p224r63_2011$B1_sre, col=clblu)
#Verde
clgreen <- colorRampPalette(c("dark green", "green", "light green")) (200)
plot(p224r63_2011$B2_sre, col=clgreen)
#Rosso
clred <- colorRampPalette(c("dark red", "red", "pink")) (200)
plot(p224r63_2011$B3_sre, col=clred)
#NIR
clnir <- colorRampPalette(c("red", "orange", "yellow")) (200)
plot(p224r63_2011$B4_sre, col=clnir)

dev.off()

