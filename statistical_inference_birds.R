
if (!require("tidyverse")) install.packages("tidyverse")

# read the data

birds_dist_env_all <- read_csv("birds_dist_env_all.csv")
birdTaxonomy <- read_csv("data-raw/BLIOCPhyloMasterTax.csv") 


bigOrders <- birdTaxonomy %>% 
  count(IOCOrder) %>% arrange(desc(n)) %>% slice(2:5)
  
speciesOrderList <- birdTaxonomy %>% 
  inner_join(bigOrders) %>% select(Scientific, IOCOrder) %>% 
  group_by(IOCOrder) %>% group_split() 

speciesOrderList <- speciesOrderList %>% 
  purrr::map(function(x) x %>% sample_n(300))


birds_dist_env_1 <- birds_dist_env_all %>% 
  inner_join(speciesOrderList[[1]], by  = c("item1" = "Scientific")) %>% 
  inner_join(speciesOrderList[[1]], by  = c("item2" = "Scientific"))

birds_dist_env_2 <- birds_dist_env_all %>% 
  inner_join(speciesOrderList[[2]], by  = c("item1" = "Scientific")) %>% 
  inner_join(speciesOrderList[[2]], by  = c("item2" = "Scientific"))

birds_dist_env_3 <- birds_dist_env_all %>% 
  inner_join(speciesOrderList[[3]], by  = c("item1" = "Scientific")) %>% 
  inner_join(speciesOrderList[[3]], by  = c("item2" = "Scientific"))

#convert pairwise distance to square data frame
birds_env_spread_APODIFORMES  <- birds_dist_env_1 %>% 
  select(item1, item2, enviromental.distance) %>% 
  spread(item2, enviromental.distance) 

birds_env_spread_CHARADRIIFORMES  <- birds_dist_env_2 %>% 
  select(item1, item2, enviromental.distance) %>% 
  spread(item2, enviromental.distance) 

#keep species name
birds_sp_APODIFORMES <-  birds_env_spread_APODIFORMES %>% select(item1)
birds_sp_CHARADRIIFORMES <-  birds_env_spread_CHARADRIIFORMES %>% select(item1)

#convert to environmental simillarity matrix
birds_env_spread_APODIFORMES <-  birds_env_spread_APODIFORMES %>%
  select(-item1) %>% 
  mutate_all(function(x) replace_na(x, 0)) %>% as.matrix()
birds_env_spread_CHARADRIIFORMES <-  birds_env_spread_CHARADRIIFORMES %>%
  select(-item1) %>% 
  mutate_all(function(x) replace_na(x, 0)) %>% as.matrix()

save(birds_env_spread_APODIFORMES, file = "data-raw/birds_env_spread_APODIFORMES.rds")
save(birds_env_spread_CHARADRIIFORMES, file = "data-raw/birds_env_spread_CHARADRIIFORMES.rds")



library(TDAstats)
# calculate homologies for both datasets
APODIFORMES.phom <- calculate_homology(birds_env_spread_APODIFORMES, dim = 1)
CHARADRIIFORMES.phom <- calculate_homology(birds_env_spread_CHARADRIIFORMES, dim = 1)
plot_barcode(APODIFORMES.phom)
plot_barcode(CHARADRIIFORMES.phom)


# load ggplot2
library("ggplot2")

# plot barcodes with labels and identical axes
p1 <- plot_barcode(APODIFORMES.phom) +
  ggtitle("Persistent Homology for APODIFORMEES") +
  xlim(c(0, 80))
p2 <- plot_barcode(CHARADRIIFORMES.phom) +
  ggtitle("Persistent Homology for CHARADRIIFORMES") +
  xlim(c(0, 80))

write_rds(p1, file = "phAPODIFORMEES.rds" )
write_rds(p2, file = "phCHARADRIIFORMES.rds" )
cowplot::plot_grid(p1, p2)
# run permutation test
# perm.test <- permutation_test(birds_env_spread_APODIFORMES, 
#                               birds_env_spread_CHARADRIIFORMES, 
#                               iterations = 100, format = "distmat")


