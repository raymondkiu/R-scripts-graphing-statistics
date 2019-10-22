# R script for Sleuth analysis using raw counts from Kallisto
# Author: Raymond Kiu Raymond.Kiu@quadram.ac.uk  October 2019
# lines 36,39 replace 'SAMPLE' with your folder name that stores the Kallisto raw counts, prep a metadata file METADATA.txt in line 42 in 2 columns: sample and condition (TSV)
# The rest is fully automated, gene names will be retrieved via Ensembl latest mouse transcript and gene names in a table- modifiable to humans etc.
# Remove hashes to use install packages
# Install BiocManager to download Bioconductor packages on R 3.6 and above
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install()

# Install rhdf5 package
#BiocManager::install(c("rhdf5"))

# Install biomaRt package
#BiocManager::install(c("biomaRt"))

#BiocManager::install(c("cowplot"))

# Install devtools package
#install.packages("devtools")

# Install sleuth package
#devtools::install_github("pachterlab/sleuth")

# Set WD on U drive (Mac):
setwd("PATH/")

# Start using Sleuth
library("sleuth")
library("ggplot2")
library("gridExtra")
library('cowplot')
theme_set(theme_cowplot())

# Specify Kallisto raw counts directory and store as a variable
sample_id <- dir(file.path("PATH TO YOUR KALLISTO DIRECTORY THAT STORES RAW COUNTS","SAMPLE"))
sample_id

kal_dirs <- file.path("PATH TO YOUR KALLISTO DIRECTORY THAT STORES RAW COUNTS"","SAMPLE", sample_id)
kal_dirs

s2c <- read.table(file.path("PATH TO YOUR KALLISTO DIRECTORY THAT STORES RAW COUNTS", "METADATA.txt"), header = TRUE, stringsAsFactors = FALSE)
s2c <- dplyr::select(s2c, sample, condition)
s2c <- dplyr::mutate(s2c, path = kal_dirs)
print(s2c)

# for biomart - associating gene names
#metadata <- dplyr::mutate(s2c,
                      #    path = file.path('PATH TO YOUR KALLISTO DIRECTORY THAT STORES RAW COUNTS', 'SAMPLE', sample_id))
#metadata

# Start quantification and normalisation - transcript level analysis
# so <- sleuth_prep(s2c, ~condition, extra_bootstrap_summary = TRUE) # this is transcript level analysis
# Here is the gene level analysis starts with mapping gene names

## Download gene name - transcript table from Ensembl
mart <- biomaRt::useMart(biomart = "ENSEMBL_MART_ENSEMBL",
                         dataset = "mmusculus_gene_ensembl",
                         host = "ensembl.org")
# ttg: transcript to gene, ttg is now the Sleuth object (data frame) that stores the gene table
ttg <- biomaRt::getBM(
  attributes = c("ensembl_transcript_id", 
                 "ensembl_gene_id", "external_gene_name"), mart = mart)
ttg <- dplyr::rename(ttg, target_id = ensembl_transcript_id,
                     ens_gene = ensembl_gene_id, ext_gene = external_gene_name)
head(ttg)

# gene mode is on now and mapping biomart gene name and starts quantification and normalisation
so <- sleuth_prep(s2c, ~condition, gene_mode = TRUE, target_mapping = ttg, aggregation_column = 'ens_gene')

# fitting curves - mandatory to fit a model
so <- sleuth_fit(so, ~condition, 'full')
so <- sleuth_fit(so, ~1, 'reduced')
so <- sleuth_lrt(so, 'reduced', 'full')
so <- sleuth_wt(so, 'conditionUCC2003',which_model = "full")
models(so)
tests(so)

# Results: lrt is for significant qval, wt is mainly for the normalised counts: scaled_reads_per_base, for heatmap purpose
sleuth_table_lrt <- sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE)
sleuth_table_wt <- sleuth_results(so, 'conditionUCC2003', 'wt', show_all = FALSE)
head(sleuth_table)
sleuth_significant_lrt <- dplyr::filter(sleuth_table_lrt, qval <= 0.5)
head(sleuth_significant_lrt, 100)

# Plot individual transcript count comparison
#plot_bootstrap(so, "ENSMUST00000006035.12", units = "est_counts", color_by = "condition")
plot_bootstrap(so, "ENSMUSG00000071470", units = "scaled_reads_per_base", color_by = "condition")  # gene level please use this

# Some plotting functions
plot_pca(so, color_by = 'condition', pc_x = 1L, pc_y=2L, units = "scaled_reads_per_base",point_size = 4, point_alpha=2, text_labels = TRUE)
plot_bootstrap(so, "ENSMUST00000006035.12", units ="est_counts", color_by = "condition")
plot_group_density(so, use_filtered = TRUE, units = "tpm",
                   trans = "log", grouping = setdiff(colnames(so$sample_to_covariates),
                                                     "sample"), offset = 1)
plot_scatter(so,use_filtered = TRUE,
             units = "scaled_reads_per_base", offset = 1, point_alpha = 0.2, xy_line = TRUE,
             xy_line_color = "red", trans = "log", xlim = NULL, ylim = NULL)

plot_vars(so, test = NULL, test_type = "wt", which_model = "full",
          sig_level = 0.1, point_alpha = 0.2, sig_color = "red", xy_line = TRUE,
          xy_line_color = "red", highlight = NULL, highlight_color = "green")

plot_pc_variance(so, use_filtered = TRUE, units = "est_counts",
                 pca_number = NULL, scale = FALSE, PC_relative = NULL)

plot_qq(so, 'conditionUCC2003', test_type = "wt", which_model = "full",
        sig_level = 0.05, point_alpha = 0.2, sig_color = "red",
        highlight = NULL, highlight_color = "green", line_color = "blue")

plot_ma(so, 'conditionUCC2003', test_type = "wt", which_model = "full",
        sig_level = 0.05, point_alpha = 0.2, sig_color = "red",
        highlight = NULL, highlight_color = "green")

plot_volcano(so, 'conditionUCC2003', test_type = "wt", which_model = "full",
             sig_level = 0.05, point_alpha = 0.2, sig_color = "red",
             highlight = NULL)


plot_sample_density(so, which_sample = so$sample_to_covariates$sample[1],
                    use_filtered = TRUE, units = "est_counts", trans = "log", offset = 1)

# Shiny app: quite handy as it has GUI
sleuth_live(so, settings = sleuth_live_settings(), options = list(port =  42427))
       
# Print Kallisto stats
kallisto_table(so, use_filtered = FALSE, normalized = TRUE,
               include_covariates = TRUE)

# To convert raw/normalised tpm to matrix from sleuth object (e.g. to make a heatmap for comparison)
tpm_matrix <- sleuth_to_matrix(so,'obs_raw','tpm')  # raw data
tpm_matrix <- sleuth_to_matrix(so,'obs_norm','est_counts') # normalised data, better

# gene level, makes more sense for gene-level analysis
tpm_matrix <- sleuth_to_matrix(so,'obs_norm','scaled_reads_per_base')  # this is needed to make a heatmap to compare all samples
head(tpm_matrix)
write.csv(tpm_matrix, "matrix.csv") # change the csv file name - this is to export the matrix into a csv file.
 
# help function
help(package = 'sleuth')
# or
?sleuth_prep
?sleuth_to_matrix
