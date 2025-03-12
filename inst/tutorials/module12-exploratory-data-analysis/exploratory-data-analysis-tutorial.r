---
title: "Module: Exploratory Data Analysis in R"
output: 
  learnr::tutorial:
    progressive: true
    allow_skip: true
runtime: shiny_prerendered
description: "Learn how to conduct exploratory data analysis in R"
---

```{r setup, include=FALSE}
library(learnr)
library(gradethis)
gradethis::gradethis_setup()
# Load additional packages
library(ggplot2)
library(dplyr)
library(tidyr)
library(corrplot)
library(reshape2)
library(skimr)
library(GGally)
```

## Introduction to Exploratory Data Analysis (EDA)

Exploratory Data Analysis (EDA) is an approach to analyzing datasets to summarize their main characteristics, often using visual methods. It's a critical step in any data analysis project, typically performed before formal modeling or hypothesis testing.

### The Purpose of EDA

The main goals of EDA include:

1. **Understanding the data structure**: Variables, data types, and dimensions
2. **Identifying patterns**: Trends, relationships, and groupings
3. **Detecting anomalies**: Outliers, errors, and missing values
4. **Testing assumptions**: Checking for normality, homoscedasticity, etc.
5. **Formulating hypotheses**: Generating questions for further investigation
6. **Informing modeling strategies**: Selecting appropriate analysis methods

EDA is an iterative and interactive process. As you explore your data, new questions arise, leading to further exploration. It's as much an art as it is a science.

### The EDA Process

A typical EDA workflow includes:

1. **Data preparation**: Cleaning, transforming, and organizing data
2. **Univariate analysis**: Exploring individual variables
3. **Bivariate analysis**: Exploring relationships between pairs of variables
4. **Multivariate analysis**: Exploring relationships among multiple variables
5. **Summarizing findings**: Drawing conclusions and planning next steps

Let's start by loading and exploring a dataset:

```{r create-data, echo=TRUE}
# Load a built-in dataset
data(diamonds, package = "ggplot2")

# Take a sample for easier handling
set.seed(123)
diamonds_sample <- diamonds[sample(nrow(diamonds), 5000), ]

# First look at the data
str(diamonds_sample)
head(diamonds_sample)
```

## Data Preparation and Initial Exploration

Before diving into detailed analysis, it's important to prepare and get a broad overview of your data.

### Understanding Data Structure

Start by examining the basic structure of your dataset:

```{r data-structure, echo=TRUE}
# Check dimensions
dim(diamonds_sample)

# Column names
names(diamonds_sample)

# Data types
sapply(diamonds_sample, class)

# Summary statistics
summary(diamonds_sample)
```

### Checking for Missing Values

Missing values can significantly impact your analysis. It's important to identify and address them early:

```{r missing-values, echo=TRUE}
# Count missing values by column
sapply(diamonds_sample, function(x) sum(is.na(x)))

# Visualize missing values (if there were any)
# This is just an example - diamonds dataset has no missing values
if (any(is.na(diamonds_sample))) {
  missing_matrix <- is.na(diamonds_sample)
  missing_count <- colSums(missing_matrix)
  barplot(missing_count, 
          main = "Missing Values by Column",
          ylab = "Count",
          las = 2)
}
```

### Enhanced Data Summaries

The `skimr` package provides more comprehensive summaries:

```{r skimr-demo, echo=TRUE}
# Get enhanced summary with skimr
library(skimr)
skim(diamonds_sample)
```

### Exercise 1: Initial Data Exploration

For this exercise, we'll use the `mpg` dataset from ggplot2. Complete the following tasks:

1. Load the `mpg` dataset and examine its structure
2. Calculate the dimensions and get a summary of the dataset
3. Check for missing values and report which columns (if any) have them
4. Create a custom function called `data_report` that takes a data frame and returns a list containing:
   - Number of rows and columns
   - Column names and their data types
   - Summary statistics for numeric columns only
   - Count of missing values by column
5. Apply your function to the `mpg` dataset and print the results

```{r ex1, exercise=TRUE}
# Write your code here

```

```{r ex1-solution}
# 1. Load the mpg dataset
data(mpg, package = "ggplot2")

# 2. Examine structure and dimensions
str(mpg)
dim(mpg)
summary(mpg)

# 3. Check for missing values
na_count <- sapply(mpg, function(x) sum(is.na(x)))
na_count

# 4. Create the data_report function
data_report <- function(df) {
  # Check input
  if (!is.data.frame(df)) {
    stop("Input must be a data frame")
  }
  
  # Initialize result list
  result <- list()
  
  # Dimensions
  result$dimensions <- c(rows = nrow(df), columns = ncol(df))
  
  # Column names and types
  result$columns <- sapply(df, class)
  
  # Summary stats for numeric columns
  numeric_cols <- sapply(df, is.numeric)
  if (any(numeric_cols)) {
    result$numeric_summary <- summary(df[, numeric_cols, drop = FALSE])
  } else {
    result$numeric_summary <- "No numeric columns found"
  }
  
  # Missing values count
  result$missing_values <- sapply(df, function(x) sum(is.na(x)))
  
  return(result)
}

# 5. Apply the function to mpg
report <- data_report(mpg)
print(report)
```

```{r ex1-check}
grade_this({
  # Check the student's submitted code
  user_code <- .user_code
  
  # Check for required elements
  uses_mpg <- grepl("data\\(mpg|mpg\\s*<-", user_code)
  checks_structure <- grepl("str\\(mpg\\)", user_code)
  checks_dimensions <- grepl("dim\\(mpg\\)|nrow\\(mpg\\)|ncol\\(mpg\\)", user_code)
  checks_summary <- grepl("summary\\(mpg\\)", user_code)
  checks_na <- grepl("is\\.na\\(", user_code)
  defines_function <- grepl("data_report\\s*<-\\s*function", user_code)
  applies_function <- grepl("data_report\\(mpg\\)", user_code)
  has_numeric_check <- grepl("is\\.numeric", user_code)
  
  # Check if all required elements are present
  if (!uses_mpg) {
    fail("Make sure to load the mpg dataset")
  } else if (!checks_structure) {
    fail("Make sure to examine the structure of the dataset using str()")
  } else if (!checks_dimensions) {
    fail("Make sure to calculate the dimensions of the dataset")
  } else if (!checks_summary) {
    fail("Make sure to get a summary of the dataset")
  } else if (!checks_na) {
    fail("Make sure to check for missing values in the dataset")
  } else if (!defines_function) {
    fail("Make sure to create a custom function called 'data_report'")
  } else if (!has_numeric_check) {
    fail("Make sure your function handles numeric columns specially")
  } else if (!applies_function) {
    fail("Make sure to apply your function to the mpg dataset")
  } else {
    pass("Great job! You've successfully performed an initial exploration of the data.")
  }
})
```

## Univariate Analysis

Univariate analysis focuses on exploring individual variables one at a time. The appropriate techniques depend on the variable type (categorical or numerical).

### Categorical Variables

For categorical variables, frequency tables and bar charts are the primary tools:

```{r categorical-uni, echo=TRUE, fig.width=9, fig.height=5}
# Count frequency of each cut type
table(diamonds_sample$cut)

# Proportion table
prop.table(table(diamonds_sample$cut)) * 100

# Bar chart of cut distribution
ggplot(diamonds_sample, aes(x = cut)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Distribution of Diamond Cuts",
       x = "Cut Quality",
       y = "Count") +
  theme_minimal()

# Bar chart with percentages
cut_counts <- diamonds_sample %>%
  count(cut) %>%
  mutate(percentage = n / sum(n) * 100)

ggplot(cut_counts, aes(x = cut, y = percentage)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = sprintf("%.1f%%", percentage)),
            vjust = -0.5) +
  labs(title = "Percentage Distribution of Diamond Cuts",
       x = "Cut Quality",
       y = "Percentage") +
  theme_minimal()
```

### Numerical Variables

For numerical variables, summary statistics and distribution plots are key tools:

```{r numerical-uni, echo=TRUE, fig.width=10, fig.height=5}
# Summary statistics for price
summary(diamonds_sample$price)

# Measures of central tendency
mean(diamonds_sample$price)
median(diamonds_sample$price)

# Measures of dispersion
sd(diamonds_sample$price)
IQR(diamonds_sample$price)
range(diamonds_sample$price)

# Histogram
ggplot(diamonds_sample, aes(x = price)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "black") +
  labs(title = "Distribution of Diamond Prices",
       x = "Price (USD)",
       y = "Frequency") +
  theme_minimal()

# Density plot
ggplot(diamonds_sample, aes(x = price)) +
  geom_density(fill = "steelblue", alpha = 0.7) +
  labs(title = "Density Plot of Diamond Prices",
       x = "Price (USD)",
       y = "Density") +
  theme_minimal()

# Boxplot
ggplot(diamonds_sample, aes(y = price)) +
  geom_boxplot(fill = "steelblue") +
  labs(title = "Boxplot of Diamond Prices",
       y = "Price (USD)") +
  theme_minimal()

# QQ plot to check normality
qqnorm(diamonds_sample$price)
qqline(diamonds_sample$price, col = "red")
```

### Data Transformations

When working with skewed data, transformations can be helpful:

```{r transformations, echo=TRUE, fig.width=10, fig.height=8}
# Set up a multi-panel plot
par(mfrow = c(2, 2))

# Original distribution
hist(diamonds_sample$price, main = "Original Price", xlab = "Price (USD)")

# Log transformation
hist(log(diamonds_sample$price), main = "Log Transformed", xlab = "Log(Price)")

# Square root transformation
hist(sqrt(diamonds_sample$price), main = "Square Root Transformed", xlab = "Sqrt(Price)")

# Inverse transformation
hist(1/diamonds_sample$price, main = "Inverse Transformed", xlab = "1/Price")

# Reset layout
par(mfrow = c(1, 1))

# Using ggplot2 for side-by-side comparison
diamonds_sample %>%
  mutate(
    log_price = log(price),
    sqrt_price = sqrt(price)
  ) %>%
  select(price, log_price, sqrt_price) %>%
  pivot_longer(cols = everything(), names_to = "transformation", values_to = "value") %>%
  ggplot(aes(x = value)) +
    geom_density(fill = "steelblue", alpha = 0.7) +
    facet_wrap(~ transformation, scales = "free") +
    labs(title = "Comparison of Transformations",
         x = "Value",
         y = "Density") +
    theme_minimal()
```

### Exercise 2: Univariate Analysis

Using the `mpg` dataset from ggplot2, complete the following tasks:

1. Perform a univariate analysis of the `class` variable (vehicle type):
   - Create a frequency table showing counts and percentages
   - Create a bar chart showing the distribution
   - Identify the most and least common vehicle classes

2. Perform a univariate analysis of the `hwy` variable (highway miles per gallon):
   - Calculate summary statistics (mean, median, sd, min, max, IQR)
   - Create a histogram and a density plot
   - Create a boxplot
   - Determine if the distribution is skewed and in which direction
   - Apply an appropriate transformation if needed

3. Create a function called `analyze_variable` that:
   - Takes a data frame and a column name as input
   - Automatically determines if the variable is categorical or numerical
   - Performs an appropriate univariate analysis based on the type
   - Returns a list with summary statistics and creates appropriate plots

```{r ex2, exercise=TRUE}
# Write your code here

```

```{r ex2-solution}
# Load required packages
library(ggplot2)
library(dplyr)

# Load the mpg dataset
data(mpg, package = "ggplot2")

# 1. Univariate analysis of class (categorical)
# Frequency table
class_freq <- table(mpg$class)
print(class_freq)

# Percentage table
class_pct <- prop.table(class_freq) * 100
print(class_pct)

# Combined table
class_summary <- data.frame(
  Count = as.numeric(class_freq),
  Percentage = as.numeric(class_pct)
)
rownames(class_summary) <- names(class_freq)
print(class_summary)

# Bar chart
ggplot(mpg, aes(x = class)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Distribution of Vehicle Classes",
       x = "Vehicle Class",
       y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Identify most and least common
most_common <- names(class_freq)[which.max(class_freq)]
least_common <- names(class_freq)[which.min(class_freq)]

cat("Most common vehicle class:", most_common, "\n")
cat("Least common vehicle class:", least_common, "\n")

# 2. Univariate analysis of hwy (numerical)
# Summary statistics
hwy_summary <- summary(mpg$hwy)
print(hwy_summary)

cat("Mean:", mean(mpg$hwy), "\n")
cat("Median:", median(mpg$hwy), "\n")
cat("Standard Deviation:", sd(mpg$hwy), "\n")
cat("Minimum:", min(mpg$hwy), "\n")
cat("Maximum:", max(mpg$hwy), "\n")
cat("IQR:", IQR(mpg$hwy), "\n")

# Histogram
ggplot(mpg, aes(x = hwy)) +
  geom_histogram(bins = 15, fill = "steelblue", color = "black") +
  labs(title = "Distribution of Highway MPG",
       x = "Highway MPG",
       y = "Frequency") +
  theme_minimal()

# Density plot
ggplot(mpg, aes(x = hwy)) +
  geom_density(fill = "steelblue", alpha = 0.7) +
  labs(title = "Density Plot of Highway MPG",
       x = "Highway MPG",
       y = "Density") +
  theme_minimal()

# Boxplot
ggplot(mpg, aes(y = hwy)) +
  geom_boxplot(fill = "steelblue") +
  labs(title = "Boxplot of Highway MPG",
       y = "Highway MPG") +
  theme_minimal()

# Check skewness
# Calculate skewness
skew <- function(x) {
  n <- length(x)
  m <- mean(x)
  s <- sd(x)
  sum((x - m)^3) / (n * s^3)
}

hwy_skewness <- skew(mpg$hwy)
cat("Skewness:", hwy_skewness, "\n")

if (hwy_skewness > 0.5) {
  cat("The distribution is positively skewed (right-skewed)\n")
} else if (hwy_skewness < -0.5) {
  cat("The distribution is negatively skewed (left-skewed)\n")
} else {
  cat("The distribution is approximately symmetric\n")
}

# Apply transformation if needed
# Log transformation (if right-skewed)
if (hwy_skewness > 0.5) {
  ggplot(mpg, aes(x = log(hwy))) +
    geom_histogram(bins = 15, fill = "steelblue", color = "black") +
    labs(title = "Log-Transformed Highway MPG",
         x = "Log(Highway MPG)",
         y = "Frequency") +
    theme_minimal()
}

# 3. Create a function for univariate analysis
analyze_variable <- function(df, var_name) {
  # Check if variable exists
  if (!var_name %in% names(df)) {
    stop(paste("Variable", var_name, "not found in the data frame"))
  }
  
  # Extract the variable
  var <- df[[var_name]]
  
  # Initialize result list
  result <- list()
  result$variable <- var_name
  
  # Determine if categorical or numerical
  if (is.factor(var) || is.character(var) || length(unique(var)) <= 10) {
    # Categorical analysis
    result$type <- "categorical"
    
    # Frequency table
    freq_table <- table(var)
    pct_table <- prop.table(freq_table) * 100
    
    result$frequencies <- freq_table
    result$percentages <- pct_table
    
    # Most and least common
    result$most_common <- names(freq_table)[which.max(freq_table)]
    result$least_common <- names(freq_table)[which.min(freq_table)]
    
    # Bar chart
    print(
      ggplot(data.frame(var = var), aes(x = var)) +
        geom_bar(fill = "steelblue") +
        labs(title = paste("Distribution of", var_name),
             x = var_name,
             y = "Count") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    )
  } else {
    # Numerical analysis
    result$type <- "numerical"
    
    # Summary statistics
    result$summary <- summary(var)
    result$mean <- mean(var)
    result$median <- median(var)
    result$sd <- sd(var)
    result$min <- min(var)
    result$max <- max(var)
    result$IQR <- IQR(var)
    
    # Skewness
    result$skewness <- skew(var)
    
    # Histogram
    print(
      ggplot(data.frame(var = var), aes(x = var)) +
        geom_histogram(bins = 15, fill = "steelblue", color = "black") +
        labs(title = paste("Distribution of", var_name),
             x = var_name,
             y = "Frequency") +
        theme_minimal()
    )
    
    # Density plot
    print(
      ggplot(data.frame(var = var), aes(x = var)) +
        geom_density(fill = "steelblue", alpha = 0.7) +
        labs(title = paste("Density Plot of", var_name),
             x = var_name,
             y = "Density") +
        theme_minimal()
    )
    
    # Boxplot
    print(
      ggplot(data.frame(var = var), aes(y = var)) +
        geom_boxplot(fill = "steelblue") +
        labs(title = paste("Boxplot of", var_name),
             y = var_name) +
        theme_minimal()
    )
    
    # Transformation if skewed
    if (abs(result$skewness) > 0.5) {
      if (result$skewness > 0.5 && min(var) >= 0) {
        # Right-skewed, apply log transformation
        var_transformed <- log(var + 1)  # +1 to handle zeros
        result$transformation <- "log"
      } else if (result$skewness < -0.5) {
        # Left-skewed, apply square transformation
        var_transformed <- var^2
        result$transformation <- "square"
      }
      
      if (exists("var_transformed")) {
        result$transformed_summary <- summary(var_transformed)
        result$transformed_skewness <- skew(var_transformed)
        
        print(
          ggplot(data.frame(var = var_transformed), aes(x = var)) +
            geom_histogram(bins = 15, fill = "steelblue", color = "black") +
            labs(title = paste("Transformed Distribution of", var_name),
                 x = paste(result$transformation, "(", var_name, ")"),
                 y = "Frequency") +
            theme_minimal()
        )
      }
    }
  }
  
  return(result)
}

# Apply the function
class_analysis <- analyze_variable(mpg, "class")
hwy_analysis <- analyze_variable(mpg, "hwy")

# Print results
print(class_analysis)
print(hwy_analysis)
```

```{r ex2-check}
grade_this({
  # Check the student's submitted code
  user_code <- .user_code
  
  # Check for required elements
  has_class_freq <- grepl("table\\(mpg\\$class\\)|count\\(mpg,\\s*class", user_code)
  has_class_pct <- grepl("prop\\.table|percent", user_code)
  has_class_plot <- grepl("geom_bar\\(.+class", user_code)
  has_class_extreme <- grepl("most_common|least_common|which\\.max|which\\.min", user_code)
  
  has_hwy_summary <- grepl("summary\\(mpg\\$hwy\\)|mean\\(mpg\\$hwy\\)", user_code)
  has_hwy_plots <- grepl("geom_histogram\\(.+hwy|geom_density\\(.+hwy|geom_boxplot\\(.+hwy", user_code)
  has_skewness <- grepl("skew", user_code)
  has_transform <- grepl("log\\(|sqrt\\(", user_code)
  
  has_function <- grepl("analyze_variable\\s*<-\\s*function", user_code)
  has_var_type_check <- grepl("is\\.factor|is\\.character|is\\.numeric", user_code)
  
  # Check if all required elements are present
  if (!has_class_freq) {
    fail("Make sure to create a frequency table for the class variable")
  } else if (!has_class_pct) {
    fail("Make sure to calculate percentages for the class variable")
  } else if (!has_class_plot) {
    fail("Make sure to create a bar chart for the class variable")
  } else if (!has_class_extreme) {
    fail("Make sure to identify the most and least common vehicle classes")
  } else if (!has_hwy_summary) {
    fail("Make sure to calculate summary statistics for the hwy variable")
  } else if (!has_hwy_plots) {
    fail("Make sure to create histogram, density plot, and boxplot for the hwy variable")
  } else if (!has_skewness) {
    fail("Make sure to check for skewness in the hwy variable")
  } else if (!has_function) {
    fail("Make sure to create an analyze_variable function")
  } else if (!has_var_type_check) {
    fail("Make sure your function checks the variable type (categorical or numerical)")
  } else {
    pass("Excellent work! You've performed a thorough univariate analysis.")
  }
})
```

## Bivariate Analysis

Bivariate analysis examines the relationship between two variables. The specific techniques depend on the types of variables being analyzed.

### Categorical vs. Categorical

For two categorical variables, we use contingency tables and stacked/grouped bar charts:

```{r cat-cat, echo=TRUE, fig.width=9, fig.height=5}
# Contingency table
cut_clarity_table <- table(diamonds_sample$cut, diamonds_sample$clarity)
print(cut_clarity_table)

# Row proportions
prop.table(cut_clarity_table, 1) * 100

# Column proportions
prop.table(cut_clarity_table, 2) * 100

# Chi-square test of independence
chi_test <- chisq.test(cut_clarity_table)
print(chi_test)

# Stacked bar chart
ggplot(diamonds_sample, aes(x = cut, fill = clarity)) +
  geom_bar(position = "stack") +
  labs(title = "Cut Quality by Clarity",
       x = "Cut",
       y = "Count",
       fill = "Clarity") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

# Grouped bar chart
ggplot(diamonds_sample, aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge") +
  labs(title = "Cut Quality by Clarity",
       x = "Cut",
       y = "Count",
       fill = "Clarity") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

# Mosaic plot (using base R)
mosaicplot(cut_clarity_table, main = "Mosaic Plot of Cut by Clarity", 
           color = TRUE, las = 2)
```

### Numerical vs. Categorical

For a numerical variable against a categorical variable, grouped summary statistics, boxplots, and violin plots are useful:

```{r num-cat, echo=TRUE, fig.width=9, fig.height=5}
# Summary statistics by group
diamonds_sample %>%
  group_by(cut) %>%
  summarize(
    Mean_Price = mean(price),
    Median_Price = median(price),
    SD_Price = sd(price),
    n = n()
  )

# ANOVA test
price_anova <- aov(price ~ cut, data = diamonds_sample)
summary(price_anova)

# Boxplot of price by cut
ggplot(diamonds_sample, aes(x = cut, y = price, fill = cut)) +
  geom_boxplot() +
  labs(title = "Diamond Price by Cut Quality",
       x = "Cut",
       y = "Price (USD)",
       fill = "Cut") +
  theme_minimal() +
  theme(legend.position = "none")

# Violin plot with jittered points
ggplot(diamonds_sample, aes(x = cut, y = price, fill = cut)) +
  geom_violin(alpha = 0.7) +
  geom_jitter(width = 0.2, size = 0.5, alpha = 0.5) +
  labs(title = "Diamond Price Distribution by Cut Quality",
       x = "Cut",
       y = "Price (USD)",
       fill = "Cut") +
  theme_minimal() +
  theme(legend.position = "none")

# Density plots by group
ggplot(diamonds_sample, aes(x = price, fill = cut)) +
  geom_density(alpha = 0.5) +
  labs(title = "Price Density by Cut Quality",
       x = "Price (USD)",
       y = "Density",
       fill = "Cut") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")
```

### Numerical vs. Numerical

For two numerical variables, scatterplots, correlation analysis, and regression are the main tools:

```{r num-num, echo=TRUE, fig.width=9, fig.height=9}
# Scatterplot of carat vs. price
ggplot(diamonds_sample, aes(x = carat, y = price)) +
  geom_point(alpha = 0.5) +
  labs(title = "Diamond Price vs. Carat",
       x = "Carat",
       y = "Price (USD)") +
  theme_minimal()

# Add a smoothing line
ggplot(diamonds_sample, aes(x = carat, y = price)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Diamond Price vs. Carat with Trend Line",
       x = "Carat",
       y = "Price (USD)") +
  theme_minimal()

# Pearson correlation
cor_carat_price <- cor(diamonds_sample$carat, diamonds_sample$price)
cat("Correlation between carat and price:", cor_carat_price, "\n")

# Linear regression
model <- lm(price ~ carat, data = diamonds_sample)
summary(model)

# Correlation matrix for numeric variables
numeric_diamonds <- diamonds_sample %>% 
  select(carat, depth, table, price, x, y, z)
cor_matrix <- cor(numeric_diamonds)
print(cor_matrix)

# Visualize correlation matrix
corrplot(cor_matrix, method = "circle", type = "upper",
         tl.col = "black", tl.srt = 45)

# Adding a third dimension with color
ggplot(diamonds_sample, aes(x = carat, y = price, color = cut)) +
  geom_point(alpha = 0.6) +
  labs(title = "Diamond Price vs. Carat by Cut",
       x = "Carat",
       y = "Price (USD)",
       color = "Cut") +
  theme_minimal() +
  scale_color_brewer(palette = "Set1")

# Scatterplot matrix for numeric variables
pairs(numeric_diamonds[, 1:4], 
      main = "Scatterplot Matrix of Diamond Characteristics")

# Using GGally for enhanced pairs plot
library(GGally)
ggpairs(numeric_diamonds[, 1:4],
        title = "Scatterplot Matrix with Correlations") 
```

### Exercise 3: Bivariate Analysis

Using the `mpg` dataset, perform the following bivariate analyses:

1. Analyze the relationship between `class` (vehicle type) and `drv` (drive train):
   - Create a contingency table with counts and proportions
   - Create an appropriate visualization (stacked bar chart or mosaic plot)
   - Perform a chi-square test and interpret the result
   - Identify any notable patterns or associations

2. Analyze the relationship between `class` (vehicle type) and `hwy` (highway MPG):
   - Calculate summary statistics of `hwy` by `class`
   - Create boxplots and violin plots
   - Perform an ANOVA test to determine if MPG differs significantly by class
   - Identify which vehicle classes have the highest and lowest MPG

3. Analyze the relationship between `displ` (engine displacement) and `hwy` (highway MPG):
   - Create a scatterplot with a trend line
   - Calculate the correlation coefficient
   - Fit a linear regression model and interpret the results
   - Enhance the scatterplot by coloring points by `class`

4. Create a function called `bivariate_analysis` that:
   - Takes a data frame and two column names as input
   - Automatically determines the types of variables (categorical or numerical)
   - Performs an appropriate bivariate analysis based on the variable types
   - Returns a list of results and creates appropriate visualizations

```{r ex3, exercise=TRUE}
# Write your code here

```

```{r ex3-solution}
# Load required packages
library(ggplot2)
library(dplyr)
library(GGally)

# Load the mpg dataset
data(mpg, package = "ggplot2")

# 1. Analyze relationship between class and drv (Categorical vs. Categorical)
# Contingency table
class_drv_table <- table(mpg$class, mpg$drv)
print(class_drv_table)

# Row proportions
class_drv_row_prop <- prop.table(class_drv_table, 1) * 100
print(class_drv_row_prop)

# Column proportions
class_drv_col_prop <- prop.table(class_drv_table, 2) * 100
print(class_drv_col_prop)

# Chi-square test
chi_test <- chisq.test(class_drv_table)
print(chi_test)

# Stacked bar chart
ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar(position = "stack") +
  labs(title = "Vehicle Class by Drive Train Type",
       x = "Vehicle Class",
       y = "Count",
       fill = "Drive Train") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer(palette = "Set1",
                    labels = c("4-wheel", "Front-wheel", "Rear-wheel"))

# Mosaic plot
mosaicplot(class_drv_table, main = "Mosaic Plot of Class by Drive Train", 
           color = TRUE, las = 2)

# Notable patterns
# Look at which combinations are most/least common
class_drv_df <- as.data.frame.table(class_drv_table)
colnames(class_drv_df) <- c("Class", "DriveType", "Count")
class_drv_df <- class_drv_df %>% arrange(desc(Count))
head(class_drv_df, 5)  # Top 5 combinations
tail(class_drv_df, 5)  # Bottom 5 combinations

# 2. Analyze relationship between class and hwy (Categorical vs. Numerical)
# Summary statistics by group
class_hwy_summary <- mpg %>%
  group_by(class) %>%
  summarize(
    Mean_MPG = mean(hwy),
    Median_MPG = median(hwy),
    SD_MPG = sd(hwy),
    Min_MPG = min(hwy),
    Max_MPG = max(hwy),
    n = n()
  ) %>%
  arrange(desc(Mean_MPG))

print(class_hwy_summary)

# Highest and lowest MPG classes
highest_mpg_class <- class_hwy_summary$class[1]
lowest_mpg_class <- class_hwy_summary$class[nrow(class_hwy_summary)]

cat("Class with highest MPG:", highest_mpg_class, "\n")
cat("Class with lowest MPG:", lowest_mpg_class, "\n")

# ANOVA test
hwy_anova <- aov(hwy ~ class, data = mpg)
summary(hwy_anova)

# Tukey's HSD post-hoc test
tukey_result <- TukeyHSD(hwy_anova)
print(tukey_result)

# Boxplot
ggplot(mpg, aes(x = class, y = hwy, fill = class)) +
  geom_boxplot() +
  labs(title = "Highway MPG by Vehicle Class",
       x = "Vehicle Class",
       y = "Highway MPG",
       fill = "Vehicle Class") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none")

# Violin plot with jittered points
ggplot(mpg, aes(x = class, y = hwy, fill = class)) +
  geom_violin(alpha = 0.7) +
  geom_jitter(width = 0.2, size = 1, alpha = 0.5) +
  labs(title = "Highway MPG Distribution by Vehicle Class",
       x = "Vehicle Class",
       y = "Highway MPG",
       fill = "Vehicle Class") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none")

# 3. Analyze relationship between displ and hwy (Numerical vs. Numerical)
# Scatterplot with trend line
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Highway MPG vs. Engine Displacement",
       x = "Engine Displacement (L)",
       y = "Highway MPG") +
  theme_minimal()

# Correlation coefficient
cor_displ_hwy <- cor(mpg$displ, mpg$hwy)
cat("Correlation between displacement and highway MPG:", cor_displ_hwy, "\n")

# Linear regression
model <- lm(hwy ~ displ, data = mpg)
summary(model)

# Enhanced scatterplot with class colors
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point(alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(title = "Highway MPG vs. Engine Displacement by Vehicle Class",
       x = "Engine Displacement (L)",
       y = "Highway MPG",
       color = "Vehicle Class") +
  theme_minimal() +
  scale_color_brewer(palette = "Set1")

# 4. Create a function for bivariate analysis
bivariate_analysis <- function(df, var1, var2) {
  # Check if variables exist
  if (!var1 %in% names(df) || !var2 %in% names(df)) {
    stop("One or both variables not found in the data frame")
  }
  
  # Extract variables
  x <- df[[var1]]
  y <- df[[var2]]
  
  # Initialize result list
  result <- list()
  result$var1 <- var1
  result$var2 <- var2
  
  # Determine variable types
  is_cat_x <- is.factor(x) || is.character(x) || length(unique(x)) <= 10
  is_cat_y <- is.factor(y) || is.character(y) || length(unique(y)) <= 10
  
  # Case 1: Both categorical
  if (is_cat_x && is_cat_y) {
    result$type <- "categorical-categorical"
    
    # Contingency table
    cont_table <- table(x, y)
    result$contingency_table <- cont_table
    
    # Chi-square test
    result$chi_square_test <- chisq.test(cont_table)
    
    # Visualization
    print(
      ggplot(df, aes(x = .data[[var1]], fill = .data[[var2]])) +
        geom_bar(position = "dodge") +
        labs(title = paste(var1, "vs.", var2),
             x = var1,
             y = "Count",
             fill = var2) +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    )
    
    # Mosaic plot
    mosaicplot(cont_table, main = paste("Mosaic Plot of", var1, "by", var2), 
               color = TRUE, las = 2)
  }
  
  # Case 2: Categorical x, Numerical y
  else if (is_cat_x && !is_cat_y) {
    result$type <- "categorical-numerical"
    
    # Summary statistics by group
    result$summary <- df %>%
      group_by(.data[[var1]]) %>%
      summarize(
        Mean = mean(.data[[var2]]),
        Median = median(.data[[var2]]),
        SD = sd(.data[[var2]]),
        n = n()
      )
    
    # ANOVA
    formula <- as.formula(paste(var2, "~", var1))
    result$anova <- summary(aov(formula, data = df))
    
    # Boxplot
    print(
      ggplot(df, aes(x = .data[[var1]], y = .data[[var2]], fill = .data[[var1]])) +
        geom_boxplot() +
        labs(title = paste(var2, "by", var1),
             x = var1,
             y = var2) +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1),
              legend.position = "none")
    )
    
    # Violin plot
    print(
      ggplot(df, aes(x = .data[[var1]], y = .data[[var2]], fill = .data[[var1]])) +
        geom_violin(alpha = 0.7) +
        geom_jitter(width = 0.2, size = 0.5, alpha = 0.5) +
        labs(title = paste("Distribution of", var2, "by", var1),
             x = var1,
             y = var2) +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1),
              legend.position = "none")
    )
  }
  
  # Case 3: Numerical x, Categorical y
  else if (!is_cat_x && is_cat_y) {
    result$type <- "numerical-categorical"
    
    # This is basically the same as Case 2, but with variables swapped
    result$summary <- df %>%
      group_by(.data[[var2]]) %>%
      summarize(
        Mean = mean(.data[[var1]]),
        Median = median(.data[[var1]]),
        SD = sd(.data[[var1]]),
        n = n()
      )
    
    # ANOVA
    formula <- as.formula(paste(var1, "~", var2))
    result$anova <- summary(aov(formula, data = df))
    
    # Boxplot
    print(
      ggplot(df, aes(x = .data[[var2]], y = .data[[var1]], fill = .data[[var2]])) +
        geom_boxplot() +
        labs(title = paste(var1, "by", var2),
             x = var2,
             y = var1) +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1),
              legend.position = "none")
    )
  }
  
  # Case 4: Both numerical
  else {
    result$type <- "numerical-numerical"
    
    # Correlation
    result$correlation <- cor(x, y)
    
    # Linear regression
    formula <- as.formula(paste(var2, "~", var1))
    result$regression <- summary(lm(formula, data = df))
    
    # Scatterplot
    print(
      ggplot(df, aes(x = .data[[var1]], y = .data[[var2]])) +
        geom_point(alpha = 0.6) +
        geom_smooth(method = "lm", color = "red") +
        labs(title = paste(var2, "vs.", var1),
             x = var1,
             y = var2) +
        theme_minimal()
    )
  }
  
  return(result)
}

# Apply the function to examples from each case
cat_cat_result <- bivariate_analysis(mpg, "class", "drv")
cat_num_result <- bivariate_analysis(mpg, "class", "hwy")
num_num_result <- bivariate_analysis(mpg, "displ", "hwy")

# Display results
print(cat_cat_result)
print(cat_num_result)
print(num_num_result)
```

```{r ex3-check}
grade_this({
  # Check the student's submitted code
  user_code <- .user_code
  
  # Check for required elements
  has_contingency <- grepl("table\\(mpg\\$class,\\s*mpg\\$drv\\)|table\\(mpg\\[,\\s*[\"']class[\"']\\],\\s*mpg\\[,\\s*[\"']drv[\"']\\]\\)", user_code)
  has_prop_table <- grepl("prop\\.table\\(", user_code)
  has_chisq <- grepl("chisq\\.test\\(", user_code)
  has_class_drv_plot <- grepl("aes\\(x\\s*=\\s*class,\\s*fill\\s*=\\s*drv\\)|aes\\(x\\s*=\\s*mpg\\$class,\\s*fill\\s*=\\s*mpg\\$drv\\)", user_code)
  
  has_class_hwy_summary <- grepl("group_by\\(class|group_by\\(mpg\\$class|aggregate\\(.+class", user_code)
  has_anova <- grepl("aov\\(", user_code)
  has_hwy_boxplot <- grepl("aes\\(.+hwy.+class", user_code)
  
  has_displ_hwy_scatter <- grepl("aes\\(x\\s*=\\s*displ,\\s*y\\s*=\\s*hwy\\)|aes\\(x\\s*=\\s*mpg\\$displ,\\s*y\\s*=\\s*mpg\\$hwy\\)", user_code)
  has_displ_hwy_cor <- grepl("cor\\(mpg\\$displ,\\s*mpg\\$hwy\\)|cor\\(mpg\\[,\\s*[\"']displ[\"']\\],\\s*mpg\\[,\\s*[\"']hwy[\"']\\]\\)", user_code)
  has_lm <- grepl("lm\\(", user_code)
  
  has_bivar_function <- grepl("bivariate_analysis\\s*<-\\s*function", user_code)
  has_bivar_type_check <- grepl("is\\.factor|is\\.character|is\\.numeric", user_code)
  has_function_call <- grepl("bivariate_analysis\\(mpg", user_code)
  
  # Check if all required elements are present
  if (!has_contingency || !has_prop_table) {
    fail("Make sure to create a contingency table with counts and proportions for class and drv")
  } else if (!has_chisq) {
    fail("Make sure to perform a chi-square test on the contingency table")
  } else if (!has_class_drv_plot) {
    fail("Make sure to create an appropriate visualization for class and drv")
  } else if (!has_class_hwy_summary) {
    fail("Make sure to calculate summary statistics of hwy by class")
  } else if (!has_anova) {
    fail("Make sure to perform an ANOVA test on hwy by class")
  } else if (!has_hwy_boxplot) {
    fail("Make sure to create boxplots or violin plots of hwy by class")
  } else if (!has_displ_hwy_scatter) {
    fail("Make sure to create a scatterplot of displ vs. hwy")
  } else if (!has_displ_hwy_cor) {
    fail("Make sure to calculate the correlation between displ and hwy")
  } else if (!has_lm) {
    fail("Make sure to fit a linear regression model for displ and hwy")
  } else if (!has_bivar_function) {
    fail("Make sure to create a function called bivariate_analysis")
  } else if (!has_bivar_type_check) {
    fail("Make sure your function checks the types of variables for appropriate analysis")
  } else if (!has_function_call) {
    fail("Make sure to apply your function to examples from the mpg dataset")
  } else {
    pass("Excellent work! You've performed comprehensive bivariate analyses on the mpg dataset.")
  }
})
```

## Multivariate Analysis

Multivariate analysis explores relationships among three or more variables simultaneously. This often builds on bivariate analysis techniques with additional dimensions.

### Adding Dimensions to Visualizations

```{r multi-dim, echo=TRUE, fig.width=9, fig.height=6}
# Scatterplot with color and size
ggplot(diamonds_sample, aes(x = carat, y = price, color = cut, size = table)) +
  geom_point(alpha = 0.6) +
  labs(title = "Diamond Price vs. Carat by Cut and Table",
       x = "Carat",
       y = "Price (USD)",
       color = "Cut",
       size = "Table %") +
  theme_minimal() +
  scale_color_brewer(palette = "Set1")

# Faceted visualization
ggplot(diamonds_sample, aes(x = carat, y = price, color = clarity)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~ cut) +
  labs(title = "Price vs. Carat by Cut and Clarity",
       x = "Carat",
       y = "Price (USD)",
       color = "Clarity") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Multiple small multiples
ggplot(diamonds_sample, aes(x = carat, y = price)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  facet_grid(cut ~ clarity) +
  labs(title = "Price vs. Carat by Cut and Clarity",
       x = "Carat",
       y = "Price (USD)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        strip.text = element_text(size = 7))
```

### Building Multiple Regression Models

```{r multi-regression, echo=TRUE}
# Simple linear regression
simple_model <- lm(price ~ carat, data = diamonds_sample)
summary(simple_model)

# Multiple regression
multi_model <- lm(price ~ carat + cut + color + clarity, data = diamonds_sample)
summary(multi_model)

# Compare models
cat("Simple model R-squared:", summary(simple_model)$r.squared, "\n")
cat("Multiple model R-squared:", summary(multi_model)$r.squared, "\n")

# ANOVA comparing models
anova(simple_model, multi_model)

# Visualization of effects (partial residual plot)
if (requireNamespace("car", quietly = TRUE)) {
  library(car)
  crPlots(multi_model, terms = ~ carat)
}
```

### Clustering and Dimension Reduction

These techniques help identify patterns in high-dimensional data:

```{r dimension-reduction, echo=TRUE, fig.width=9, fig.height=6, eval=requireNamespace("cluster", quietly = TRUE)}
# Prepare data for clustering
diamonds_numeric <- diamonds_sample %>%
  select(carat, depth, table, price, x, y, z) %>%
  scale()  # Standardize variables

# K-means clustering
if (requireNamespace("cluster", quietly = TRUE)) {
  library(cluster)
  
  # Determine optimal number of clusters
  set.seed(123)
  wss <- numeric(10)
  for (i in 1:10) {
    wss[i] <- sum(kmeans(diamonds_numeric, centers = i)$withinss)
  }
  
  # Elbow plot
  plot(1:10, wss, type = "b", pch = 19,
       xlab = "Number of Clusters", ylab = "Within Sum of Squares",
       main = "Elbow Method for Optimal k")
  
  # K-means with optimal k (let's say k=3 based on elbow)
  set.seed(123)
  km <- kmeans(diamonds_numeric, centers = 3)
  
  # Add cluster assignments back to original data
  diamonds_sample$cluster <- factor(km.result$cluster)
  
  # Visualize clusters
  ggplot(diamonds_sample, aes(x = carat, y = price, color = cluster)) +
    geom_point(alpha = 0.6) +
    labs(title = "Diamond Clusters based on Numeric Features",
         x = "Carat",
         y = "Price (USD)",
         color = "Cluster") +
    theme_minimal()
}

# PCA (Principal Component Analysis)
if (requireNamespace("stats", quietly = TRUE)) {
  # Perform PCA
  pca_result <- prcomp(diamonds_numeric)
  
  # Summary of PCA
  summary(pca_result)
  
  # Visualize the first two principal components
  pca_data <- as.data.frame(pca_result$x[, 1:2])
  pca_data$cut <- diamonds_sample$cut
  
  ggplot(pca_data, aes(x = PC1, y = PC2, color = cut)) +
    geom_point(alpha = 0.6) +
    labs(title = "PCA of Diamond Characteristics",
         x = "Principal Component 1",
         y = "Principal Component 2",
         color = "Cut") +
    theme_minimal()
}
```

### Exercise 4: Multivariate Analysis

Using the `mpg` dataset, perform a multivariate analysis focusing on highway fuel efficiency (`hwy`). Complete the following tasks:

1. Create multivariate visualizations that show:
   - The relationship between `displ` (engine displacement) and `hwy` (highway MPG), with points colored by `class` and sized by `cyl` (number of cylinders)
   - The same relationship faceted by `drv` (drive train)
   - A grid of small multiples showing the relationship by combinations of `drv` and `year`

2. Build regression models to predict `hwy`:
   - A simple model using only `displ`
   - A multiple regression model using `displ`, `cyl`, `class`, and `drv`
   - Compare the models using R-squared and ANOVA
   - Interpret which variables have the strongest effect on fuel efficiency

3. Perform a clustering analysis to identify vehicle groups:
   - Use k-means clustering on the numerical variables (`displ`, `cyl`, `cty`, `hwy`)
   - Determine the optimal number of clusters
   - Visualize the clusters in relation to `displ` and `hwy`
   - Characterize each cluster in terms of vehicle types

4. Put together a comprehensive EDA report that:
   - Summarizes the key findings from your univariate, bivariate, and multivariate analyses
   - Identifies the most important factors affecting highway fuel efficiency
   - Provides actionable insights for someone looking to purchase a fuel-efficient vehicle

```{r ex4, exercise=TRUE}
# Write your code here

```

```{r ex4-solution}
# Load required packages
library(ggplot2)
library(dplyr)
library(tidyr)
library(cluster)

# Load the mpg dataset
data(mpg, package = "ggplot2")

# 1. Create multivariate visualizations
# Relationship between displ and hwy, colored by class and sized by cyl
ggplot(mpg, aes(x = displ, y = hwy, color = class, size = cyl)) +
  geom_point(alpha = 0.7) +
  labs(title = "Highway MPG vs. Engine Displacement",
       subtitle = "Colored by Vehicle Class, Sized by Cylinders",
       x = "Engine Displacement (L)",
       y = "Highway MPG",
       color = "Vehicle Class",
       size = "Cylinders") +
  theme_minimal() +
  scale_color_brewer(palette = "Set1")

# Same relationship faceted by drive train
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point(alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  facet_wrap(~ drv, labeller = labeller(
    drv = c("4" = "4-wheel", "f" = "Front-wheel", "r" = "Rear-wheel")
  )) +
  labs(title = "Highway MPG vs. Engine Displacement by Drive Train",
       subtitle = "Colored by Vehicle Class",
       x = "Engine Displacement (L)",
       y = "Highway MPG",
       color = "Vehicle Class") +
  theme_minimal() +
  scale_color_brewer(palette = "Set1")

# Grid of small multiples by drv and year
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point(alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  facet_grid(drv ~ year, labeller = labeller(
    drv = c("4" = "4-wheel", "f" = "Front-wheel", "r" = "Rear-wheel")
  )) +
  labs(title = "Highway MPG vs. Engine Displacement",
       subtitle = "By Drive Train and Model Year",
       x = "Engine Displacement (L)",
       y = "Highway MPG",
       color = "Vehicle Class") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  scale_color_brewer(palette = "Set1")

# 2. Build regression models
# Simple model
simple_model <- lm(hwy ~ displ, data = mpg)
summary(simple_model)

# Multiple regression model
multi_model <- lm(hwy ~ displ + cyl + class + drv, data = mpg)
summary(multi_model)

# Compare models using R-squared
simple_r2 <- summary(simple_model)$r.squared
multi_r2 <- summary(multi_model)$r.squared

cat("Simple model R-squared:", simple_r2, "\n")
cat("Multiple model R-squared:", multi_r2, "\n")
cat("Improvement:", (multi_r2 - simple_r2) * 100, "percentage points\n")

# ANOVA comparing models
anova_result <- anova(simple_model, multi_model)
print(anova_result)

# Interpret variable importance
coefficients <- summary(multi_model)$coefficients
# Sort coefficients by absolute t-value to assess importance
coef_importance <- data.frame(
  Variable = rownames(coefficients),
  Estimate = coefficients[, 1],
  StdError = coefficients[, 2],
  tValue = coefficients[, 3],
  pValue = coefficients[, 4]
) %>%
  filter(Variable != "(Intercept)") %>%
  mutate(AbsTValue = abs(tValue)) %>%
  arrange(desc(AbsTValue))

print(coef_importance)

# 3. Clustering analysis
# Prepare data for clustering
mpg_numeric <- mpg %>%
  select(displ, cyl, cty, hwy) %>%
  scale()  # Standardize variables

# Determine optimal number of clusters
set.seed(123)
wss <- numeric(10)
for (i in 1:10) {
  wss[i] <- sum(kmeans(mpg_numeric, centers = i)$withinss)
}

# Elbow plot
plot(1:10, wss, type = "b", pch = 19,
     xlab = "Number of Clusters", ylab = "Within Sum of Squares",
     main = "Elbow Method for Optimal k")

# Based on elbow plot, choose an optimal k (let's say 3)
set.seed(123)
k <- 3
km_result <- kmeans(mpg_numeric, centers = k)

# Add cluster assignments to original data
mpg_with_clusters <- mpg %>%
  mutate(cluster = factor(km_result$cluster))

# Visualize clusters in relation to displ and hwy
ggplot(mpg_with_clusters, aes(x = displ, y = hwy, color = cluster)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(title = "Vehicle Clusters based on Engine and Efficiency",
       x = "Engine Displacement (L)",
       y = "Highway MPG",
       color = "Cluster") +
  theme_minimal()

# Characterize clusters
cluster_profile <- mpg_with_clusters %>%
  group_by(cluster) %>%
  summarize(
    Count = n(),
    Avg_Displacement = mean(displ),
    Avg_Cylinders = mean(cyl),
    Avg_City_MPG = mean(cty),
    Avg_Highway_MPG = mean(hwy)
  )

print(cluster_profile)

# Distribution of vehicle classes within each cluster
class_by_cluster <- mpg_with_clusters %>%
  group_by(cluster, class) %>%
  summarize(Count = n(), .groups = "drop") %>%
  group_by(cluster) %>%
  mutate(Percentage = Count / sum(Count) * 100) %>%
  arrange(cluster, desc(Percentage))

print(class_by_cluster)

# Visualize class distribution by cluster
ggplot(mpg_with_clusters, aes(x = cluster, fill = class)) +
  geom_bar(position = "fill") +
  labs(title = "Vehicle Class Distribution by Cluster",
       x = "Cluster",
       y = "Proportion",
       fill = "Vehicle Class") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

# 4. Comprehensive EDA report
cat("\n============================================================\n")
cat("                  COMPREHENSIVE EDA REPORT                   \n")
cat("============================================================\n\n")

cat("INTRODUCTION\n")
cat("This report analyzes the mpg dataset to identify factors affecting highway fuel efficiency.\n\n")

cat("KEY FINDINGS FROM UNIVARIATE ANALYSIS\n")
cat("- Highway MPG (hwy) has a mean of", mean(mpg$hwy), "and ranges from", min(mpg$hwy), "to", max(mpg$hwy), "\n")
cat("- The most common vehicle class is", names(which.max(table(mpg$class))), "\n")
cat("- Engine displacement (displ) ranges from", min(mpg$displ), "to", max(mpg$displ), "liters\n\n")

cat("KEY FINDINGS FROM BIVARIATE ANALYSIS\n")
cat("- Strong negative correlation between engine displacement and highway MPG:", cor(mpg$displ, mpg$hwy), "\n")
cat("- Vehicle class has a significant impact on MPG (ANOVA p-value < 0.001)\n")
cat("- Compact cars have the highest average MPG at", mean(mpg$hwy[mpg$class == "compact"]), "\n")
cat("- SUVs have the lowest average MPG at", mean(mpg$hwy[mpg$class == "suv"]), "\n\n")

cat("KEY FINDINGS FROM MULTIVARIATE ANALYSIS\n")
cat("- Multiple regression model explains", round(multi_r2 * 100, 1), "% of the variance in highway MPG\n")
cat("- The most important predictors of high MPG (in order) are:\n")
for(i in 1:min(5, nrow(coef_importance))) {
  cat("  ", i, ". ", coef_importance$Variable[i], 
      " (t-value: ", round(coef_importance$tValue[i], 2), ")\n", sep = "")
}
cat("\n- We identified", k, "distinct vehicle clusters based on engine and efficiency metrics\n")
cat("- Cluster profiles:\n")
for(i in 1:nrow(cluster_profile)) {
  cat("  Cluster", i, ": ", round(cluster_profile$Avg_Highway_MPG[i], 1), "MPG, ", 
      round(cluster_profile$Avg_Displacement[i], 1), "L engines\n", sep = "")
}

cat("\nACTIONABLE INSIGHTS FOR FUEL-EFFICIENT VEHICLE PURCHASE\n")
cat("1. Engine size matters most: Smaller engines (< 2.0L) consistently deliver better MPG\n")
cat("2. Vehicle class is critical: Compact and subcompact cars offer the best efficiency\n")
cat("3. Drive train affects efficiency: Front-wheel drive vehicles typically offer better MPG\n")
cat("4. Cylinder count: Fewer cylinders generally means better fuel economy\n")
cat("5. Recommendation: For maximum highway efficiency, look for 4-cylinder compact cars with\n")
cat("   small engines (<2.0L) and front-wheel drive\n")
```

```{r ex4-check}
grade_this({
  # Check the student's submitted code
  user_code <- .user_code
  
  # Check for required elements
  has_multivar_plot <- grepl("aes\\(x\\s*=\\s*displ,\\s*y\\s*=\\s*hwy,\\s*color\\s*=\\s*class", user_code)
  has_size_aes <- grepl("size\\s*=\\s*cyl", user_code)
  has_facet_drv <- grepl("facet_wrap\\(~\\s*drv\\)|facet_grid\\(.+drv", user_code)
  has_facet_grid <- grepl("facet_grid\\(", user_code)
  
  has_simple_model <- grepl("lm\\(hwy\\s*~\\s*displ", user_code)
  has_multi_model <- grepl("lm\\(hwy\\s*~\\s*displ.+cyl.+class.+drv", user_code)
  has_model_compare <- grepl("r\\.squared|anova\\(", user_code)
  
  has_cluster <- grepl("kmeans\\(", user_code)
  has_optimal_k <- grepl("wss|silhouette|elbow", user_code)
  has_cluster_viz <- grepl("aes\\(.+cluster\\)|group_by\\(.+cluster", user_code)
  
  has_report <- grepl("KEY FINDINGS|COMPREHENSIVE|ACTIONABLE", user_code)
  
  # Check if all required elements are present
  if (!has_multivar_plot) {
    fail("Make sure to create multivariate visualizations showing the relationship between displ and hwy")
  } else if (!has_size_aes) {
    fail("Make sure to size points by cylinder count (cyl) in your visualization")
  } else if (!has_facet_drv) {
    fail("Make sure to create facets by drive train (drv)")
  } else if (!has_facet_grid) {
    fail("Make sure to create a grid of small multiples")
  } else if (!has_simple_model || !has_multi_model) {
    fail("Make sure to build both simple and multiple regression models")
  } else if (!has_model_compare) {
    fail("Make sure to compare the models using R-squared and/or ANOVA")
  } else if (!has_cluster) {
    fail("Make sure to perform a clustering analysis")
  } else if (!has_optimal_k) {
    fail("Make sure to determine the optimal number of clusters")
  } else if (!has_cluster_viz) {
    fail("Make sure to visualize the clusters")
  } else if (!has_report) {
    fail("Make sure to create a comprehensive EDA report summarizing your findings")
  } else {
    pass("Outstanding work! You've performed a thorough multivariate analysis and created a comprehensive EDA report.")
  }
})
```

## Exploratory Data Analysis Workflow

A structured EDA workflow helps ensure a thorough and systematic exploration of your data.

### Step-by-Step EDA Process

Here's a recommended EDA workflow:

1. **Define Questions**: Start with clear questions you want to answer
2. **Data Preparation**: Clean and structure your data for analysis
3. **Univariate Analysis**: Understand individual variables
4. **Bivariate Analysis**: Explore relationships between variables
5. **Multivariate Analysis**: Investigate complex relationships
6. **Summarize Findings**: Draw conclusions and generate insights
7. **Communicate Results**: Create clear visualizations and reports

### Iterative Nature of EDA

EDA is not a linear process but an iterative one:

```{r eda-workflow, echo=FALSE, fig.width=8, fig.height=5}
# Create a diagram of the EDA workflow
library(DiagrammeR)

grViz("
digraph eda_workflow {
  graph [rankdir = LR]
  
  node [shape = rectangle, style = filled, fillcolor = lightblue, fontname = 'Arial']
  
  Questions [label = 'Define\nQuestions']
  Preparation [label = 'Data\nPreparation']
  Univariate [label = 'Univariate\nAnalysis']
  Bivariate [label = 'Bivariate\nAnalysis']
  Multivariate [label = 'Multivariate\nAnalysis']
  Insights [label = 'Generate\nInsights']
  
  Questions -> Preparation [penwidth = 2]
  Preparation -> Univariate [penwidth = 2]
  Univariate -> Bivariate [penwidth = 2]
  Bivariate -> Multivariate [penwidth = 2]
  Multivariate -> Insights [penwidth = 2]
  
  # Feedback loops
  Univariate -> Questions [constraint = false, color = red, label = 'New\nQuestions']
  Bivariate -> Preparation [constraint = false, color = red, label = 'Data\nIssues']
  Multivariate -> Univariate [constraint = false, color = red, label = 'Verify\nPatterns']
  Insights -> Questions [constraint = false, color = red, label = 'Further\nExploration']
}
")
```

### Common Pitfalls and Best Practices

Some tips for effective EDA:

- **Don't skip data cleaning**: Missing values, outliers, and errors can lead to incorrect conclusions
- **Balance exploration and focus**: Explore broadly, but don't lose sight of your key questions
- **Use appropriate visualizations**: Choose the right plots for your data types and questions
- **Look beyond the obvious**: Investigate unusual patterns and unexpected relationships
- **Document your process**: Keep track of your analyses and findings for reproducibility
- **Be aware of biases**: Consider sampling biases, measurement errors, and your own preconceptions
- **Remember correlation isn't causation**: Identify relationships, but be cautious about inferring causality

## Summary

In this module, you've learned about Exploratory Data Analysis (EDA) in R, covering:

1. **The EDA Process**:
   - Understanding the purpose and importance of EDA
   - Following a structured workflow from univariate to multivariate analysis
   - Iteratively exploring data to generate insights

2. **Univariate Analysis**:
   - Examining the distribution of individual variables
   - Using appropriate techniques for categorical and numerical data
   - Identifying patterns and anomalies in single variables

3. **Bivariate Analysis**:
   - Exploring relationships between pairs of variables
   - Applying different techniques based on variable types
   - Testing for statistical significance in relationships

4. **Multivariate Analysis**:
   - Investigating complex relationships among multiple variables
   - Building predictive models to understand factors' influences
   - Using clustering to identify patterns in high-dimensional data

5. **Effective EDA Practices**:
   - Choosing appropriate visualizations
   - Avoiding common pitfalls
   - Communicating findings clearly

EDA is a crucial first step in any data analysis project, providing the foundation for more advanced statistical methods, machine learning, and data-driven decision making.

## Additional Resources

- [R for Data Science - EDA Chapter](https://r4ds.had.co.nz/exploratory-data-analysis.html)
- [Exploratory Data Analysis with R](https://bookdown.org/rdpeng/exdata/)
- [Data Visualization: A Practical Introduction](https://socviz.co/)
- [The Art of Data Science](https://leanpub.com/artofdatascience)
- [Introduction to Statistical Learning](https://www.statlearning.com/)
