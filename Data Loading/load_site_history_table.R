load_site_history_table <- function(filepath) {
  message("Loading SITE_HISTORY table")
  message("... reading source data")
  site_history<-read.csv(filepath,
     header=T, na.strings=c(""," ","NA"),
     colClasses=c(
        'numeric',    # site_history_id
        'numeric',    # work_site_id
        'numeric',    # site_event_id
        'numeric',    # year_of_record
        'numeric',    # month_of_record
        'numeric',    # day_of_record
        'Date',       # record_date
        'character',  # site_owner
        'character',  # site_type
        'character')) # site_status
  message("... sorting data")
  site_history <- site_history %>% arrange(site_history_id)
  dataset_size = nrow(site_history)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(site_history)), " variables")
  return (site_history)
}