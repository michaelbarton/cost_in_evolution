rm(list=ls())

file = paste(getwd(),'../data/site_mutation_rates.csv',sep='/')
data = read.csv(file)

postscript(paste(getwd(),'../plots/site_mutation_density.eps',sep='/'),
  width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
plot(
  density(data$rate),
  xlab="Site mutation rate",
  main=""
)
graphics.off()
