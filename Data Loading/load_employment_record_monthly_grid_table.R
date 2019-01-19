load_employment_record_monthly_grid_table <- function(filepath) {
  message("Loading EMPLOYMENT_RECORD_MONTHLY_GRID table")
  message("... reading source data")
  employment_record<-read.csv(filepath,
     header=T, na.strings=c(""," ","NA"),
     colClasses=c(
        'numeric',    # employment_record_id
        'numeric',    # employee_id
        'numeric',    # hr_event_id
        'numeric',    # year_of_record
        'numeric',    # month_of_record
        'numeric',    # day_of_record
        'Date',       # record_date
        'numeric',    # work_site_id
        'numeric',    # job_concept_id
        'character',  # work_state
        'numeric',    # employment_type_concept_id
        'character',  # job_source_value
        'character',  # job_source_concept_id
        'character',  # employment_status_source_value
        'character',  # employment_status_source_concept_id
        'character',  # employment_type_source_value
        'character',  # employment_type_source_concept_id
        'character',  # business_unit_source_value
        'character',  # business_unit_source_concept_id
        'character',  # department_source_value
        'character',  # department_source_concept_id
        'numeric'))   # annual_salary
  message("... sorting data")
  employment_record <- employment_record %>% arrange(employment_record_id)
  dataset_size = nrow(employment_record)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(employment_record)), " variables")
  return (employment_record)
}