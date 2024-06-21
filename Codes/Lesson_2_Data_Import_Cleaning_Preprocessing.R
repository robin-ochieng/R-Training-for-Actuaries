#Importing the necessary Packages
library(readr)
library(readxl)
library(dplyr)


#Importing csv datasets using readr package
#C:/Users/Robin Ochieng/OneDrive - Kenbright/Attachments/projects/2024/May/R Training/Data/Data_CSV.csv
data_csv <- read.csv("path/to/your/file.csv")

#General method for reading in tabular data
data <- read.table("path/to/file.csv", sep = ",", header = TRUE)

#Fast and flexible reader from the data.table package
library(data.table)
data <- fread("path/to/file.csv")

#Importing excel datasets
data_excel <- read_excel("C:/Users/Robin Ochieng/OneDrive - Kenbright/Attachments/projects/2024/May/R Training/Data/Data_Excel.xlsx")



#2) Data Cleaning and Pre processing Techniques

#a)Checking and Handling Duplicates
# Check for duplicates
duplicates <- duplicated(data_excel) 
nrow(duplicates)

# You can also see which rows are duplicates
View(data_excel[duplicates, ])

# Removing Duplicate Values 
# Using unique()
clean_data1 <- unique(data_excel)
View(clean_data1)


# Using !duplicated()
clean_data2 <- data[!duplicated(data), ]
print(clean_data2)

#b)Rename Columns for clarity and accessibility
names(data_excel)[names(data_excel) == "Statutory Class"] <- "Class"


#c) Transforming Data i.e adding a new column in our dataset
data_excel <- data_excel %>% 
  mutate(`Gross_Paid_Dollar` = `Gross Paid` / 132)


#3). Dealing with Missing Values and Outliers
#a. Detecting missing values in our Dataset
missing_values = sum(is.na(data_excel$`Gross Paid2`))
print(missing_values)

#b. Handling missing values by imputation or removal
# Imputation by mean or median - Use median for skewed data
# Impute missing values in column A with the mean of A
data_excel$`Gross Paid2` <- ifelse(is.na(data_excel$`Gross Paid2`), mean(data_excel$`Gross Paid2`, na.rm = TRUE), data_excel$`Gross Paid2`)

# Impute missing values in column B with the median of B
data$`Gross Paid2` <- ifelse(is.na(data$`Gross Paid2`), median(data$`Gross Paid2`, na.rm = TRUE), data$`Gross Paid2`)

data$`Gross Paid2` <- na.omit(data$`Gross Paid2`)

# Display the updated data frame
print(data)

#b. Dealing with Outliers in our Dataset - FINDING, COUNTING and Printing Outliers in our dataset
# FINDING OUTLIERS
# Calculate the first and third quartile
Q1 <- quantile(data_excel$`Gross Paid`, 0.050)
Q3 <- quantile(data_excel$`Gross Paid`, 0.950)
IQR <- Q3 - Q1

# Define outliers as those outside of Q1 - 1.5*IQR and Q3 + 1.5*IQR
outliers <- data_excel$`Gross Paid` < (Q1 - 1.5 * IQR) | data_excel$`Gross Paid` > (Q3 + 1.5 * IQR)

# COUNTING OUTLIERS
# Count the number of outliers
outlier_count <- sum(outliers)
# Print the number of outliers 
print(outlier_count)

# PRINTING/VIEWING OUTLIERS present in our DATASET
# Extract rows that contain outliers
outlier_data <- data_excel[outliers, ]
# Print the outlier values
View(outlier_data)



#EXPORTING DATA FROM R TO EXCEL AND CSV FORMATS
#a). Exporting Data to CSV Format
write.csv(data_excel, "whole Data.csv")


#Exporting Data to Excel Format
install.packages("openxlsx")
library(openxlsx)

#a). Exporting Data to Excel Format
write.xlsx(data_excel, "data20.xlsx")



