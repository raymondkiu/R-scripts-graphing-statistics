# this script can analyse population diversity - inverse Simpson index, Shannon Weaver index and Fisher Alpha index using diversity package

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
