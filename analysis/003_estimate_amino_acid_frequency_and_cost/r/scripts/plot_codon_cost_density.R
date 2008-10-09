library(lattice)

file = paste(getwd(),'../data/alignment_codon_costs.csv',sep='/')
data = read.csv(file)

levels(data$cost_type)[which(levels(data$cost_type)  == 'nit-rel')] <- "Nitrogen Relative"
levels(data$cost_type)[which(levels(data$cost_type)  == 'nit-abs')] <- "Nitrogen Absolute"
levels(data$cost_type)[which(levels(data$cost_type)  == 'car-rel')] <- "Carbon Relative"
levels(data$cost_type)[which(levels(data$cost_type)  == 'car-abs')] <- "Carbon Absolute"
levels(data$cost_type)[which(levels(data$cost_type)  == 'sul-rel')] <- "Sulphur Relative"
levels(data$cost_type)[which(levels(data$cost_type)  == 'sul-abs')] <- "Sulphur Absolute"
levels(data$cost_type)[which(levels(data$cost_type)  == 'phos-rel')] <- "Phosphorus Relative"
levels(data$cost_type)[which(levels(data$cost_type)  == 'phos-abs')] <- "Phosphorus Absolute"
levels(data$cost_type)[which(levels(data$cost_type)  == 'none-wei')] <- "Molecular Weight"

density_data <- data.frame(cost=c(),density=c(),cost_type=c())

costs <- unique(data$cost_type)
for(i in 1:length(costs)){
  cost <- costs[i]
  subset <- data[data$cost_type == cost,]
  density <- density(subset$cost)
  density_data <- rbind(density_data,data.frame(cost=density$x,density=density$y,cost_type=cost))
}


chart <- xyplot(
  density ~ cost | cost_type,
  data=density_data,
  scale='free',
  ylab="Density",
  xlab="Frequency weighted alignment codon cost",
  panel=panel.lines)

postscript(paste(getwd(),'../plots/average_codon_cost_density.eps',sep='/'),
  width=10,height=10,onefile=FALSE,horizontal=FALSE, paper = "special")
print(chart)
graphics.off()

