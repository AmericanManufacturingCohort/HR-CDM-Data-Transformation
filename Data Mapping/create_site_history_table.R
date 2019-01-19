create_site_history_table <- function() {
  if (!("dplyr" %in% (.packages()))) {
    library(dplyr)    
  }

  message("Creating SITE_HISTORY table")
  message("... loading data from external source 'Plants_History.csv'")  # The file is a curated data from domain experts
  plants_history<-read.csv('resources/Plants_History.csv',
      header=T, na.strings=c(""," ","NA"),
      colClasses=c(
          'numeric',    # site_history_id
          'numeric',    # work_site_id
          'numeric',    # site_event_id
          'numeric',    # year_of_record
          'numeric',    # month_of_record
          'numeric',    # day_of_record
          'Date',       # record_date
          'character',  # locatcd <-- only exists in this table to help the domain experts filling out the history entries
          'character',  # site_owner
          'character',  # site_type
          'character')) # site_status

  message("... selecting only the variables that describe work site history")
  site_history <- plants_history %>% select(site_history_id, work_site_id, site_event_id, year_of_record, month_of_record,
      day_of_record, record_date, site_owner, site_type, site_status)

  dataset_size = nrow(site_history)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(site_history)), " variables")

  return (site_history)
}