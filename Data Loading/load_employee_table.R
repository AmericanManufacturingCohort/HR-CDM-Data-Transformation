load_employee_table <- function(filepath) {
  message("Loading EMPLOYEE table")
  message("... reading source data")
  employee<-read.csv(filepath,
     header=T, na.strings=c(""," ","NA"),
     colClasses=c(
        'numeric',    # employee_id
        'Date',       # hired_date
        'Date',       # termination_date
        'Date',       # retired_date 
        'numeric'))   # retirement_eligibility_flag
  message("... sorting data")
  employee <- employee %>% arrange(employee_id)
  dataset_size = nrow(employee)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(employee)), " variables")
  return (employee)
}