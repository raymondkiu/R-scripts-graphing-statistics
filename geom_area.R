setwd("U:/Raymond_Kiu/Research/Papers/04_PHE_food_poisoning/Figures") 
# library(scales)
library(ggplot2)
# library(scales)




cbPalette <- c( Food = "#cc0000", Carehome = "#0000FF", Actinomyces = "#EEEE00", Anaerostipes = "#CD00CD", Bacteroides = "#FFC125", Bifidobacterium = "#0000FF" , Blautia = "#FFFF00", Chryseobacterium = "#8A360F", Citrobacter = "#FF3030" , Clostridium = "#5E2612", Dorea = "#87CEFA", Enterobacter = "#8E8E38", Enterococcus = "#00BFFF", Erysipelatoclostridium = "#EE1289", Escherichia = "#FF9912", Faecalibacterium = "#00FF00", Fastidiosipila = "#FFD700", Fusicatenibacter = "#555555", Geobacillus = "#FA8072", Granulicatella = "#FF82AB", Haemophilus = "#71C671", Intestinibacter = "#800000", Lachnoclostridium = "#191970", Lactobacillus = "#00EE76", Mesorhizobium = "#8B008B", Other = "#8B8386", Paeniclostridium = "#CAE1FF", Peptoclostridium = "#C0FF3E", Propionibacterium = "#8B4513", Pseudomonas = "#FFB5C5", Rhodococcus = "#CD69C9", Rikenella = "#CD6600", Robinsoniella = "#D02090", Roseburia = "#9C66IF", Lactococcus = "#7FFFD4", Rothia = "#66CD00", Sellimonas = "#00CED1", Shigella = "#DC143C", Staphylococcus = "#872657", Stenotrophomonas = "#008B45", Streptococcus = "#00FFFF", Tyzzerella = "#9F79EE")
#cbPalette <- c( Acinetobacter = "#F0FFF0", Actinobacillus = "#698B69", Actinomyces = "#98FB98", Bacteroides = "#FF6347", Bifidobacterium = "#56B4E9" , Blautia = "#999991", Chryseobacterium = "#FAEBD7", Citrobacter = "#FFA500" , Clostridium = "#009E73", Dorea = "#F0E442", Enterobacter = "#0072B2", Enterococcus = "#D55E00", environmental= "#CC79A7", Erysipelatoclostridium = "#CD6889", Escherichia = "#EE1289", Faecalibacterium = "#8B0A50", Faecalitalea = "#308014", Gemella = "#CD69C9", Granulicatella = "#C4C4C4", Haemophilus = "#FFE1FF", Lachnoclostridium = "#EED2EE", Lactobacillus = "#CDB5CD", Mesorhizobium = "#8B668B", Peptoclostridium = "#EE82EE", Propionibacterium = "#483D8B", Rhodococcus = "#473C8B", Roseburia = "#0000EE", Ruminococcaceae = "#3D59AB", Selenomonadales = "#4169E1", Sellimonas = "#6C7B8B", Staphylococcus = "#4A708B", Stenotrophomonas = "#00B2EE", Streptococcus = "#00688B" , other = "")
Stack_data <- read.csv("frequency.csv")
test <- head(Stack_data)

png(filename= "frequency.png",
    width = 2000,        # 5 x 300 pixels
    height = 1200,
    res = 300,            # 300 pixels per inch
    pointsize = 40)        # smaller font size
#png(filename = "frequency.png", width = 1200,
#    height = 800);

# Copy Stack_data to x
#x <-test;
x <- Stack_data;






# Add a column named frac which is percentages rather than counts.
multv <- c();
for(hr in c(2010,2011,2012,2013,2014,2015,2016,2017)) {
  num <- nrow(x[x$Year == hr,]);
  hsum <- sum(x[x$Year == hr, "Number"]);
  multv <- c(multv, rep(hsum, num));
}
#x$frac <- (x$Counts / multv) * 100;

# below we are reordering them to show the values in decreasing order
#x$Organism <- reorder(x$Organism, x$frac)
#x$Organism <- factor(x$Organism, levels=rev(levels(x$Organism)))

# Below, we are plotting from dataframe x using "frac" and "Hours".

p2 <- ggplot() + theme_classic() +
  geom_area( aes( x = Year, y = Number, fill = Cohort), data = x, stat="identity", position = "stack") +
  
  scale_fill_manual(values=cbPalette)+
  theme(legend.position="top", legend.direction="horizontal", legend.title = element_blank()) +
  
  scale_x_continuous(breaks=seq(2005,2018,1)) +
  labs(x="Year of isolation",y="Number of genomes") +
  ggtitle("title")



p2
dev.off()
