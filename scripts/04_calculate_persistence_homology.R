
if (!require("reticulate")) install.packages("reticulate")
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("TDAstats")) install.packages("TDAstats")
if (!require("TDAmapper")) devtools::install_github("paultpearson/TDAmapper")

# # create a new environment 
virtualenv_create("r-reticulate")

# # # create a new environment and install from pip
# virtualenv_install("r-reticulate", "giotto-ph")
# virtualenv_install("r-reticulate", "numpy")


# # load environment
np <- import("numpy")
#importe module gph
gph <- import("gph")

#load source helper functions
source("R/dgm_to_df.R")
source("R/dgm_wrapper.R")

# load square matrix

load(file = "data-raw/rodentia_env_spread.rds")

# compute persistence homology parallel
# dimension 2 takes some time

dgm <-  gph$ripser_parallel(rodentia_env_spread, maxdim=2L, n_threads=-1L)
dgm_df <- dgm_to_df(dgm)

png("persistence_barcode_rodents.png")
TDAstats::plot_barcode(as.matrix(dgm_df))
dev.off()

png("persistence_rodents.png")
TDAstats::plot_persist(as.matrix(dgm_df))
dev.off()
