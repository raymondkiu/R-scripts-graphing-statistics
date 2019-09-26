# Author: Raymond Kiu Raymond.Kiu@quadram.ac.uk
# This script is very useful to merge files based on one common column (column 1), can join multiple columns

# sourcing the required libraries
#if (!requireNamespace("BiocManager", quietly = TRUE))
# install.packages("BiocManager")
#BiocManager::install("DESeq2")
library(DESeq2)
library(RColorBrewer)
library(gplots)
library(ggplot2)
#source("https://bioconductor.org/biocLite.R")
#biocLite("tximport")
library(tximport)
#biocLite("rhdf5")
setwd("U:/")

# This script merges mart and plotData two csv files, using plotData as the base, will print everything in plotData empty cell (unmapped) will be added with NA.
mart <-read.csv("mart_export.csv",header = TRUE) # load the biomart transcript and Gene Names
plotData <- read.csv("counts.csv", header = TRUE) # read the plotdata
head(mart)
head(plotData)
#merge the plotdata with mart names
plotData <-merge(x = plotData, y = mart, by = ncol(plotData[1]), all.x=TRUE) #Merge the genes based on column [1]
head(plotData)

# final is deleting any rows with 'NA' - only do this if you know what you are doing
#final <- plotData [!(is.na(plotData$GeneName)) ,]
#final
#write.csv(final,"merged-final.csv")

# print a csv file -not 'final'
write.csv(plotData,"merged.csv")
