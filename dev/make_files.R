fs::dir_create("R")
file.edit("R/script_sequence_1.R")
fs::dir_create("dev")

fs::dir_create("data/input", recursive = TRUE)
fs::dir_create("data/final", recursive = TRUE)
fs::dir_create("data/input/doremifasol", recursive = TRUE)
fs::dir_create("data/input/dvf", recursive = TRUE)
