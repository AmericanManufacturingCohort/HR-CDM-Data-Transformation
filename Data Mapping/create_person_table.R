create_person_table <- function(combined_dataset) {
  if (!("dplyr" %in% (.packages()))) {
    library(dplyr)    
  }
  if (!("lubridate" %in% (.packages()))) {
    library(lubridate)    
  }
  
  message("Creating PERSON table")
  message("... extracting data")
  person<-combined_dataset %>%
      select(eessno,dobdt,sex,ethnicde) %>%
      group_by(eessno) %>%
      mutate(dobdt = unique(dobdt[!is.na(dobdt)])[1],
         sex = unique(sex[!is.na(sex)])[1],
         ethnicde = unique(ethnicde[!is.na(ethnicde)])[1]) %>%
      ungroup() %>%
      distinct() %>%
      mutate(person_id=NA,
          gender_concept_id=NA,
          year_of_birth=year(dobdt), 
          month_of_birth=month(dobdt), 
          day_of_birth=day(dobdt),
          birth_datetime=dobdt,
          race_concept_id=NA, 
          ethnicity_concept_id=NA, 
          location_id=NA, 
          provider_id=NA, 
          care_site_id=NA,
          person_source_value=eessno,
          gender_source_value=ifelse(sex=="M","Male",ifelse(sex=="F","Female",NA)),
          gender_source_concept_id=sex, 
          race_source_value=NA, 
          race_source_concept_id=NA,
          ethnicity_source_value=ethnicde,
          ethnicity_source_concept_id=NA) %>%
      select(person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth,
          birth_datetime, race_concept_id, ethnicity_concept_id, location_id, provider_id,
          care_site_id, person_source_value, gender_source_value, gender_source_concept_id, race_source_value,
          race_source_concept_id, ethnicity_source_value, ethnicity_source_concept_id) %>%
      arrange(person_source_value)

  message("... filling in the gender_concept_id according to the OMOP Vocabulary")
  person$gender_concept_id <- ifelse(person$gender_source_value=="Male",8507,ifelse(person$gender_source_value=="Female",8532,0))

  message("... filling in the ethnicity_concept_id according to the OMOP Vocabulary")
  person$ethnicity_concept_id<-
      ifelse(is.na(person$ethnicity_source_value),0,
          ifelse(person$ethnicity_source_value %in% c("", "Declined to State", "Not Applicable"), 0,
              ifelse(person$ethnicity_source_value %in% c("Hispanic", "Hispanic or Latino"), 38003563, 38003564)))

  message("... generating person unique id, starting from 1000001")
  person$person_id<-1000000+seq.int(from=1, to=nrow(person))

  dataset_size = nrow(person)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(person)), " variables")

  message("... testing data size")
  expected_size = 231813
  if (dataset_size == expected_size) {
    message("... test PASSED - the resulting data size meets the expected number")
  } else {
    stop("... test (!)FAILED (expected size: ", expected_size, ", collected: ", dataset_size, ")")
  }
  return (person)
}