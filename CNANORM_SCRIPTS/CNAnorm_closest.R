args<-commandArgs(TRUE)

library(CNAnorm) 

get_results = function(v,w,x,y,z) 
{
a=read.delim(file=v, stringsAsFactors=FALSE, check.names=FALSE)
set.seed(31)
CN <- dataFrame2object(a)
toSkip <- c("X", "Y", "MT")
CN <- gcNorm(CN, exclude=toSkip)
CN <- addSmooth(CN, lambda=7)
CN <- peakPloidy(CN, exclude=toSkip, method='closest')
pdf(w, height=4.27, width=11.69)
plotPeaks(CN)
dev.off()
CN <- validation(CN,ploidy = (sugg.ploidy(CN) - 1))
CN <- addDNACopy(CN)
CN <- discreteNorm(CN) 
pdf(x, height=4.27, width=11.69)
data(gPar)
gPar$genome$colors$gain.dot <- 'darkorange'
gPar$genome$colors$grid <- NULL
gPar$genome$cex$gain.dot <- .2
gPar$genome$cex$loss.dot <- .2
plotGenome(CN, superimpose='DNACopy', show.centromeres=FALSE, gPar=gPar, colorful=TRUE)
dev.off()
pdf(y, height=4.27, width=11.69)
plotGenome(CN, superimpose='smooth', show.centromeres=FALSE)
dev.off()
exportTable(CN, file=z, show='center')
}

get_results(args[1],args[2],args[3],args[4],args[5])
