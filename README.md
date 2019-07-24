# HR-CDM Data Transformation Pipeline

This repository houses the source code and documentation of the HR-CDM Data Transformation Pipeline used to transform the AMC Human Resources (AMC-HR) data set to HR-CDM data set (See the [HR-CDM Specification](https://github.com/AmericanManufacturingCohort/HR-CDM-Specification/wiki) to learn the data model).

## Overview

The image below illustrates the 3 steps to perform the data transformation: 1) Data Selection, 2) Data Mapping, and 3) Data Loading

!["HR-CDM Transformation Pipeline: Data Selection -> Data Mapping -> Data Loading"](https://github.com/AmericanManufacturingCohort/HR-CDM-Data-Transformation/wiki/_Images/data-transformation-pipeline.png)

**Step 1: Data Selection**

_We merged two data sources in the AMC-HR data collection into a single "combined" data set._

In this step, we itemized the variables in the two data sources so that equivalent variables could be identified. Working from one data source to the other source, each identified variable was checked to ensure it captures the same information as the other. Once aligned, the variables were relabelled with a new variable name that was consistent across both sources. We completed this step by merging the data from selected variables where we ended up with a data set containing 29 variables.

**Step 2: Data Mapping**

_We mapped the variables from the "combined" data set to the HR-CDM table schemas as a preparation for the data transformation._

In this step, we looked at each HR-CDM table schema and identified the appropriate variable from the combined data set to fill out the schema. Once each table schema was mapped, a special program would read those mappings, extract the value and build the table. In this process, data were separated into many tables and unique identifiers were assigned to signify each table's record. We then maintained the integrity and consistency of the original data set by creating relationships between those tables through each record's unique identifiers. The result is a newly transformed HR-CDM data set.

**Step 3: Data Loading**

_We created an easy and consistent way to load the transformed data set into different data storages or data analytics._

At the time of this writing, we created data loading functions in R and Python languages that will load CSV files to data frames. Other platforms will come as a future work.

For more detailed description of each step, please refer to the [Wiki page](https://github.com/AmericanManufacturingCohort/HR-CDM-Data-Transformation/wiki).

## License

(TBD) 
