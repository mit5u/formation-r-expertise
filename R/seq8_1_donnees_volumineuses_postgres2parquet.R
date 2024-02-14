# connexion à une base de données PostgreSQL ----
connexion <- DBI::dbConnect(RPostgres::Postgres(),
                            host = "postgresql-164525.projet-sortie-sas",
                            dbname = "dvf",
                            user = "user_readonly",
                            password = "@ccess_dvf1234"
)

# prise en main de la bdd ----
dbListTables(connexion) # incorrect

dbListObjects(connexion, DBI::Id(schema = "dvf"))

dbGetQuery(connexion,
           "SELECT COUNT(1)
           FROM dvf.mutation") # 9691803 # lent

dbGetQuery(
  connexion,
  "
  SELECT 100 * count(*) AS estimate FROM dvf.mutation TABLESAMPLE SYSTEM (1);
  "
) # 9 945 500, moins long mais pas du tout instantané

dbGetQuery(
  connexion,
  "
  SELECT 100 * count(*) AS estimate FROM dvf.disposition_parcelle TABLESAMPLE SYSTEM (1);
  "
) # 16 585 400

# chargement des tables mutations et disposition_parcelle ----
set.seed(1234)
tictoc::tic()

mutation_db <- dbGetQuery(connexion,
                          "
                          SELECT * FROM dvf.mutation
                          TABLESAMPLE SYSTEM(1)
                          ") # ~1 % des observations, ou LIMIT 1000 pour avoir exactement 1000 lignes


disposition_parc_db <- dbGetQuery(connexion,
                                  "
                          SELECT * FROM dvf.disposition_parcelle
                          TABLESAMPLE SYSTEM(1)
                          ") # ~1% des observations, ou LIMIT 1000 pour avoir exactement 1000 lignes

# jointure pour obtenir une table unique ----

dvf_tbl <- mutation_db %>%
  left_join(disposition_parc_db)

# sauvegarde au format parquet partitionné ----

PATH_DVF <- file.path(PATH_INPUT, "dvf")

dir_create(PATH_DVF)

write_dataset(
  dataset = dvf_tbl,
  path = PATH_DVF,
  partitioning = c("coddep"),
  format = "parquet"
)

# déconnexion de la bdd ----

dbDisconnect(connexion)
tictoc::toc() # 105.27 sec elapsed
