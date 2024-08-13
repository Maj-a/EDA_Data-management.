# EDA_Data-management -> Data Inspection.
Exploratory Data Analysis -> Data Management -> Data Inspection 
This stage involves reviewing the data within your environment. I call it a “getting to know the data” phase, where you examine the number and types of variables (columns) and observations (rows) to understand the data structure.

## Background: 
The data for analysis is a Glassdoor Gender Pay Gap data obtained from Kaggle in which base pay and bonus, seniority, education level/type and gender information are provided for each employee, the job titles and departments are also included.
Link to the data set as accessed on the 04.07.2024: https://www.kaggle.com/datasets/nilimajauhari/glassdoor-analyze-gender-pay-gap/data 
(The reason why the link has not been provided as a hyperlink is to be transparent about the source of the data & security.)

## Here's what we'll explore in this project: 
1. **Import the Data:** We'll start by bringing in the Glassdoor Gender Pay Gap data, which we'll call GPGdata.
2. **Initial Data Check:** We'll examine the number of rows and columns to understand the size of the data.
3. **Sneak Peek:** Let's take a look at the first 10 and last 5 rows of the dataset.
4. **Data Summary:** We'll summarize all the variables, checking for any missing or duplicated data.
5. **Salary Insights:** We'll find out who earns the top 5 and bottom 5 salaries based on BasePay.
6. **Sum It Up:** We'll calculate the total BasePay for each department.
7. **Focused Subset:** We'll create a subset of employees in the Management Department with a BasePay of $60,000 or less, keeping variables like Bonus, Seniority, Education, and Gender.
7. **Exporting Results:** Finally, we'll save this subset as an Excel file.
## Ready to dive in? Just keep scrolling! 
### 0. Import packages and libraries
```r
library(dplyr)'
install.packages("openxlsx")'
library(openxlsx)
library(ggplot2)
```
### 1. Import Glassdoor Gender Pay Gap data and name it as GPGdata.
'GPGdata<-read.csv(file.choose(), header=T)'

### 2. Check number of rows, columns in the data.
```r
dim(GPGdata)
```
![image](https://github.com/user-attachments/assets/d035d3a2-4502-40ee-9a80-2b97998fd645)

#### --> Observation: This dataset contains 1000 rows and 9 columns.
### 3. Display first 10 rows and last 5 rows.
```r
head(GPGdata, n=10)
tail(GPGdata, n=5)
```

####--> Display of first 10 rows
![image](https://github.com/user-attachments/assets/57b8ab19-672c-4c4c-becf-cceaf9358e4e)

####--> Display of last 5 rows
![image](https://github.com/user-attachments/assets/e9b79955-d0e6-4ec1-bdb9-9eff11ea7fed)

### 4. Describe (summarize) all variables, check for missing values and duplicates.
### a) Summary
```r
summary(GPGdata)
```
![image](https://github.com/user-attachments/assets/4396cd47-e2d2-4776-979e-150394d8e692)

#### --> Observation: 
The GPGdata dataset comprises 1,000 records with a mix of data types. The JobTitle, Gender, Education, and Dept columns are categorical variables. Age is a numerical variable ranging from 18 to 65, with a median of 41. PerfEval (Performance Evaluation) is an ordinal variable ranging from 1 to 5, with a median score of 3. Seniority is also ordinal, with values from 1 to 5 and a median of 3. Both BasePay and Bonus are continuous numerical variables; BasePay ranges from $34,208 to $179,726 with a median of $93,328, while Bonus ranges from $1,703 to $11,293 with a median of $6,507.

### b) Checking for missing values
```r
MissingV_by_columns <- colSums(is.na(GPGdata))
print("Missing Values in GPGdata data set by columns:")
print(MissingV_by_columns)
```
![image](https://github.com/user-attachments/assets/3354bfcd-3f83-445c-b1c0-4821401e4afe)

#### --> Observation: No missing values detected. 

### c) Checking for duplicates
###### Find exact duplicate rows
```r
duplicates_all <- GPGdata %>% 
  filter(duplicated(.) | duplicated(., fromLast = TRUE))
```
###### Print the number of duplicate rows
```r
print(nrow(duplicates_all))
```
###### Print the duplicate rows themselves
```r
print(duplicates_all)
```

![image](https://github.com/user-attachments/assets/02524b5b-41cd-4bca-9d59-8967e9204e74)


#### --> Observation: No duplicates detected.
```5
## Should duplicates be present: Removing duplicates while keeping the first occurrence
# cleaned_data <- GPGdata %>% 
#  distinct()
## Printing the number of rows after removing duplicates
# print(nrow(cleaned_data))
```
### 5. Display top 5 and bottom 5 salaries in terms of BasePay amount.
```r
GPGdataTop<-GPGdata[order(-GPGdata$BasePay),]
top5<- head(GPGdataTop, n=5)
print(top5)
```
![image](https://github.com/user-attachments/assets/dd322301-2e54-4e8d-aba9-c45cef663c71)

```r
GPGdataBottom<-GPGdata[order(GPGdata$BasePay),]
bottom5 <- head(GPGdataBottom, n=5)
print(bottom5)
print(is.data.frame(bottom5))'
```
![image](https://github.com/user-attachments/assets/6b1279fa-b4a6-43d3-89d9-15a6cd95a3c2)

#### Visualisation: 5 top and 5 bottom salaries

#### Visualisation: 5 top salaries
```r
top5 <- top5 %>% 
  mutate(RowID = row_number())
top5_plot <- ggplot(data = top5, aes(x = as.factor(RowID), y = BasePay, fill = JobTitle)) +
  geom_col(fill = "violetred") +
  theme_classic() +
  labs(title = " Top 5 Salaries", x = "Employee", y = "Base Pay") +
  scale_x_discrete(labels = bottom5$JobTitle) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(top5_plot)
```
![image](https://github.com/user-attachments/assets/405391e7-c865-49a9-8241-b32085b6ea15)

#### Visualisation: 5 bottom salaries
```r
bottom5 <- bottom5 %>% 
  mutate(RowID = row_number())
bottom5_plot <- ggplot(data = bottom5, aes(x = as.factor(RowID), y = BasePay, fill = JobTitle)) +
  geom_col(fill = "steelblue") +
  theme_classic() +
  labs(title = "Bottom 5 Salaries", x = "Employee", y = "Base Pay") +
  scale_x_discrete(labels = bottom5$JobTitle) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(bottom5_plot)
```
![image](https://github.com/user-attachments/assets/5789d108-017c-4d02-b155-26c444b9ea7f)

### 6. Calculate the sum for variable ‘BasePay’ by ‘Dept’  variable.
```r
BasePay_ByDept<-aggregate(BasePay~Dept, data=GPGdata, FUN = sum)
BasePay_ByDept
```

![image](https://github.com/user-attachments/assets/c5c42fd1-3bad-4104-8eea-175c16de7aff)

##### second method:
```r
BasePay_ByDept2<-GPGdata%>%
  group_by(Dept)%>%
  summarise(Total_BasePay_per_Dept=sum(BasePay))%>%
  as.data.frame()
BasePay_ByDept2 
```
```r
ggplot(BasePay_ByDept2, aes(x = Dept, y = Total_BasePay_per_Dept / 1000000)) +
  geom_col(fill="turquoise3") +
  geom_text(aes(label = round(Total_BasePay_per_Dept / 1000000, 2)), 
            vjust = -0.3, 
            size = 4) +  
  theme_light() +
  labs(title = "Total (sum) of Base Pay by Department", x = "Department", y = "Base Pay (in millions)")
```

  ![image](https://github.com/user-attachments/assets/481cab9a-dafd-4910-ab2d-4dc027d180c4)

### 7. Create a subset of Employees from Management Department with BasePay < = 60,000.
###    Keep variables: Bonus, Seniority, Education and Gender in the subset data.

'GPG_below_60<-subset(GPGdata, Dept =="Management" & BasePay <= 60000, 
                     select=c(BasePay,Bonus,Seniority,Education,Gender))
head(GPG_below_60)'

![image](https://github.com/user-attachments/assets/5913cab3-c12e-4523-ad45-669a045b94d1)

#### Another way of creating a specific subset
```r
GPG_below_60_2<-GPGdata%>%
  filter(Dept == "Management", BasePay <= 60000)%>%
  select(Bonus,Seniority,Education,Gender, BasePay)%>%
  arrange(desc(BasePay))

GPG_below_60_2  
head(GPG_below_60_2)
tail(GPG_below_60_2)
```

#### Counting how many ee at Management level is paid below 60k per year.
```r
countGPG_below_60_2<-count(GPG_below_60_2)
countGPG_below_60_2
```

![image](https://github.com/user-attachments/assets/2ce15dab-91be-4c90-bf48-269d9172ada1)

#### --> Observation: There are 13 Managers who earn BasePay below 60 000 per year. 

### 8. Export the subsetted data into an xlsx file.
```r
write.xlsx(GPG_below_60_2, 'C:\\Users\\Maja\\Desktop\\output.xlsx', colNames=TRUE)
```
##### another way: 
```r
write.xlsx(GPG_below_60_2,file.choose())
```

## Brief summary of the Gender Pay Gap data set:
The GPGdata dataset contains 1,000 records with nine columns, featuring a mix of data types. The JobTitle, Gender, Education, and Dept columns are categorical, while Age is a numerical variable ranging from 18 to 65, with a median of 41. PerfEval and Seniority are ordinal variables on a 1-5 scale, both with a median of 3. BasePay and Bonus are continuous numerical variables, with BasePay ranging from $34,208 to $179,726 and Bonus from $1,703 to $11,293. No missing values or duplicates were detected.
