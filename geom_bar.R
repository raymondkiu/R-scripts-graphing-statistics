setwd("/")
library(ggplot2)

data <- read.csv("BP-bar.csv", header = TRUE, stringsAsFactors = FALSE)
data

png("Col.png",
    width = 6*1050,        # 5 x 300 pixels
    height =6*450,
    res = 600,            # 300 pixels per inch
    pointsize =40)

Data2<- ggplot(data, aes(x=reorder(Term, Gene_count), y=Gene_count)) + facet_grid(Group ~ ., drop=TRUE) + geom_bar(fill="Blue",stat="identity",position="stack") + theme_bw()+ ylim(0,1000) + coord_flip()
Data2

dev.off()

