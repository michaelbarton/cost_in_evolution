file = paste(getwd(),'../data/gene_alignment.csv',sep='/')
data = read.csv(file)

alignment_density = density((data$gene - 3) / data$alignment)

postscript(paste(getwd(),'../plots/gene_alignment_density.eps',sep='/'),
  width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
plot(alignment_density,main="",xlab="Ratio of gene to alignment length\nexcluding stop codons")
graphics.off()
