# Katja Junttila, 19.11.2020, Exercise 4
# Includes also work from 23.11.2020, Exercise 5, see below

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

# Exercise 5 starts here

# Load the human data
human <- read.csv("data/human.csv")

# The data set originates from the United Nations Development Programme.
# It consists of indicators of human development.
# Explanations of variables:
# expedu = expected years of schooling
# explife = life expectancy at birth
# gni = gross national Income per capita
# matmor = maternal mortality ratio
# adobirth = adolescent birth rate
# fparl = percetange of female representatives in parliament
# eduratio = ratio of females to males with at least secondary education
# labratio = ratio of females to males in the labour force

# Explore the structure and dimensions of the data
str(human)
dim(human)

# Access stringr
library(stringr)

# Transform the gni variable to numeric
human$gni <- str_replace(human$gni, pattern=",", replace ="") %>% as.numeric

# Exclude unneeded variables
keep <- c("country", "eduratio", "labratio", "expedu", "explife", "gni",
          "matmor", "adobirth", "fparl")
human <- select(human, one_of(keep))

# Remove rows with missing values
human <- filter(human, complete.cases(human))

# Remove observations related to regions instead of countries
last <- nrow(human) - 7
human <- human[1:last,]

# Define row names by country names
rownames(human) <- human$country

# Remove the country column
human <- select(human, -country)

# Save the new human data set
write.csv(human, "data/human.csv", row.names = T)
