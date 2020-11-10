# Katja Junttila, 10.11.2020, Exercise 3

# Wrangling student performance data from https://archive.ics.uci.edu/ml/datasets/Student+Performance

# Access the dplyr library
library(dplyr)

# Read the data
mat <- read.table("data/student-mat.csv", sep = ";", header = T)
por <- read.table("data/student-por.csv", sep = ";", header = T)

# Explore structure and dimensions
str(mat)
str(por)
dim(mat)
dim(por)

# Define the variables used as identifiers
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu",
             "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

# Join the two data sets using the selected identifiers
mat_por <- inner_join(mat, por, by = join_by)

# Explore structure and dimensions
str(mat_por)
dim(mat_por)

# create a new data frame with only the joined columns
alc <- select(mat_por, one_of(join_by))

# columns that were not used for joining the data
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(mat_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column  vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# Create average weekday and weekend alcohol consumption
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# Create a logical column of "high_use"
alc <- mutate(alc, high_use = alc_use > 2)

# Glimpse at the data
glimpse(alc)

write.csv(alc, "data/alc.csv", row.names = F)
