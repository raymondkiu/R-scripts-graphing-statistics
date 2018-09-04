setwd("U:/")
library(RColorBrewer)
library(ggplot2)





genusPalette <- c( Acinetobacter="#CDCD00",
                   Actinomyces="#BDB76B",
                   Anaerococcus="#CDCDC1",
                   Bacteroides="#FF8C69",
                   #Bifidobacterium="#000080",
                   Bifidobacterium="gold",
                   Bilophila="#EED5D2",
                   Candida="#CDC9C9",
                   #Citrobacter="#FFA500",
                   Citrobacter="blue4",
                   #Clostridium="#848484",
                   Clostridium="red1",
                   Coprobacter="#FFE4E1",
                   Coprobacillus="#EED5D2",
                   Corynebacterium="#FFFAF0",
                   Dermabacter="#EEEEE0",
                   #Enterococcus="#76EE00",
                   Enterococcus="lightskyblue",
                   Escherichia="#FFFF00",
                   Eggerthella="#E0EEE0",
                   Enterobacter="#FF7F00",
                   Finegoldia="#FFDAB9",
                   Flavonifractor="#F5F5DC",
                   Gemella="#EECBAD",
                   Granulicatella="#E3E3E3",
                   Haemophilus="#00FA9A",
                   #Klebsiella="#FFBBFF",
                   Klebsiella="navy",
                   Lactobacillus="#DB7093",
                   Parabacteroides="#bc4512",
                   Peptoniphilus="#9B30FF",
                   Peptostreptococcaceae="#912CEE",
                   Prevotella="#2e9f97",
                   Propionibacterium="#00C5CD",
                   Proteus="#FAFAD2",
                   Pseudomonas="#BCD2EE",
                   Raoultella="#9268a5",
                   Rothia="#00EEEE",
                   Serratia="#BDB76B",
                   Shigella="#D2B48C",
                   #Streptococcus="#DAA520",
                   Streptococcus="rosybrown1",
                   Staphylococcus="royalblue1",
                   Stenotrophomonas="#627037",
                   Ureaplasma="#EEE0E5",
                   Staphylococcus="#FF4040",
                   Varibaculum="#a5571c",
                   Veillonella="#F4A460",
                   Bradyrhizobium="black",
                   Burkholderia="brown",
                   Neisseria="#FF00FF",
                   Ochrobactrum="#848484",
                   Peptostreptococcus="#282828",
                   Roseomonas="#B7B7B7"
)





speciesPalette <- c(Acinetobacter_johnsonii="#CDCD00",
                    Acinetobacter_junii="#8B8B00",
                    Actinomyces_neuii="#BDB76B",
                    Acinetobacter_unclassified="#808000",
                    Actinomyces_urogenitalis="#d88c49",
                    
                    Anaerococcus_prevotii="#CDCDC1",
                    
                    Bacteroides_fragilis="#FF8C69",
                    Bacteroides_ovatus="#EE8262",
                    Bacteroides_uniformis="#CD7054",
                    Bacteroides_vulgatus="#FF7256",
                    
                    Bifidobacterium_bifidum ="#0000FF",
                    Bifidobacterium_breve="#000080",
                    Bifidobacterium_animalis="#27408B",
                    Bifidobacterium_longum="#6495ED",
                    Bifidobacterium_dentium="#104E8B",
                    
                    Bilophila_wadsworthia="#EED5D2",
                    Bilophila_unclassified="#FFE4E1",
                    
                    Candida_albicans="#CDC9C9",
                    
                    Citrobacter_freundii="#FFA500",
                    Citrobacter_unclassified="#FF9912",
                    Citrobacter_koseri="#FFD700",
                    
                    Clostridium_difficile="#848484",
                    Clostridium_perfringens="#1E1E1E",
                    Clostridium_ramosum="#555555",
                    Clostridium_symbiosum="#515151",
                    Clostridium_bartlettii="#5B5B5B",
                    Clostridium_glycolicum="#AAAAAA",
                    
                    
                    Coprobacter_fastidiosus="#FFE4E1",
                    Coprobacillus_unclassified="#EED5D2",
                    
                    Corynebacterium_accolens="#FFFAF0",
                    Corynebacterium_amycolatum="#F5DEB3",
                    Corynebacterium_bovis="#FFE7BA",
                    Corynebacterium_kroppenstedtii="#EED8AE",
                    Corynebacterium_striatum="#CDBA96",
                    Corynebacterium_tuberculostearicum="#FDF5E6",
                    Corynebacterium_pseudogenitalium="#FFFAF0",
                    
                    Dermabacter_sp_HFH0086="#EEEEE0",
                    
                    Enterococcus_faecalis="#76EE00",
                    Enterococcus_faecium="#66CD00",
                    Enterococcus_avium="#6E8B3D",
                    
                    Escherichia_coli="#FFFF00",
                    Escherichia_unclassified="#EEEE00",
                    
                    Eggerthella_lenta="#E0EEE0",
                    Eggerthella_unclassified="#C1CDC1",
                    
                    Enterobacter_aerogenes="#FF7F00",
                    Enterobacter_cloacae="#EE7600",
                    Enterobacter_hormaechei="#CD6600",
                    
                    Finegoldia_magna="#FFDAB9",
                    
                    Flavonifractor_plautii="#F5F5DC",
                    
                    Gemella_haemolysans="#EECBAD",
                    Gemella_unclassified="#CDAF95",
                    
                    Granulicatella_unclassified="#E3E3E3",
                    Granulicatella_adiacens="#E0E0E0",
                    
                    Haemophilus_parainfluenzae="#00FA9A",
                    
                    Klebsiella_oxytoca="#FFBBFF",
                    Klebsiella_pneumoniae="#CD96CD",
                    Klebsiella_unclassified="#DDA0DD",
                    
                    Lactobacillus_acidophilus="#DB7093",
                    Lactobacillus_crispatus="#FF82AB",
                    Lactobacillus_fermentum="#CD6889",
                    Lactobacillus_rhamnosus="#FFB6C1",
                    Lactobacillus_gasseri="#FFC0CB",
                    Lactobacillus_animalis="#FF3E96",
                    Lactobacillus_casei_paracasei="#EE3A8C",
                    Lactobacillus_plantarum="#8B2252",
                    Parabacteroides_distasonis="#bc4512",
                    Parabacteroides_unclassified="brown",
                    Peptoniphilus_rhinitidis="#9B30FF",
                    Peptostreptococcaceae_noname_unclassified="#912CEE",
                    Prevotella_bivia="#2e9f97",
                    Propionibacterium_acnes="#00C5CD",
                    Propionibacterium_avidum="#00868B",
                    Propionibacterium_granulosum="#00F5FF",
                    Propionibacterium_sp_HGH0353="#00868B",
                    Proteus_mirabilis="#FAFAD2",
                    Pseudomonas_unclassified="#BCD2EE",
                    Pseudomonas_aeruginosa="#CAE1FF",
                    Raoultella_ornithinolytica="#9268a5",
                    Rothia_mucilaginosa="#00EEEE",
                    Serratia_marcescens="#BDB76B",
                    Shigella_sonnei="#D2B48C",
                    Streptococcus_agalactiae="#DAA520",
                    Streptococcus_anginosus="#FFC125",
                    Streptococcus_constellatus="#EEB422",
                    Streptococcus_gallolyticus="#FF4500",
                    Streptococcus_gordonii="#CD950C",
                    Streptococcus_mitis_oralis_pneumoniae="#CD9B1D",
                    Streptococcus_parasanguinis="#B8860B",
                    Streptococcus_phage_Cp_1="#EEAD0E",
                    Streptococcus_salivarius="#8B6508",
                    Streptococcus_sp_C150="#CD950C",
                    Streptococcus_thermophilus="#FFB90F",
                    Streptococcus_urinalis="#EE9A00",
                    Streptococcus_vestibularis="#89661c",
                    Stenotrophomonas_maltophilia="#627037",
                    Stenotrophomonas_unclassified="#BDFCC9",
                    Stenotrophomonas_maltophilia="#32CD32",
                    Ureaplasma_parvum="#EEE0E5",
                    Staphylococcus_epidermidis="#FF4040",
                    Staphylococcus_haemolyticus="#EE3B3B",
                    Staphylococcus_hominis="#8B2323",
                    Staphylococcus_lugdunensis="#B22222",
                    Staphylococcus_phage_ROSA="#CD2626",
                    Staphylococcus_warneri="#EE2C2C",                                                                   
                    Staphylococcus_aureus="#FF0000",
                    Staphylococcus_caprae_capitis="#DC143C",
                    Varibaculum_cambriense="#a5571c",
                    Veillonella_atypica="#F4A460",                                                                  
                    Veillonella_parvula="#8B4513",
                    Veillonella_unclassified="#d88c49",
                    Veillonella_sp_oral_taxon_780="#9b6336",
                    Veillonella_dispar="#da8d73",
                    "#cc6949")

familyPalette <-c(
  Bacteroidaceae="#CDCD00",
  Porphyromonadaceae="#BDB76B",
  Tannerellaceae="#CDCDC1",
  Rhizobiaceae="#FF8C69",
  Enterobacteriaceae="#EECBAD",
  Pasteurellaceae="#EED5D2",
  Moraxellaceae="#CDC9C9",
  Xanthomonadaceae="#FFA500",
  Actinomycetaceae="#848484",
  Bifidobacteriaceae="#000080",
  Corynebacteriaceae="#FFFF00",
  Dermabacteraceae="#E0EEE0",
  Nocardioidaceae="#F5F5DC",
  Propionibacteriaceae="#00C5CD",
  Bacillaceae="#2e9f97",
  Staphylococcaceae="#9268a5",
  Enterococcaceae="#DAA520",
  Lactobacillaceae="#a5571c",
  Streptococcaceae="#FF4040",
  Clostridiaceae="#EEE0E5",
  Lachnospiraceae="#00FA9A",
  Peptostreptococcaceae="#FAFAD2",
  Ruminococcaceae="#F4A460"
)







#provide the filename below
Stack_data <- read.csv("Q088.csv")
#Stack_data_2 <- as.character(Stack_data$ID)
#head(Stack_data_2)
head(Stack_data)

png("Q088_data.png",
    width = 8*500,        # 5 x 300 pixels
    height = 10*500,
    res = 600,            # 300 pixels per inch
    pointsize = 8)

library(reshape2)
df_long <- melt(Stack_data,  id.vars ="ID" ,  variable.name ="Species")
head(df_long)
library(scales)
ncol(Stack_data)
library(ggplot2)


n <- 60
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))

color_new = grDevices::colors()[grep('gr(a|e)y', grDevices::colors(), invert = T)]
#ggplot(df_long,  aes(x = ID,  y = value,  fill =Species)) + 
# geom_bar(stat ="identity" ,  position = position_fill())+ theme(legend.position="right" ,  legend.direction="horizontal" ,  legend.title = element_blank())+
# labs(x="" , y="EGGNOG categories %")+theme(axis.text.x=element_text(angle=90, hjust=1, vjust=0.5)) + scale_fill_manual(values =familyPalette )



ggplot(df_long[order(df_long$value, decreasing = F),],  aes(x = ID,  y = value,  fill =Species ,drop=TRUE )) +

  geom_bar(stat ="identity" ,  position = position_fill()) + theme(legend.text = element_text(size=10,face= "italic"),legend.position="right" ,  legend.direction="vertical" , legend.title = element_blank())+
  labs(x=" " , y=" ") +theme(axis.text.x=element_text(angle=90, size =20, colour="black"), 
                                                        axis.title.y = element_text(angle=90, hjust=1, vjust=1, size=20), 
                                                        axis.text.y = element_text(size=20,colour = "black"), 
                                                        axis.title.x = element_text(size=25)) + scale_fill_manual(values = genusPalette) 
dev.off()


