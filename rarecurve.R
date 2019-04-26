library(Hotelling)
library(vegan)
library(plyr)

#####colorsfor rarecurve
col <- c("darkgreen", "green3","green","red4", "red2", "red", "navy",  "royalblue","skyblue1","purple4","violet","cyan3","green","navy","darkgreen","pink")
#lty <- c("solid", "dashed", "longdash", "dotdash")

X <- read.csv("Genus-only.csv",row.names=1)
head(X)
Y <- t(X)
pdf("rarecurve_2.pdf",6,6)

rarecurve(Y, step = 100, xlab= "No. of normalised reads", ylab = "No. of genera",lwd=4,col = col,lty = "solid", label = FALSE)
legend("bottomright", 
       legend = c(row.names(Y)), 
       col = col, 
       pch =26:31, 
       lwd=4,
       ncol=2,
       x.intersp=0.5,
       bty = "n", 
       pt.cex = 5, 
       cex = 0.8, 
       text.col = "black", 
       horiz = F , 
       inset = c(0.1, 0.1, 0.1))

dev.off()
