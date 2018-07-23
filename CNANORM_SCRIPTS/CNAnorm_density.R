args<-commandArgs(TRUE)

library(CNAnorm) 

get_results = function(v,w,x,y) 
{
a=read.delim(file=v, stringsAsFactors=FALSE, check.names=FALSE)
set.seed(31)
CN <- dataFrame2object(a)
toSkip <- c("Y", "MT")
CN <- gcNorm(CN, exclude=toSkip)
CN <- addSmooth(CN, lambda=7)
CN <- peakPloidy(CN, exclude=toSkip, method='density', density.adjust=0.6)
CN <- discreteNorm(CN)
pdf(w, height=4.27, width=11.69)
plotPeaks(CN)
dev.off()
pdf(x, height=4.27, width=11.69)
data(gPar)
gPar$genome$colors$gain.dot <- 'darkorange'
gPar$genome$colors$grid <- NULL
gPar$genome$cex$gain.dot <- .2
gPar$genome$cex$loss.dot <- .2
plotGenome(CN, superimpose='smooth',show.centromeres=FALSE, gPar=gPar, colorful=TRUE)
dev.off()
exportTable(CN, file=y, show='center')
}

get_results(args[1],args[2],args[3],args[4])
