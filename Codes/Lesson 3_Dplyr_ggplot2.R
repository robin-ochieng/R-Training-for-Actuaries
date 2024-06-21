#Loading the packages
library(MASS)
library(dplyr)
library(ggplot2)
library(readxl)
library(lubridate)

#Loading the dataset
data <- read_excel("C:/Users/Robin Ochieng/OneDrive - Kenbright/Attachments/projects/2024/May/R Training/Data/Data_Excel.xlsx", 
                   col_types = c("text", "date", "date", 
                                 "date", "text", "numeric", "numeric", 
                                 "text", "text", "text", "text", "text", 
                                 "text", "numeric"))

#1).DPLYR
#Check the first 5 rows
View(head(data))

#Using the Various dplyr Functions
#1. # Group data by 'Category', sum 'Gross Paid' and 'Net Paid' excluding NAs, and print results.
summary_data <- data %>%
  group_by(Category) %>%
  summarize(`Gross Paid` = mean(`Gross Paid`, na.rm = T), `Net Paid` = mean(NetPaid, na.rm = T))

print(summary_data)


# Convert the 'Gross Paid' column to TZ shillings and store in a new column named 'Gross_Paid_Tz'.
conversion_rate <- 19.77

data1 <- data %>%
  mutate(Gross_Paid_Tz = `Gross Paid` * conversion_rate) 

View(data1)


#3. Filter Out the Marine class data 
marine_data <- filter(data, `Statutory Class` == "MARINE")

View(marine_data)

#4. Filter Out the Marine class data 
filtered_data <- filter(data, `Gross Paid` >= 20000000)
View(filtered_data)

#5) Select the Loss Date, Paid Date and Statutory Class Columns from the dataset 
selected_columns <- select(data, `Loss Date`, `Paid Date`, `Statutory Class`)
View(selected_columns)

#5) Arranging the data by NetPaid column in descending order
arranged_data <- arrange(data, desc(NetPaid))
View(arranged_data)

#6. Counting the number of entries per Category 
category_count <- count(data, Category)
print(category_count)

#7. Getting the unique values of Category
distinct_category <- distinct(data, Category)
print(distinct_category)

#8).How Many Claims were reported each year
claims_per_year <- data %>%
  mutate(Year = year(Reported)) %>%
  group_by(Year) %>%
  summarise(Count = n())
View(claims_per_year)

#9). What is the average NetPaid amount per Category?
average_netpaid <- data %>%
  group_by(Category) %>%
  summarise(Average_NetPaid = mean(NetPaid, na.rm = TRUE))
print(average_netpaid)

#10) Which Statutory Class has the highest total Gross Paid?
total_gross_paid <- data %>%
  group_by(`Statutory Class`) %>%
  summarise(Total_Gross_Paid = sum(`Gross Paid`, na.rm = TRUE))
View(total_gross_paid)

#11 How does the payment delay vary across different Categories?
payment_delays <- data %>%
  mutate(Delay = as.numeric(`Paid Date` - `Loss Date`)) %>%
  group_by(Category) %>%
  summarise(Average_Delay = mean(Delay, na.rm = TRUE))
print(payment_delays)





#2).GGPLOT2 

#1).Bar Plot of Total Claims per District
# Group the data by Category then summarize by `Gross Paid`

#Bar Plot
ggplot(summary_data, aes(x = Category, y = `Gross Paid`, fill = Category)) +
  geom_bar(stat = "identity") +
  labs(title = "Gross Paid per Category", x = "Category", y = "Gross Paid") +
  theme_minimal()

#2) Scatter Plot of Gross Paid versus Net Paid with points colored by Category and a linear regression line added
ggplot(data, aes(x = `Gross Paid`, y = NetPaid)) +
  geom_point(aes(color = Category)) +
  labs(title = "Scatter Plot of Gross Paid vs. NetPaid", x = "Gross Paid", y = "Net Paid") +
  theme_light() +
  geom_smooth(method = "lm", se = FALSE)  # Add a linear regression line without confidence interval

#3) Plotting the box plot to show the distribution of payment delays in each category
ggplot(data, aes(x = Category, y = `Gross Paid`, fill = Category)) +
  geom_boxplot() +
  labs(title = "Box Plot of Gross Paid per Category", x = "Category", y = "Gross Paid") +
  theme_bw()#adds a black and white theme

#4) Plotting Reported claims per year
ggplot(claims_per_year, aes(x = Year, y = Count)) +
  geom_col(fill = "steelblue") +
  labs(title = "Claims Reported Each Year", x = "Year", y = "Number of Claims")

#5) statutory class by gross paid
ggplot(total_gross_paid, aes(x = `Statutory Class`, y = Total_Gross_Paid, fill = `Statutory Class`)) +
  geom_bar(stat = "identity") +
  labs(title = "Total Gross Paid by Statutory Class", x = "Statutory Class", y = "Total Gross Paid") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


