# R_code_knitr.r
# Creare un report che contenga codice r e grafici!
setwd("C:/lab/") #dentro lab c'è il codice da usare!

#carico la libreria knitr
#require(knitr)
library(knitr)

#utilizziamo la funzine stitch()
stitch("R_code_greenland.r", template = system.file("misc", "knitr-template.Rnw", package="knitr"))
#mi genera un file .tex (LaTex)



