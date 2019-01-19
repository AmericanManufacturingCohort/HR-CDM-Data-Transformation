create_employee_table <- function(combined_dataset, person, employment_record) {
  if (!("dplyr" %in% (.packages()))) {
    library(dplyr)    
  }

  message("Creating EMPLOYEE table")
  message("... extracting data")
  employee_id_mapping <- person %>% distinct(person_source_value, person_id) %>% select(person_source_value, person_id)
  employee<-combined_dataset %>%
      left_join(employee_id_mapping, by=c("eessno"="person_source_value")) %>%
      group_by(person_id) %>%
      summarize(employee_id=first(person_id),
          hired_date=first(hiredt),
          termination_date=last(termdt),
          retirement_eligibility_flag=max(retirement_eligibility_flag)) %>%
      select(employee_id, hired_date, termination_date, retirement_eligibility_flag) %>%
      arrange(employee_id)

  message("... populating retirement dates from employee track records")
  retired_tbl<-employment_record %>% 
      filter(work_state=="Retire") %>%
      group_by(employee_id) %>%
      slice(which.max(record_date)) %>%
      select(employee_id,record_date) %>%
      mutate(retired_date=record_date) %>%
      arrange(employee_id,record_date)
  
  message("... adding retirement date")
  employee<-employee %>%
      left_join(retired_tbl, by="employee_id") %>%
      select(employee_id, hired_date, termination_date, retired_date, retirement_eligibility_flag) %>%
      arrange(employee_id)

  dataset_size = nrow(employee)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(employee)), " variables")

  message("... testing data size")
  expected_size = 231813
  if (dataset_size == expected_size) {
    message("... test PASSED - the resulting data size meets the expected number")
  } else {
    stop("... test (!)FAILED (expected size: ", expected_size, ", collected: ", dataset_size, ")")
  }
  return (employee)
}