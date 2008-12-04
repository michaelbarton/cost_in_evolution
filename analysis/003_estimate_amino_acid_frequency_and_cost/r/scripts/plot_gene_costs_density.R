rm(list=ls())
library(lattice)
library(reshape)

file = paste(getwd(),'../data/gene_costs.csv',sep='/')
data = read.csv(file)

melted = melt(data,id.vars=c('gene','alignment'))

chart <- densityplot(
  ~ value | variable,
  scale='free',
  data=melted,
  xlab="Protein weight (Da)",
  panel=function(x,subscripts){
    subset <- melted[subscripts,]
    values <- c('true','false')
    colours <- c('red','blue')
    for(i in 1:2){
      panel.densityplot(
        subset[subset$alignment == values[i],]$value,
        col=colours[i],
        pch='.'
      )
    }
  }
)

postscript(paste(getwd(),'../plots/average_gene_cost_density.eps',sep='/'),
  width=10,height=5,onefile=FALSE,horizontal=FALSE, paper = "special")
print(chart)
graphics.off()
