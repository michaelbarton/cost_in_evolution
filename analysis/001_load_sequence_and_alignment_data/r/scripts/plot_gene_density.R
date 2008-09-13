file = paste(getwd(),'../data/gene_alignment.csv',sep='/')
data = read.csv(file)

gene_density = density(data$gene)
max_gene_density = max(gene_density$y)
mode_gene_length = gene_density$x[which(gene_density$y == max_gene_density)]

postscript(paste(getwd(),'../plots/gene_density.eps',sep='/'),
  width=5,height=5,onefile=FALSE,horizontal=FALSE, paper = "special",colormodel="rgb")
plot(gene_density,main="",xlab="Gene length including stop codons")
abline(v=mode_gene_length,lty=2,col="red")
text(y=max_gene_density,x=mode_gene_length * 5,
  paste(floor(mode_gene_length),'nucleotides'),
  col="red")
graphics.off()

