# Exercice chiffre ----
pattern <- "[0-9]"

# données de test
phrase_ok <- "On est le 9 février aujourd'hui"
phrase_ko <- "On est le neuf février aujourd'hui"

# "toutes les variables de type phrase_ok ou phrase_ko, éventuellement numérotées"
liste_chaines <- ls(pattern = "^phrase_[ok]{2}[0-9]*")

# application
map(liste_chaines, ~ str_detect(get(.x), pattern)) %>% 
  set_names(liste_chaines)

# Exercice noms propres ----
# pattern <- "(?:[A-Z][a-z]+\\s?)" # SO
pattern <- "[A-Z][a-z]+"

phrase <- "Louis et Martin sont allés à Madrid alors qu'ils souhaitaient visiter la Pologne"

str_extract_all(phrase, pattern)
