# session 1
install.packages(c("tidyverse", "doremifasol"))
# session 2
install.packages(c("bench", "arrow", "pryr", "sparklyr"))
sparklyr::spark_install() # pour Spark 2.4.3, il faut installer Java 8 
# par exemple via le terminal avec sudo apt-get install openjdk-8-jre
# sc <- sparklyr::spark_connect(master = "local")
# sparklyr::spark_disconnect(sc)

# session 8
install.packages("RPostgres")
install.packages("tictoc")
