library(tidyr)
library(dplyr)
library(readxl)

# 1. Loading the dataset
data <- read_excel("C:/Users/Robin Ochieng/OneDrive - Kenbright/Attachments/projects/2024/May/R Training/Data/Data_Excel.xlsx", 
                   col_types = c("text", "date", "date", 
                                 "date", "text", "numeric", "numeric", 
                                 "text", "text", "text", "text", "text", 
                                 "text", "numeric"))

# 2. Separate Date into Year, Month, and Day
data_sep <- separate(data, `Loss Date`, into = c("Loss_Year", "Loss_Month", "Loss_Day"), sep = "-")

# 3. Combine Year, Month, and Day into Date
data_unite <- unite(data_sep, `Loss Date`, Loss_Year, Loss_Month, Loss_Day, sep = "-")

# 4. Handle Missing Data
missing_before <- sum(is.na(data$`Gross Paid2`))
data_fill <- fill(data, `Gross Paid2`, .direction = "down")  # Assumes downward filling is what's needed
missing_after <- sum(is.na(data_fill$`Gross Paid2`))

# 5. Pivot Specific Columns
data2 <- select(data, `Gross Paid`, `Gross Paid2`)
data_pivot_long <- pivot_longer(data2, cols = c(`Gross Paid`, `Gross Paid2`), names_to = "Gross_Paid_Type", values_to = "Gross_Paid_Amount")

# 6. Multiple Separations
data_sep2 <- separate(data, `1ST.TREATY`, into = c("Treaty_Type", "Treaty_Amount"), sep = 1)
data_sep3 <- separate(data_sep2, `2ND.TREATY`, into = c("Treaty_Type2", "Treaty_Amount2"), sep = 1)

# 7. Nested Separations
data_sep_nested <- separate(data, `Loss Date`, into = c("Loss_Year_Month", "Loss_Day"), sep = "-")
data_sep_nested <- separate(data_sep_nested, Loss_Year_Month, into = c("Loss_Year", "Loss_Month"), sep = "-")

# 8. Combining Multiple Columns
data_unite2 <- unite(data, "Claim_Identifier", c(Category, `Loss Date`, `Statutory Class`), sep = "_")

# 9. Replacing NA Values
data_replace_na <- replace_na(data, list(`Gross Paid2` = 0))

# 10. Monthly Claims Summary
data_month <- separate(data, `Loss Date`, into = c("Loss_Year", "Loss_Month", "Loss_Day"), sep = "-")
monthly_summary <- data_month %>%
  group_by(Loss_Month) %>%
  summarize(`Total Gross Paid` = sum(`Gross Paid`))

# 11. Claims by Category and Year
data_year <- separate(data, `Loss Date`, into = c("Loss_Year", "Loss_Month", "Loss_Day"), sep = "-")
category_year_summary <- data_year %>%
  group_by(Category, Loss_Year) %>%
  summarize(`Total Gross Paid` = sum(`Gross Paid`))
