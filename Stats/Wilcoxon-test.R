# Wilcoxon/Mann-Whitney U Test - non-parametric ranking test for 2 groups of samples
# Input as below in AA.csv file (anyname will do):
#Group	Expression
#GF	7.494513561
#GF	162.7364256
#GF	5.363562804
#GF	132.7034936
#GF	156.1904421
#GF+	7.458721592
#GF+	112.796109
#GF+	122.5823552
#GF+	8.514227517
#GF+	7.362322081

# Read data:
Data <- read.csv("AA.csv")
Data

# Wilcox test = t-test but non-parametric, ranking test
# Expression is numeric, only compares two groups, better to have a separate input

res <- wilcox.test(Expression ~ Group, data = Data, exact=FALSE,alternative = "two.sided") # two-sided test

res$p.value # print the p-value only

res # print everything

# You see sth like this:
#Wilcoxon rank sum test with continuity correction

#data:  Expression by Group
#W = 0, p-value = 0.01219
#alternative hypothesis: true location shift is not equal to 0

# To print out stats as below:
library(dplyr)
group_by(data, Group, Gene) %>%
  summarise(
    count = n(),
    median = median(Expression, na.rm = TRUE),
    mean = mean(Expression, na.rm=TRUE),
    IQR = IQR(Expression, na.rm = TRUE))
    
# you will see:
# A tibble: 16 x 6
# Groups:   Group [2]
#   Group Gene  count median    mean   IQR
#   <chr> <chr> <int>  <dbl>   <dbl> <dbl>
# 1 GF    Ddx3y     5 677.   430.    715. 
# 2 GF    Frmd7     5   0      0.479   0  
# 3 GF    Kdm5d     5 133.    92.9   149. 
# 4 GF    Sry       5   0      0       0  
# 5 GF    Usp9y     5   0      0       0  
# 6 GF    Uty       5 102.    71.0    99.6
