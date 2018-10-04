## Author: Raymond Kiu Raymond.Kiu@quadram.ac.uk

#############################
## create a world map in R ##
#############################

library(rworldmap)
newmap <- getMap(resolution = "low", projection = NA) # resolution can be low, less islands, li or high
plot(newmap)

# create a European map
# plot(newmap, xlim = c(-20, 59), ylim = c(35, 71), asp = 1, col = "lightgrey")
