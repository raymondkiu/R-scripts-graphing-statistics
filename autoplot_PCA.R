setwd("U:/Raymond_Kiu/Research/Aim1_WGS_analysis/Imperial_cohort/Pheno_PCA/")
library(ggfortify)
library(cluster)
require("gplots")
require("ggplot2")
require("RColorBrewer")
data <- read.csv("Pheno_Scoring.csv")
head(data[1])


df <- data[c(2:ncol(data))]
head(df)

########################################################################################################
## Use 'quantile' method - ignore 0 in the matrix to get better distance clustering based on ranking  ##
########################################################################################################
#quants <- normalize.quantiles(as.matrix(df), copy = F)
#pca.data <-prcomp(quants,
#                  center = TRUE,
#                  scale. = TRUE)
# autoplot(pac.data, data = data, colour = 'Group', size =4, loadings.label = TRUE, label.size ="10", loadings.label.colour="black")


png("PCA_test.png",
    width = 6*800,        # 5 x 300 pixels
    height = 6*800,
    res = 800,            # 300 pixels per inch
    pointsize = 20)

autoplot(prcomp(df), data = data, colour = 'Group', size =4, loadings.label = TRUE, label.size ="10", loadings.label.colour="black")+
theme(legend.position="bottom", legend.direction="horizontal", legend.title = element_blank())+
scale_color_manual(values=c("BELL2/3"="Red","BELL1"="#8e44ad","Red","Non-NEC"="#28b463","Purple","Brown","Orange","Black"))+ 
   geom_point(aes(shape=Group, color=Group))+
  scale_shape_manual(values=c(3, 16, 17))

#autoplot(pam(df, 2), frame = TRUE, frame.type = 'norm') 
#autoplot(fanny(df, 3), frame = TRUE)+
#  theme(legend.position="bottom", legend.direction="horizontal", legend.title = element_blank())
#autoplot

dev.off()

