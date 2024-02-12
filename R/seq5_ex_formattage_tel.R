# formattage de la colonne telephone ----
# certains sont au format +33XXXXXXXXX
# d'autres au format XX.XX.XX.XX.XX
# d'autres au format XX XX XX XX XX
# => remplacer espace ou point par chaîne vide
# et remplacer +33 par 0
revenus %>%
  mutate(telephone = str_replace_all(telephone, "[ \\.]", ""),
         telephone = str_replace_all(telephone, "\\+33", "0"))
