rm(list=ls())

file = paste(getwd(),'../data/gene_mutations.csv',sep='/')
data = read.csv(file)

wall <- data[data$dataset == 'Wall2005',]
codeml <- data[data$dataset == 'Barton2009',]

#
# Distribution of Wall2005 synonymous data
#

postscript(paste(getwd(),'../plots/wall_density.eps',sep='/'),
  width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
plot(density(wall$rate),xlab="Synomymous mutation rate (dS)",main="")
graphics.off()

postscript(paste(getwd(),'../plots/wall_qq.eps',sep='/'),
  width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
qqnorm(wall$rate,main = "",ylab="Synonymous mutation rate sample quantitles")
qqline(wall$rate)
graphics.off()

postscript(paste(getwd(),'../plots/codeml_density.eps',sep='/'),
  width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
plot(density(codeml$rate),xlab="Codeml estimated mutation rate",main="")
graphics.off()

postscript(paste(getwd(),'../plots/codeml_log_density.eps',sep='/'),
  width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
plot(density(log(codeml$rate)),xlab="logE Codeml estimated mutation rate",main="")
graphics.off()

postscript(paste(getwd(),'../plots/codeml_log_qq.eps',sep='/'),
  width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
qqnorm(log(codeml$rate),main = "",ylab="logE codeml estimated mutation rate sample quantitles")
qqline(log(codeml$rate))
graphics.off()
