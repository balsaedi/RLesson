# RLesson: Interactive R Programming Tutorials

## Overview

RLesson is a comprehensive educational package containing 12 interactive tutorials designed to teach R programming from basics to advanced concepts. These self-contained lessons guide students through learning R in a step-by-step manner with interactive exercises and immediate feedback.

## Features

- **Interactive Learning**: All tutorials include code exercises with automated feedback
- **Progressive Structure**: Lessons build upon each other from basic to advanced concepts
- **User-Friendly Interface**: Simple menu system to navigate between tutorials
- **Progress Tracking**: Keep track of completed lessons
- **Self-Paced Learning**: Study at your own pace and revisit lessons as needed

## Topics Covered

1. **The R Environment**: Introduction to R's core components and basic functionality
2. **Creating Variables in R**: Learn how to create and work with variables
3. **Numeric, Character, and Logical Data Types**: Understanding basic data types
4. **Vectors in R**: Creating and manipulating vectors
5. **Matrices in R**: Working with two-dimensional data structures
6. **Lists in R**: Managing complex, heterogeneous data
7. **Data Frames in R**: Handling tabular data
8. **Factors in R**: Working with categorical data
9. **Data Input in R**: Importing, reading, and writing data
10. **Data Visualization in R**: Creating effective visualizations
11. **Descriptive Statistics in R**: Calculating and interpreting statistics
12. **Exploratory Data Analysis in R**: Techniques for data exploration

## Installation

### Option 1: Simple Installation (with dependencies)

```r
# Install devtools if you don't have it
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# Install RLesson package from GitHub (master branch)
devtools::install_github("YourGitHubUsername/RLesson", 
                        ref = "master",
                        dependencies = TRUE)
```

### Option 2: Installation Helper Function

Copy and paste this function into your R console to install RLesson and all its dependencies:

```r
install_rlesson <- function() {
  # Required packages
  required_pkgs <- c("learnr", "shiny", "gradethis", "ggplot2", "dplyr", 
                    "tidyr", "readr", "readxl", "writexl", "haven", 
                    "reshape2", "psych", "moments", "corrplot", 
                    "RColorBrewer")
  
  # Install devtools if needed
  if (!requireNamespace("devtools", quietly = TRUE)) {
    message("Installing devtools package...")
    install.packages("devtools")
  }
  
  # Install required packages if needed
  for (pkg in required_pkgs) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message("Installing ", pkg, " package...")
      install.packages(pkg)
    }
  }
  
  # Install RLesson from GitHub (master branch)
  message("Installing RLesson package from GitHub...")
  devtools::install_github("YourGitHubUsername/RLesson", 
                          ref = "master",
                          dependencies = TRUE)
  
  message("Installation complete! Run library(RLesson) followed by lesson_menu() to start learning.")
}

# Run the function to install RLesson
install_rlesson()
```

## Usage

After installation, load the package and launch the lesson menu:

```r
library(RLesson)
lesson_menu()
```

This will open a menu interface where you can:
- Browse all available lessons
- See descriptions of each lesson
- Track your progress through the curriculum
- Launch interactive tutorials

You can also launch a specific lesson directly:

```r
launch_lesson("module1-environment")
```

## Requirements

- R version 3.5.0 or higher
- RStudio (recommended for the best interactive experience)
- Rtools must be installed (required for installing R packages from GitHub)
  - Windows users: Download Rtools from https://cran.r-project.org/bin/windows/Rtools/
  - Mac users: Install Xcode Command Line Tools
  - Linux users: Install R development packages (r-base-dev or r-devel)
- Internet connection (for initial installation)

## Troubleshooting

If you encounter issues during installation:

1. Make sure you have the latest version of R and RStudio
2. **Verify Rtools is properly installed**:
   - For Windows users: Run `pkgbuild::has_build_tools(debug = TRUE)` in R to check if Rtools is correctly configured
   - For Mac users: Run `pkgbuild::has_build_tools(debug = TRUE)` to check if Xcode tools are available
3. Check that you can install packages from CRAN
4. Try installing the dependencies manually before installing RLesson
5. If you see compiler or build errors, it's usually related to Rtools configuration
6. If problems persist, please report the issue on GitHub

## License

This package is released under the MIT License.

## Acknowledgments

Special thanks to the developers of the learnr and gradethis packages which power the interactive tutorials.
