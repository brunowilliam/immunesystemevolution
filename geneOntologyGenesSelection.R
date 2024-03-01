library(readr)
library(dplyr)
library(purrr)
library(biomaRt)
library(magrittr)
library(KEGGREST)

get_go_genes <- function(go_term) {
  ensembl <- useEnsembl(biomart = "ensembl", dataset = 'hsapiens_gene_ensembl')
  
  getBM(
    attributes = c(
      'external_gene_name',
      'go_id',
      'name_1006'
    ),
    filters = 'go',
    values = 'go_term',
    mart = ensembl
  )
}


df <- get_go_genes("GO:0002376")
