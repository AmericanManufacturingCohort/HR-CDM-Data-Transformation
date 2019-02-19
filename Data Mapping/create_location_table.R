create_location_table <- function() {
  options(scipen=999)  # Prevents representing large numbers in scientific notation
  if (!("dplyr" %in% (.packages()))) {
    library(dplyr)    
  }

  message("Creating LOCATION table")
  message("... loading data from external source 'Plants_Master.csv'")
  plants_master<-read.csv('resources/Plants_Master.csv',
      header=T, na.strings=c(""," ","NA"),
      colClasses=c(
          'numeric',     # work_site_id
          'numeric',     # location_id
          'character',   # work_site_source_value
          'character',   # address_1
          'character',   # address_2
          'character',   # city
          'character',   # state
          'character',   # zip
          'character',   # county
          'character'))  # location_source_value

  plants_master_size = nrow(plants_master)
  message("... collecting ", formatC(plants_master_size, format="d", big.mark=","), " rows in ", length(names(plants_master)), " variables")

  message("... selecting only the variables that describe work site locations")
  location <- plants_master %>% select(location_id, address_1, address_2, city, state, zip, county, location_source_value)	

  dataset_size = nrow(location)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(location)), " variables")

  message("... testing data size")
  expected_size = plants_master_size
  if (dataset_size == expected_size) {
    message("... test PASSED - the resulting data size meets the expected number")
  } else {
    stop("... test (!)FAILED (expected size: ", expected_size, ", collected: ", dataset_size, ")")
  }
  return (location)
}