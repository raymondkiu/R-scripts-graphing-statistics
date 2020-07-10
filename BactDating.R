library(devtools)
library(pkgconfig)
devtools::install_github("xavierdidelot/BactDating")
devtools::install_github("r-lib/pkgbuild", force = TRUE)
R <- 1
library(dplyr)
library(BactDating)
devtools::install_github('xavierdidelot/TransPhylo')
library(TransPhylo)
library(ape)
library(coda)

# To set working directory
setwd("Desktop/Bactdating/")

# set seed
set.seed(0)

# To load clonalframeML output (use the prefix)
t=loadCFML(prefix ="clonalframeML.out")

# To see the tip labels in the tree
t$tip.label

# Load csv as object R (column 1 = samples name, column 2 = decimal year)
e <-readLines("Name.csv")
e
d <-as.numeric(readLines("DecimalYear.csv"))  # coerce character data as numeric data
d

# Load into names functions
names(d) <- d
names(d) <- e
d
names(d)

# Rooting tree
rooted=initRoot(t,d,mtry = 10, useRec = T)
rooted
plot(rooted,show.tip.label = F)

# Root to tip analysis: temporal signal
roottotip(rooted, d, rate = NA, permTest = 100000, showFig = T,
          colored = T, showPredInt = "gamma", showText = T, showTree = T)

# Main analysis
res=bactdate(rooted,d,nbIts=10000)
#res=bactdate(unroot(rooted),d,nbIts=1000)
plot(res,'treeCI',show.tip.label = F, show.axis = T,cex = .2,)

# See where is the root
plot(res,'treeRoot',show.tip.label=T)

# See the MCMC
plot(res,'trace')
mcmc=as.mcmc(res)
effectiveSize(mcmc)

# Checking for convergence
res=bactdate(t,d,nbIts=1e5)

plot(res,'trace')
plot(res,'treeCI')
axisPhylo(backward = F)
plot(rooted)
plot(res)
axisPhylo(backward = F)
plot(res,'scatter')




