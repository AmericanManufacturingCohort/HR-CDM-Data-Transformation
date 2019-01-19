create_employment_record_table <- function(raw_data, person) {
  if (!("dplyr" %in% (.packages()))) {
    library(dplyr)    
  }
  if (!("lubridate" %in% (.packages()))) {
    library(lubridate)    
  }

  source("action_recode.R")
  
  message("Creating EMPLOYMENT_RECORD table")
  message("... loading empstats mapping")
  empstats_mapping<-read.csv('resources/Empstats_Mapping.csv',
      header=T, na.strings=c(""," ","NA"),
      colClasses=c(
          'character',   # empstats
          'character'))  # empstats_label

  message("... loading emptype mapping")
  emptype_mapping<-read.csv('resources/Emptype_Mapping.csv',
      header=T, na.strings=c(""," ","NA"),
      colClasses=c(
          'character',   # emptype
          'character'))  # emptype_label

  message("... loading plant code mapping")
  plant_mapping<-read.csv('resources/Plants_Master.csv',
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

  message("... augmenting the raw data with the data mappings")
  employee_id_mapping <- person %>% distinct(person_source_value, person_id) %>% select(person_source_value, person_id)
  augmented_data<-raw_data %>%
      left_join(employee_id_mapping, by=c("eessno"="person_source_value")) %>%
      left_join(empstats_mapping, by="empstats") %>%
      left_join(emptype_mapping, by="emptype") %>%
      left_join(plant_mapping, by=c("locatcd"="work_site_source_value"))

  message("... testing the augmented data table")
  original_size = nrow(raw_data)
  augmented_data_size = nrow(augmented_data)
  if (augmented_data_size == original_size) {
    message("... test PASSED - table join operation doesn't produce unexpected new data")
  } else {
    stop("... test (!)FAILED (expected size: ", original_size, ", collected: ", augmented_data_size, ")")
  }

  message("... extracting data")
  employment_record<-augmented_data %>%
      mutate(employment_record_id=NA,
          employee_id=person_id,
          hr_event_id=base_id,
          year_of_record=year(effdtdt), 
          month_of_record=month(effdtdt), 
          day_of_record=day(effdtdt), 
          record_date=effdtdt,
          work_site_id=work_site_id,
          job_concept_id=NA, 
          work_state=mapply(action_recode, empstats, action, reasoncd, retirement_eligibility_flag),
          employment_type_concept_id=NA,
          job_source_value=jobtitle, 
          job_source_concept_id=jobcode, 
          employment_status_source_value=empstats_label,
          employment_status_source_concept_id=empstats,
          employment_type_source_value=emptype_label,
          employment_type_source_concept_id=emptype,
          business_unit_source_value=buname,
          business_unit_source_concept_id=NA,
	  department_source_value=deptname,
          department_source_concept_id=NA,
          annual_salary=annual) %>%
      select(employment_record_id, employee_id, hr_event_id, year_of_record, month_of_record,
          day_of_record, record_date, work_site_id, job_concept_id, work_state,
          employment_type_concept_id, job_source_value, job_source_concept_id, employment_status_source_value,
          employment_status_source_concept_id, employment_type_source_value, employment_type_source_concept_id,
          business_unit_source_value, business_unit_source_concept_id, department_source_value,
          department_source_concept_id, annual_salary) %>%
      arrange(employee_id,record_date)

  message("... generating track record unique id, starting from 1")
  employment_record$employment_record_id<-seq.int(from=1, to=nrow(employment_record))

  message("... testing table join operation")
  original_size = nrow(raw_data)
  employment_record_size = nrow(employment_record)
  if (employment_record_size == original_size) {
    message("... test PASSED - table join operation doesn't produce unexpected new data")
  } else {
    stop("... test (!)FAILED (expected size: ", original_size, ", collected: ", employment_record_size, ")")
  }

  dataset_size = nrow(employment_record)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(employment_record)), " variables")

  message("... testing data size")
  expected_size = 3052017
  if (dataset_size == expected_size) {
    message("... test PASSED - the resulting data size meets the expected number")
  } else {
    stop("... test (!)FAILED (expected size: ", expected_size, ", collected: ", dataset_size, ")")
  }
  return (employment_record)
}