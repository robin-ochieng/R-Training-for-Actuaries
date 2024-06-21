# Load the packages
library(dplyr)
library(lubridate)
library(readxl)
library(ggplot2)


#1. Creating date and time objects using Lubridate functions

now()#Output today's date and time 

today()#Output today's date


ymd <- ymd("2017-03-30")#if data comes as year month date format use ymd format
class("2017-03-30")
class(ymd)

mdy <- mdy("March 30th, 2017")#if data comes as month date year format use mdy format
class(mdy)

dmy <- dmy("30-Mar-2017")#if data comes as month year date format use mdy format
class(dmy)

ymd_hms("2017-03-30 20:11:59")#Add an underscore and one or more of 'h', 'm', and 's'to the name parsing function

mdy_hm("03/30/2017 08:01")

make_date(year=2017, day=12, month=1)

install.packages("nycflights13")
library(nycflights13)#An Inbuilt flight data that you can access by installing and loading the nycflights13 package
View(flights)

flights_data <- flights %>% 
  select(origin, year, month,day,hour,minute)
View(flights_data)

#Parsing data to create objects 
flights_data <- flights_data %>%
  mutate(flight_date = ymd_hm(paste(year, month, day, hour, minute)))
View(flights_data)

#Another function to create date time is the make_datetime()
flights_data <- flights_data %>%
  mutate(flight_date2 = make_datetime(year, month, day, hour, minute))
View(flights_data)

#Another function to create date is the make_date()
flights_data <- flights_data %>%
  mutate(flight_date3 = make_date(year, month, day))
View(flights_data)


#2)Extracting Date-Time data
#Lubridate equips us with extra functions to allow plucking of specific components from date time objects
#Assuming we want to know the weekday or month from a date object
flights_data <- flights_data %>%
  mutate(weekday = wday(flight_date3, label = T),
         month_name = month(flight_date3, label = T),
         weekday_full = wday(flight_date3, label = T, abbr = FALSE),
         month_name_full = month(flight_date3, label = T, abbr = FALSE))
View(flights_data)

#3). Arithmetic with date-time data
#Calculate the date and time in exactly 30 years from now
now()+years(30)

#Filter for the month of september using Boolean Operators
september_flights_data <- flights_data %>%
  filter(flight_date >= ymd("2013-09-01")&flight_date < ymd("2013-10-01"))
View(september_flights_data)

#4). Time Spans(duration, periods and intervals)
#a)Duration-An exact number of Seconds, 
my_duration <- dseconds(15)
print(my_duration)
dminutes(4)
dmonths(5)
ymd("2016-01-01")+dyears(10)
ymd("2016-01-01")+dmonths(6)

#b)Period - A span of time represented in Human unit of time like weeks and months, 
ymd("2016-01-01")+years(10)#Much better compared to duration
months(3)+days(1)+hours(11)+minutes(8)#You can also add periods
months(9)*10

#c)Intervals - time span that must have a defined start and a defined end point 
start <- ymd_hms("2023-01-01 12:00:00")
end <- ymd_hms("2023-01-15 12:00:00")
interval <- interval(start, end) 

#We can also use mathematical operators to compare two intervals
start2 <- ymd_hms("2023-01-01 12:00:00")
end2 <- ymd_hms("2023-01-11 12:00:00")
interval2 <- interval(start2, end2)

interval < interval2


#We can also Convert duration to periods
as.duration(interval)
as.period(interval)





# importing the dataset
df <- read_excel("C:/Users/Robin Ochieng/OneDrive - Kenbright/Attachments/projects/2024/May/R Training/Data/Data_Excel.xlsx")

# Ensure all date columns are in Date format
df <- df %>%
  mutate(
    `Loss Date` = as.Date(`Loss Date`, format="%Y-%m-%d"),
    `Reported` = as.Date(`Reported`, format="%Y-%m-%d"),
    `Paid Date` = as.Date(`Paid Date`, format="%Y-%m-%d"))

# Compute the number of days between "Loss Date" and "Reported"
df <- df %>%
  mutate(Days_Loss_to_Reported = as.numeric(`Reported` - `Loss Date`))

# Compute the number of days between "Loss Date" and "Paid Date"
df <- df %>%
  mutate(Days_Loss_to_Paid = as.numeric(`Paid Date` - `Loss Date`))

# Extract the year from "Loss Date", "Paid Date", and "Reported" and create a summary per year
year_summary <- df %>%
  mutate(
    Year_Loss = year(`Loss Date`),
    Year_Paid = year(`Paid Date`),
    Year_Reported = year(`Reported`)
  ) %>%
  group_by(Year_Loss, Year_Paid, Year_Reported) %>%
  summarise(Count = n())

# Calculate the age of each claim by finding the difference between the current date and "Paid Date"
df <- df %>%
  mutate(Claim_Age = as.numeric(Sys.Date() - `Paid Date`))

# Create a subset of data for claims reported in the first quarter of any year
first_quarter_claims <- df %>%
  filter(month(`Reported`) %in% 1:3)

# Plot the trend of "Gross Paid" amounts by month
df %>%
  mutate(Month = floor_date(`Loss Date`, "month")) %>%
  group_by(Month) %>%
  summarise(Total_Gross_Paid = sum(`Gross Paid`, na.rm = TRUE)) %>%
  ggplot(aes(x = Month, y = Total_Gross_Paid)) +
  geom_line() +
  labs(title = "Trend of Gross Paid Amounts by Month", x = "Month", y = "Gross Paid")

# Determine which claims were reported on weekends
df <- df %>%
  mutate(Reported_Weekend = weekdays(`Reported`) %in% c("Saturday", "Sunday"))

# Calculate the number of days from "Reported" to "Paid Date" for each claim
df <- df %>%
  mutate(Days_Reported_to_Paid = as.numeric(`Paid Date` - `Reported`))

# Extract the week number from "Loss Date" and create a summary of the number of claims per week
week_summary <- df %>%
  mutate(Week_Number = week(`Loss Date`)) %>%
  group_by(Week_Number) %>%
  summarise(Count = n())

# Filter claims that were reported within a specific date range
filtered_claims <- df %>%
  filter(`Reported` >= as.Date("2022-01-01") & `Reported` <= as.Date("2023-12-01"))

# Create buckets for claim ages and summarize the number of claims in each bucket by class
df <- df %>%
  mutate(
    Age_Bucket = cut(Claim_Age, breaks = c(-Inf, 30, 60, 90, 120, Inf), labels = c("0-30 days", "31-60 days", "61-90 days", "91-120 days", "120+ days"))
  )

age_bucket_summary <- df %>%
  group_by(Age_Bucket, `Statutory Class`) %>%
  summarise(Count = n())

# Calculate the average number of claims reported each day
average_claims_per_day <- df %>%
  mutate(Report_Day = as.Date(`Reported`)) %>%
  group_by(Report_Day) %>%
  summarise(Daily_Count = n()) %>%
  summarise(Average_Daily_Claims = mean(Daily_Count))

# Analyze the number of claims reported by day of the week
claims_by_day_of_week <- df %>%
  mutate(Day_of_Week = weekdays(`Reported`)) %>%
  group_by(Day_of_Week) %>%
  summarise(Count = n())

# Identify the top 10 claims with the longest duration between "Loss Date" and "Paid Date"
top_10_longest_claims <- df %>%
  arrange(desc(Days_Loss_to_Paid)) %>%
  top_n(10, Days_Loss_to_Paid)

# Calculate the quarterly trend of "NetPaid" amounts
df %>%
  mutate(Quarter = paste(year(`Loss Date`), quarter(`Loss Date`), sep = "-Q")) %>%
  group_by(Quarter) %>%
  summarise(Total_NetPaid = sum(NetPaid, na.rm = TRUE)) %>%
  ggplot(aes(x = Quarter, y = Total_NetPaid)) +
  geom_line() +
  labs(title = "Quarterly Trend of NetPaid Amounts", x = "Quarter", y = "NetPaid")

# Calculate the median reporting delay for each month
monthly_median_reporting_delay <- df %>%
  mutate(Report_Month = floor_date(`Reported`, "month")) %>%
  group_by(Report_Month) %>%
  summarise(Median_Reporting_Delay = median(Days_Loss_to_Reported, na.rm = TRUE))

# Find the maximum claim age for each "Statutory Class"
max_claim_age_per_class <- df %>%
  group_by(`Statutory Class`) %>%
  summarise(Max_Claim_Age = max(Claim_Age, na.rm = TRUE))
