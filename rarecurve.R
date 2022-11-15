library(vegan)

setwd("Desktop/")

#colorsfor rarecurve
col <- c("NE1"="darkgreen","NE2"="pink","NE3"="purple")

#line
#lty <- c("solid", "dashed", "longdash", "dotdash")

# input format in csv (read counts, the file should be csv)
#Sample	Moraxella osloensis	Corynebacterium striatum	Pseudomonas oryzihabitans	Staphylococcus epidermidis	Pseudomonas resinovorans	Micrococcus luteus	Streptococcus mitis	Streptococcus pneumoniae	Cutibacterium acnes
#NE1	100	689	0	45	0	3112	1234	12333	122
#NE2	200	10300	16900	12	1	443	555	1234	11
#NE3	100	1700	11224	3333	10	3455	800	12222	11

X <- read.csv("test.csv",row.names=1)
head(X)

rarecurve(X, step = 100, xlab= "No. of reads", ylab = "No. of genera",lwd=4,col=col,lty = "solid", label = TRUE)
