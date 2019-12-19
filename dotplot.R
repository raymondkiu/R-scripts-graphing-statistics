setwd("/")
library(ggplot2)

 
#data <- read.csv("testing1.csv",sep =";", header = TRUE, stringsAsFactors = FALSE)
data <- read.csv("testing1.csv", header = TRUE, stringsAsFactors = FALSE)
data
data2<- ggplot(data, aes(y=Pathway, x=Count, size=FoldChange, color=FDR)) + facet_grid(Group ~ .) + geom_point(alpha = 0.8) + theme_bw()
data2

data2 = data2 + scale_color_gradient(low = "red2",  high = "mediumblue", space = "Lab", limit = c(0.00000000000000000000000000000000000000000000000004, 0.05))
data2 +scale_size(range = c(2, 5))
data2 
