# Katja Junttila, 29.11.2020, Exercise 6

# Access dplyr and tidyr
library(dplyr)
library(tidyr)

# Read the data sets BPRS and RATS
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep = " ", header = T)
RATS <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = "\t", header = T)

# Check structures
str(BPRS)    # 'data.frame':	40 obs. of  11 variables, all variables integers
str(RATS)    # 'data.frame':	16 obs. of  13 variables, all variables integers

# Check variable names
names(BPRS)    # "treatment" "subject" "week0" "week1" "week2" "week3" "week4" "week5" "week6" "week7" "week8"  
names(RATS)    # "ID" "Group" "WD1" "WD8" "WD15" "WD22" "WD29" "WD36" "WD43" "WD44" "WD50" "WD57" "WD64"

# Glimpse the data
glimpse(BPRS)
glimpse(RATS)

# Print out summaries
summary(BPRS)    # "treatment" and "subject" are categorical variables
summary(RATS)    # "ID" and "Group" are categorical variables

# Convert categorical variables to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# Create variable ID for BPRS
BPRS$ID <- factor(1:nrow(BPRS))

# Convert BPRS to long form, add a week variable
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject, -ID)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(BPRSL$weeks, 5, 5)))

# Convert RATS to long form, add a Time variable
RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4))) 

# Taking a serious look at the new data
# Check structures
str(BPRSL) # 'data.frame':	360 obs. of  5 variables
str(RATSL) # 'data.frame':	176 obs. of  5 variables

# Check variable names
names(BPRSL) # "treatment" "subject" "weeks" "bprs" "week"
names(RATSL) # "ID" "Group" "WD" "Weight" "Time"

# Glimpse the data
glimpse(BPRSL)
glimpse(RATSL)

# Print out summaries
summary(BPRSL)
summary(RATSL)

# Save the new BPRSL and RATSL data sets
write.csv(BPRSL, "data/BPRSL.csv", row.names = F)
write.csv(RATSL, "data/RATSL.csv", row.names = F)
