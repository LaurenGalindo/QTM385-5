## SQL in R
## Source of this content: 
## https://dept.stat.lsa.umich.edu/~jerrick/courses/stat701/notes/sql.html

## sqldf package
library(sqldf)
data("mtcars")
sqldf("SELECT * FROM mtcars LIMIT 6")
  # The parts that belong to SQL can be any case, but the parts in R are case-sensitive!

## The sqldf package is incredibly simple, 
## from R’s point of view. There is a single 
## function are concerned about: sqldf. 
## Passed to this function is a SQL statement, such as:

 # sqldf('SELECT age, circumference FROM Orange WHERE Tree = 1 ORDER BY circumference ASC')

## SQL Queries

# There are a large number of SQL 
# major commands1. Queries are 
# accomplished with the SELECT command. 
# First a note about convention:
  
# By convention, SQL syntax is written 
# in all UPPER CASE and variable names/database 
# names are written in lower case. Technically, 
# the SQL syntax is case insensitive, so it 
# can be written in lower case or otherwise. 
# Note however that R is not case insensitive, 
# so variable names and data frame names must 
# have proper capitalization. Hence:

sqldf("SELECT * FROM iris")

# Same as
iris

# And this should fail:
sqldf("SELECT * from IRIS")

# Now with limit
sqldf("SELECT * FROM iris LIMIT 5")

## Exercise: build a query that computes the average
## mpg by cyl in the mtcars dataset.
sqldf('SELECT cyl, AVG(mpg) 
      FROM mtcars
      GROUP BY cyl')

## Run Python in R
## from: https://www.listendata.com/2018/03/run-python-from-r.html

# Install reticulate package
install.packages("reticulate")

# Load reticulate package
library(reticulate)

# Check if python is available
py_available()

## Where is my Python?
Sys.which("python")

## Making it available:
use_python(as.character(Sys.which("python")))

## Importing libraries:
os <- import("os") # os is the name of the library (ex: pandas, numpy, etc.)
os$getcwd() # Python function
  getwd() # R function

## Some linear algebra:
numpy <- import("numpy")
y <- array(1:6, c(2, 3)) 
x <- numpy$array(y) 
numpy$transpose(x)


# Eigen analysis:
numpy$linalg$eig(x)

## Installing packages:
conda_install("r-reticulate", "pandas") # loading pandas into the reticulate package now

## Now going to Python: (opens up a python)
repl_python()
# Load Pandas package
import pandas as pd
# Importing Dataset
tips = pd.read_csv("https://raw.githubusercontent.com/umbertomig/qtm151/main/datasets/tips.csv")
# Number of rows and columns
tips.shape
# Select random no. of rows 
tips.sample(n = 10)
# Return to R
exit

## Access a Python object in R:
py$tips

## And vice-versa: accessing an R object in
## Python?
myMtcars = head(mtcars)

## Some serious interactive Python code:
repl_python()
import pandas as pd
r.myMtcars.describe()
pd.isnull(r.myMtcars.disp)
exit

## My Python version:
py_config()

## Do I have a package?
py_module_available("pandas")
py_module_available("matplotlib")

## That's all, folks! Thank you so much for the
## semester!