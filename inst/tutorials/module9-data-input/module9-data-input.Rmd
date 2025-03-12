---
title: "Module: Data Input in R"
output: 
  learnr::tutorial:
    progressive: true
    allow_skip: true
runtime: shiny_prerendered
description: "Learn how to input, read, write, and explore data in R"
---

```{r setup, include=FALSE}
library(learnr)
library(gradethis)
gradethis::gradethis_setup()
# Load additional packages
library(readr)
library(readxl)
if (!requireNamespace("writexl", quietly = TRUE)) {
  install.packages("writexl")
}
library(writexl)
if (!requireNamespace("haven", quietly = TRUE)) {
  install.packages("haven")
}
library(haven)
```

## Introduction to Data Input in R

Data is the foundation of any analysis in R. Before you can analyze data, you need to get it into R in a usable format. This module covers various methods for:

- Setting up a working directory
- Entering data directly in R
- Reading data from external files and sources
- Writing data back to files
- Exploring different dataset formats

Understanding these basics will allow you to smoothly transition from having data stored somewhere to actually working with it in R.

## Setting Up a Working Directory

The working directory is the default location where R will look for files you want to read and where it will save files you create. Managing your working directory is a key first step in organizing your R workflow.

### Checking Your Current Working Directory

```{r wd-check, echo=TRUE}
# Check the current working directory
getwd()
```

### Setting Your Working Directory

```{r wd-set-example, echo=TRUE, eval=FALSE}
# Set the working directory
# Note: This will only work if the directory exists on your computer
setwd("/path/to/your/directory")

# On Windows, use forward slashes or double backslashes
setwd("C:/Users/YourName/Documents")  # Forward slashes work
setwd("C:\\Users\\YourName\\Documents")  # Double backslashes also work
```

### Using R Projects

R Projects are a great way to manage your work in R, especially in RStudio. They automatically set the working directory to the project location and help keep your files organized.

To create a new R Project in RStudio:
1. Click File > New Project
2. Choose 'New Directory' or 'Existing Directory'
3. Follow the prompts to name your project and set its location

### Creating Directory Structure

It's good practice to organize your data project with subdirectories:

```{r dir-create, echo=TRUE, eval=FALSE}
# Create directories for your project
dir.create("data")
dir.create("scripts")
dir.create("output")
dir.create("figures")

# Check if a directory exists before creating it
if (!dir.exists("data")) {
  dir.create("data")
}
```

### Exercise 1: Setting Up a Working Directory

Complete the following tasks:

1. Write code to check your current working directory
2. Write code to create a new directory called "analysis" in your current working directory
3. Write code to set your working directory to this new "analysis" directory
4. Create a subdirectory called "data" inside the "analysis" directory

```{r ex1, exercise=TRUE}
# Write your code here

```

```{r ex1-solution}
# 1. Check current working directory
getwd()

# 2. Create new directory
dir.create("analysis")

# 3. Set working directory to new directory
setwd("analysis")  # In a real setting, you might need the full path

# 4. Create subdirectory
dir.create("data")

# Alternatively for steps 3 and 4:
# setwd("analysis")
# dir.create("data")
```

```{r ex1-check}
grade_this({
  # Check the student's submitted code
  user_code <- .user_code
  
  # Check for required functions
  uses_getwd <- grepl("getwd\\(\\)", user_code)
  uses_dir_create <- grepl("dir\\.create\\(", user_code)
  uses_setwd <- grepl("setwd\\(", user_code)
  creates_analysis <- grepl("dir\\.create\\([\"']analysis[\"']\\)", user_code)
  creates_data <- grepl("dir\\.create\\([\"']data[\"']\\)", user_code)
  
  if (!uses_getwd) {
    fail("Make sure to use getwd() to check your current working directory")
  } else if (!uses_dir_create) {
    fail("Make sure to use dir.create() to create directories")
  } else if (!creates_analysis) {
    fail("Make sure to create an 'analysis' directory")
  } else if (!uses_setwd) {
    fail("Make sure to use setwd() to change your working directory")
  } else if (!creates_data) {
    fail("Make sure to create a 'data' subdirectory inside your analysis directory")
  } else {
    pass("Great job! You've set up a proper directory structure for a data analysis project.")
  }
})
```

## Entering Data Directly in R

### Creating Vectors

The simplest way to input data directly is by creating vectors:

```{r vectors-demo, echo=TRUE}
# Create numeric vectors
ages <- c(25, 30, 22, 28, 33)
heights <- c(165, 180, 155, 170, 175)

# Create character vectors
names <- c("Alice", "Bob", "Charlie", "David", "Emma")
genders <- c("F", "M", "M", "M", "F")

# Create logical vectors
is_student <- c(TRUE, FALSE, TRUE, FALSE, TRUE)

# Display vectors
ages
names
is_student
```

### Creating Matrices

Matrices are 2-dimensional structures with elements of the same type:

```{r matrix-demo, echo=TRUE}
# Create a matrix from a vector
mat1 <- matrix(1:12, nrow = 4, ncol = 3)
mat1

# Create a matrix with specific values
mat2 <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 2, ncol = 3, byrow = TRUE)
mat2
```

### Creating Data Frames

Data frames are the most common way to store data in R:

```{r df-demo, echo=TRUE}
# Create a data frame from individual vectors
student_data <- data.frame(
  Name = c("Alice", "Bob", "Charlie", "David", "Emma"),
  Age = c(25, 30, 22, 28, 33),
  Height = c(165, 180, 155, 170, 175),
  Gender = c("F", "M", "M", "M", "F"),
  IsStudent = c(TRUE, FALSE, TRUE, FALSE, TRUE)
)

# View the data frame
student_data

# Structure of the data frame
str(student_data)
```

### Using Data Editor

R provides interactive ways to edit data:

```{r editor-demo, echo=TRUE, eval=FALSE}
# Create a new data frame using the data editor
new_data <- edit(data.frame())

# Edit an existing data frame
edited_data <- edit(student_data)

# Fix a data frame in place
fix(student_data)  # Opens the editor and saves changes directly to student_data
```

### Exercise 2: Entering Data Directly

Create the following data directly in R:

1. Create a numeric vector called `scores` containing test scores: 85, 92, 78, 90, 88
2. Create a character vector called `subjects` containing subject names: "Math", "Science", "English", "History", "Art"
3. Create a data frame called `test_results` that combines:
   - `student_id`: 1 through 5
   - `scores`: from your vector above
   - `subjects`: from your vector above
   - `passed`: logical vector indicating if score is >= 80
4. Add a new column to `test_results` called `grade` that assigns:
   - "A" for scores 90 and above
   - "B" for scores 80-89
   - "C" for scores 70-79
   - "D" for scores below 70

```{r ex2, exercise=TRUE}
# Write your code here

```

```{r ex2-solution}
# 1. Create numeric vector of scores
scores <- c(85, 92, 78, 90, 88)

# 2. Create character vector of subjects
subjects <- c("Math", "Science", "English", "History", "Art")

# 3. Create data frame combining student_id, scores, subjects, and passed
test_results <- data.frame(
  student_id = 1:5,
  scores = scores,
  subjects = subjects,
  passed = scores >= 80
)

# 4. Add grade column
test_results$grade <- ifelse(test_results$scores >= 90, "A",
                     ifelse(test_results$scores >= 80, "B",
                     ifelse(test_results$scores >= 70, "C", "D")))

# View the result
test_results
```

```{r ex2-check}
grade_this({
  # Check the student's submitted code
  user_code <- .user_code
  
  # Check for required variable assignments and functions
  has_scores <- grepl("scores\\s*<-", user_code)
  has_subjects <- grepl("subjects\\s*<-", user_code)
  has_test_results <- grepl("test_results\\s*<-", user_code)
  uses_data_frame <- grepl("data\\.frame\\(", user_code)
  adds_grade <- grepl("grade\\s*<-|\\$grade\\s*=", user_code)
  
  # Check if all variables are created correctly
  if (!has_scores) {
    fail("Make sure to create a vector called 'scores' with the test scores")
  } else if (!has_subjects) {
    fail("Make sure to create a vector called 'subjects' with the subject names")
  } else if (!has_test_results || !uses_data_frame) {
    fail("Make sure to create a data frame called 'test_results' using data.frame()")
  } else if (!adds_grade) {
    fail("Make sure to add a 'grade' column to the test_results data frame")
  } else {
    pass("Great job! You've correctly created the vectors and data frame with all required columns.")
  }
})
```

## Reading Data into R

### Reading CSV Files

CSV (Comma-Separated Values) files are the most common format for data exchange:

```{r csv-demo, echo=TRUE, eval=FALSE}
# Read CSV file with base R
data1 <- read.csv("data/sample.csv")

# Read CSV with readr (tidyverse) - often faster and more flexible
library(readr)
data2 <- read_csv("data/sample.csv")

# Common options for reading CSVs
data3 <- read.csv("data/sample.csv", 
                 header = TRUE,        # First row contains column names
                 sep = ",",            # Separator is a comma
                 stringsAsFactors = FALSE,  # Don't convert strings to factors
                 na.strings = c("", "NA", "N/A"))  # These values will be read as NA
```

### Reading Excel Files

Excel files are another common data source:

```{r excel-demo, echo=TRUE, eval=FALSE}
# Read Excel file using readxl package
library(readxl)
excel_data <- read_excel("data/sample.xlsx")

# Specify sheet and range
excel_data2 <- read_excel("data/sample.xlsx", 
                         sheet = "Sheet1",
                         range = "A1:D20",
                         col_names = TRUE)

# List all sheets in an Excel file
excel_sheets("data/sample.xlsx")
```

### Reading Data from Other Statistical Software

You can import data from other statistical software formats:

```{r foreign-demo, echo=TRUE, eval=FALSE}
# Read SPSS data
library(haven)
spss_data <- read_sav("data/example.sav")

# Read Stata data
stata_data <- read_dta("data/example.dta")

# Read SAS data
sas_data <- read_sas("data/example.sas7bdat")
```

### Reading from Databases

You can connect to databases using various packages:

```{r db-demo, echo=TRUE, eval=FALSE}
# Reading from databases using DBI
library(DBI)
library(RSQLite)

# Connect to a SQLite database
con <- dbConnect(SQLite(), "data/mydatabase.sqlite")

# List tables in the database
dbListTables(con)

# Read data from a table
db_data <- dbReadTable(con, "my_table")

# Run a custom SQL query
query_data <- dbGetQuery(con, "SELECT * FROM my_table WHERE column1 > 100")

# Don't forget to close the connection when done
dbDisconnect(con)
```

### Reading Data from the Web

You can also read data directly from the internet:

```{r web-demo, echo=TRUE, eval=FALSE}
# Read CSV from a URL
url_data <- read.csv("https://example.com/data.csv")

# Read data from a web API (requires jsonlite)
library(jsonlite)
json_data <- fromJSON("https://api.example.com/data")

# Download a file first, then read it
temp_file <- tempfile()
download.file("https://example.com/data.csv", temp_file)
downloaded_data <- read.csv(temp_file)
```

### Exercise 3: Reading Data

For this exercise, we'll use the built-in datasets package that comes with R, which allows us to simulate reading data from files.

Complete the following tasks:

1. Load the built-in mtcars dataset and save it to a CSV file called "cars.csv" in a "data" directory
2. Read the CSV file back into a new variable called `car_data`
3. Create a function called `read_dataset` that takes a dataset name as input and:
   - Checks if a "data" directory exists, creates it if it doesn't
   - Saves the requested dataset (using `get()`) to a CSV in the data directory
   - Reads the CSV back and returns the data
4. Use your function to read the "iris" dataset

```{r ex3, exercise=TRUE}
# Write your code here

```

```{r ex3-solution}
# 1. Load mtcars and save to CSV
data(mtcars)
if (!dir.exists("data")) {
  dir.create("data")
}
write.csv(mtcars, "data/cars.csv", row.names = TRUE)

# 2. Read the CSV back
car_data <- read.csv("data/cars.csv", row.names = 1)

# 3. Create the function
read_dataset <- function(dataset_name) {
  # Check if data directory exists
  if (!dir.exists("data")) {
    dir.create("data")
  }
  
  # Get the dataset
  dataset <- get(dataset_name)
  
  # Create a file path
  file_path <- paste0("data/", dataset_name, ".csv")
  
  # Save to CSV
  write.csv(dataset, file_path, row.names = TRUE)
  
  # Read back and return
  result <- read.csv(file_path, row.names = 1)
  return(result)
}

# 4. Use the function with iris
iris_data <- read_dataset("iris")

# View the results
head(car_data)
head(iris_data)
```

```{r ex3-check}
grade_this({
  # Check the student's submitted code
  user_code <- .user_code
  
  # Check for required actions
  uses_write_csv <- grepl("write\\.csv\\(", user_code)
  uses_read_csv <- grepl("read\\.csv\\(", user_code)
  has_car_data <- grepl("car_data\\s*<-", user_code)
  defines_function <- grepl("read_dataset\\s*<-\\s*function", user_code)
  uses_dir_exists <- grepl("dir\\.exists\\(", user_code)
  uses_function <- grepl("read_dataset\\([\"']iris[\"']\\)", user_code)
  
  # Check if all required actions are performed
  if (!uses_write_csv) {
    fail("Make sure to use write.csv() to save the mtcars dataset")
  } else if (!uses_read_csv) {
    fail("Make sure to use read.csv() to read the CSV back into R")
  } else if (!has_car_data) {
    fail("Make sure to create a variable called car_data with the CSV contents")
  } else if (!defines_function) {
    fail("Make sure to define a function called read_dataset")
  } else if (!uses_dir_exists) {
    fail("Your function should check if the data directory exists")
  } else if (!uses_function) {
    fail("Make sure to use your function to read the iris dataset")
  } else {
    pass("Great job! You've created a function that handles reading and writing datasets.")
  }
})
```

## Writing Data to Files

### Writing CSV Files

```{r write-csv-demo, echo=TRUE, eval=FALSE}
# Create sample data
sample_data <- data.frame(
  ID = 1:5,
  Name = c("Alice", "Bob", "Charlie", "David", "Emma"),
  Score = c(85, 92, 78, 90, 88)
)

# Write to CSV using base R
write.csv(sample_data, "data/output.csv", row.names = FALSE)

# Write to CSV using readr (tidyverse)
library(readr)
write_csv(sample_data, "data/output2.csv")

# Write with specific options
write.csv2(sample_data, "data/output_euro.csv")  # Uses semicolon as separator
```

### Writing Excel Files

```{r write-excel-demo, echo=TRUE, eval=FALSE}
# Create sample data
sheet1_data <- data.frame(
  ID = 1:5,
  Name = c("Alice", "Bob", "Charlie", "David", "Emma"),
  Score = c(85, 92, 78, 90, 88)
)

sheet2_data <- data.frame(
  Product = c("Apples", "Bananas", "Oranges"),
  Price = c(1.20, 0.80, 1.50),
  Quantity = c(100, 150, 80)
)

# Write to Excel using writexl
library(writexl)
write_xlsx(list(Students = sheet1_data, Products = sheet2_data), 
          "data/output.xlsx")
```

### Saving R Objects

You can save R objects directly to be reloaded later:

```{r save-r-demo, echo=TRUE, eval=FALSE}
# Save a single R object
saveRDS(sample_data, "data/sample_data.rds")

# Save multiple R objects
save(sample_data, sheet1_data, sheet2_data, file = "data/multiple_objects.RData")

# Load them back
loaded_data <- readRDS("data/sample_data.rds")
load("data/multiple_objects.RData")  # Loads objects directly into environment
```

### Exercise 4: Writing Data

Complete the following tasks:

1. Create a data frame called `employees` with the following data:
   - `id`: 1, 2, 3, 4, 5
   - `name`: "John", "Sarah", "Michael", "Jessica", "Robert"
   - `department`: "Sales", "Marketing", "IT", "HR", "Finance"
   - `salary`: 50000, 60000, 70000, 55000, 65000
   - `start_date`: "2020-01-15", "2019-05-20", "2021-02-10", "2018-11-01", "2020-08-30"

2. Write this data frame to:
   - A CSV file called "employees.csv" without row names
   - An RDS file called "employees.rds"

3. Create a second data frame called `departments` with:
   - `dept_name`: "Sales", "Marketing", "IT", "HR", "Finance"
   - `location`: "New York", "Chicago", "San Francisco", "Boston", "Seattle"
   - `manager`: "Smith", "Johnson", "Williams", "Brown", "Jones"

4. Save both data frames in a single R data file called "company_data.RData"

```{r ex4, exercise=TRUE}
# Write your code here

```

```{r ex4-solution}
# 1. Create employees data frame
employees <- data.frame(
  id = 1:5,
  name = c("John", "Sarah", "Michael", "Jessica", "Robert"),
  department = c("Sales", "Marketing", "IT", "HR", "Finance"),
  salary = c(50000, 60000, 70000, 55000, 65000),
  start_date = c("2020-01-15", "2019-05-20", "2021-02-10", "2018-11-01", "2020-08-30")
)

# 2. Write to CSV and RDS
write.csv(employees, "employees.csv", row.names = FALSE)
saveRDS(employees, "employees.rds")

# 3. Create departments data frame
departments <- data.frame(
  dept_name = c("Sales", "Marketing", "IT", "HR", "Finance"),
  location = c("New York", "Chicago", "San Francisco", "Boston", "Seattle"),
  manager = c("Smith", "Johnson", "Williams", "Brown", "Jones")
)

# 4. Save both data frames to a single RData file
save(employees, departments, file = "company_data.RData")

# Display the data frames
employees
departments
```

```{r ex4-check}
grade_this({
  # Check the student's submitted code
  user_code <- .user_code
  
  # Check for required variables and actions
  has_employees <- grepl("employees\\s*<-", user_code)
  has_departments <- grepl("departments\\s*<-", user_code)
  uses_write_csv <- grepl("write\\.csv\\(", user_code)
  uses_save_rds <- grepl("saveRDS\\(", user_code)
  uses_save <- grepl("save\\(", user_code)
  
  # Check for required data elements
  has_employee_data <- grepl("id\\s*=|name\\s*=|department\\s*=|salary\\s*=|start_date\\s*=", user_code)
  has_department_data <- grepl("dept_name\\s*=|location\\s*=|manager\\s*=", user_code)
  
  # Check if all required actions are performed
  if (!has_employees || !has_employee_data) {
    fail("Make sure to create the employees data frame with all required columns")
  } else if (!has_departments || !has_department_data) {
    fail("Make sure to create the departments data frame with all required columns")
  } else if (!uses_write_csv) {
    fail("Make sure to use write.csv() to save the employees data frame to a CSV file")
  } else if (!uses_save_rds) {
    fail("Make sure to use saveRDS() to save the employees data frame to an RDS file")
  } else if (!uses_save) {
    fail("Make sure to use save() to save both data frames to a single RData file")
  } else {
    pass("Great job! You've correctly created and saved the data in multiple formats.")
  }
})
```

## Exploring Different Dataset Formats

### Checking Data Structure

```{r structure-demo, echo=TRUE}
# Load built-in dataset
data(mtcars)

# Check structure
str(mtcars)

# Summary statistics
summary(mtcars)

# Dimensions
dim(mtcars)
nrow(mtcars)
ncol(mtcars)

# Column names
names(mtcars)
```

### Viewing Data

```{r view-demo, echo=TRUE}
# First few rows
head(mtcars)

# Last few rows
tail(mtcars)

# View specific columns
mtcars[, c("mpg", "cyl", "hp")]

# View in RStudio (not run here)
# View(mtcars)
```

### Wide vs. Long Format

Data can be organized in wide or long format. Understanding and converting between these formats is crucial for different analysis types:

```{r reshape-demo, echo=TRUE}
# Create sample data in wide format
wide_data <- data.frame(
  student = c("Alice", "Bob", "Charlie"),
  math = c(90, 85, 92),
  science = c(88, 90, 85),
  english = c(85, 80, 88)
)

# Display wide data
wide_data

# Convert to long format using reshape2
if (!requireNamespace("reshape2", quietly = TRUE)) {
  install.packages("reshape2")
}
library(reshape2)
long_data <- melt(wide_data, id.vars = "student", 
                 variable.name = "subject", value.name = "score")

# Display long data
long_data

# Convert back to wide format
wide_again <- dcast(long_data, student ~ subject, value.var = "score")
wide_again
```

### Transforming Data with tidyr

```{r tidyr-demo, echo=TRUE, eval=FALSE}
# Using tidyr for reshaping (part of tidyverse)
library(tidyr)

# Wide to long
long_data_tidyr <- wide_data %>%
  pivot_longer(cols = c("math", "science", "english"),
               names_to = "subject",
               values_to = "score")

# Long to wide
wide_data_tidyr <- long_data_tidyr %>%
  pivot_wider(names_from = subject,
              values_from = score)
```

### Exercise 5: Exploring Dataset Formats

Complete the following tasks:

1. Load the built-in `airquality` dataset
2. Perform exploratory analysis:
   - Check the structure of the dataset
   - Get summary statistics
   - Display the first 5 rows
   - List the column names
3. Convert the dataset from wide to long format using `reshape2::melt()` where:
   - Month and Day remain as identifier variables
   - The other variables become a new "Measurement" variable
   - Values go into a "Value" variable
4. Calculate the average of each measurement type by month in the long format

```{r ex5, exercise=TRUE}
# Write your code here

```

```{r ex5-solution}
# Load the dataset
data(airquality)

# 2. Exploratory analysis
# Check structure
str(airquality)

# Summary statistics
summary(airquality)

# First 5 rows
head(airquality, 5)

# Column names
names(airquality)

# 3. Convert to long format
library(reshape2)
long_airquality <- melt(airquality, 
                        id.vars = c("Month", "Day"),
                        variable.name = "Measurement",
                        value.name = "Value")

# View the long format
head(long_airquality)

# 4. Calculate average by month for each measurement
monthly_avg <- aggregate(Value ~ Month + Measurement, 
                        data = long_airquality, 
                        FUN = mean, 
                        na.rm = TRUE)

# Display the result
monthly_avg
```

```{r ex5-check}
grade_this({
  # Check the student's submitted code
  user_code <- .user_code
  
  # Check for required functions and variables
  uses_data <- grepl("data\\(airquality\\)", user_code)
  uses_str <- grepl("str\\(", user_code)
  uses_summary <- grepl("summary\\(", user_code)
  uses_head <- grepl("head\\(", user_code)
  uses_names <- grepl("names\\(", user_code)
  uses_melt <- grepl("melt\\(", user_code)
  uses_aggregate <- grepl("aggregate\\(", user_code)
  
  # Check for key elements
  has_long_format <- grepl("id\\.vars\\s*=", user_code)
  has_monthly_calc <- grepl("Value\\s*~\\s*Month", user_code)
  
  # Check if all required actions are performed
  if (!uses_data) {
    fail("Make sure to load the airquality dataset using data()")
  } else if (!uses_str || !uses_summary || !uses_head || !uses_names) {
    fail("Make sure to use str(), summary(), head(), and names() to explore the dataset")
  } else if (!uses_melt || !has_long_format) {
    fail("Make sure to use melt() to convert the data to long format with Month and Day as id variables")
  } else if (!uses_aggregate || !has_monthly_calc) {
    fail("Make sure to calculate the monthly average for each measurement type")
  } else {
    pass("Great job! You've successfully explored the airquality dataset and transformed it between formats.")
  }
})
```

## Summary

In this module, you've learned essential data input skills for R, including:

1. **Setting up a working directory**: Organizing your file structure for efficient data analysis

2. **Entering data directly in R**: Creating vectors, matrices, and data frames manually

3. **Reading data from external sources**: Importing from CSV, Excel, databases, the web, and other statistical software formats

4. **Writing data to files**: Saving your data in various formats for later use or sharing

5. **Exploring dataset formats**: Understanding data structure and converting between wide and long formats

These skills provide the foundation for all data analysis work in R. By mastering them, you'll be able to efficiently get data into and out of R, allowing you to focus on the actual analysis.

## Additional Resources

- [R Data Import/Export Manual](https://cran.r-project.org/doc/manuals/r-release/R-data.html)
- [readr Package Documentation](https://readr.tidyverse.org/)
- [readxl Package Documentation](https://readxl.tidyverse.org/)
- [Data Manipulation with dplyr](https://dplyr.tidyverse.org/)
- [Data Reshaping with tidyr](https://tidyr.tidyverse.org/)
