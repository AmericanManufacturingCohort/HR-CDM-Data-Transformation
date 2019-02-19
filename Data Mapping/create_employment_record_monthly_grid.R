create_employment_record_monthly_grid <- function(employment_record) {
  options(scipen=999)  # Prevents representing large numbers in scientific notation
  if (!("dplyr" %in% (.packages()))) {
    library(dplyr)    
  }
  if (!("data.table" %in% (.packages()))) {
    library(data.table)
  }
  if (!("zoo" %in% (.packages()))) {
    library(zoo)    
  }
  if (!("lubridate" %in% (.packages()))) {
    library(lubridate)
  }
    
  message("Creating EMPLOYMENT_RECORD_MONTHLY_GRID table")
  message("... generating monthly fillers")
  filler <- employment_record %>% 
      group_by(employee_id) %>% 
      summarize(start=min(record_date),end=max(record_date)) %>% 
      filter(end > as.Date('1996-01-01')) %>% 
      rowwise() %>% 
      do(data.frame(employee_id=.$employee_id,hired_date=.$start,record_date=seq(as.Date('1996-01-01'),as.Date('2013-12-31'),by="month"))) %>% 
      mutate(employment_record_id=NA,
          employee_id=employee_id,
          hr_event_id=NA,
          year_of_record=year(record_date),
          month_of_record=month(record_date),
          day_of_record=day(record_date),
          record_date=record_date,
          work_site_id=NA,
          job_concept_id=NA,
          work_state=ifelse(record_date<hired_date,"Unhire",NA),
          employment_type_concept_id=NA,
          job_source_value=NA,
          job_source_concept_id=NA,
          employment_status_source_value=NA,
          employment_status_source_concept_id=NA,
          employment_type_source_value=NA,
          employment_type_source_concept_id=NA,
          business_unit_source_value=NA,
          business_unit_source_concept_id=NA,
          department_source_value=NA,
          department_source_concept_id=NA,
          annual_salary=NA) %>% 
    select(-one_of('hired_date'))

  message("... adding fillers to the employment record")
  filler$tmpkey <- with(filler, paste0(employee_id, record_date))
  employment_record$tmpkey <- with(employment_record, paste0(employee_id, record_date))
  employment_record_monthly_grid <- rbind(employment_record, filler[!filler$tmpkey %in% employment_record$tmpkey,]) %>% 
     select(-one_of('tmpkey')) %>%
     arrange(employee_id,record_date)

  message("... filling down empty cells (coffee time!)")
  setDT(employment_record_monthly_grid)[,work_site_id := na.locf(work_site_id, na.rm=F), by=employee_id]
  setDT(employment_record_monthly_grid)[,job_concept_id := na.locf(job_concept_id, na.rm=F), by=employee_id]
  setDT(employment_record_monthly_grid)[,work_state := na.locf(work_state, na.rm=F), by=employee_id]
  setDT(employment_record_monthly_grid)[,employment_type_concept_id := na.locf(employment_type_concept_id, na.rm=F), by=employee_id]
  setDT(employment_record_monthly_grid)[,job_source_value := na.locf(job_source_value, na.rm=F), by=employee_id]
  setDT(employment_record_monthly_grid)[,job_source_concept_id := na.locf(job_source_concept_id, na.rm=F), by=employee_id]
  setDT(employment_record_monthly_grid)[,employment_status_source_value := na.locf(employment_status_source_value, na.rm=F), by=employee_id]
  setDT(employment_record_monthly_grid)[,employment_status_source_concept_id := na.locf(employment_status_source_concept_id, na.rm=F), by=employee_id]
  setDT(employment_record_monthly_grid)[,employment_type_source_value := na.locf(employment_type_source_value, na.rm=F), by=employee_id]
  setDT(employment_record_monthly_grid)[,employment_type_source_concept_id := na.locf(employment_type_source_concept_id, na.rm=F), by=employee_id]
  setDT(employment_record_monthly_grid)[,business_unit_source_value := na.locf(business_unit_source_value, na.rm=F), by=employee_id]
  setDT(employment_record_monthly_grid)[,business_unit_source_concpet_id := na.locf(business_unit_source_concept_id, na.rm=F), by=employee_id]
  setDT(employment_record_monthly_grid)[,department_source_value := na.locf(department_source_value, na.rm=F), by=employee_id]
  setDT(employment_record_monthly_grid)[,department_source_concept_id := na.locf(department_source_concept_id, na.rm=F), by=employee_id]
  setDT(employment_record_monthly_grid)[,annual_salary := na.locf(annual_salary, na.rm=F), by=employee_id]

  message("... creating data frame")
  employment_record_monthly_grid <- as.data.frame(employment_record_monthly_grid)
  employment_record_monthly_grid <- employment_record_monthly_grid %>%
      mutate(employment_record_id=NA,
          employee_id=as.numeric(employee_id),
          hr_event_id=as.numeric(hr_event_id),
          year_of_record=as.numeric(year_of_record), 
          month_of_record=as.numeric(month_of_record), 
          day_of_record=as.numeric(day_of_record), 
          record_date=as.Date(record_date),
          work_site_id=as.numeric(work_site_id),
          job_concept_id=as.numeric(job_concept_id), 
          work_state=as.character(work_state),
          employment_type_concept_id=as.numeric(employment_type_concept_id),
          job_source_value=as.character(job_source_value), 
          job_source_concept_id=as.character(job_source_concept_id), 
          employment_status_source_value=as.character(employment_status_source_value),
          employment_status_source_concept_id=as.character( employment_status_source_concept_id),
          employment_type_source_value=as.character(employment_type_source_value),
          employment_type_source_concept_id=as.character(employment_type_source_concept_id),
          business_unit_source_value=as.character(business_unit_source_value),
          business_unit_source_concept_id=as.character(business_unit_source_concept_id),
	  department_source_value=as.character(department_source_value),
          department_source_concept_id=as.character(department_source_concept_id),
          annual_salary=as.numeric(annual_salary)) %>%
      select(employment_record_id, employee_id, hr_event_id, year_of_record, month_of_record,
          day_of_record, record_date, work_site_id, job_concept_id, work_state,
          employment_type_concept_id, job_source_value, job_source_concept_id, employment_status_source_value,
          employment_status_source_concept_id, employment_type_source_value, employment_type_source_concept_id,
          business_unit_source_value, business_unit_source_concept_id, department_source_value,
          department_source_concept_id, annual_salary)

  message("... generating track record unique id, starting from 1")
  employment_record_monthly_grid$employment_record_id<-seq.int(from=1, to=nrow(employment_record_monthly_grid))

  dataset_size = nrow(employment_record_monthly_grid)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(employment_record_monthly_grid)), " variables")

  message("... testing data size")
  expected_size = 41609407
  if (dataset_size == expected_size) {
    message("... test PASSED - the resulting data size meets the expected number")
  } else {
    stop("... test (!)FAILED (expected size: ", expected_size, ", collected: ", dataset_size, ")")
  }
  return (employment_record_monthly_grid)
}