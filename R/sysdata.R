# Internal data for the package
lesson_data <- data.frame(
  id = c(
    "module1-environment",
    "module2-variables",
    "module3-data-types",
    "module4-vectors",
    "module5-matrices",
    "module6-lists",
    "module7-data-frames",
    "module8-factors",
    "module9-data-input",
    "module10-data-visualization",
    "module11-descriptive-statistics",
    "module12-exploratory-data-analysis"
  ),
  title = c(
    "Module 1: The R Environment",
    "Module 2: Creating Variables in R",
    "Module 3: Numeric, Character, and Logical Data Types",
    "Module 4: Vectors in R",
    "Module 5: Matrices in R",
    "Module 6: Lists in R",
    "Module 7: Data Frames in R",
    "Module 8: Factors in R",
    "Module 9: Data Input in R",
    "Module 10: Data Visualization in R",
    "Module 11: Descriptive Statistics in R",
    "Module 12: Exploratory Data Analysis in R"
  ),
  description = c(
    "Learn about the R statistical environment and its core components",
    "Learn how to create and work with variables in R",
    "Learn about the basic data types in R: numeric, character, and logical",
    "Learn how to create and manipulate vectors in R",
    "Learn how to create and manipulate matrices in R",
    "Learn how to create and work with lists in R",
    "Learn how to create and manipulate data frames in R",
    "Learn how to create and work with factors in R",
    "Learn how to input, read, write, and explore data in R",
    "Learn how to create effective data visualizations in R",
    "Learn how to calculate and interpret descriptive statistics in R",
    "Learn how to conduct exploratory data analysis in R"
  ),
  path = paste0(
    "tutorials/",
    c(
      "module1-environment/module1-environment.Rmd",
      "module2-variables/module2-variables.Rmd",
      "module3-data-types/module3-data-types.Rmd",
      "module4-vectors/module4-vectors.Rmd",
      "module5-matrices/module5-matrices.Rmd",
      "module6-lists/module6-lists.Rmd",
      "module7-data-frames/module7-data-frames.Rmd",
      "module8-factors/module8-factors.Rmd",
      "module9-data-input/module9-data-input.Rmd",
      "module10-data-visualization/module10-data-visualization.Rmd",
      "module11-descriptive-statistics/module11-descriptive-statistics.Rmd",
      "module12-exploratory-data-analysis/module12-exploratory-data-analysis.Rmd"
    )
  ),
  stringsAsFactors = FALSE
)
