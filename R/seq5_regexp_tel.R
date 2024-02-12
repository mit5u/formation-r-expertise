pattern <- "^0[67][0-9]{8}$"

chaine_ok <- "0617229701"
chaine_ok2 <- "0789988998"

chaine_ko <- "06aaaaaaaaaa12345678"
chaine_ko2 <- "061234567"
chaine_ko3 <- "06123456789"
chaine_ko4 <- "06ab12345678"

liste_chaines <- ls(pattern = "^chaine_[ok]{2}[0-9]*$")
map(liste_chaines, ~ str_detect(get(.x), pattern)) %>% 
  set_names(liste_chaines)
