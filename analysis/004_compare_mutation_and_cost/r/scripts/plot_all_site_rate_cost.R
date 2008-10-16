rm(list=ls())
library(lattice)
library(KernSmooth)

file = paste(getwd(),'../data/site_vs_rate_cost.csv',sep='/')
data = read.csv(file)

chart <- xyplot(
  cost ~ log(rate) | cost_type:condition,
  scale = "free",
  xlab="log. codeml estimated evolutionary rate",
  ylab="Estimated site cost",
  data=data,
  panel=function(x,y,...){
       
    x1 <- c()
    y1 <- c()
    z <- c()
    density <- bkde2D(cbind(x,y),bandwidth=c(bw.nrd(x),bw.nrd(y)))
    for(i in 1:length(density$x1)){
      for(j in 1:length(density$x2)){
        x1 <- c(x1,density$x1[i])
        y1 <- c(y1,density$x2[j])
        z <- c(z,density$fhat[i,j])
      }
    }
    panel.contourplot(
      x1,y1,z,
      at=pretty(z,n=30),
      subscripts=1:length(x1),
      contour=TRUE,
      region=FALSE,
      labels=FALSE,
      col="grey20"
    )
    panel.loess(x,y,col="grey20",lwd=2,lty=2)

    rho <- cor(x,y,method="spear")
    panel.text(-4,max(y),
      paste("R =",signif(rho,digits=4)))
  }
)

postscript(paste(getwd(),'../plots/all_site_vs_cost.eps',sep='/'),
  width=10,height=10,onefile=FALSE,horizontal=FALSE, paper = "special")
print(chart)
graphics.off()
