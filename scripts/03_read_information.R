if (!require("tidyverse")) install.packages("tidyverse")
library(dplyr)

# read the data

rodentia_dist_phylo_geo_env <- read_csv("data-raw/rodentia_dist_phylo_geo_env.csv")
#convert pairwise distance to square data frame
rodentia_env_spread <- rodentia_dist_phylo_geo_env %>% 
  select(item1, item2, env_distance) %>% 
  spread(item2, env_distance) 

#keep species name
rodentia_sp <-  rodentia_env_spread %>% select(item1)

#convert to environmental simillarity matrix
rodentia_env_spread <-  rodentia_env_spread %>%
  select(-item1) %>% 
  mutate_all(function(x) replace_na(x, 0)) %>% as.matrix()

save(rodentia_env_spread, file = "data-raw/rodentia_env_spread.rds")
