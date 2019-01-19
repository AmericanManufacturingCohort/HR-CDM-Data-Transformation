create_hrcdm_tables <- function(combined_dataset_filepath, retirement_eligibility_dataset_filepath, output_dir="/tmp") {
  if (!("dplyr" %in% (.packages()))) {
    library(dplyr)    
  }
  
  source("create_person_table.R")
  source("create_hr_event_table.R")
  source("create_employment_record_table.R")
  source("create_employee_table.R")
  source("create_work_site_table.R")
  source("create_location_table.R")
  source("create_site_history_table.R")
  source("create_employment_record_monthly_grid.R")

  combined_dataset <- load_combined_dataset(combined_dataset_filepath)
  retire_eligibility <- load_retirement_eligibility_data(retirement_eligibility_dataset_filepath)

  message("Adding retirement eligibility info to the raw data")
  combined_dataset <- combined_dataset %>% left_join(retire_eligibility, by="eessno")
  combined_dataset$retirement_eligibility_flag[is.na(combined_dataset$retirement_eligibility_flag)]<-0  # Assume NA == 0

  message("--- Building CORE tables ---")
  # 1: PERSON table
  person <- create_person_table(combined_dataset)
  write_csv(person, output_dir, "PERSON")
  
  # 2: HR_EVENT table  
  hr_event <- create_hr_event_table(combined_dataset, person)
  write_csv(hr_event, output_dir, "HR_EVENT")

  # 3: EMPLOYMENT_RECORD table
  employment_record <- create_employment_record_table(combined_dataset, person)
  write_csv(employment_record, output_dir, "EMPLOYMENT_RECORD")

  # 4: EMPLOYEE table
  employee <- create_employee_table(combined_dataset, person, employment_record)
  write_csv(employee, output_dir, "EMPLOYEE")

  # 5: WORK_SITE table
  work_site <- create_work_site_table()
  write_csv(work_site, output_dir, "WORK_SITE")

  # 6: LOCATION table
  location <- create_location_table()
  write_csv(location, output_dir, "LOCATION")

  # 7: SITE_HISTORY table
  site_history <- create_site_history_table()
  write_csv(site_history, output_dir, "SITE_HISTORY")

  message("--- Building DERIVED tables ---")
  # 1: EMPLOYMENT_RECORD_MONTHLY_GRID
  employment_record_monthly_grid <- create_employment_record_monthly_grid(employment_record)
  write_csv(employment_record_monthly_grid, output_dir, "EMPLOYMENT_RECORD_MONTHLY_GRID")
}

load_combined_dataset <- function(filepath) {
  message("Loading combined dataset")
  message("... reading source data")
  combined_dataset<-read.csv(filepath,
     header=T, na.strings=c(""," ","NA"),
     colClasses=c(
        'character',  # eessno
        'character',  # ethnicde
        'character',  # sex
        'Date',       # dobdt 
        'Date',       # hiredt
        'Date',       # termdt
        'Date',       # deathdt
        'Date',       # effdtdt
        'character',  # actioncd
        'character',  # action
        'character',  # actionde
        'character',  # reasoncd
        'character',  # locatcd
        'character',  # locatdes
        'character',  # empstats
        'character',  # emptype
        'character',  # jobfamily
        'character',  # jobtitle
        'character',  # jobcode
        'character',  # deptname
        'character',  # deptcode
        'character',  # buname
        'character',  # bucode
        'character',  # paygroup
        'numeric',    # comprate
        'numeric',    # annual
        'numeric',    # first_risk_score
        'numeric',    # risk_score_year
        'character')) # source
  message("... sorting data")
  combined_dataset <- combined_dataset %>% arrange(eessno,effdtdt)
  message("... generating base id, starting from 10000001")
  combined_dataset$base_id<-10000000+seq.int(from=1, to=nrow(combined_dataset))
  message("... reading ", nrow(combined_dataset) , " rows in ", length(names(combined_dataset)), " variables")
  return (combined_dataset)
}

load_retirement_eligibility_data <- function(filepath) {
  message("Loading retirment eligibility data")
  retire_eligibility<-read.csv(filepath,
      header=T, na.strings=c(""," ","NA"))
  retire_eligibility<-retire_eligibility %>%
      filter(Elig==1) %>%
      mutate(retirement_eligibility_flag=Elig) %>%
      select(eessno, retirement_eligibility_flag) %>%
      distinct %>%
      arrange(eessno)
  dataset_size = nrow(retire_eligibility)
  message("... reading ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(retire_eligibility)), " variables")
  return (retire_eligibility)
}

write_csv <- function(df, output_dir, fname) {
  filepath = paste0(output_dir, "/", fname, ".csv")
  message("... writing ", fname, " table to ", filepath)
  write.csv(df, filepath, na="", row.names=F)
}