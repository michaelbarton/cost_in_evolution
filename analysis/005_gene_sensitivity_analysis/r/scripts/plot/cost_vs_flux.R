rm(list=ls())
library(lattice)
library(reshape)

file = paste(getwd(),'../data/gene_cost_by_flux.csv',sep='/')
data = read.csv(file)

molten <- melt(data,id=1:4)

# Take max sensitivity across all environments
maxes <- cast(molten,gene + reaction + cost_type ~ variable,max)

# Select for only fluxes less than zero
# i.e. those that show a flux sensitivity
maxes <- maxes[maxes$sensitivity > 0, ]

# Take logs of each axis
maxes$sensitivity <- log(maxes$sensitivity)
maxes$tree_length <- log(maxes$tree_length)

chart <- xyplot(
  tree_length ~ sensitivity | cost_type,
  scales="free",
  xlab="log. maximum reaction flux sensitivity in all conditions",
  ylab="log. codeml estimated alignment tree length",
  data=maxes,
  panel=function(x,y){
    col="grey60"
    panel.xyplot(x,y,col=col)
    panel.loess(x,y,col="grey40",lwd=2,lty=2)
  }
)

#postscript(paste(getwd(),'../plots/sensitivity_vs_tree_length.eps',sep='/'),
#  width=10,height=10,onefile=FALSE,horizontal=FALSE, paper = "special")
#print(chart)
#graphics.off()
