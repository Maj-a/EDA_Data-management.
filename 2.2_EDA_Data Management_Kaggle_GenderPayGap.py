# -*- coding: utf-8 -*-
"""
Created on Sat Mar 16 20:23:57 2024

@author: Maja
"""

###### 2 - Data Management - Glassdoor Gender Pay Gap

### 0. Import packages and libraries.

import pandas as pd

### 1. 1. Import Glassdoor Gender Pay Gap data and name it as GPGdata.

GPGdata = pd.read_csv("C:/Users/Maja/Documents/Learning/MS_Projects/Portfolio 2024/GitHub Portfolio/2_Data management/Glassdoor Gender Pay Gap.csv")

### 2. Check number of rows, columns in the data.

print("2) Check number of rows, columns in the data:", GPGdata)

### 3. Display first 10 rows and last 5 rows.

print("3) Display first 10 rows:", GPGdata.head(n=10))
print("3) Display last 5 rows:", GPGdata.tail(n=5))

### 4. Describe (summarize) all variables, check for missing values and duplicates.
# a) Summary
print("4) Describe all variables via info:", GPGdata.info())
print("4) Describe all variables via Describe", GPGdata.describe())
print(GPGdata.describe(include='all'))

# b) Checking if missing values are present
MissingV_by_columns = GPGdata.isna().sum()
print("Missing Values in GPGdata dataset by columns:")
print(MissingV_by_columns)

### --> Observation: No missing values detected.
 
## c) Checking for duplicates
duplicates_all = GPGdata[GPGdata.duplicated(keep=False)]
# Print the number of duplicate rows
print(f"Number of duplicate rows: {len(duplicates_all)}")
# Print the duplicate rows themselves
print(duplicates_all)

### 5. Display top 5 and bottom 5 salaries in terms of BasePay amount.

GPGdata_BasePay = GPGdata[['BasePay']]
print("5) GPGdata_BasePay", GPGdata_BasePay)

GPGdata_BasePay_Sorted = GPGdata_BasePay.sort_values(by = ['BasePay'], ascending=[0])
print("5) GPGdata_BasePay_Sorted:", GPGdata_BasePay_Sorted)

# Top 5 salaries
print("5) Top 5 salaries:", GPGdata_BasePay_Sorted.head(n=5))

# Bottom 5 salaries 
print("5) Bottom 5 salaries:", GPGdata_BasePay_Sorted.tail(n=5))

### 6.  Calculate the sum for variable ‘BasePay’ by ‘Dept’ variable.
# Printing headlines to check column names
print("6) Printing headlines to check column names", list(GPGdata))

# Calculating the sum of ‘BasePay’ by department.
BasePay_ByDept = GPGdata.groupby('Dept')['BasePay'].sum().reset_index()
print("6) Calculating the sum of ‘BasePay’ by department:", BasePay_ByDept)
## Visual of BasePay by Department
# Plotting with Matplotlib
import matplotlib.pyplot as plt
plt.figure(figsize=(10, 6))
plt.bar(BasePay_ByDept['Dept'], BasePay_ByDept['BasePay'], color='skyblue')
plt.title('Total Base Pay by Department')
plt.xlabel('Department')
plt.ylabel('Total Base Pay')
plt.xticks(rotation=45, ha='right')
plt.show()

# Plotting with Seaborn
import seaborn as sns
plt.figure(figsize=(10, 6))
sns.barplot(x='Dept', y='BasePay', data=BasePay_ByDept, palette='viridis')
plt.title('Total Base Pay by Department')
plt.xlabel('Department')
plt.ylabel('Total Base Pay')
plt.xticks(rotation=45, ha='right')
plt.show()

### 7. Create a subset of Employees from Management Department with BasePay < = 60,000.
###    Keep variables: Bonus, Seniority, Education and Gender in the subset data.

# Creating a subset of Employees from Management Department with BasePay < = 60,000.
subsetA = GPGdata[(GPGdata['Dept'] == 'Management') & (GPGdata['BasePay'] <= 60000)]
print("7) Subset of Employees from Management Department with BasePay < = 60,000:", subsetA)

# Keep only the desired columns
subset = subsetA[['BasePay', 'Bonus', 'Seniority', 'Education','Gender']]

### 8. Export the subsetted data into an xlsx file.

subset.to_excel('C:/Users/Maja/Desktop/subset.xlsx', index=False)



















