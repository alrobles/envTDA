if (!require("reticulate")) install.packages("reticulate")

library(reticulate)
 
# # create a new environment 
virtualenv_create("TDA-environment")

# # create a new environment and install from pip
virtualenv_install("TDA-environment", "giotto-ph")
virtualenv_install("TDA-environment", "numpy")

