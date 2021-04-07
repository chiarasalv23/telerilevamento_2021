#___________________GREENLAND TIME SERIES ANALYSIS______________________
#Greenland increase of temperature - Data and code from Emanuela Cosma
#_______________________________________________________________________

#carico pacchetto raster
library(raster)
install.package("gdal")
#cambiamo la nostra workin' directory
setwd("C:/lab/greenland")

#DAY 1
#LST -> Land Surface Temperature (temperatura misurata a terra dal satellite - progetto copernicus)
#importiamo i singoli dataset lst_2000.tif, lst_2005.tif, lst_2010.tif, lst_2015.tif
lst_2000 <- raster("lst_2000.tif")
lst_2005 <- raster("lst_2005.tif")
lst_2010 <- raster("lst_2010.tif")
lst_2015 <- raster("lst_2015.tif")

#multipanel con i 4 plottaggi
plot(lst_2000)
plot(lst_2005)
plot(lst_2010)
plot(lst_2015)

#Se vogliamo importare tutte le immagini insieme, usiamo la funzione chiave si chiama lapply
#Prima creiamo una lista di files con list.files()
list.files() #vedo tutti i files in greenland
rlist <- list.files(pattern = "lst") #mi inserisce nella lista tutti i file con pattern lst 
rlist
import <- lapply(rlist, raster) #applico alla lista rlist la funzione raster
import

#facciamo un file unico...
#Creiamo uno stack! Unico blocco con tanti files raster tutti insieme!
TGr <- stack(import)
#plottiamo il file completo
plot(TGr) #non mi serve più fare il par!

#plot RGB -> sovrapposizione delle immagini tutte insieme che fanno parte dello stack TGr
#1: lst_2000, 2: lst_2005, 3: lst_2010, 4: lst_2015
#R: lst_2000, G: lst_2005, B: lst_2010
plotRGB(TGr, 1, 2, 3, stretch = "lin")
#R: lst_2005, G: lst_2010, B: lst_2015
plotRGB(TGr, 2, 3, 4, stretch = "lin")
