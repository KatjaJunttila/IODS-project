# Katja Junttila, 19.11.2020, Exercise 4

# Wrangling "Human development" data from http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv
# and "Gender inequality" data from http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv

# Access dplyr
library(dplyr)

# Read the "Human development" data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

# Read the "Gender inequality" data
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Explore the structure and dimensions of the data sets
str(hd)
dim(hd)
str(gii)
dim(gii)

# Create summaries of the variables
summary(hd)
summary(gii)

# Shorter names for variables
colnames(hd) <- c("hdirank", "country", "hdi", "explife", "expedu", "meanedu",
                 "gni", "diffrank")
colnames(gii) <- c("hdirank", "country", "gii", "matmor", "adobirth", "fparl",
                   "fedu", "medu", "flab", "mlab")

# Create new variables for f/m ratio in secondary education and labour force
gii <- mutate(gii, eduratio = fedu/medu, labratio = flab/mlab)

# Join the two data sets using country as the identifier
human <- inner_join(hd, gii, by = "country")

# Save the new human data set
write.csv(human, "data/human.csv", row.names = F)
