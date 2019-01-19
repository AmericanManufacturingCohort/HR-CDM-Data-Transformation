create_combined_dataset <- function(pv_filepath, oracle_filepath, output_dir="/tmp") {
  source("create_harmonized_peoplesoft_dataset.R")
  source("create_harmonized_oracle_dataset.R")
  pv_dataset <- create_harmonized_peoplesoft_dataset(read_csv(pv_filepath))
  oracle_dataset <- create_harmonized_oracle_dataset(read_csv(oracle_filepath))
  if ("dplyr" %in% (.packages())) {
    detach(package:dplyr)
  }
  library(plyr)
  message("Combining datasets")
  message("... merging datasets")
  combined_dataset <- rbind.fill(pv_dataset, oracle_dataset)
  message("... removing duplicates")
  combined_dataset <- unique(combined_dataset)
  detach(package:plyr)
  dataset_size = nrow(combined_dataset)
  message("... collecting ", formatC(dataset_size, format="d", big.mark=","), " rows in ", length(names(combined_dataset)), " variables")
  detach(package:plyr)

  message("... testing data size")
  expected_size = 3052017
  if (dataset_size == expected_size) {
    message("... test PASSED - the resulting data size meets the expected number")
  } else {
    stop("... test (!)FAILED (expected size: ", expected_size, ", collected: ", dataset_size, ")")
  }
  write_csv(combined_dataset, output_dir, "COMBINED_DATASET")
  return (combined_dataset)
}

read_csv <- function(filepath) {
  message("... reading CSV data from ", filepath)
  df = read.csv2(filepath, sep="|", quote="")
  return (df)
}

write_csv <- function(df, output_dir, fname) {
  filepath = paste0(output_dir, "/", fname, ".csv")
  message("... writing output to ", filepath)
  write.csv(df, filepath, na="", row.names=F)
}