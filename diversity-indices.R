# this script can analyse population diversity - inverse Simpson index, Shannon Weaver index and Fisher Alpha index using diversity package

library(vegan)

# Data format:
#Genus	C1	C2	C3	C4	C5	E1	E2	E3	E4	E5
#Mucispirillum	0	0	0	0	0.284577933	0	0	0	0.097360774	0.023813304
#Bacteroides	32.28779718	52.80707855	25.98486069	68.13351813	59.58650483	64.56351459	53.25338313	57.8253519	54.20298972	26.26318752
#Odoribacter	0	0	0	0	0	0	0	0	0	0
#Prevotella	0.29717682	1.37166261	0.94057014	2.065142065	0.860591099	0.122601884	0.020614056	0.218452596	0.136305084	0.040410455


X <- read.csv("Genus-only-normalised.csv",row.names=1)
head(X)
row.names(X)
Y <- t(X)


alpha <-fisher.alpha(Y, MARGIN =1, se = TRUE)

########## compute the diversity analysis

simp <- diversity(Y, "simpson")
invsimp <- diversity(Y, "invsimpson")
shannon <- diversity(Y,"shannon")


############ print the diversity index

rbind(invsimp)
rbind(shannon)
rbind(alpha)

# show all indices in column
cbind(invsimp,shannon,alpha)

Z <- cbind(invsimp,shannon)

write.csv(Z, file="diversity-index.csv"). # write into csv

#Sample	1/Simpson	Shannon
#C1	2.065260335	0.932623078
#C2	2.373586835	1.088605054
#C3	1.98979124	0.95799131
