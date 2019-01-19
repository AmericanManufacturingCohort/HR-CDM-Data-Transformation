load_work_site_table <- function(filepath) {
  message("Loading WORK_SITE table")
  message("... reading source data")
  work_site<-read.csv(filepath,
     header=T, na.strings=c(""," ","NA"),
     colClasses=c(
        'numeric',    # work_site_id
        'character',  # work_site_source_value
        'numeric'))   # location_id
  message("... sorting data")
  work_site <- work_site %>% arrange(work_site_id)
  dataset_size = nrow(work_site)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(work_site)), " variables")
  return (work_site)
}