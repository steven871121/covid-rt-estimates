# Collate estimates from different estimates in same sub-regional folder 

collate_estimates <- function(name){
  
  # Get locations of summary csv
  sources <- as.list(paste0(list.files(here::here("subnational", name), full.names = TRUE),
                            "/summary/rt.csv"))
  names(sources) <- list.files(here::here("subnational", name))
  
  # Read and bind
  rt <- purrr::discard(sources, grepl("collated", names(sources))) %>%
    purrr::map(., ~ fread(.x)) %>%
    dplyr::bind_rows(.id = "source") %>%
    dplyr::filter(type == "estimate") %>%
    dplyr::select(-type)
  
  # Check a collated file exists
  if(!dir.exists(here::here("subnational", name, "collated", Sys.Date()))){
    dir.create(here::here("subnational", name, "collated", Sys.Date()))
  }
  
  # Save back to main UK folder
  data.table::fwrite(rt, here::here("subnational", name, "collated", Sys.Date(), "uk-collated-rt.csv"))
  
}
