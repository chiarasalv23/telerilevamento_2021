#R _code_classification.r

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
