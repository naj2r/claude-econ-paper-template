# config.R — Central path configuration for R scripts
# Source this at the top of every R script:
#   source("scripts/config.R")

# --- PROJECT ROOT (edit these for your machine) ---
RB <- "{{path/to/quarto/project/root}}"
OL <- "{{path/to/Overleaf/project}}"

# --- DERIVED PATHS (do not edit) ---
DATA     <- file.path(RB, "data_final")
DATA_RAW <- file.path(RB, "data_raw")
OUTPUT   <- file.path(RB, "output")
RESULTS  <- file.path(RB, "output", "results")
CODE     <- file.path(RB, "code")
TABLES   <- file.path(OL, "files", "tab")
FIGURES  <- file.path(OL, "files", "fig")

# --- VERIFY ---
if (!file.exists(file.path(RB, "_quarto.yml"))) {
  warning("Cannot find _quarto.yml at ", RB, " — check config.R")
} else {
  message("Paths loaded. RB = ", RB)
}
