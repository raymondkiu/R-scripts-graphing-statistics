library(tidyverse)

data <- read_csv(file = "key-genes2.csv")
data

a <- ggplot(data = data) + aes(x=Gene, y=Fold, fill=FDR) + geom_bar(stat="identity") + theme_linedraw(base_size = 12) + facet_grid(~ Category, scales="free", space="free", facets="Category") + coord_flip()  +   # Side bar chart as coordination is flipped
  
  ylim(-6,6)+ theme_bw()+ theme(axis.text.y=element_text(colour="black",face="italic",size=12), axis.text=element_text(size=12)) + 
  scale_fill_gradient(low="blue", high="red") + # Fill the bar with gradient colour
  geom_errorbar(aes(ymin=Fold-SE, ymax=Fold+SE), colour="darkgrey",width=.5) # Add in error bar

a  # view the plot (object) in the R studio


ggsave("bar-key-genes2.png", plot = last_plot(), device = NULL, path = NULL,    # Save the plot to png format
       scale = 1, width = 20, height = 35, units = c("cm"),
       dpi = 1500, limitsize = TRUE)
