## Volcano plot with "significant" genes labeled by labelsig=TRUE
res <- read.csv("DE.csv")

volcanoplot <- function (res, lfcthresh=2, sigthresh=0.01, main="Volcano Plot", legendpos="bottomright", labelsig=FALSE, textcx=1, ...) {
  with(res, plot(log2FoldChange, -log10(pvalue), pch=20, main=main, ...))
  with(subset(res, padj<sigthresh ), points(log2FoldChange, -log10(pvalue), pch=20, col="red", ...))
  with(subset(res, abs(log2FoldChange)<lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="grey", ...))
  with(subset(res, abs(log2FoldChange)>lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="grey", ...))
  with(subset(res, padj<sigthresh & (log2FoldChange)>lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="red", ...))
  with(subset(res, padj<sigthresh & (log2FoldChange)<lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="blue", ...))
  if (labelsig) {
    require(calibrate)
    with(subset(res, padj<sigthresh & abs(log2FoldChange)>lfcthresh), textxy(log2FoldChange, -log10(pvalue), labs=Gene, cex=textcx, ...))
  }
  legend(legendpos, xjust=0.4, yjust=0.4, legend=c(paste("down-regulated"), paste("not significant"), "up-regulated"), pch=20, col=c("blue","grey","red"))
}
png("diffexpr-volcanoplot.png", 1500, 1500, pointsize=40)
volcanoplot(res, lfcthresh=2, sigthresh=0.01, textcx=.8, xlim=c(-12, 12))
dev.off()
