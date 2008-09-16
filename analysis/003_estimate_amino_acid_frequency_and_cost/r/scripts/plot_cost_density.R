rm(list=ls())
library(lattice)

file = paste(getwd(),'../data/costs.csv',sep='/')
data = read.csv(file)

chart <- densityplot(
  ~ cost | type,
  scale='free',
  xlab="Estimated cost",
  data=data)

postscript(paste(getwd(),'../plots/cost_density.eps',sep='/'),
  width=10,height=10,onefile=FALSE,horizontal=FALSE, paper = "special")
print(chart)
graphics.off()

