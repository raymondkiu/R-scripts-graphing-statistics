library(DESeq2)
library(RColorBrewer)
library(gplots)
library(ggplot2)
#source("https://bioconductor.org/biocLite.R")
#biocLite("tximport")
library(tximport)
#biocLite("rhdf5")
setwd("~/Desktop/HallLabData/Mel/RNASeq/GrantForLindsay/")


 ####prepare input

sampleInfo <- read.csv("BM_vsFM_4_experiment.csv", header=TRUE, row.names=1)
head(sampleInfo)
## add X at the beginning of rows beginning with a number (makes it consistent to column names of of the count matrix!)
if ( any(grepl("^[0-9]", sampleInfo$name)) ) {
  sampleInfo[grepl("^[0-9]", sampleInfo$name),]$name = paste("X", sampleInfo[grepl("^[0-9]", sampleInfo$name),]$name, sep="")  
}
sampleInfo = DataFrame(as.data.frame(unclass(sampleInfo)))
##sampleInfo = sampleInfo[order(sampleInfo$name, decreasing=F),]  # order by sample name
as.character(sampleInfo$name)
head(sampleInfo)
## count matrix (e.g. from DESeq or featureCounts)

countdata<-read.csv("BMvsFM_4.csv",header=TRUE,row.names=1)
head(countdata)
countdata = DataFrame(countdata)
#countdata = countdata[,as.character(sampleInfo[,1])]
head(countdata)
colnames(countdata)

dds = DESeqDataSetFromMatrix(
  countData = countdata,
  colData = sampleInfo,
  design = ~ condition)
dds
dds <-dds[rowSums(counts(dds)>1) >=6]


countdata <- as.matrix(countdata)
head(countdata)

# Assign condition (first four are controls, second four contain the expansion)
condition <- dds$condition

# Analysis with DESeq2 ----------------------------------------------------



# Create a coldata frame and instantiate the DESeqDataSet. See ?DESeqDataSetFromMatrix
(coldata <- data.frame(row.names=colnames(countdata), condition))
dds <- DESeqDataSetFromMatrix(countData=countdata, colData=coldata, design=~condition)
dds

# Run the DESeq pipeline
dds <- DESeq(dds)

dim(dds)
# Plot dispersions
png("qc-dispersions.png", 1000, 1000, pointsize=20)
plotDispEsts(dds, main="Dispersion plot")
dev.off()

# Regularized log transformation for clustering/heatmaps, etc
rld <- rlogTransformation(dds)
head(assay(rld))
hist(assay(rld))

# Colors for plots below


(mycols <- brewer.pal(8, "Dark2")[1:length(unique(condition))])

# Sample distance heatmap
sampleDists <- as.matrix(dist(t(assay(rld))))

png("qc-heatmap-samples.png", w=1000, h=1000, pointsize=20)
heatmap.2(as.matrix(sampleDists), key=F, trace="none",
          col=colorpanel(100, "black", "white"),
          ColSideColors=mycols[condition], RowSideColors=mycols[condition],
          margin=c(19, 19), main="Sample Distance Matrix")
dev.off()

# Principal components analysis
## Could do with built-in DESeq2 function:
## DESeq2::plotPCA(rld, intgroup="condition")
## I like mine better:
rld_pca <- function (rld, intgroup = "condition", ntop = 500, colors=NULL, legendpos="bottomleft", main="PCA Biplot", textcx=1, ...) {
  require(genefilter)
  require(calibrate)
  require(RColorBrewer)
  rv = rowVars(assay(rld))
  select = order(rv, decreasing = TRUE)[seq_len(min(ntop, length(rv)))]
  pca = prcomp(t(assay(rld)[select, ]))
  fac = factor(apply(as.data.frame(colData(rld)[, intgroup, drop = FALSE]), 1, paste, collapse = " : "))
  if (is.null(colors)) {
    if (nlevels(fac) >= 3) {
      colors = brewer.pal(nlevels(fac), "Paired")
    }   else {
      colors = c("black", "red")
    }
  }
  pc1var <- round(summary(pca)$importance[2,1]*100, digits=1)
  pc2var <- round(summary(pca)$importance[2,2]*100, digits=1)
  pc1lab <- paste0("PC1 (",as.character(pc1var),"%)")
  pc2lab <- paste0("PC1 (",as.character(pc2var),"%)")
  plot(PC2~PC1, data=as.data.frame(pca$x), bg=colors[fac], pch=21, xlab=pc1lab, ylab=pc2lab, main=main, ...)
  with(as.data.frame(pca$x), textxy(PC1, PC2, labs=rownames(as.data.frame(pca$x)), cex=textcx))
  legend(legendpos, legend=levels(fac), col=colors, pch=20)
  #     rldyplot(PC2 ~ PC1, groups = fac, data = as.data.frame(pca$rld),
  #            pch = 16, cerld = 2, aspect = "iso", col = colours, main = draw.key(key = list(rect = list(col = colours),
  #                                                                                         terldt = list(levels(fac)), rep = FALSE)))
}
png("qc-pca.png", 1000, 1000, pointsize=20)
rld_pca(rld, colors=mycols, intgroup="condition", xlim=c(-75, 35))
dev.off()


# Get differential expression results
res <- results(dds)
table(res$padj<0.01)
## Order by adjusted p-value
res <- res[order(res$padj), ]



## Merge with normalized count data
resdata <- merge(as.data.frame(res), as.data.frame(counts(dds, normalized=TRUE)), by="row.names", sort=FALSE)
names(resdata)[1] <- "Gene"
head(resdata)
## Write results
write.csv(resdata, file="diffexpr-results.csv")


##combine the gene column of biomart to the deseq2 results 
mart <-read.csv("GeneNames_done.csv",header = TRUE) # load the biomart transcript and Gene Names
head(mart)
genes <- read.csv("diffexpr-results.csv", header = TRUE) # read the DESeqResults.tsv
head(genes)
genes <-merge(genes, mart[, c("Gene","GeneName")])
genes <- genes[,c(ncol(genes),1:(ncol(genes)-1))]
head(genes)
genes$X=NULL
write.csv(genes,"DESeq2.all.genenames.csv")




## Examine plot of p-values
hist(res$pvalue, breaks=50, col="grey")

## Examine independent filtering
attr(res, "filterThreshold")
plot(attr(res,"filterNumRej"), type="b", xlab="quantiles of baseMean", ylab="number of rejections")

## MA plot
## Could do with built-in DESeq2 function:
## DESeq2::plotMA(dds, ylim=c(-1,1), cex=1)
## I like mine better:
maplot <- function (res, thresh=0.01, labelsig=FALSE, textcx=1, ...) {
  with(res, plot(baseMean, log2FoldChange, pch=20, cex=.5, log="x", ...))
  with(subset(res, padj<thresh), points(baseMean, log2FoldChange, col="red", pch=20, cex=1.5))
  if (labelsig) {
    require(calibrate)
    with(subset(res, padj<thresh), textxy(baseMean, log2FoldChange, labs=Gene, cex=textcx, col=2))
  }
}
png("Diffexpr-maplot.png", 1500, 1000, pointsize=20)
maplot(resdata, main="MA Plot")
dev.off()

## Volcano plot with "significant" genes labeled by labelsig=TRUE
volcanoplot <- function (res, lfcthresh=2, sigthresh=0.01, main="Volcano Plot", legendpos="bottomright", labelsig=FALSE, textcx=1, ...) {
  with(res, plot(log2FoldChange, -log10(pvalue), pch=20, main=main, ...))
  with(subset(res, padj<sigthresh ), points(log2FoldChange, -log10(pvalue), pch=20, col="red", ...))
  with(subset(res, abs(log2FoldChange)>lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="orange", ...))
  with(subset(res, padj<sigthresh & abs(log2FoldChange)>lfcthresh), points(log2FoldChange, -log10(pvalue), pch=20, col="green", ...))
  if (labelsig) {
    require(calibrate)
    with(subset(res, padj<sigthresh & abs(log2FoldChange)>lfcthresh), textxy(log2FoldChange, -log10(pvalue), labs=Gene, cex=textcx, ...))
  }
  legend(legendpos, xjust=1, yjust=1, legend=c(paste("FDR<",sigthresh,sep=""), paste("|LogFC|>",lfcthresh,sep=""), "both"), pch=20, col=c("red","orange","green"))
}
png("diffexpr-volcanoplot.png", 1200, 1000, pointsize=20)
volcanoplot(resdata, lfcthresh=1, sigthresh=0.01, textcx=.8, xlim=c(-2.3, 2))
dev.off()

##write results into tables
fdr =0.05
de_total = res[which(resdata$padj < fdr),]
length(de_total[,1])

head(de_total)


write.csv(de_total[order(de_total$padj, decreasing=F),],"DESeq2.de_all.csv")
De_all <-read.csv("DESeq2.de_all.csv")
#add geneNames to the de genes
De_all<-merge(x = De_all, y = mart, by = ncol(De_all[1]), all.x=TRUE)
#bring the last column to front
De_all <-De_all[,c(ncol(De_all),1:(ncol(De_all)-1))]
write.csv(De_all,"DESeq2.de_all_geneNames.csv")

#upregulated genes
de_up = de_total[which(de_total$log2FoldChange>0),]
de_up = de_up[order(de_up$padj, decreasing=F),]   # order by adjusted p-value
length(de_up[,1])
write.csv(de_up,"DESeq2.de_up.csv")
De_upG <-read.csv("DESeq2.de_up.csv")
#add geneNames to the de genes
De_upG<-merge(x = De_upG, y = mart, by = ncol(De_upG[1]), all.x=TRUE)
#bring the last column to front
De_upG <-De_upG[,c(ncol(De_upG),1:(ncol(De_upG)-1))]
write.csv(De_upG,"DESeq2.de_up_geneNames.csv")


de_down = de_total[which(de_total$log2FoldChange<0),]
de_down = de_down[order(de_down$padj, decreasing=F),]           # order by adjusted p-value
length(de_down[,1])
write.csv(de_down,"DESeq2.de_down.csv")
De_downG <-read.csv("DESeq2.de_down.csv")
#add geneNames to the de genes
De_downG<-merge(x = De_downG, y = mart, by = ncol(De_downG[1]), all.x=TRUE)
#bring the last column to front
De_downG <-De_downG[,c(ncol(De_downG),1:(ncol(De_downG)-1))]
write.csv(De_downG,"DESeq2.de_down_geneNames.csv")



#new kind of MA plot

jpeg(
  "DESeq2_MAplot.jpeg",
  width=8,
  height=8,
  units="in",
  res=500)
DESeq2::plotMA(dds, alpha=fdr, ylim=c(-2,2),main=sprintf("MA-plot\n(FDR: %.2f, up: %d, down: %d)",fdr,length(de_up[,1]),length(de_down[,1])),ylab="log2 fold change")
dev.off()


topN=50
# topN genes by pvalue    added the gene Names 
if (length(de_total[,1]) > 0) {
  d = data.frame(id=rownames(de_total), padj=de_total$padj)
  if ( length(rownames(d)) < topN ) topN = length(rownames(d))
  
  d_topx_padj = d[order(d$padj, decreasing=F),][1:topN,]
  d_topx_padj
  plotdata = assay(rld)[as.character(d_topx_padj$id),]  # <- error
  plotdata
  
  ## test
  setdiff( as.character(d_topx_padj$id), rownames(plotdata))
  
  
  
  
  write.csv(plotdata,"Plotdata50genes.csv")
  mart <-read.csv("GeneNames_done.csv",header = TRUE) # load the biomart transcript and Gene Names
  plotData <- read.csv("Plotdata50genes.csv", header = TRUE) # read the plotdata
  head(mart)
  head(plotData)
  #merge the plotdata with mart names
  plotData <-merge(x = plotData, y = mart, by = ncol(plotData[1]), all.x=TRUE) #Merge the genes 
  
  final <- plotData [!(is.na(plotData$GeneName)) ,]
  final
  write.csv(final,"plotdata_aftermerge.csv")
  plotData <-final
  #plotdata <-merge(plotdata, mart[, c("Gene","GeneName")])
  plotData <-plotData[,c(ncol(plotData),1:(ncol(plotData)-1))] # changing the last colum as first column
  head(plotData)
  rnames <- plotData[,1]
  plotData <-data.matrix(plotData[,3:ncol(plotData)])
  rownames(plotData) <- rnames
  head(plotData)

 
 
 
 
  pdf(sprintf("Gene_clustering_top%i_DE_genes.pdf",topN), pointsize = 9)
  heatmap.2(plotData, scale="row", trace="none", dendrogram="column",
            col=colorRampPalette(rev(brewer.pal(9,"RdBu")))(255),
            main=sprintf("Top %d DE genes (by p-value)", topN), keysize=1,
            margins = c(17,21),
            cexRow=0.7, cexCol=0.9)
  dev.off()
}


#Incase there is no biomart then we would just put the gene ids in the heatmap

if (length(de_total[,1]) > 0) {
  d = data.frame(id=rownames(de_total), padj=de_total$padj)
  if ( length(rownames(d)) < topN ) topN = length(rownames(d))
  
  d_topx_padj = d[order(d$padj, decreasing=F),][1:topN,]
  d_topx_padj
  plotdata = assay(rld)[as.character(d_topx_padj$id),]  # <- error
  plotdata
  
  ## test
  setdiff( as.character(d_topx_padj$id), rownames(plotdata))
  
  # rownames(plotdata) = sprintf("%s\n(%s)", colnames(rld), rld$condition) #paste(colnames(rld), rld$condition, sep="-")
  # colnames(plotdata) = sprintf("%s\n(%s)", colnames(rld), rld$condition) #paste(colnames(rld), rld$condition, sep="-")
  
  if ( exists("gene_names_dic") ) rownames(plotdata) = id_to_gene_name(rownames(plotdata))  # exchange ids by gene names
  plotdata
  
  pdf(sprintf("No_geneNames_clustering_top%i_DE_genes.pdf",topN), pointsize = 9)
  heatmap.2(plotdata, scale="row", trace="none", dendrogram="column",
            col=colorRampPalette(rev(brewer.pal(9,"RdBu")))(255),
            main=sprintf("Top %d DE genes (by p-value)", topN), keysize=1,
            margins = c(17,12),
            cexRow=0.7, cexCol=0.9)
  dev.off()
}

#PCA new
data <- plotPCA(rld, intgroup=c( "condition"), returnData=TRUE)
percentVar = round(100 * attr(data, "percentVar"))
ggplot(data, aes(PC1, PC2, color=condition, shape=name)) +
  geom_hline(aes(yintercept=0), colour="grey") +
  geom_vline(aes(xintercept=0), colour="grey") +
  geom_point(size=5) +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  theme_bw(base_size = 14) +
  ggtitle("PCA\n") +
  scale_shape_manual(values=c(0:35,0:35))
ggsave(file=sprintf("PCA.pdf"), width=7, height=6)


file.remove("DESeq2.de_all.csv","diffexpr-results.csv","plotdata_aftermerge.csv","Plotdata50genes.csv","DESeq2.de_up.csv","DESeq2.de_down.csv")















