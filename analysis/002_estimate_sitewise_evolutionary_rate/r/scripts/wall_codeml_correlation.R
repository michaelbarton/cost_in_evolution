rm(list=ls())
library(reshape)
library(lattice)

file = paste(getwd(),'../data/gene_mutations.csv',sep='/')
data = read.csv(file)

melted <- melt(data,id.var=c("gene","dataset"))
data <- na.omit(cast(melted,gene ~ dataset + variable))

data <- rbind(
  data.frame(data,type='linear'),
  data.frame(
    gene=data$gene,
    Barton2009_rate=log(data$Barton2009_rate),
    Wall2005_rate=data$Wall2005_rate,
    type='log')
)

chart <- xyplot(
  Barton2009_rate ~ Wall2005_rate | type,
  scale="free",
  panel=function(x,y,...){
    panel.xyplot(x,y,col="grey70")
    panel.loess(x,y,col="grey30",lty=2,lwd=3)
  },
  xlab="Wall 2005 synonymous mutation rate (dS)",
  ylab="Codeml estimated gene mutation rate",
  data
)

postscript(paste(getwd(),'../plots/wall_codeml_correlation.eps',sep='/'),
  width=10,height=5,onefile=FALSE,horizontal=FALSE, paper = "special")
print(chart)
graphics.off()

log <- data[data$type=='log',2:3]
linear <- data[data$type=='linear',2:3]

cor.test(linear$Barton2009_rate,linear$Wall2005_rate,method="spearman")
cor.test(log$Barton2009_rate,log$Wall2005_rate,method="spearman")

