library(lattice)

file = paste(getwd(),'../data/correlation_by_gene.csv',sep='/')
data = read.csv(file)

data$gene_mutation <- log(data$gene_mutation)

chart <- xyplot(
  r ~ gene_mutation | condition:cost_type ,
  pch='.',
  ylab="Spearman's Rho between site cost and mutation rate",
  xlab="log. Codeml estimated tree length",
  panel=function(x,y,...){
    panel.xyplot(x,y,...,col="grey50")
    panel.abline(h=0,lty=3,col="grey20")
    panel.loess(x,y,...,lty=2,col="grey20",lwd=2)
  },
  data=data
)

postscript(paste(getwd(),'../plots/tree_length_vs_spearmans_rank.eps',sep='/'),
  width=10,height=10,onefile=FALSE,horizontal=FALSE, paper = "special")
print(chart)
graphics.off()
