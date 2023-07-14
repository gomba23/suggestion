# 1. General Workflow
# 1) Setup project (rMarkdown, bookdown, or just R file) 
# 2) Install packages that you need. See 2.
# 3) Define your variables
## your Y: "Willingness to ..."
## your X: c("",""), the 500 dependent variables
# 4) Inspect how the data looks like, do you have missing values, how many different values do you have in each column
# 5) Data cleaning
# 6) Correlation analysis
# 7) Data splitting (Training and Test datasets)
# 8) Model building using Training dataset

# Factor analysis (group your X variables in to several Factors)
# Build a regression model using grouped Factors 
# Identify important Factors and important variables that contribute most to the important Factors

# 9) Test your model performance on Test dataset
# 10) done 


# 2. Packages 
## 2.1 Must have 
# handling data
require(tidyverse)
require(foreign)

# plotting 
require(ggplot2)

# machine learning 
require(carat)

# auto explorative data analysis
require(SmartEDA)


## 2.2 Nice to have
# managing r environment
require(renv)

# a book template 
require(bookdown)

# data description 
require(psych)



# 3. read data
fileName = "xx.dta"
workingDir = "your_working_directory"
filePath = file.path(workingDir, fileName)

# assign to DF 
DF = foreign::read.dta(
  filePath,
  convert.dates = F,
  convert.factors = F,
  missing.type = F,
  convert.underscore = F,
  warn.missing.labels = F
)

# 4. Explorative Data Analysis 

# look at DF in the View tab
View(DF)

# look at missing values
SmartEDA::ExpData(customers, type=2)
