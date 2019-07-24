# HR-CDM Data Transformation Pipeline

This repository houses the source code and documentation of the HR-CDM Data Transformation Pipeline used to transform the AMC Human Resources (AMC-HR) data set to HR-CDM data set (See the [HR-CDM Specification](https://github.com/AmericanManufacturingCohort/HR-CDM-Specification/wiki) to learn the data model).

## Overview

The image below illustrates the 3 steps to perform the data transformation: 1) Data Selection, 2) Field Mapping, and 3) Data Loading

!["HR-CDM Transformation Pipeline: Data Selection -> Field Mapping -> Data Loading"](https://github.com/AmericanManufacturingCohort/HR-CDM-Data-Transformation/wiki/_Images/data-transformation-pipeline.png)

**Step 1: Data Selection**

_We selected relevant variables from the data sources and created a base data set._

In this step, we itemized the variables in the two data sources and identified those that are similar to each other. Working from one data source to the other, we checked each variable by its name, description and content and came up with a matching pair. Once paired, we then relabelled the variables with a new same name to make them consistent during the merging. We completed this step by creating a single "base" data set that consists of 29 elected variables.

**Step 2: Field Mapping**

_We mapped the variables from the base data set to the HR-CDM table schemas and normalized the relationships_

In this step, we looked at each HR-CDM table schema and fields and identified the appropriate variable from the base data set to fill out the target field. Once we produced the mappings, an ETL program would read those mappings, extract the value from the base data set and build the HR-CDM tables. The program will split the source data table into many tables and assign unique identifiers to identify the rows. We then maintained the integrity and consistency of the base data set by referencing the table relationships using the identifiers.

**Step 3: Data Loading**

_We created an easy and consistent way to load the HR-CDM tables into different data store platforms._

At the time of this writing, we created data loading functions in R and Python languages that will load CSV files to data frames. Other platforms will come as a future work.

For more detailed description of each step, please refer to the [Wiki page](https://github.com/AmericanManufacturingCohort/HR-CDM-Data-Transformation/wiki).

## License

(TBD) 
