# Functional analysis using a list of Ensembl gene ID via ClusterProfiler
# Plotting codes included
# Input: Tab-delimited gene list (.txt) with header 'Ensembl' - that's it, sth like:
#Ensembl
#ENSMUSG00000060807
#ENSMUSG00000107705
#ENSMUSG00000051159
#ENSMUSG00000101878
#ENSMUSG00000031383
# Output: 
# 1. Tab-delimited file with all functional information
# 2. Pretty plots
# Author: Raymond Kiu Raymond.Kiu@quadram.ac.uk (2020)

# install Biocmanager
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
# Install clusterProfiler
BiocManager::install("clusterProfiler")

# Download mus musculus db (required)
BiocManager::install("org.Mm.eg.db")

# source required libraries
library(dplyr)
library(ReactomePA)
library(clusterProfiler)
library(ggplot2)
library(forcats)

# Empty df's for data
all_reactome <- data.frame()
all_kegg <- data.frame()
all_go <- data.frame()
all_mkegg <- data.frame()

setwd("~/Sleuth/")
# Read tab delimited file as input: header: Ensembl, A list of EnsemblID gene in the same column
input_g <- read.delim("test3.txt", header=T)

# Prepare data
# Get ENTREZID for each ENSEMBL gene ID on column 2 (it will generate itself) - input_e
input_e <- bitr(input_g$Ensembl, fromType='ENSEMBL', toType='ENTREZID', OrgDb="org.Mm.eg.db")
input_e


##################
#### REACTOME ####
##################

# Reactome pathway enrichment
genes_reactome <- enrichPathway(gene=input_e$ENTREZID,organism ="mouse",pvalueCutoff=0.05,readable=T)
#Get reactome results
genes_reactome2 <- as.data.frame(genes_reactome)
genes_reactome2
all_reactome <- rbind(all_reactome, genes_reactome2)


##################
#### GO ##########
##################

# Run gene mapping, ont can be MF, BP, CC or ALL for three
genes_go <- enrichGO(gene=input_e$ENTREZID, OrgDb="org.Mm.eg.db",ont= "BP", pvalueCutoff=0.05)
genes_go

# Drop GO level=3 (maybe worthwhile doing this)
# dropped_go <- dropGO(genes_go, level=3)
#Get GO results
genes_go2 <- as.data.frame(genes_go)
all_go <- rbind(all_go, genes_go2)
all_go


##################
#### KEGG ########
##################

#KEGG pathway enrichment
genes_kegg <- enrichKEGG(gene=input_e$ENTREZID ,organism = "mmu",pvalueCutoff = 0.05)
#Get KEGG results
genes_kegg2 <- as.data.frame(genes_kegg)
genes_kegg2

#Append reactome results to previous results
all_kegg <- rbind(all_kegg, genes_kegg2)
all_kegg


#### Plotting: for example reactome top 10 ####
# Get top 10 list by p adjust
all_reactome_top10 <- all_reactome %>% top_n(-10, p.adjust)
# Convert gene ratio to decimal
all_reactome_top10$GeneRatio <- sapply(all_reactome_top10$GeneRatio, function(x) eval(parse(text=x)))
all_reactome_top10$GeneRatio
all_reactome_top10

# plotting
ggplot(all_reactome_top10, aes(x = GeneRatio, y = fct_reorder(Description, GeneRatio))) + 
  geom_point(aes(color = p.adjust,size = Count)) +
  theme_bw(base_size = 20) +
  scale_colour_gradient(high="mediumblue", low="red2") +
  ylab(NULL)

#### Plotting: for example GO top 15 ####
# Change labels and get top 10 by p adjust - change the x in top_n(-x, p.adjust) for top x terms
# it is -x because we want the least p.adjust so technically it is ranking from the bottom.
all_go
all_go_top15 <- top_n(all_go, -15, p.adjust)
# all_go_top15 <- top_n(all_go, 20, Count) # Top 20 by gene count
# all_go_top15 <- all_go %>% top_n(-20, p.adjust) # This works as well. Can compare

# Convert gene ratio to decimal
all_go_top15$GeneRatio <- sapply(all_go_top15$GeneRatio, function(x) eval(parse(text=x)))
all_go_top15

# plotting
ggplot(all_go_top15, aes(x = GeneRatio, y = fct_reorder(Description, GeneRatio))) + 
  geom_point(aes(color = p.adjust,size = Count)) +
  theme_bw(base_size = 14) +
  scale_colour_gradient(high="mediumblue", low="red2",space = "Lab")+
  ylab(NULL)

#### Plotting: for example KEGG top 10 ####
# Change labels and get top 15 by p adjust
all_kegg_top15 <- all_kegg %>% top_n(-15, p.adjust)
# Convert gene ratio to decimal
all_kegg_top15$GeneRatio <- sapply(all_top15$GeneRatio, function(x) eval(parse(text=x)))
all_kegg_top15

# plotting
ggplot(all_kegg_top15, aes(x = GeneRatio, y = fct_reorder(Description, GeneRatio))) + 
  geom_point(aes(color = p.adjust,size = Count)) +
  theme_bw(base_size = 14) +
  scale_colour_gradient(high="mediumblue", low="red2",space = "Lab")+
  ylab(NULL)

#### Save table outputs ####
write.table(all_reactome, "FunctionalEnrichment_Reactome_0.05.txt",quote = F, sep = "\t", row.names = F)
write.table(all_kegg, "FunctionalEnrichment_KEGG_0.05.txt",quote = F, sep = "\t", row.names = F)
write.table(all_go, "FunctionalEnrichment_GO_0.05.txt",quote = F, sep = "\t", row.names = F)
