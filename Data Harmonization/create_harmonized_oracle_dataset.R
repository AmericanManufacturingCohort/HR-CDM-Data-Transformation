create_harmonized_oracle_dataset <- function(df) {
  if (!("dplyr" %in% (.packages()))) {
    library(dplyr)    
  }
  if (!("lubridate" %in% (.packages()))) {
    library(lubridate)    
  }
  
  message("Processing Oracle dataset")
  message("... preparing variables")
  oracle_variables <- names(oracle_dataset)
  names(oracle_dataset) <- tolower(oracle_variables)
  oracle_dataset <- separate(oracle_dataset, deptcode, " ", into=c("deptcode_cd", "deptcode_des"), remove=F)
  oracle_dataset <- separate(oracle_dataset, paygrdes, " ", into=c("paygrdes_cd", "paygrdes_des"), remove=F)

  message("... sorting raw data based on {eessno, effdtdt}")
  oracle_dataset <- df %>%
      mutate_if(is.factor, as.character) %>%
      arrange(eessno, effdtdt)

  message("... generating row id")
  oracle_dataset$row_id <- paste0("OR.HR_", seq.int(from=1, to=nrow(df)))

  message("... extracting data")
  oracle_dataset <- oracle_dataset %>%
      mutate_if(is.factor, as.character) %>%
      mutate(eessno=eessno,
             ethnicde=ifelse(ethnicde=="",NA,ethnicde),
             sex=ifelse(sex=="",NA,ifelse(sex=="Male","M",ifelse(sex=="Female","F",sex))),
             dobdt=as.Date(dobdt,format = "%m/%d/%Y"),
             hiredt=as.Date(hiredt,format = "%m/%d/%Y"),
             termdt=as.Date(termdt,format = "%m/%d/%Y"),
	           deathdt=as.Date(date_of_death,format = "%m/%d/%Y"),
             effdtdt=as.Date(effdtdt,format = "%m/%d/%Y"),
             actioncd=NA,
             action=ifelse(action=="",NA,action),
             actionde=ifelse(action=="",NA,action),
             reasoncd=NA,
             locatcd=ifelse(locatcd=="",NA,locatcd),
             locatdes=ifelse(locatdes=="",NA,locatdes),
             empstats=NA,
             emptype=ifelse(compfreq=="",NA,compfreq),
             jobfamily=ifelse(oracle_jobfamily=="",NA,oracle_jobfamily),
             jobtitle=ifelse(hourly_pv_jobtitle=="",NA,hourly_pv_jobtitle),
             jobcode=ifelse(hourly_pv_jobcode=="",NA,hourly_pv_jobcode),
             deptname=ifelse(deptname=="",NA,deptname),
             deptcode=ifelse(deptcode_cd=="",NA,deptcode_cd),
             buname=ifelse(bundesc=="",NA,bundesc),
             bucode=NA,
             paygroup=ifelse(paygrdes_cd=="",NA,paygrdes_cd),
             comprate=ifelse(!is.na(as.numeric(comprate)), round(as.numeric(comprate), digits=2), NA),
             annual=ifelse(!is.na(as.numeric(annual)), round(as.numeric(annual), digits=2), NA),
             first_risk_score=ifelse(!is.na(as.numeric(first_risk_score)), as.numeric(first_risk_score), NA),
             risk_score_year=ifelse(!is.na(as.numeric(risk_score_year)), as.numeric(risk_score_year), NA),
             source="OR") %>%
      select(row_id, eessno, ethnicde, sex, dobdt, hiredt,
             termdt, deathdt, effdtdt, actioncd, action,
             actionde, reasoncd, locatcd, locatdes, empstats,
             emptype, jobfamily, jobtitle, jobcode, deptname,
             deptcode, buname, bucode, paygroup, comprate,
             annual, first_risk_score, risk_score_year, source)

  message("... removing duplicates")
  oracle_dataset <- unique(oracle_dataset)
  dataset_size = nrow(oracle_dataset)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(oracle_dataset)), " variables")

  message("... testing data size")
  expected_size = 614028
  if (dataset_size == expected_size) {
    message("... test PASSED - the resulting data size meets the expected number")
  } else {
    stop("... test (!)FAILED (expected size: ", expected_size, ", collected: ", dataset_size, ")")
  }
  return (oracle_dataset)
}