# données externes ----
download.file(
  "https://www.insee.fr/fr/statistiques/fichier/7633685/dpt2022_csv.zip",
  destfile = file.path(PATH_INPUT, "dpt2022_csv.zip") 
)

# Décompression du fichier zip
unzip(file.path(PATH_INPUT, "dpt2022_csv.zip"), exdir = PATH_FINAL)

# Lecture du fichier CSV
dpt2022 <- read.csv(file.path(PATH_FINAL, "dpt2022.csv"), sep = ";")

# Écriture des données en format Parquet
arrow::write_parquet(
  x = dpt2022,
  sink = file.path(PATH_FINAL, "dpt2022.parquet")
)
# intérêt du format parquet ----
file.size(file.path(PATH_FINAL, "dpt2022.csv")) / 
  file.size(file.path(PATH_FINAL, "dpt2022.parquet")) # parquet 10x plus compact que csv

# partitionnement ----
colnames(dpt2022) # dpt = clef de partitionnement dans notre exemple
# (on peut en indiquer plusieurs)

# Création d'un sous-dossier pour contenir les données
dossier_partitions = file.path(PATH_FINAL, "dpt2022 partitions")
dir_create(dossier_partitions)

arrow::write_dataset(
  dataset = dpt2022, 
  path = dossier_partitions, 
  partitioning = c("dpt"), # la variable de partitionnement
  format = "parquet"
)

# requête sur fichier parquet ----
# Établir la connexion au fichier Parquet partitionné
donnees_dpt22_part <- open_dataset(
  dossier_partitions,
  partitioning = arrow::schema(dpt = arrow::utf8()) #On met la clé de partitionnement 'dpt' dans 'schema(dpt = arrow)'
)

# Définir la requête
requete <- donnees_dpt22_part %>%
  filter(dpt == "75") %>% # Ici, on filtre selon la clé de partitionnement, on veut le département 75
  select(sexe, preusuel, annais, nombre) %>%
  group_by(sexe, annais) %>%
  summarise(nb_prenoms = sum(nombre))

# Récupérer le résultat sous forme d'un `dataframe`
resultat_dpt2022 <- requete %>%
  collect()

resultat_dpt2022

# install.packages("openxlsx")
# install.packages(c("data.table", "fs"))
# install.packages("arrow")

choix = "xlsx" # "csv"

download.file(glue("https://www.insee.fr/fr/statistiques/fichier/2521169/base_cc_comparateur_{choix}.zip"),
              destfile = file.path(PATH_INPUT, glue("base_cc_comparateur_{choix}.zip")))

unzip(file.path(PATH_INPUT, glue("base_cc_comparateur_{choix}.zip")), exdir = PATH_FINAL)


filename <- file.path(PATH_FINAL, glue("base_cc_comparateur.{choix}"))

if(choix == "xlsx") {
  indreg <- openxlsx::read.xlsx(filename, startRow = 6) %>% tibble()
} else {
  indreg <- data.table::fread(filename) %>% tibble()
}

head(indreg)

## créer une fonction permettant de partitionner en fichiers Parquet un dataframe ----
parquet_partitionner <- function(dataset, chemin_partition, cle_part) {
  
  dossier_partitions <-  file.path(PATH_FINAL, chemin_partition)
  
  fs::dir_create(dossier_partitions) # éviter le warning généré par base::dir.create() si le répertoire existe déjà
  
  arrow::write_dataset(dataset = dataset,
                       path = dossier_partitions,
                       partitioning = c(cle_part),
                       format = "parquet")
  
  return(invisible(dossier_partitions))
}
parquet_partitionner(indreg, "ind_reg partitions", "REG") # KO si choix = "csv" (pas de variable REG/DEP/LIBGEO)

## Créer une fonction permettant d’avoir le solde naturel  dans un ensemble de régions ----
## (nombre de naissances moins le nombre de décès) en 2022.
## Les colonnes nécessaires à ce calcul sont : "NAISD22" et "DECESD22"

requeter_collecter_nnat <- function(n_region) {
  
  donnees_connect <- open_dataset(
    file.path(PATH_FINAL, "ind_reg partitions"),
    partitioning = arrow::schema(REG = arrow::utf8())
  )
  
  requete <- donnees_connect %>% 
    filter(REG %in% n_region) %>% 
    select(REG, NAISD22, DECESD22) %>%
    group_by(REG)%>%
    mutate(solde_naturel = NAISD22 - DECESD22)%>% 
    collect %>%
    summarise(across(where(is.numeric()), sum))
  
}

# On utilise la fonction. Ici, on filtre selon la clé de partitionnement, on veut la région avec le code "75"

nnat_idf <- requeter_collecter_nnat('75')

# On détermine la région possédant le solde naturel le plus élevé

nnat <- requeter_collecter_nnat(unique(indreg$REG)) # on met en entrée toutes les régions

nnat %>% 
  arrange(desc(solde_naturel)) %>% 
  slice(1)

# regions <- unique(indreg$REG)
# 
# soldes_reg <- data.frame(stringsAsFactors = FALSE)
# 
# for (region in regions){
#   solde_reg <- requeter_collecter_nnat(region)
#   soldes_reg <- rbind(soldes_reg, solde_reg)
# }
# 
# max_solde <- soldes_reg[which.max(soldes_reg$solde_naturel), ]
# 
# max_region <- max_solde$REG

# cat("la région possédant le solde naturel le plus élevé est " , max_region, "\n")
