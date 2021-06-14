#R_code_complete - Telerilevamento Geo-Ecologico

#-------------------------------------------------

# Summary:

# 1. Remote Sensing - first code
# 2. Time Series
# 3. Copernicus data
# 4. knitr 
# 5. Multuvariate analysis
# 6. Classification - Solar Orbiter
# 7. GgPlot2
# 8) Vegetation Indexes 
# 9) Land Cover
# 10) Variability
#-------------------------------------------------

# 1) R for remote sensing!

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

# dev.off() #puliamo again...

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
#dev.off()
#due righe, una colonna
par(mfcol = c(2, 1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
#dev.off()
#plottare le prime 4 bande landsat B1, B2, B3, B4
#SU 4 RIGHE E 1 COLONNA
par(mfrow = c(4, 1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)
#dev.off()
#anche se così viene un po' brutto...
#adesso mettiamole 2x2 che è più ordinato...
par(mfrow = c(2,2))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)
# dev.off()

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

# dev.off()

#DAY 4
library(raster) #richiamo la libreria raster
#loading pacchetto sp -> pacchetto con classi e metodi per dati spaziali!
setwd("c:/lab/") #dico al sistema dove sono i dati con cui devo lavorare...
p223r63_2011 <- brick("p224r63_2011_masked.grd") #virgolette perché il dataset è esterno ad r

#plot RGB! 
#Bande landsat
#B1: blu, B2: verde, B3: rosso, B4: NIR, B5: MIR, B6: TIR (FAR), B7: MIR
#stretching lineare
plotRGB(p224r63_2011, r = 3, g = 2, b = 1, stretch = "Lin") #immagine a colori naturali RGB
#dev.off()
plotRGB(p224r63_2011, r = 4, g = 3, b = 2, stretch = "Lin") #sulla componente R abbiamo montato l'IR (la vegetazione riflette tantissimo). Visualizzazione a falsi colori
#dev.off()
plotRGB(p224r63_2011, r = 3, g = 4, b = 2, stretch = "Lin")
#dev.off()
plotRGB(p224r63_2011, r = 3, g = 2, b = 4, stretch = "Lin")
#dev.off()

#esercizio: fare un multiframe 2x2 con queste 4 visualizzazioni 
par(mfrow = c(2,2))
plotRGB(p224r63_2011, r = 3, g = 2, b = 1, stretch = "Lin")
plotRGB(p224r63_2011, r = 4, g = 3, b = 2, stretch = "Lin")
plotRGB(p224r63_2011, r = 3, g = 4, b = 2, stretch = "Lin")
plotRGB(p224r63_2011, r = 3, g = 2, b = 4, stretch = "Lin")

#creare un pdf direttamente da R
pdf("ilmioprimopdf.pdf") #sarà nella caertella lab
par(mfrow = c(2,2))
plotRGB(p224r63_2011, r = 3, g = 2, b = 1, stretch = "Lin")
plotRGB(p224r63_2011, r = 4, g = 3, b = 2, stretch = "Lin")
plotRGB(p224r63_2011, r = 3, g = 4, b = 2, stretch = "Lin")
plotRGB(p224r63_2011, r = 3, g = 2, b = 4, stretch = "Lin")
#dev.off()

#histogram stretching
plotRGB(p224r63_2011, r = 3, g = 4, b = 2, stretch = "hist")

#multiframe 3x1 natural colors, green linear, green linear hist
par(mfrow=c(3,1))
plotRGB(p224r63_2011, r = 3, g = 2, b = 1, stretch = "Lin")
plotRGB(p224r63_2011, r = 3, g = 4, b = 2, stretch="Lin")
plotRGB(p224r63_2011, r = 3, g = 4, b = 2, stretch="Hist")
#dev.off()

#DAY 5
#back to 1988...
#immagine landsat p224r63_1988

#ricordare ad R che vogliamo utilizzare il pacchetto raster (che è già dentro R)
library(raster)
#solito procedimento...
setwd("C:/lab/")
p224r63_2011 <- brick("p224r63_2011_masked.grd")
p224r63_2011

#oggi aggiungiamo anche l'immagine del '88
#MULTITEMPORAL SET
p224r63_1988 <- brick("p224r63_1988_masked.grd")
p224r63_1988 #vedo tutte le info
#eseguiamo un plottaggio selvaggio!
plot(p224r63_1988) #vari sensori che hanno visto il mondo ad una certa lunghezza d'onda (varie bande)

#passiamo direttamente al plottaggio RGB
#______________________Promemoria Bande landsat_________________________
#B1: blu, B2: verde, B3: rosso, B4: NIR, B5: MIR, B6: TIR (FAR), B7: MIR
#_______________________________________________________________________
plotRGB(p224r63_1988, r = 3, g = 2, b = 1, stretch = "lin") #Plottaggio true colors!
#dev.off()
#sfruttiamo l'IR (che per la vegetazione è ottimale!)
#R: B4; G: B3; B: B2;
plotRGB(p224r63_1988, r = 4, g = 3, b = 2, stretch = "lin") #plottaggio immagine in falso colore
#dev.off()

#Indagine diacronica (1988 e 2011 a confronto)
#Fare un par, creare uno schema con due righe e una colonna e inserire 2011 e 1988
par(mfrow = c(2, 1))
plotRGB(p224r63_1988, r = 4, g = 3, b = 2, stretch = "lin")
plotRGB(p224r63_2011, r = 4, g = 3, b = 2, stretch = "lin")

#realizzare un multiframe (par) 2x2 con entrambi i tipi di stretching (lin e hist)
par(mfrow = c(2, 2))
#in ordine...
plotRGB(p224r63_1988, r = 4, g = 3, b = 2, stretch = "lin") #1
plotRGB(p224r63_2011, r = 4, g = 3, b = 2, stretch = "lin") #2
plotRGB(p224r63_1988, r = 4, g = 3, b = 2, stretch = "hist") #3
plotRGB(p224r63_2011, r = 4, g = 3, b = 2, stretch = "hist") #4

#creaiamo un pdf con questi grafici...
pdf("multitemp.pdf") #sempre dentro la cartella lab! Uso le virgolette perché esco da R
par(mfrow = c(2, 2))
plotRGB(p224r63_1988, r = 4, g = 3, b = 2, stretch = "lin")
plotRGB(p224r63_2011, r = 4, g = 3, b = 2, stretch = "lin")
plotRGB(p224r63_1988, r = 4, g = 3, b = 2, stretch = "hist")
plotRGB(p224r63_2011, r = 4, g = 3, b = 2, stretch = "hist")
#dev.off()

#-------------------------------------------------

2) 

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
#dev.off()
level.plot(TGr$lst_2005)
#dev.off()
levelplot(TGr$lst_2010)
#dev.off()
levelplot(TGr$lst_2015)
#dev.off()

#plottiamo immagini singole utilizzando la colorRampPalette
cl <- colorRampPalette(c("white", "cyan", "light blue", "blue")) (200)
levelplot(TGr, col.regions = cl)
#dev.off()
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
#dev.off()

levelplot(melt_amount, col.regions = cl_melt) #levelplot
#dev.off()
 
#-------------------------------------------------

# 3) R_code_copernicus.r

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
# deserto -> valori minimi (orange)
# europa -> valori molto alti (darkgreen)

#Ricampionamento - resampling
fcoverres <- aggregate(fcover, fact = 100)
#creo questa nuova variabile per il dato ricampionato
#utilizzo la funzione aggregate in cui metto come argomento il dato originale e il fattore di ricampionamento
#come funziona fact sta scritto sugli appunti, ricopiatelo, pigra!
plot(fcoverres, col = cl, main = "GLOBAL FCOVER RESAMPLED") #eseguo di nuovo il plottaggio ma con il dato ricampionato
#Si perdono molte informazioni 

#-------------------------------------------------

# 4) R_code_knitr.r

# Creare un report che contenga codice r e grafici!
setwd("C:/lab/") #dentro lab c'è il codice da usare!

#carico la libreria knitr
#require(knitr)
library(knitr)

#utilizziamo la funzine stitch()
stitch("R_code_greenland.r", template = system.file("misc", "knitr-template.Rnw", package="knitr"))
#mi genera un file .tex (LaTex)

#-------------------------------------------------

# 5) R_code_multivariate_analysis.r

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

#-------------------------------------------------

#6) R _code_classification.r

# DAY 1
# Solar Orbiter

library(raster) #per usare la funzione brick()
library(RStoolbox)
setwd("C:/lab/")

so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg") 
#abbiamo appena imporato l'immagine

#possiamo visualizzare tutti e tre i livelli RGB
plotRGB(so, 1, 2, 3, stretch = "lin")

#classificazione dell'immagine! 
#Classificazione non supervisionata -> l'utente non definisce a priori le classi

#utilizziamo una funzione per la classificazione non supervisionata (dentro RStoolbox)
soc <- unsuperClass(so, nClasses = 3) #immagine da classificare, num classi)
#adesso eseguiamo il plottaggio della mappa
plot(soc$map)
set.seed(42) #per fare la classificazione vengono utilizzate le stesse repliche


#classificazione non supervisionata con 20 classi
sok <- unsuperClass(so, nClasses = 20)
plot(sok$map)
#set.seed(42)

#Download di un immagine da: https://www.esa.int/Science_Exploration/Space_Science/Orbiting_the_Sun_together
#immagine rinominata sun
sun <- brick("sun.png")
#faccio la classificazione non supervisionata
sunc <- unsuperClass(sun, nClasses = 3)
plot(sunc$map)


# DAY 2

# Grand Canyon
# nome immagine: dolansprings_oli_2013088_canyon_lrg.jpg

library(raster)
library(RStoolbox)
setwd("C:/lab/")

#creiamo un brick perché stiamo lavorando con un'immagine RGB (tre livelli)
gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg")
#plottaggio RGB
plotRGB(gc, 1, 2, 3, stretch = "lin")
#stessa cosa ma con stretch hist
plotRGB(gc, 1, 2, 3, stretch = "hist")

#iniziamo il processo di classificazione
#iniziamo con due classi...
#classificazione non-supervisionata: unsuperClass()
gcc <- unsuperClass(gc, nClasses = 2)
#plottaggio
plot(gcc$map)

#classificazione con 4 classi
gcc4 <- unsuperClass(gc, nClasses = 4)
plot(gcc4$map)


#-------------------------------------------------

# 7) GgPlot2

library(raster)
library(RStoolbox)
library(ggplot2)
library(gridExtra)

setwd("~/lab/")

p224r63 <- brick("p224r63_2011_masked.grd")

ggRGB(p224r63,3,2,1, stretch="lin")
ggRGB(p224r63,4,3,2, stretch="lin")

p1 <- ggRGB(p224r63,3,2,1, stretch="lin")
p2 <- ggRGB(p224r63,4,3,2, stretch="lin")

grid.arrange(p1, p2, nrow = 2) # this needs gridExtra

#-------------------------------------------------

#8) R_code_vegetation_indexes.r

library(raster)
setwd("C:/lab/")

# DAY 1

#carichiamo i dati defor1.jpg e defor2.jpg -> Earth Observatory NASA
defor1 <- brick("defor1.jpg")
defor2 <- brick("defor2.jpg")

#facciamo un par per plottare le due immagini per vedere i cambiamenti nell'area
par(mfrow = c(2,1))
plotRGB(defor1, r = 1, g = 2, b = 3, stretch = 'lin')
plotRGB(defor2, r = 1, g = 2, b = 3, stretch = 'lin')

# DAY 2
#richiamo i pacchetti che mi servono...
require(RStoolbox) #per usare alcune funzioni per gli indici di vedetazione
#setto la working directory...
#defor1 e defor2 -> sito in cui è stata fatta una forte deforestazione
#siamo a Rio Peixoto Brazil! 
#le carichiamo e le riplottiamo...

defor1 #vedo le info del file e le sue bande (vedere come si chiamano)
# NIR: defor1.1, RED: defor1.2, GREEN: defor1.3
#CALCOLO DVI per defor1 
#NIR - RED
dvi1 <- defor1$defor1.1 - defor1$defor1.2 #per ogni pixel prendiamo il valore NIR meno valore RED
#in uscita abbiamo una mappa formata da tanti pixel che sono la diffrenza dell'NIR e RED -> DVI difference vegetation index!
plot(dvi1)

#cambiano la palette di colori
#colorRampPalette
cl <- colorRampPalette(c('darkblue', 'yellow', 'red', 'black')) (200)
plot(dvi1, col = cl, main = 'DV1 at time 1')

#CALCOLO DVI per defor2
dvi2 <- defor2$defor2.1 - defor2$defor2.2
plot(dvi2, col = cl, main = 'DVI at time 2') 

#par per vederli insieme... 
par(mfrow = c(1, 2))
plot(dvi1, col = cl, main = 'DV1 at time 1')
plot(dvi2, col = cl, main = "DVI at time 2")

#Vedere l'andamento e cosa è cambiato da defor1 a defor2
difdvi <- dvi1 - dvi2 #differenza dei due momenti temporali
#creo una nuova colorRampPalette
cld <- colorRampPalette(c('blue', 'white', 'red')) (200)
plot(difdvi, col = cld, main = 'Difference DVI1 and DV2')

#CALCOLO NDVI1 e NDV2
# (NIR - RED) / (NIR + RED)
ndvi1 <- (defor1$defor1.1 - defor1$defor1.2) / (defor1$defor1.1 + defor1$defor1.2)
ndvi2 <- (defor2$defor2.1 - defor2$defor2.2) / (defor2$defor2.1 + defor2$defor2.2)

#plot con par
par(mfrow = c(1, 2))
plot(ndvi1, col = cl, main = 'NDVI at time 1')
plot(ndvi2, col = cl, main = "NDVI at time 2")

#Vedere l'andamento e cosa è cambiato da defor1 a defor2
difndvi <- ndvi1 - ndvi2
#plot
plot(difndvi, col = cld, main = 'Difference between NDVIs') #mostra le aree con maggior perdita di vegetazione :( 

#usiamo la funzione spectralindices() di RStoolbox...
#come usare r from scratch, ossia da 0
#per defor1
vi1<- spectralIndices(defor1, green = 3, red = 2, nir = 1)
plot(vi1, col = cl)
#per defor2
vi2<- spectralIndices(defor2, green = 3, red = 2, nir = 1)
plot(vi2, col = cl)

# DAY 3
# --- WORLD WIDE NDVI ---
# Pacchetto rasterdiv
install.packages("rasterdiv")
require(rasterdiv) #for world wide NDVI
#plottiamo il nostro set copNDVI che contiene NDVI medio per ogni 21 Giugno dal 1999 al 2017
plot(copNDVI)
#togliamo l'acqua...
#sovrascrivo il dataset senza i valori...
copNDVI <- reclassify(copNDVI, cbind(253:255, NA)) #ai valori NDVI da 253 a 255 assegnamo NA (non assigned)
plot(copNDVI)
#per usare levelplot dobbiamo prima...
require(rasterVis)
#cosa fa levelplot? mostra la media dei valori sulle righe e sulle colonne
levelplot(copNDVI)

#-------------------------------------------------

# 9) R_code_land_cover.r

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

#-------------------------------------------------

# 10) R_code_variability.r

# Ghiacciaio del Similaun

# DAY 1

# librerie
require(raster)
require(RStoolbox)

# Set working directory
setwd("C:/lab/")

# Carichiamo sentinel.png
sent <- brick("sentinel.png")

# Plottaggio...
# NIR = 1, RED = 2, GREEN = 3
plotRGB(sent) # Stretch automatico lineare
#plotRGB(sent, r = 1, g = 2, b = 3, stretch = "lin")

plotRGB(sent, r = 2, g = 1, b = 3, stretch = "lin")
sent
# class      : RasterBrick 
# dimensions : 794, 798, 633612, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 798, 0, 794  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/lab/sentinel.png 
# names      : sentinel.1, sentinel.2, sentinel.3, sentinel.4 
# min values :          0,          0,          0,          0 
# max values :        255,        255,        255,        255 

# Assegnamo le singole bande a variabili per richiamarle più easy...
nir <- sent$sentinel.1
red <- sent$sentinel.2
ndvi = (nir - red) / (nir + red)
plot(ndvi)

# Cambio palette...
cl <- colorRampPalette(c('black', 'white', 'red', 'magenta', 'green')) (200)
plot(ndvi, col = cl)

# Adesso calcoliamo la variabilità dell'immagine!
#funzione focal() per usare la moving window
ndvisd3 <- focal(ndvi, w = matrix(1/9, nrow = 3, ncol = 3), fun = sd)
# Cambiamo la palette...
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow')) (200) 
plot(ndvisd3, col=clsd)

# calcoliamo la media della biomassa...
ndvimean3 <- focal(ndvi, w = matrix(1/9, nrow = 3, ncol = 3), fun = mean)
plot(ndvimean3, col = clsd)

# Cambiamo la grandezza della moving window...
# 13 x 13 Standard Deviation
ndvisd13 <- focal(ndvi, w = matrix(1/169, nrow = 13, ncol = 13), fun = sd)
plot(ndvisd13, col = clsd)
# 5 x 5 Standard Deviation
ndvisd5 <- focal(ndvi, w = matrix(1/25, nrow = 5, ncol = 5), fun = sd)
plot(ndvisd5, col = clsd)

# Facciamo l'analisi delle componenti principali
# PCA
sentpca <- rasterPCA(sent)
plot(sentpca$map)

# Per vedere quanta variabilità spiegano le singole componenti...
summary(sentpca$model)
# Importance of components:
#                           Comp.1     Comp.2      Comp.3
# Standard deviation     77.3362848 53.5145531 5.765599616
# Proportion of Variance  0.6736804  0.3225753 0.003744348  (Prop. di var. spiegata)
# Cumulative Proportion   0.6736804  0.9962557 1.000000000
#                       Comp.4
# Standard deviation          0
# Proportion of Variance      0
# Cumulative Proportion       1

# La prima PC spiega il 67.36% delle informazioni originali. 

# DAY 2

# Dichiaro nuovamente le librerie e setto la working directory
library(ggplot2)
library(gridExtra)
library(viridis) # serve per i colori, per colorare i plot di ggplot in modo automatico!
# sent <- brick("sentinel.png")
# sentpca <- rasterPCA(sent)
# plot(sentpca)
# summary(sentpca)
# sentpca per vedere tutte le variabilità (vedi day 1)
# PC1 --> ha più info all'interno dell'immagine
# Funzione focal per passare la moving window e calcolare la deviazione standard (variabilità di tutti i dati originali) e la riportavamo sul valore centrale. 
# Sposto la moving window e il processo riparte! 

sentpca$map$PC1 #seleziono solo la PC1...
# Calcoliamo la variabilità sulla pc1
# Moving window 3 x 3
pc1sd3 <- focal(pc1, w = matrix(1/9, nrow = 3, ncol = 3), fun = sd)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow')) (200) 
plot(pc1sd3, col=clsd) # come cambiano i valori su una singola banda
# Moving window 5 x 5 
pc1sd5 <- focal(pc1, w=matrix(1/25, nrow=5, ncol=5), fun=sd)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow')) (200) 
plot(pc1sd5, col=clsd)

# source() test!
source("source_test_lezione.r") # Per prendere e caricare un codice dall'esterno!

# Plottare i nostri dati tramite ggplot2
#ggplot() # mi crea una finestra vuota
ggolot() + 
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer))

ggplot() + 
+ geom_raster(pc1sd3, mapping = aes(x = x, y = y, fill = layer))

# Usando viridis!
ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) +
scale_fill_viridis()

ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) +
scale_fill_viridis()  +
ggtitle("Standard deviation of PC1 by viridis colour scale")

ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) +
scale_fill_viridis(option = "magma")  +
ggtitle("Standard deviation of PC1 by magma colour scale")

# grid arrange
# associamo ogni plottaggio ad un oggetto...
p1 <- ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) +
scale_fill_viridis()  +
ggtitle("Standard deviation of PC1 by viridis colour scale")

p2 <- ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) +
scale_fill_viridis(option = "magma")  +
ggtitle("Standard deviation of PC1 by magma colour scale")

p3 <- ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) +
scale_fill_viridis(option = "turbo")  +
ggtitle("Standard deviation of PC1 by turbo colour scale")

grid.arrange(p1, p2, p3, nrow = 1)

#------------------------ END -------------------------





