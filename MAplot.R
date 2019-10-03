res <- read.csv("DE2MA.csv")

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
