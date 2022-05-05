dgm_to_df <- function(dgm_object){
  purrr::map2_df(.x = dgm_object[[1]], .y = 1:length(dgm_object[[1]]), dgm_wrapper ) %>% 
    filter(death < max(death))
}
