library(tidyverse) # To use ggsave
library(cluster) # To use prcomp
library(ggfortify)
library(ggsci)  # this is the color palette package, refer to https://nanx.me/ggsci/reference/index.html
library(gridExtra)


data3 <- read_csv("16S-PCA.csv")

df <- data3[c(3:ncol(data3))]
head(df)


# Use PCA as an example
aa <-autoplot(prcomp(df), label=FALSE,  frame = FALSE,frame.type="t", data = data3, colour = "Group", size =4, loadings=TRUE, loadings.label = FALSE, label.size =15, loadings.colour="black")+
  theme(legend.position="bottom", legend.direction="horizontal", legend.title = element_blank()) + theme_bw()+ theme(axis.text.y=element_text(colour="black",size=14), axis.text.x=element_text(colour="black",size=14),axis.text=element_text(size=14))+
  geom_point(aes(color=Group))

aa + scale_color_nejm()

# To save as png
ggsave("test-nejm.png", plot = last_plot(), device = NULL, path = NULL,
       scale = 1, width = 24, height = 20, units = c("cm"),
       dpi =1200, limitsize = TRUE)
