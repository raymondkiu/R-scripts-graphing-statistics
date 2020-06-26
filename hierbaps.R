## Author: Raymond Kiu Raymond.Kiu@quadram.ac.uk
## This R script computes phylogenetic clustering using hierbaps method

# Install packages
install.packages("rhierbaps")
install.packages("devtools")
#install.packages("ggtree")
install.packages("phytools")

# install ggtree - special source
source("https://bioconductor.org/biocLite.R")
biocLite("ggtree")

# Load libraries
library(rhierbaps)
library(ggtree)
library(phytools)

# Set seed
set.seed(1234) # To enable reproduction of the same result

# Set working directory (path to your file)
setwd("U:/")
    
# Load FASTA file  
snp.matrix <- load_fasta("coregene_snp.fa")

# Predict clustering (main run)
hb.results <- hierBAPS(snp.matrix, max.depth = 2, n.pops = 20, quiet = TRUE, n.cores = 4)
# n.cores only available in Linux R not in R studio

# Look into your data, first column should be your isolate names
head(hb.results$partition.df)
tail(hb.results$partition.df)

############### this section is additional and not tested ###########################
hb.results <- hierBAPS(snp.matrix, max.depth = 2, n.pops = 20, n.extra.rounds = Inf, 
                       quiet = TRUE)

system.time(hierBAPS(snp.matrix, max.depth = 2, n.pops = 20, quiet = TRUE))
#>    user  system elapsed 
#>  83.378  10.177  96.571
#check running time

# plotting:
newick.file.name <- file("coregene_snp.tree", package = "rhierbaps")
iqtree <- phytools::read.newick(coregene_snp.tree)

#####################################################################################

# To save files in csv:
write.csv(hb.results$partition.df, file = "hierbaps_partition.csv")

#save_lml_logs(hb.results, file.path(tempdir(), "hierbaps_logML.txt"))
