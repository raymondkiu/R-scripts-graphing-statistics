setwd("U:/Raymond_Kiu/Research/Thesis/Chapter_7/")
library(ggfortify)
library(cluster)
library(gplots)
library(ggplot2)
library(RColorBrewer)
# autoplot(prcomp(df), data = data, color = 'ID' , size =6, shape=20, fill= NULL ,loadings.label = TRUE,loadings.label.repel= TRUE,loadings.label.size=4, label.size ="10")+
#   theme(legend.position="bottom", legend.direction="horizontal", legend.title = element_blank())+
#   scale_color_manual(values=c("BELL2/3"="Blue","BELL1"="slateblue1","Non-NEC"="Springgreen3"))+
#   scale_fill_manual(values=c("BELL2/3"="Blue","BELL1"="slateblue1","Non-NEC"="Springgreen3"))+
#   geom_point(aes(color=ID))
data <- read.csv("Pheno_Scoring_individual_new_10.18.csv")
head(data[1])


df <- data[c(2:ncol(data))]
head(df)

png("PCA_virulence_final_5label.png", width = 6*800, height = 6*800, res = 800, pointsize = 15)
# png("PCA_test.png",
# width = 6*800,        # 5 x 300 pixels
# height = 6*800,
# res = 800,
# pointsize = 20)

#autoplot(prcomp(df), data = data, colour = 'ID',frame=FALSE,frame.type='convex',loadings=TRUE,loadings.label=TRUE,loadings.label.repel=TRUE,size=4,loadings.label.colour="black")+
#  theme(legend.position="bottom", legend.direction="horizontal", legend.title = element_blank())+
#autoplot(prcomp(df),data=data,colour='ID', label=FALSE, frame=FALSE,frame.type='convex',loadings=TRUE,loadings.label=TRUE,loadings.label.repel=TRUE,size=3,loadings.label.colour="black")+scale_color_manual(values=c("red", "slateblue1", "Springgreen3","black", "darkred", "forestgreen", "orange", "blue", "yellow", "skyblue","grey","violet","darkturquoise","darkviolet","green","navy","darkgreen","pink"))+
#  scale_fill_manual(values=c("red", "slateblue1", "Springgreen3", "black", "darkred", "forestgreen", "orange", "blue", "yellow", "skyblue","grey","violet","darkturquoise","darkviolet","green","navy","darkgreen","pink"))+theme_bw()+ylab("PC2")

autoplot(prcomp(df),data=data,colour='ID', label=TRUE, frame=TRUE,frame.type='convex',loadings=TRUE,loadings.label=TRUE,loadings.label.repel=TRUE,size=3,loadings.label.size=3,loadings.label.colour="black")+scale_color_manual(values=c("red", "slateblue1", "Springgreen3","black", "darkred", "forestgreen", "orange", "blue", "yellow", "skyblue","grey","violet","darkturquoise","darkviolet","green","navy","darkgreen","pink"))+
  scale_fill_manual(values=c("red", "slateblue1", "Springgreen3", "black", "darkred", "forestgreen", "orange", "blue", "yellow", "skyblue","grey","violet","darkturquoise","darkviolet","green","navy","darkgreen","pink"))+theme_bw()+theme(legend.position="bottom", legend.direction="horizontal", legend.title = element_blank())


dev.off()
