## Volcano plot with "significant" genes labeled by labelsig=TRUE
res <- read.csv("DE.csv")

# format of csv
# Gene,log2FoldChange,pvalue,padj
# Gm48415,10.14034929,5.41E-16,1.15E-11
# Smg1,9.604422597,3.00E-15,3.19E-11
# Plec,8.422424515,9.91E-15,5.57E-11
# Gm47578,9.230186615,1.05E-14,5.57E-11
# Gm15500,-10.04933593,1.65E-14,7.02E-11
# Gcc2,8.995148614,2.55E-14,8.34E-11

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
