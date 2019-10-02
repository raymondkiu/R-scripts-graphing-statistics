# Author: Raymond Kiu Raymond.Kiu@quadram.ac.uk

#####################################################################
# To install and load required packages and setting working directory
#####################################################################
#if (!require("gplots")) {
#   install.packages("gplots", dependencies = TRUE)
#   library(gplots)
#   }
#if (!require("RColorBrewer")) {
#   install.packages("RColorBrewer", dependencies = TRUE)
#   library(RColorBrewer)
#   }

#########################################################
# Loading required packages and setting working directory
#########################################################
library(gplots)
library(RColorBrewer)

setwd("working directory path")    #set working directory

#########################################################
# reading in data and transform it to matrix format
#########################################################

data <- read.csv("combined.binary.insertion.csv")
head(data)                                    # print the frist first row to check if the data looks OK
rnames <- data[,1]                            # assign labels in column 1 to "rnames"
mat_data <- data.matrix(data[,2:ncol(data)])  # transform column 2-5 into a matrix
rownames(mat_data) <- rnames                  # assign row names

#########################################################
# customizing and plotting heatmap
#########################################################

# creates a own color palette from red to green, this is an example of 3 color breaks
my_palette <- colorRampPalette(c("white","white", "plum2"))(n = 299) 
# refer to http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf for colour name (different from HTML code)
# (optional) defines the color breaks manually for a "skewed"color transition
col_breaks = c(seq(0,0.1,length=100),             # color 1
               seq(0.2,0.3,length=100),           # color 2
               seq(0.4,1.0,length=100))           # color 3

# below is an example of 4 color breaks: uncomment to use the script, change the color as you like,
# my_palette <- colorRampPalette(c("white","red","purple4", "plum2"))(n = 399)
# col_breaks = c(seq(0,0.9,length=100),          # color 1
#               seq(1,1.5,length=100),           # color 2
#               seq(1.6,2.5,length=100),         # color 3   
#               seq(2.6,3.5,length=100))         # color 4           

# print an image in png format - if you want to save the picture directly into a new file which you cannot visualise in the R studio
# adjust resolution and width and height accordingly- test for best combination
png("test.png",
  width = 5*300,        # 5 x 300 pixels
  height = 60*300,
  res = 300,            # 300 pixels per inch
  pointsize = 40)        # smaller font size

# changes the distance measure and clustering method
# NOTE: Matrix here not symmetrical. For symmetrical matrices
# only one distance and cluster could and SHOULD be defined.
# Distance options: euclidean (default), maximum, canberra, binary, minkowski, manhattan
# Cluster options: complete (default), single, average, mcquitty, median, centroid, ward
#row_distance = dist(mat_data, method = "manhattan")
#row_cluster = hclust(row_distance, method = "ward.D")
#col_distance = dist(t(mat_data), method = "manhattan")
#col_cluster = hclust(col_distance, method = "ward.D")



heatmap.2(mat_data,
          key=FALSE, key.xlab="Percentage Identity (%)", keysize=1.0, key.title=NULL, #details about color key
          cexRow=0.6, cexCol=0.7, #size of col and row.
          #  xlab = "Clostridium perfringens strains", ylab ="Toxins/ Virulent Enzymes",
          #scale="none",
          breaks= col_breaks,      # color breaks
          #main = "Antimicrobial Resistance Profile", # heat map title
          notecol = "black",      # change font color of cell labels to black#
          density.info = "density",  # turns off density plot inside color legend
          dendrogram="none",
          trace = "none",         # turns off trace lines inside the heat map
          margins = c(3,3),     # widens margins around plot
          col = my_palette,       # use on color palette defined earlier
          colsep=0:ncol(mat_data), # apply separation from which column
          rowsep=0:nrow(mat_data), # apply separation from which row
          sepcolor=" gray85", # separation (border color)
          sepwidth=c(0.05,0.05),  # separation width (border width)
          Rowv=FALSE, # apply default clustering method
          Colv=FALSE,
          #Rowv = as.dendrogram(row_cluster), # apply default clustering method
          #Colv = as.dendrogram(col_cluster) # apply default clustering method
          #RowSideColors=as.character(as.numeric(dat$GO)
)

# To extract ordered row names for the clustering use below and write a csv
# sorted <- mat_data [match(rev(labels(hh$rowDendrogram)), rownames(mat_data)), ]
# head(sorted)
# write.csv(sorted,"sorted.csv")

########################
####To print legend
########################
#legend ("topleft",
#title="Heatmap Legend",
#title.adj=-1,
# legend=c("Absent","Present"),
#fill=c("lightgrey","darkblue"), border=FALSE, bty="o", y.intersp = 0.8, x.intersp =0.4, cex=0.8, pt.cex=1.5)


dev.off()




