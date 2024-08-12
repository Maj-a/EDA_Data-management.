
#######  2 -  Data Management: Glassdoor Gender Pay Gap

### 0. Import packages and libraries
library(dplyr)
install.packages("openxlsx")
library(openxlsx)
library(ggplot2)
### 1. Import Glassdoor Gender Pay Gap data and name it as GPGdata.
GPGdata<-read.csv(file.choose(), header=T)

### 2. Check number of rows, columns in the data.
dim(GPGdata)

### 3. Display first 10 rows and last 5 rows.
head(GPGdata, n=10)
tail(GPGdata, n=5)

### 4. Describe (summarize) all variables, check for missing values and duplicates. 
## a) Summary
summary(GPGdata)

## b) Checking if missing values are present
MissingV_by_columns <- colSums(is.na(GPGdata))
print("Missing Values in GPGdata data set by columns:")
print(MissingV_by_columns)
### --> Observation: No missing values detected. 

## c) Checking for duplicates
# Find exact duplicate rows
duplicates_all <- GPGdata %>% 
  filter(duplicated(.) | duplicated(., fromLast = TRUE))
# Print the number of duplicate rows
print(nrow(duplicates_all))
# Print the duplicate rows themselves
print(duplicates_all)

### --> Observation:No duplicates detected.
# Should duplicates be present: Removing duplicates while keeping the first occurrence
#cleaned_data <- GPGdata %>% 
#  distinct()
# Printing the number of rows after removing duplicates
# print(nrow(cleaned_data))

### 5. Display top 5 and bottom 5 salaries in terms of BasePay amount.
GPGdataTop<-GPGdata[order(-GPGdata$BasePay),]
top5<- head(GPGdataTop, n=5)
print(top5)
GPGdataBottom<-GPGdata[order(GPGdata$BasePay),]
bottom5 <- head(GPGdataBottom, n=5)
print(bottom5)
print(is.data.frame(bottom5))

# Visualisation: 5 top and 5 bottom salaries
# Visualisation: 5 top salaries
# Add RowID to bottom5
top5 <- top5 %>% 
  mutate(RowID = row_number())
top5_plot <- ggplot(data = top5, aes(x = as.factor(RowID), y = BasePay, fill = JobTitle)) +
  geom_col(fill = "violetred") +
  theme_classic() +
  labs(title = " Top 5 Salaries", x = "Employee", y = "Base Pay") +
  scale_x_discrete(labels = bottom5$JobTitle) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(top5_plot)

# Visualisation: 5 bottom salaries
# Add RowID to bottom5
bottom5 <- bottom5 %>% 
  mutate(RowID = row_number())
bottom5_plot <- ggplot(data = bottom5, aes(x = as.factor(RowID), y = BasePay, fill = JobTitle)) +
  geom_col(fill = "steelblue") +
  theme_classic() +
  labs(title = "Bottom 5 Salaries", x = "Employee", y = "Base Pay") +
  scale_x_discrete(labels = bottom5$JobTitle) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(bottom5_plot)

### 6. Calculate the sum for variable ‘BasePay’ by ‘Dept’  variable.
BasePay_ByDept<-aggregate(BasePay~Dept, data=GPGdata, FUN = sum)
BasePay_ByDept

# second method:
BasePay_ByDept2<-GPGdata%>%
  group_by(Dept)%>%
  summarise(Total_BasePay_per_Dept=sum(BasePay))%>%
  as.data.frame()
BasePay_ByDept2 

ggplot(BasePay_ByDept2, aes(x = Dept, y = Total_BasePay_per_Dept / 1000000)) +
  geom_col(fill="turquoise3") +
  geom_text(aes(label = round(Total_BasePay_per_Dept / 1000000, 2)), 
            vjust = -0.3, # Adjusts the vertical position of the text
            size = 4) +   # Adjusts the size of the text
  theme_light() +
  labs(title = "Total (sum) of Base Pay by Department", x = "Department", y = "Base Pay (in millions)")

### 7. Create a subset of Employees from Management Department with BasePay < = 60,000.
###    Keep variables: Bonus, Seniority, Education and Gender in the subset data.

GPG_below_60<-subset(GPGdata, Dept =="Management" & BasePay <= 60000, 
                     select=c(BasePay,Bonus,Seniority,Education,Gender))
head(GPG_below_60)

# Another way of creating a specific subset
GPG_below_60_2<-GPGdata%>%
  filter(Dept == "Management", BasePay <= 60000)%>%
  select(Bonus,Seniority,Education,Gender, BasePay)%>%
  arrange(desc(BasePay))

GPG_below_60_2  
head(GPG_below_60_2)
tail(GPG_below_60_2)

# Counting how many ee at Management level is paid below 60k per year.
countGPG_below_60_2<-count(GPG_below_60_2)
countGPG_below_60_2

# --> Observation: There are 13 Managers who earn BasePay below 60 000 per year. 

### 8. Export the subsetted data into an xlsx file.
write.xlsx(GPG_below_60_2, 'C:\\Users\\Maja\\Desktop\\output.xlsx', colNames=TRUE)

# another way: 
write.xlsx(GPG_below_60_2,file.choose())
