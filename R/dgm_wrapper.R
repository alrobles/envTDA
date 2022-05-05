dgm_wrapper <- function(dgm, dgm_name){
  dgm %>% 
    as_tibble() %>% 
    setNames(c("birth", "death"))  %>% 
    mutate(dimension = dgm_name) %>% 
    mutate(dimension = as.numeric(dimension) - 1 ) %>% 
    select(dimension, birth, death)
}
