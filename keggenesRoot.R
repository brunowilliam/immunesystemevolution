library(GeneBridge)
library(dplyr)
library(RCurl)
library(jsonlite)
library(vroom)
library(janitor)
library(geneplast.data)
library(AnnotationHub)


kegg_gene_list <- read.csv("data/kegghsa2024.csv")

get_string_ids <- function(ids, species = '9606'){
  ids_colapse <- paste0(ids, collapse = "%0d")
  
  jsonlite::fromJSON(
    RCurl::postForm(
      "https://string-db.org/api/json/get_string_ids",
      identifiers = ids_colapse,
      echo_query = '1',
      species = species
      
    ),
  )
}

string_id <- get_string_ids(kegg_gene_list$gene_symbol) %>%
  janitor::clean_names() %>%
  tidyr::separate(string_id, into = c("ssp_id", "string_id"), sep = "\\.")



ah <- AnnotationHub()

meta <- query(ah, "geneplast")

load(meta[["AH83116"]])


#preparando o ogdata
  immuno_cogs <- cogdata %>%
  filter(ssp_id %in% string_id$ssp_id) %>%
  filter(protein_id %in% string_id$string_id) %>%
  select(-gene_id)
  

#framework de inferencia das raízes
gbr <- newBridge(ogdata = cogdata, phyloTree = phyloTree,ogids = immuno_cogs$cog_id, refsp = "9606")

gbr <- runBridge(gbr, threshold=0.3)

gbr <- runPermutation(gbr, nPermutations=1000)

res <- getBridge(gbr, what = "results")
head(res)


plotBridgeTree(gbr, whichOG= "NOG89263")

plotBridgeStats(gbr)
