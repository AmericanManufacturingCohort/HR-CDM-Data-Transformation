load_location_table <- function(filepath) {
  message("Loading LOCATION table")
  message("... reading source data")
  location<-read.csv(filepath,
     header=T, na.strings=c(""," ","NA"),
     colClasses=c(
        'numeric',    # location_id
        'character',  # address_1
        'character',  # address_2
        'character',  # city
        'character',  # state
        'character',  # zip
        'character',  # county
        'character')) # location_source_value
  message("... sorting data")
  location <- location %>% arrange(location_id)
  dataset_size = nrow(location)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(location)), " variables")
  return (location)
}