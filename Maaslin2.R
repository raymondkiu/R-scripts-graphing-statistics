################################################
### Maaslin2 for microbiome statistical analysis
################################################
## To install Maaslin2
#if(!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("Maaslin2")

library("Maaslin2")
setwd("~/Desktop/Collaborators/")

# Needs two input files: data (taxa) + metadata
input_data <-read.csv("PND28vs30-taxonomy.csv")
# Sample	Flavonifractor	Intestinimonas	Massilistercora	Bacteroides	Streptococcus
# b41	0.698	0.179	0.318	2.119	0.039
# b42	0.621	0.24	1.132	2.712	0.087
# b43	0.769	0.257	0.301	3.486	0.061
# b44	1.019	0.384	0.376	2.843	0.062
# b45	0.886	0.317	0.25	4.449	0.053
# b81	1.009	0.353	0.497	4.684	0.068
input_metadata <-read.csv("PND28vs30-metadata.csv")
# Sample	Group
# b41	PND30
# b42	PND30
# b43	PND30
# b44	PND30
# b45	PND30
# b81	PND28
# b82	PND28
# b83	PND28

# Set reference levels:
input_metadata$Group = factor(input_metadata$Group,
            levels = c("PND28","PND30"))


# Run Maaslin2
Maaslin2(
  input_data, input_metadata, 'PND28vs30',
  fixed_effects = c("Group"),
  reference = c("Group,PND28"))

