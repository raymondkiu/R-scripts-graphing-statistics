setwd("U:/Raymond_Kiu/Research/Aim1_WGS_analysis/Imperial_cohort/virulence_PCA/")
library(ggfortify)
library(cluster)
require("gplots")
require("ggplot2")
require("RColorBrewer")
data <- read.csv("virulence.csv")
head(data[1])


df <- data[c(2:ncol(data))]
head(df)

png("PCA_virulence.png",
    width = 6*800,        # 5 x 300 pixels
    height = 6*800,
    res = 800,            # 300 pixels per inch
    pointsize = 20)

autoplot(prcomp(df), data = data, colour = 'Group', size =5, loadings.label = TRUE,loadings.label.repel= TRUE,loadings.label.size=3, label.size ="12", loadings.label.colour="black")+
theme(legend.position="bottom", legend.direction="horizontal", legend.title = element_blank())+
scale_color_manual(values=c("Bell2/3"="Red","Bell1"="#ffcc00","Non-NEC"="Blue","Purple","Brown","Orange","Black","Green","Yellow","Lightgreen","Lightblue","Gray"))+ 
   geom_point(aes(shape=Group, color=Group))
  #scale_shape_manual(values=c(3, 16, 17))
#autoplot(pam(df, 2), frame = TRUE, frame.type = 'norm') 
#autoplot(fanny(df, 3), frame = TRUE)+
#  theme(legend.position="bottom", legend.direction="horizontal", legend.title = element_blank())
#autoplot
dev.off()
