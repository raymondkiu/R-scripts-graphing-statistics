# Create a cfu/g bar charts comparison with logticks, log10 y axis and error bars

library(tidyverse)
library(scales)

# Data format
#Sample	Mean	SD	Group
#Day 1	0.01	0.001	Faeces
#Day 2	13000000	5000000	Faeces
#Day 3	150000000	7000000	Faeces
#Day 4	110000000	8900000	Faeces
#Small Intestine	250000	15000	Intestinal Contents
#Colon	950000000	40000	Intestinal Contents

data <- read_csv(file = "cfu.csv")
data


# note that legend key title was turned off
b <- ggplot(data = data) + aes(x=Sample, y=data$Mean, fill=Group) + geom_bar(stat = "identity") + 
  theme_linedraw(base_size = 12)+
  theme_bw()+ theme(axis.text.y=element_text(colour="black",face="italic",size=14), axis.text.x=element_text(size=14, angle=0, color="black")) + 
  guides(fill = guide_legend(reverse = FALSE)) +  theme(legend.text = element_text(colour="black", size=14)) + theme(legend.title = element_blank())+ 
                                                                                 
  scale_x_discrete(limits=data$Sample)+
  geom_errorbar(aes(ymin=Mean-SD, ymax=Mean+SD), colour="black",width=.2) 

# Use log10 on y axis with logticks on the left side (l), 
b + scale_y_continuous(trans = log10_trans(),
                      breaks = trans_breaks("log10", function(x) 10^x),
                      limits = c(1,1e10),
                      labels = trans_format("log10", math_format(10^.x))) + annotation_logticks(sides="l") + 
# Use grey color palette                      
scale_fill_grey()

# Save as png file
ggsave("cfu.png", plot = last_plot(), device = NULL, path = NULL,
       scale = 1, width = 25, height = 15, units = c("cm"),
       dpi = 600, limitsize = TRUE)
