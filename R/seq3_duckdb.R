# copier les fichiers dans le nouveau répertoire ----
PATH_A_TESTER <- dir_create(file.path(PATH_FINAL, "A_tester"))

fichiers <- c("dpt2022.csv", "dpt2022.parquet")

map2(file.path(PATH_FINAL, fichiers),
     file.path(PATH_A_TESTER, fichiers),
     ~ file_copy(.x, .y, overwrite = TRUE))

# connexion à une base duckdb locale ----

dpt2022 <- read.csv(file.path(PATH_FINAL, "dpt2022.csv"), sep = ";")

con <- dbConnect(duckdb(), dbdir = file.path(PATH_A_TESTER, "dpt2022.duckdb"), read_only = FALSE)
to_duckdb(dpt2022, table_name = "DPT2022", con = con)

dbSendQuery(con, "CREATE OR REPLACE TABLE dataset AS SELECT * FROM DPT2022")
dbListTables(con)
dbGetQuery(con, "SELECT * FROM dataset LIMIT 10")
# dbDisconnect(con, shutdown = TRUE)

file.size(file.path(PATH_A_TESTER, "dpt2022.csv")) / 
  file.size(file.path(PATH_A_TESTER, "dpt2022.parquet")) # parquet 10 fois plus compact que csv
file.size(file.path(PATH_A_TESTER, "dpt2022.duckdb")) / 
  file.size(file.path(PATH_A_TESTER, "dpt2022.parquet")) # parquet 3 fois plus compact que duckdb

# Formulation de requêtes ----
## exemple ----

query <-
  # tbl(con, "dataset") %>% 
  dpt2022 %>%
  # arrow::to_duckdb() %>% 
  filter(preusuel == 'ADAM') %>% 
  group_by(annais) %>%
  summarise(
    nb_prenoms_adam_nat = sum(nombre)
  ) %>%
  arrange(desc(nb_prenoms_adam_nat))

query %>% 
  collect()

query %>%
  show_query()

## exercice ----
query <-
  # dpt2022 %>% # soit depuis l'objet R, soit depuis la table duckdb avec tbl()
  tbl(con, "dataset") %>% 
  filter(sexe == 1) %>%
  # arrow::to_duckdb() %>%
  group_by(annais, dpt) %>%
  summarise(
    nb_prenoms_abel = sum(nombre[preusuel == 'ABEL']),
    nb_prenoms = sum(nombre)
  ) %>%
  mutate(
    part_abel = nb_prenoms_abel / nb_prenoms
  )  %>%
  arrange(desc(part_abel))

query %>% 
  collect()
