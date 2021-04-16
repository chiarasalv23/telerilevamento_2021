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
#list.files() vedo tutti i files in greenland
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
#R: lst_2015, G: lst_2010, B: lst_2010
plotRGB(TGr, 4, 3, 2, stretch = "lin")

#DAY 2
#utilizzeremo il pacchetto rastervist
library(raster)
library(rasterVis) #deriva da un pacchetto chiamato lattice che serviva per visualizzare le matrici
#librerie dichiarate sempre all'inizio del codice
#settiamo di nuovo la working directory
setwd("C:/lab/greenland")

rlist <- list.files(pattern = "lst") #mi inserisce nella lista creata tutti i file con pattern lst 
rlist 
import <- lapply(rlist, raster) #applico alla lista rlist la funzione raster
import
TGr <- stack(import) #creo lo stack 
TGr
#Usiamo la funzione level plot
levelplot(Tgr)

#plot singoli livelli dello stack!
levelplot(TGr$lst_2000)
dev.off()
level.plot(TGr$lst_2005)
dev.off()
levelplot(TGr$lst_2010)
dev.off()
levelplot(TGr$lst_2015)
dev.off()

#plottiamo immagini singole utilizzando la colorRampPalette
cl <- colorRampPalette(c("white", "cyan", "light blue", "blue")) (200)
levelplot(TGr, col.regions = cl)
dev.off()
#però così ho a lato una legenda per ogni grafico, non è bello...

#cambiamo i titoli sulle singole mappe, ossia i nomi dei vari livelli che abbiamo creato
levelplot(TGr, col.regions = cl, names.attr = c("July 2000", "July 2005", "July 2010", "July 2015"))
#così abbiamo rinominato i layer
#inseiamo adesso il titolo, aggiungiamo agli argomenti della funzione levelplot -> main = "LST variation in time"
levelplot(TGr, col.regions = cl, main = "LST variation in time", names.attr = c("July 2000", "July 2005", "July 2010", "July 2015"))

#adesso andiamo a lavorare sui dati di Melt
#abbiamo tantissimi dati, quindi creiamo un lista con il procediamento fatto prima...
meltlist <- list.files(pattern = "melt") #mettiamo nella lista tutti i files che hanno come pattern comune la parola melt
meltlist #visualizzo la lista
melt_import <- lapply(meltlist, raster) #applico la funzione raster alla lista meltlist
melt_import 
melt <- stack(melt_import) #creo lo stack
melt #lo visualizzo

levelplot(melt) #levelplot dello sciogliamento

#algebra delle matrici...
melt_amount <- melt$X2007annual_melt - melt$X1979annual_melt 
#leghiamo la singola immagine allo stack a cui appartiene!
#viene fatta una sottrazione tra i due livelli
#vediamo così l'amount di melt (ghiaccio perso dal '79 al '07)

#creo una palette
cl_melt <- colorRampPalette(c("blue", "white", "red")) (100)
plot(melt_amount, col = cl_melt)
dev.off()

levelplot(melt_amount, col.regions = cl_melt) #levelplot
dev.off()
 



