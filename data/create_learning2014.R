# Katja Junttila, 4.11.2020, Excercise 2

# Install dplyr package
install.packages("dplyr")

# Access the dplyr library
library(dplyr)

# Read the data
lrn2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",
                  header = T, sep = "\t")

# Explore the structure and dimensions
str(lrn2014)
dim(lrn2014)
# The lrn2014 data has 183 observations of 60 variables.

# Combine questions related to deep, surface, and strategic learning.
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30",
                   "D06", "D15","D23", "D31")
surface_questions <- c("SU02", "SU10", "SU18", "SU26", "SU05", "SU13", "SU21",
                       "SU29", "SU08", "SU16", "SU24", "SU32")
strategic_questions <- c("ST01", "ST09", "ST17", "ST25", "ST04", "ST12",
                         "ST20", "ST28")

# Create variables deep, surf, and stra, scale them by averaging
deep_columns <- select(lrn2014, one_of(deep_questions))
lrn2014$deep <- rowMeans(deep_columns)

surf_columns <- select(lrn2014, one_of(surface_questions))
lrn2014$surf <- rowMeans(surf_columns)

stra_columns <- select(lrn2014, one_of(strategic_questions))
lrn2014$stra <- rowMeans(stra_columns)

# Create analysis dataset with gender, age, attitude, deep, stra, surf, and
# points.
analysis_columns <- c("gender", "Age", "Attitude", "deep", "stra", "surf",
                      "Points")
learning2014 <- select(lrn2014, one_of(analysis_columns))

# Get rid of capital letters.
colnames(learning2014)[2] <- "age"
colnames(learning2014)[3] <- "attitude"
colnames(learning2014)[7] <- "points"

# Exclude observations where exam points is zero.
learning2014 <- filter(learning2014, points != 0)

# Set the working directory to IODS-project folder.
setwd("~/Ohjelmointi/Open Data Science/IODS-project")

# Save the analysis dataset to data folder.
write.csv(learning2014,
          "~/Ohjelmointi/Open Data Science/IODS-project/data/learning2014.csv",
          row.names = F)

# Read the saved data and check the structure.
check_lrn <- read.csv("./data/learning2014.csv")
str(check_lrn)
head(check_lrn)
