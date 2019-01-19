load_person_table <- function(filepath) {
  message("Loading PERSON table")
  message("... reading source data")
  person<-read.csv(filepath,
     header=T, na.strings=c(""," ","NA"),
     colClasses=c(
        'numeric',    # person_id
        'numeric',    # gender_concept_id
        'numeric',    # year_of_birth
        'numeric',    # month_of_birth 
        'numeric',    # day_of_birth
        'Date',       # birth_datetime
        'numeric',    # race_concept_id
        'numeric',    # ethnicity_concept_id
        'numeric',    # location_id
        'numeric',    # provider_id
        'numeric',    # care_site_id
        'character',  # person_source_value
        'character',  # gender_source_value
        'character',  # gender_source_concept_id
        'character',  # race_source_value
        'character',  # race_source_concept_id
        'character',  # ethnicity_source_value
        'character')) # ethnicity_source_concept_id
  message("... sorting data")
  person <- person %>% arrange(person_id)
  dataset_size = nrow(person)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(person)), " variables")
  return (person)
}