# 1. General Workflow
# 1) Setup project (rMarkdown, bookdown, or just R file) 
# 2) Install packages that you need. See 2.
# 3) Define your variables
## your Y: "Willingness to ..."
## your X: c("",""), the 500 dependent variables
# 4) Inspect how the data looks like, do you have missing values, how many different values do you have in each column
# 5) Data cleaning: filling missing values 
# 6) Correlation analysis
# 7) Data splitting (Training and Test datasets)
# 8) Model building using Training dataset 

## 8.1) #using catboost and analyze feature importance 
## 8.2) using factor analysis and analyze factor importance 

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
# newly added 
require(catboost)
require(mlbench)

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



# 5. Filling missing values
DF[is.na(DF)] <- 0 


###############
# 7 & 8
## catboost
###############
## https://stackoverflow.com/questions/60440590/r-catboost-to-handle-categorical-variables

library(caret)
library(catboost)
library(mlbench)
data(DF)
#create train and test data sets:

set.seed(1)

tr <- createDataPartition(DF$Class, p = 0.7, list = FALSE)

trainer <- DF[tr,]
tester <- DF[-tr,]
#train models:

fitControl <- trainControl(method = "cv",
                           number = 3,
                           savePredictions = TRUE,
                           summaryFunction = twoClassSummary,
                           classProbs = TRUE)

model <- train(x = trainer[,1:60],
               y = trainer$Class,
               method = catboost.caret, 
               trControl = fitControl, 
               tuneLength = 5,
               metric = "ROC")
#predict using caret:

preds1 <- predict(model, tester, type = "prob")
# save the final model:

catboost::catboost.save_model(model$finalModel, "model")
#load the saved model:

model2 <- catboost::catboost.load_model("model")
#predict using the saved model:

preds2 <- catboost.predict(model2,
                           catboost.load_pool(tester),
                           prediction_type = "Probability")
#check equality of predictions

all.equal(preds1[,2], preds2)


saveRDS(model, "caret.model.rds")
model3 <- readRDS("caret.model.rds")
preds3 <- predict(model3, tester, type = "prob")


