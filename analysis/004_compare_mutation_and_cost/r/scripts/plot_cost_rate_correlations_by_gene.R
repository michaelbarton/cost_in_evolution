library(lattice)

file = paste(getwd(),'../data/correlation_by_gene.csv',sep='/')
data = read.csv(file)

chart <- densityplot(
  ~ r | condition:cost_type,
  pch='.',
  xlab="Spearman's Rho between site cost and mutation rate",
  panel=function(x,...){
    panel.abline(v=0,lty=2,col="grey20")
    panel.densityplot(x,...)
  },
  data=data
)

postscript(paste(getwd(),'../plots/correlation_by_gene.eps',sep='/'),
  width=10,height=10,onefile=FALSE,horizontal=FALSE, paper = "special")
print(chart)
graphics.off()
