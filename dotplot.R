setwd("/")
library(ggplot2)

 
#data <- read.csv("dotplot-data.csv",sep =";", header = TRUE, stringsAsFactors = FALSE)
data <- read.csv("Reactome.csv", header = TRUE, stringsAsFactors = FALSE)
data

png("Reactome3.png",
    width = 6*675,        # 5 x 300 pixels
    height =6*470,
    res = 600,            # 300 pixels per inch
    pointsize =12)

data2<- ggplot(data, aes(y=Term, x=Fold_Enrichment, size=Gene_Count, color=FDR, stat="identity")) + facet_grid(Group ~ ., drop=TRUE, scales="free_x") + geom_point(alpha = 0.9) + theme_bw() + scale_y_discrete(limits=data$Term) + xlim(1.0,3.1)
data2
 
data2 = data2+scale_color_gradient(low = "red2",  high = "mediumblue", space = "Lab", limit = c(0.00000000001, 0.05))

data2+scale_size(range = c(1, 4), limits = c(5,500))
data2
 
dev.off()
