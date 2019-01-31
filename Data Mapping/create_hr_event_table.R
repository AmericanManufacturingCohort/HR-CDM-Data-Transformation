create_hr_event_table <- function(combined_dataset, person) {
  if (!("dplyr" %in% (.packages()))) {
    library(dplyr)    
  }
  if (!("lubridate" %in% (.packages()))) {
    library(lubridate)    
  }
 
  message("Creating HR_EVENT table")
  message("... slicing source data")
  combined_dataset<-combined_dataset %>%
      select(eessno, effdtdt, jobtitle, jobcode, empstats,
             emptype, buname, bucode, deptname, deptcode,
             locatcd, annual, action, actioncd, actionde,
             reasoncd, retirement_eligibility_flag)
  message("... removing duplicates")
  combined_dataset<-unique(combined_dataset)
  message("... generating HR_EVENT primary key")
  combined_dataset$base_id<-10000000+seq.int(from=1, to=nrow(combined_dataset)) 

  message("... extracting data")
  employee_id_mapping <- person %>% distinct(person_source_value, person_id) %>% select(person_source_value, person_id)
  hr_event<-combined_dataset %>%
      left_join(employee_id_mapping, by=c("eessno"="person_source_value")) %>%
      mutate(hr_event_id=base_id,
          employee_id=person_id, 
          year_of_event=year(effdtdt), 
          month_of_event=month(effdtdt), 
          day_of_event=day(effdtdt), 
          event_date=effdtdt, 
          hr_event_concept_id=NA,
          hr_event_source_value=action, 
          hr_event_source_concept_id=actioncd,
          hr_event_reason=reasoncd,
          hr_event_description=actionde) %>% 
      select(hr_event_id, employee_id, year_of_event, month_of_event, day_of_event,
          event_date, hr_event_concept_id, hr_event_source_value, hr_event_source_concept_id, hr_event_reason,
          hr_event_description)

  message("... testing table join operation")
  original_size = nrow(combined_dataset)
  hr_event_size = nrow(hr_event)
  if (hr_event_size == original_size) {
    message("... test PASSED - table join operation doesn't produce unexpected new data")
  } else {
    stop("... test (!)FAILED (expected size: ", original_size, ", collected: ", hr_event_size, ")")
  }

  dataset_size = nrow(hr_event)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(hr_event)), " variables")

  message("... testing data size")
  expected_size = 3032114
  if (dataset_size == expected_size) {
    message("... test PASSED - the resulting data size meets the expected number")
  } else {
    stop("... test (!)FAILED (expected size: ", expected_size, ", collected: ", dataset_size, ")")
  }
  return (hr_event)
}