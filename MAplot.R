res <- read.csv("DE2MA.csv")

# CSV format as follows:
# Gene,AveExpr,log2FoldChange,pvalue,padj
# Gm48415,1.242150603,10.14034929,5.41E-16,1.15E-11
# Smg1,0.972791678,9.604422597,3.00E-15,3.19E-11
# Plec,0.383659158,8.422424515,9.91E-15,5.57E-11
# Gm47578,0.787138905,9.230186615,1.05E-14,5.57E-11
# Gm15500,1.471363151,-10.04933593,1.65E-14,7.02E-11


maplot <- function (res, thresh=0.01, labelsig=FALSE, textcx=1, ...) {
  with(res, plot(AveExpr, log2FoldChange, pch=20, col="grey", cex=1, ...))
  with(subset(res, padj<thresh), points(AveExpr, log2FoldChange, col="red", pch=20, cex=1))
  with(subset(res, padj<thresh & (log2FoldChange)<0), points(AveExpr, log2FoldChange, col="blue", pch=20, cex=1))
  if (labelsig) {
    require(calibrate)
    with(subset(res, padj<thresh), textxy(AveExpr, log2FoldChange, labs=Gene, cex=textcx, col="grey",xlim=c(-2, 15)))
  }
  }
png("Diffexpr-maplot.png", 1500, 1500, pointsize=40)
maplot(res, main="MA Plot")
dev.off()
