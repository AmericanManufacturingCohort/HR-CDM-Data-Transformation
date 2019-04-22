create_harmonized_peoplesoft_dataset <- function(df) {
  if (!("dplyr" %in% (.packages()))) {
    library(dplyr)    
  }
  if (!("lubridate" %in% (.packages()))) {
    library(lubridate)    
  }
  
  message("Processing PeopleSoft dataset")
  message("... preparing variables")
  pv_variables <- names(pv_dataset)
  names(pv_dataset) <- tolower(pv_variables)

  message("... sorting raw data based on {eessno, effdtdt}")
  pv_dataset <- df %>%
      mutate_if(is.factor, as.character) %>%
      arrange(eessno, effdtdt)

  message("... generating row id")
  pv_dataset$row_id <- paste0("PV.HR_", seq.int(from=1, to=nrow(df)))

  message("... extracting data")
  pv_dataset <- pv_dataset %>%
      mutate_if(is.factor, as.character) %>%
      mutate(eessno=eessno,
             ethnicde=ifelse(ethnicde=="",NA,ethnicde),
             sex=ifelse(sex=="",NA,sex),
             dobdt=as.Date(dobdt,format = "%m/%d/%Y"),
             hiredt=as.Date(hiredt,format = "%m/%d/%Y"),
             termdt=as.Date(termdt,format = "%m/%d/%Y"),
	           deathdt=as.Date(date_of_death,format = "%m/%d/%Y"),
             effdtdt=as.Date(effdtdt,format = "%m/%d/%Y"),
             actioncd=ifelse(actioncd=="",NA,actioncd),
             action=ifelse(actionde=="",NA,actionde),
             actionde=ifelse(actionde=="",NA,actionde),
             reasoncd=ifelse(reasoncd=="",NA,reasoncd),
             locatcd=ifelse(locatcd=="",NA,locatcd),
             locatdes=ifelse(locatdes=="",NA,locatdes),
             empstats=ifelse(empstats=="",NA,empstats),
             emptype=ifelse(emptype=="",NA,emptype),
             jobfamily=NA,
             jobtitle=ifelse(jobtitle=="",NA,jobtitle),
             jobcode=ifelse(jobcode=="",NA,jobcode),
             deptname=ifelse(deptname=="",NA,deptname),
             deptcode=ifelse(deptabr=="",NA,deptabr),
             buname=ifelse(bundesc=="",NA,bundesc),
             bucode=ifelse(busunit=="",NA,busunit),
             paygroup=ifelse(paygroup=="",NA,paygroup),
             comprate=ifelse(!is.na(as.numeric(comprate)), round(as.numeric(comprate), digits=2), NA),
             annual=ifelse(!is.na(as.numeric(annual)), round(as.numeric(annual), digits=2), NA),
             first_risk_score=ifelse(!is.na(as.numeric(first_risk_score)), as.numeric(first_risk_score), NA),
             risk_score_year=ifelse(!is.na(as.numeric(risk_score_year)), as.numeric(risk_score_year), NA),
             source="PV") %>%
      select(row_id, eessno, ethnicde, sex, dobdt, hiredt,
             termdt, deathdt, effdtdt, actioncd, action,
             actionde, reasoncd, locatcd, locatdes, empstats,
             emptype, jobfamily, jobtitle, jobcode, deptname,
             deptcode, buname, bucode, paygroup, comprate,
             annual, first_risk_score, risk_score_year, source)

  message("... removing duplicates")
  pv_dataset <- unique(pv_dataset)
  dataset_size = nrow(pv_dataset)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(pv_dataset)), " variables")
   
  message("... testing data size")
  expected_size = 2437989
  if (dataset_size == expected_size) {
    message("... test PASSED - the resulting data size meets the expected number")
  } else {
    stop("... test (!)FAILED (expected size: ", expected_size, ", collected: ", dataset_size, ")")
  }
  return (pv_dataset)
}