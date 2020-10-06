# Collate estimates from different estimates in same sub-regional folder 

collate_estimates <- function(name, target = "rt"){
  
  # Get locations of summary csv
  sources <- as.list(paste0(list.files(here::here("subnational", name), full.names = TRUE),
                            "/summary/", target, ".csv"))
  names(sources) <- list.files(here::here("subnational", name))
  
  # Read and bind
  df <- purrr::discard(sources, grepl("collated", names(sources))) %>%
    purrr::map(., ~ fread(.x)) %>%
    dplyr::bind_rows(.id = "source") %>%
    dplyr::filter(type == "estimate") %>%
    dplyr::select(-type)
  
  # Check a collated file exists
  if(!dir.exists(here::here("subnational", name, "collated", target))){
    dir.create(here::here("subnational", name, "collated", target))
  }
  
  # Save back to main UK folder
  data.table::fwrite(df, here::here("subnational", name, "collated", target, paste0(Sys.Date(), ".csv")))
  return(invisible(NULL))
}
