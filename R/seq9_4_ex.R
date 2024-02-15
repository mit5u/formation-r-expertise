library(memoise)
library(dplyr)
library(stringr)
library(ggplot2)

library(gganimate) # bonus pour l'animation de la pyramide

conflicted::conflicts_prefer(dplyr::lag)

# make age pyramid data ----
AGE <- c(rep(0:99, 2))
SEXE <- c(rep("M", 100),
          rep("F", 100))
POP23 <- c(
  352683, 354519, 365145, 371748, 378148, 388856, 399901, 412459, 418143, 428153,
  428836, 440750, 436488, 441459, 437364, 443910, 436434, 432710, 427231, 425514,
  427164, 429861, 398538, 388456, 373740, 374096, 367906, 357779, 360571, 376550,
  384247, 393946, 392338, 398872, 399404, 406312, 405575, 404680, 397886, 422638,
  426081, 431745, 408933, 401779, 403916, 393835, 407431, 428702, 447358, 458933,
  456873, 444241, 436905, 429360, 428095, 436569, 435783, 437808, 429915, 414713,
  411806, 405833, 401023, 388250, 384240, 376468, 368130, 364529, 354669, 357503,
  345600, 354825, 343943, 338851, 327715, 302432, 222831, 213124, 202826, 182808,
  156916, 157233, 156663, 145422, 133873, 124776, 109135, 99363, 85127, 75448,
  62561, 51824, 38419, 29395, 22206, 16016, 11798, 7790, 5195, 3139, 338259,
  340544, 350978, 353828, 364891, 373511, 383431, 397638, 399488, 407089, 412059,
  421569, 416755, 417716, 416914, 423328, 413231, 408604, 404297, 402293, 403533,
  405339, 380335, 376780, 367795, 372303, 370225, 364883, 367749, 387616, 395325,
  407219, 414610, 422255, 424846, 433518, 432731, 429648, 422259, 446168, 448788,
  454529, 428339, 416336, 416260, 405621, 416810, 437459, 460104, 468826, 464850,
  455819, 451330, 445885, 443800, 454420, 455825, 461836, 457392, 441542, 441861,
  440227, 438632, 428337, 425274, 423564, 419195, 414925, 405947, 411004, 397539,
  409427, 401042, 397926, 387506, 364389, 275188, 265873, 257145, 235708, 208705,
  213969, 222922, 211947, 204065, 197233, 185718, 179233, 161003, 154087, 134920,
  120798, 97050, 82120, 66331, 53641, 41304, 30837, 22751, 15995
)

donnees_pyramide_age <- data.frame("AGE" = AGE,
                                   "SEXE" = SEXE,
                                   "POP2023" = POP23) %>% 
  arrange(AGE, SEXE)

# make mortality data ----
repeter_elements <- function(vecteur, n) {
  vecteur_rep <- rep(vecteur, each = n)
  return(vecteur_rep)
}

AGE <- c(rep(0:99, 2))
SEXE <- c(rep("M", 100),
          rep("F", 100))
TAUX_MORT <- c(
  3.3,
  rep(c(0.2), 4),
  repeter_elements(c(0.1, 0.1, 0.3, 0.5, 0.7, 0.8,
                     1.1, 1.6, 2.7, 4.2, 6.7, 10.7, 15.6),
                   5),
  repeter_elements(c(26.9, 79.6, 235.6),
                   10),
  2.8,
  rep(c(0.2), 4),
  repeter_elements(c(0.1, 0.1, 0.1, 0.2, 0.2, 0.3,
                     0.5, 0.8, 1.4, 2.3, 3.4, 5.0, 7.2),
                   5),
  repeter_elements(c(13.6, 51.7, 185.9),
                   10)
)

taux_mortalite <- data.frame("AGE" = AGE,
                             "SEXE" = SEXE,
                             "TAUX_MORT" = TAUX_MORT) %>%
  arrange(AGE, SEXE)

# make birth rate data ----
AGE <- c(rep(0:99, 2))

SEXE <- c(rep("F", 100),
          rep("M", 100))

TAUX_NAT <- c(rep(0, 15),
              rep(2.3, 10),
              rep(10.9, 5),
              rep(12.7, 5),
              rep(7, 5),
              rep(0.9, 11),
              rep(0, 149))

taux_natalite <- data.frame("AGE" = AGE,
                            "SEXE" = SEXE,
                            "TAUX_NAT" = TAUX_NAT) %>%
  arrange(AGE, SEXE)


# make final dataset ----
taux_mortalite <- taux_mortalite %>%
  mutate(TAUX_MORT = TAUX_MORT / 1000) # pour transformer le pour mille en pourcentage

taux_natalite <- taux_natalite %>%
  mutate(TAUX_NAT = TAUX_NAT / 100) # pour transformer le pourcentage en pourcentage

# Merge des différentes base de données
donnees_compilees <- donnees_pyramide_age %>%
  inner_join(taux_mortalite, by = c("AGE", "SEXE")) %>%
  inner_join(taux_natalite, by = c("AGE", "SEXE"))

donnees_compilees <- select(donnees_compilees, AGE, SEXE, TAUX_MORT, TAUX_NAT, POP2023)


# Implémenter une fonction recursive prenant en argument un dataframe avec la
# pyramide des âges d’une année donnée et renvoyant un dataframe du même
# dataframe complété des colonnes des pyramides des âges sur les années
# suivantes.
# NB : On pourra supposer que les naissances sont réparties uniformément
# entre les deux sexes.

## calcul direct ----
predict_pop_n_years <- function(df,
                                var_pop_ref = POP2023,
                                n = 1 # how many years in the future we want to predict
) {
  # assert_that(//TODO, msg = "les tranches d'âge et de sexe dans les tables de natalité et de mortalité fournies ne correspondent pas)
  year_ref <- as.numeric(str_sub(as_label(ensym(var_pop_ref)), -4)) # 4 derniers caractères du nom de variable passé en argument
  
  df %>%
    mutate("POP{year_ref + n}_predict" := case_when(
      AGE == 0 ~
        {{var_pop_ref}} * (1 + 0.5 * TAUX_NAT/100 - TAUX_MORT/100) ** n,
      TRUE ~
        {{var_pop_ref}} * (1 + TAUX_NAT/100 - TAUX_MORT/100) ** n)
    )
}

# predict_pop_n_years(donnees_pyramide_age, n = 1) %>% head()

## avec la récursivité ----

simuler_population <- memoise(function(df,
                                       n = 1
) {
  
  if (n == 0) {
    # initialisation
    return(df)
    
  } else {
    
    # Année = 4 derniers caractères du dernier nom de colonne 
    prev_year <- as.numeric(str_sub(last(colnames(df)), -4))
    
    # Créez la nouvelle colonne et distinction à l'âge 0
    df <- df %>%
      mutate("POP{prev_year + 1}" := if_else(
        AGE == 0,
        
        # Effectifs des âge 0 (naissances de l'année)
        # hypothèse de travail :
        # autant de naissances de garçons que de filles, donc pour
        # chaque sexe, l'effectif est la moitié de la natalité totale
        round(
          sum(df[[glue("POP{prev_year}")]] * TAUX_NAT) / 2
        ),
        
        # Effectifs des âges non nuls (cohorte vieillie d'un an, moins les décès)
        round(
          lag(df[[glue("POP{prev_year}")]]) * (1 - lag(TAUX_MORT))
        )
      ))
    
    # Appel récursif pour l'année suivante
    df <- simuler_population(df, n - 1)
  }
  
})

simuler_population(donnees_compilees, n = 1) %>% head()

# graphic ----

visualiser_donnees_simulees <- function(donnees_compilees, annee) {
  
  assert_that(annee >= 2023, msg = "Les données ne peuvent être simulées qu'à une date ultérieure à 2023")
  
  donnees_simulees <- simuler_population(donnees_compilees, annee - 2023)
  
  p <- donnees_simulees %>%
    mutate(
      # rotation pour avoir les femmes d'un côté, les hommes de l'autre
      POP = ifelse(SEXE == "M", -1 * .data[[glue("POP{annee}")]], .data[[glue("POP{annee}")]])
    ) %>%
    ggplot(aes(x = AGE, y = POP, fill = SEXE)) + 
    geom_bar(stat = "identity") +
    coord_flip() +
    labs(title = annee, x = "Âge", y = "Population", fill = "Sexe") +
    scale_fill_manual(values = c("#39eab9", "#052337")) +
    theme_minimal()
  return(p)
}

animation <- donnees_compilees %>%
  simuler_population(n = 2030 - 2023) %>% 
  mutate(across(starts_with("POP"), 
                # rotation pour avoir les femmes d'un côté, les hommes de l'autre
                ~ if_else(SEXE == "M", -.x, .x))
  ) %>%
  # transposition (générer un graphique par année => avoir une variable année)
  pivot_longer(cols = starts_with("POP"),
               names_to = "year",
               names_prefix = "POP",
               values_to = "POP") %>% 
  mutate(year = as.integer(year)) %>% # la variable du frame_time pour l'animation doit être numérique
  ggplot(aes(x = AGE, y = POP, fill = SEXE)) + 
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = 'Année: {frame_time}',
       x = "Âge",
       y = "Population",
       fill = "Sexe") +
  scale_fill_manual(values = c("#39eab9", "#052337")) +
  theme_minimal() +
  transition_time(year) +
  ease_aes('linear')

animate(animation, nframes = 10 * (2030-2023), fps = 10,
        renderer = gifski_renderer("~/pyramide/"))

anim_save("pyramide.gif")
