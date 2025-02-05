setwd("~/Path/to/workdir/)

library(tidyverse)
library(gplots)
library(RColorBrewer)

## Data preprocessing
sample_info = read.csv("./Model.csv")

data_crispr = read.csv("./CRISPRGeneEffect.csv")
colnames(data_crispr) = stringr::str_extract(colnames(data_crispr), "[^..]+")
colnames_df = data.frame(names = colnames(data_crispr) )

corr_input_genes = readxl::read_xlsx("./correlation_genes.xlsx") %>%
  as.data.frame() %>%
  unique()

avana_2024_dep = data_crispr %>%
  dplyr::select(X, corr_input_genes$Gene_name)
colnames(avana_2024_dep)[1] = "Cell_lines"

rownames(avana_2024_dep) = avana_2024_dep$Cell_lines
avana_2024_dep$Cell_lines = NULL

avana_2024_dep_corr = cor(avana_2024_dep)

hclust.custom <- function(d) {hclust(d, method="complete")}
blue.to.red <- colorRampPalette(brewer.pal(11, "RdBu"))(64) %>% rev()

## generate correlation heatmap
pdf("./staga_heatmap_depmap_2024Q2_color_rev1.pdf",
    width = 6.5, height = 6.5)
scale_max = 0.6
heatmap.2(avana_2024_dep_corr, na.rm=TRUE,
          col = blue.to.red, trace = "none",
          symbreaks=TRUE, breaks = seq(-scale_max, scale_max, length.out = 65),
          hclustfun = hclust.custom, dendrogram = "row", key = TRUE)
dev.off()

## generate correlation heatmap
svg("plot.svg", width = 6.5, height = 6.5)
heatmap.2(avana_2024_dep_corr, na.rm=TRUE,
          col = blue.to.red, trace = "none",
          symbreaks=TRUE, breaks = seq(-scale_max, scale_max, length.out = 65),
          hclustfun = hclust.custom, dendrogram = "row", key = TRUE,
          labCol = FALSE)
dev.off() 

#heatmap generators
generate_heatmap <- function(genes, scale_max) {
  genes <- intersect(rownames(rnai_dep_corr), genes)
  heatmap.2(rnai_dep_corr[genes, genes], na.rm=TRUE,
            col = blue.to.red, trace = "none",
            symbreaks=TRUE, breaks = seq(-scale_max, scale_max, length.out = 65),
            hclustfun = hclust.custom, dendrogram = "row", key = FALSE)
}

generate_heatmap_crispr <- function(genes, scale_max) {
  genes <- intersect(rownames(avana_2017_dep_corr), genes)
  heatmap.2(avana_2017_dep_corr[genes, genes], na.rm=TRUE,
            col = blue.to.red, trace = "none",
            symbreaks=TRUE, breaks = seq(-scale_max, scale_max, length.out = 65),
            hclustfun = hclust.custom, dendrogram = "row", key = FALSE)
  
  
}

#baf heatmap
baf_genes <- c("SMARCA4","ARID1A","ARID2","PBRM1","SMARCB1","SMARCD1","SMARCD2","SMARCD3","SMARCC1","SMARCC2","PHF10","DPF2","BRD9","BRD7","SS18","SMARCE1", "GLTSCR1")
pdf(file.path(out_dir, "baf_heatmap.pdf"),
    width = 5.5, height = 5.5)
generate_heatmap(baf_genes, 0.6)
dev.off()

#Polymerase family
pol_genes <- c("POLR2D","POLR2A","POLR2E","POLR2F","POLR2C","POLR2J","POLR2L","RPA3","POLR2K","POLR1B","TWISTNB","POLR3B","POLR3E","POLR3C","POLR3K","POLR3D","POLR1D","POLR1C","POLR3G","POLR3H","POLR3A","CRCP","POLR3F","POLR2G","POLR2I","POLR1A","CD3EAP","POLR2B","POLR2H","POLR1E")
pdf(file.path(out_dir, "pol_family_heatmap.pdf"),
    width = 6.5, height = 6.5)
generate_heatmap(pol_genes, 0.65)
dev.off()

#staga/atac
staga_atac <- c("ATXN7","ATXN7L3","ENY2","KAT2A","KAT2B","SGF29","SUPT3H","SUPT7L","SUPT20H","TADA1","TADA2B","TADA3","TAF6L","TRRAP","USP22","TAF5L", "EP300", "ZZZ3","KAT14","CCDC101","DR1","HCFC1","KAT2A","KAT2B","MBIP","POLE3","TADA2A","TADA3","WDR5","YEATS2")
pdf(file.path(out_dir, "staga_heatmap.pdf"),
    width = 6.5, height = 6.5)
generate_heatmap_crispr(staga_atac, 0.80)
dev.off()

#RZZ/NRZ
nrz_rzz <- c("KNTC1","ZWILCH","ZWINT","RINT1","NBAS","C19orf25","STX18","BNIP1")
pdf(file.path(out_dir, "nrz_rzz_heatmap.pdf"),
    width = 5.5, height = 5.5)
generate_heatmap_crispr(nrz_rzz, 0.7)
dev.off()

