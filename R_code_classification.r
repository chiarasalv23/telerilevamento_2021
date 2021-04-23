#R _code_classification.r

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

# END # 
