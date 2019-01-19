load_hr_event_table <- function(filepath) {
  message("Loading HR_EVENT table")
  message("... reading source data")
  hr_event<-read.csv(filepath,
     header=T, na.strings=c(""," ","NA"),
     colClasses=c(
        'numeric',    # hr_event_id
        'numeric',    # employee_id
        'numeric',    # year_of_event
        'numeric',    # month_of_event
        'numeric',    # day_of_event
        'Date',       # event_date
        'numeric',    # hr_event_concept_id
        'character',  # hr_event_source_value
        'character',  # hr_event_source_concept_id
        'character',  # hr_event_reason
        'character')) # hr_event_description
  message("... sorting data")
  hr_event <- hr_event %>% arrange(hr_event_id)
  dataset_size = nrow(hr_event)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(hr_event)), " variables")
  return (hr_event)
}