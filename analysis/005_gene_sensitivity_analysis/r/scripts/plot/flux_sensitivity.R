rm(list=ls())
library(lattice)
library(reshape)

file = paste(getwd(),'../data/flux_sensitivity_data.csv',sep='/')
data = read.csv(file)

melted <- melt(data,id=1:4)


###################################
#
# Mean and standard deviations of sensitivities
#
###################################

# Mean and standard deviation for each set of cost types
mean_sd <- cast(melted,condition + cost_type ~ variable, function(x) c(mean=mean(x),sd=sd(x)))
write.csv(mean_sd,paste(getwd(),'../results/sensitivity_summary.csv',sep='/'))

###################################
#
# Log density plot of deviations
#
###################################

# Aggregate over reaction names - take the mean of sensitivities for each reaction
aggr <- cast(melted,condition + cost_type + reaction ~ variable, mean)

# Calculate absolute log distance
log_distance <- function(val){
  distances <- val
  for(i in 1:length(distances)){
    if (distances[i] < 0)
      distances[i] <- log2(abs(distances[i]))*-1
    else if(distances[i] > 0)
      distances[i] <- log2(distances[i])
    else
      0
    }
  distances
  }

# Create plot of log distribution of reaction sensitivities
dens <- densityplot(
  ~ log_distance(sensitivity) | condition:cost_type,
  data=aggr,
  pch='.',
  xlab="log2 reaction sensitivity"
  )

postscript(paste(getwd(),'../plots/log_reaction_sensitivity_distribution.eps',sep='/'),
  width=10,height=10,onefile=FALSE,horizontal=FALSE, paper = "special")
print(dens)
graphics.off()
