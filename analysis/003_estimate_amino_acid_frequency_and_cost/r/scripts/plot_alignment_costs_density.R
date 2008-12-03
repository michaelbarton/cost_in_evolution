rm(list=ls())
library(lattice)

file = paste(getwd(),'../data/average_alignment_costs.csv',sep='/')
data = read.csv(file)
#data$cost_type <- levels(data$cost_type)

levels(data$cost_type)[which(levels(data$cost_type)  == 'nit-rel')] <- "Nitrogen Relative"
levels(data$cost_type)[which(levels(data$cost_type)  == 'nit-abs')] <- "Nitrogen Absolute"
levels(data$cost_type)[which(levels(data$cost_type)  == 'car-rel')] <- "Carbon Relative"
levels(data$cost_type)[which(levels(data$cost_type)  == 'car-abs')] <- "Carbon Absolute"
levels(data$cost_type)[which(levels(data$cost_type)  == 'sul-rel')] <- "Sulphur Relative"
levels(data$cost_type)[which(levels(data$cost_type)  == 'sul-abs')] <- "Sulphur Absolute"
levels(data$cost_type)[which(levels(data$cost_type)  == 'phos-rel')] <- "Phosphorus Relative"
levels(data$cost_type)[which(levels(data$cost_type)  == 'phos-abs')] <- "Phosphorus Absolute"
levels(data$cost_type)[which(levels(data$cost_type)  == 'none-wei')] <- "Molecular Weight"


chart <- densityplot(
  ~ cost | cost_type,
  data=data,
  pch=".",
  xlab="Frequency weighted, mean per residue protein cost",
  scale="free")

postscript(paste(getwd(),'../plots/average_alignment_cost_density.eps',sep='/'),
  width=10,height=10,onefile=FALSE,horizontal=FALSE, paper = "special")
print(chart)
graphics.off()
