library("ggplot2")
library(tidyverse)

data <- read_csv(file = "key-genes.csv")
data

a <- ggplot(data = data) + aes(x=Gene, y=Fold, fill=FDR) + geom_bar(stat="identity") + theme_linedraw(base_size = 15)+ facet_grid(~ Category, scales="free", space="free", facets="Category") + coord_flip() +
 theme_bw()+ theme(axis.text.y=element_text(colour="black",face="italic",size=12), axis.text=element_text(size=12)) +scale_fill_gradient(low="blue", high="red")
  # xlab("Cell types") +
  # ylab("Percentage %")
  # labs(title = "Cell type percentage") +
  # labs(subtitle = "Enrichment test") +
  # labs(fill = "Adjusted\nP values")
#a + scale_fill_viridis_c()
a

ggsave("bar-key-genes.png", plot = last_plot(), device = NULL, path = NULL,
       scale = 1, width = 15, height = 20, units = c("cm"),
       dpi = 320, limitsize = TRUE)
