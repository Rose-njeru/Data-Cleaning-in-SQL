# Data-Cleaning-in-SQL

## 🏘 Nashville Housing Data Cleaning using MySQl Workbench

### Task
To ensure the data is clean and ready for analysis


### Data Cleaning Process
+ Step 1

The first process involved the changing of the salesdate column into desired data type
+ Step 2

Replacing  the null values of  Property Address either using Case statement or Coalesce
Update the table
+ Step 3

Breaking Property Address into individual columns address,city,state
This was done using Substring,locate,length and substring index 
+ Step 4 

Changing Y and N to YES and NO using Case Statement
Using case Statement to equate Y to YES and N to NO
+ Step 5

Identifying and deleting null values
Using window function to identifying null values i.e the values indicating a number higher than 1 are null

+ Step 6

Delete the null values from the table
Removing Redutant Columns 
Using Delete syntax to remove Salesdate,Taxdistrict,PropertyAddress and OwnerAdsress

## SQL Fundamentals Used
### Data Defination Language
 The Alter and Drop commands were used in defining diffrent columns in the dataset
### Data Manipulation Language
Insert,Update,delete commands manipulated diffrent columns in the dataset,

### Data Query Language
Select

#### Case Statements, Coalesce
 + replacing the null values in property Address column
 
#### Locate and Substring  
+ Breaking out Property Address into individual columns

 #### Substring_index
+  Identifying the delimeter in Owner Address column and breaking it into individual columns

#### Type of join
+ The table was joined with itself while performing data manipulation
