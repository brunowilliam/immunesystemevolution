library(tidyverse)
library(magrittr)

# Read data
link_pathway_entrez_hsa <- read_tsv("data/link_pathway_entrez_hsa.tsv",
                                    col_names = c("entrez_id", "pathway_id"),
                                    col_types = "cc")

 
 # Dictionary
pathways <- tribble(
  ~pathway_id,       ~pathway_name,
  "path:hsa04640",   "Hematopoietic cell lineage",
  "path:hsa04610",   "Complement and coagulation cascades",
  "path:hsa04611",   "Platelet activation",
  "path:hsa04613",   "Neutrophil extracellular trap formation",
  "path:hsa04624",   "Toll and Imd signaling pathway",
  "path:hsa04621",   "NOD-like receptor signaling pathway",
  "path:hsa04622",   "RIG-I-like receptor signaling pathway",
  "path:hsa04623",   "Cytosolic DNA-sensing pathway",
  "path:hsa04625",   "C-type lectin receptor signaling pathway",
  "path:hsa04650",   "Natural killer cell mediated cytotoxicity",
  "path:hsa04612",   "Antigen processing and presentation",
  "path:hsa04660",   "T cell receptor signaling pathway",
  "path:hsa04658",   "Th1 and Th2 cell differentiation",
  "path:hsa04659",   "Th17 cell differentiation",
  "path:hsa04657",   "IL-17 signaling pathway",
  "path:hsa04662",   "B cell receptor signaling pathway",
  "path:hsa04664",   "Fc epsilon RI signaling pathway",
  "path:hsa04666",   "Fc gamma R-mediated phagocytosis",
  "path:hsa04670",   "Leukocyte transendothelial migration",
  "path:hsa04672",   "Intestinal immune network for IgA production",
  "path:hsa04062",   "Chemokine signaling pathway"
)

# entrez_id column separation
link_pathway_entrez_hsa %<>% separate(
  entrez_id,
  into = c("species", "entrez_id"),
  sep = ":"
)

#filtering pathways of interest
genes_pathways_hsa <- inner_join(link_pathway_entrez_hsa, pathways)

#building entrez_id to gene_symbol dictionaries
entrez_names_hsa <- read_tsv("data/Homo_sapiens.gene_info.gz",
  skip = 1,
  col_names = c("entrez_id", "gene_symbol"),
  col_types = cols_only("-", "c", "c")
  )

#translating entrez_id to gene_symbol
genes_pathways_hsa <- link_pathway_entrez_hsa %>%
  inner_join(pathways) %>%
  inner_join(entrez_names_hsa)

write.csv(genes_pathways_hsa, "data/kegghsa2024.csv")










