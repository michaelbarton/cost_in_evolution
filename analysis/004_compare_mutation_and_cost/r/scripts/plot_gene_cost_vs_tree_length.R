rm(list=ls())
library(lattice)

file = paste(getwd(),'../data/gene_cost_rate.csv',sep='/')
data = read.csv(file)

chart <- xyplot(
  cost ~ log(tree_length) | cost_type:condition,
  pch='.',
  scale="free",
  panel=function(x,y,...){
    panel.xyplot(x,y,...,col="grey50")
    panel.loess(x,y,...,col="grey20",lwd=2,lty=2)
  },
  xlab="log. codeml estimated tree length",
  ylab="Average per residue cost",
  data=data
)

results <- data.frame(condition=c(),cost_type=c(),spearman=c())
costs <- unique(data$cost_type)
conditions <- unique(data$condition)
for(i in 1:length(costs)){
  for(j in 1:length(conditions)){
    subset = data[data$cost_type == costs[i] & data$condition == conditions[j],]
    if(dim(subset)[1] == 0){
      next
    }
    results <- rbind(
      results,
      data.frame(
        condition=conditions[j],
        cost_type=costs[i],
        spearman=cor(log(subset$tree_length),subset$cost,method="spear")
      )
    )
  
  }
}

write.csv(results,paste(getwd(),'../results/gene_cost_tree_length_correlation.csv',sep='/'))

postscript(paste(getwd(),'../plots/gene_cost_tree_length_correlation.eps',sep='/'),
  width=10,height=10,onefile=FALSE,horizontal=FALSE, paper = "special")
print(chart)
graphics.off()
