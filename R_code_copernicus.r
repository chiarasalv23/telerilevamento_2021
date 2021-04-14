#R_code_copernicus.r
#Visualizing copernicus data
#______________________________________
            #FCOVER 
#_______________________________________
#estensione spaziale della vegetazione!
#______________________________________

install.packages("ncdf4")
#richiamiamo i due pacchetti...
library(raster)
library(ncdf4)

#facciamo il setting della working directory:
setwd("C:/lab/FCOVER/") #"" perché usciamo da R

#assegno il dato alla variabile
fcover <- raster("c_gls_FCOVER_202006130000_GLOBE_PROBAV_V1.5.1.nc") #è un solo strato (non serve usare brick)
fcover #vediamo le informazioni 

#facciamo il primo plottaggio della nostra immagine
#siccome non usiamo uno schema RGB, in quanto non abbiamo bande (strati) da montare sulle componenti RGB
#abbiamo un singolo strato quindi possiamo decidere noi una colorramppalette! Ovviamente i colori saranno funzioni dei valori numerici...

cl <- colorRampPalette(c("orange", "yellow", "green", "darkgreen")) (200) #valori minimi di fcover -->> valori maggiori di fcover
plot(fcover, col = cl, main = "GLOBAL FCOVER") #con la funzione main metto il titolo in testa al grafico
#deserto -> valori minimi (orange)
#europa -> valori molto alti (darkgreen)

#Ricampionamento - resampling
fcoverres <- aggregate(fcover, fact = 100)
#creo questa nuova variabile per il dato ricampionato
#utilizzo la funzione aggregate in cui metto come argomento il dato originale e il fattore di ricampionamento
#come funziona fact sta scritto sugli appunti, ricopiatelo, pigra!
plot(fcoverres, col = cl, main = "GLOBAL FCOVER RESAMPLED") #eseguo di nuovo il plottaggio ma con il dato ricampionato
#Si perdono molte informazioni 




