# DATACLEANING-FIFA21

Introduction

Data cleaning is the process of identifying and correcting or removing errors, inconsistencies, and inaccuracies in a dataset. It involves detecting and addressing problems with data such as missing data, duplicate data, incorrect data types, outliers, and inconsistencies.
Data cleaning is a crucial step in data analysis, as it helps ensure the accuracy, consistency, and reliability of the data. If the data is not cleaned properly, it can lead to incorrect conclusions, inaccurate predictions, and flawed insights.
About the challenge
A recent data cleaning challenge was organized on Twitter in the data tech space giving every Data Analyst at all levels of expertise (beginner, intermediate or expert) the opportunity to hone their skills and create a portfolio-worthy project.
The challenge encouraged all participants to clean a messy data using any of their preferred tools.
As a participant in the challenge, I used Microsoft SQL Server for this cleaning Project.
About the Dataset
The FIFA 21 dataset contains player and team statistics from the popular video game FIFA 21. The dataset was gotten from Kaggle and was tagged messy, raw dataset showing that it is an ideal dataset for a data cleaning project. 

Data Assessment

Before cleaning the data, it was necessary to assess the quality and completeness of the dataset. The following issues were discovered during the assessment:

Missing data: some of the player and team statistics were missing from the dataset.
Incorrect data types: some columns had incorrect data types, such as strings instead of integers.
Duplicate data: some player data were duplicated in the dataset.
Inconsistent data: some columns had inconsistent data, such as different spellings of player names.
Null entries: Some columns had null entries.
Errors in spellings and values: Some columns had errors in spellings and also included special characters in the spellings.
Irrelevant data.

Cleaning Process
1) I began my cleaning process by extracting the Player name from the PlayerUrl since the Players name in the LongName column had a lot of special characters.
2) Next I standardise the Joined date format. I converted the date from Month Day, Year to the recommended international standard YYYY-MM-DD.
3) Then, I cleaned the club column format. The club field had a lot of misspellings and special characters, so I cleaned and replaced them.
4) Next, I cleaned the value, wage and release clause columns. I replace the k and m with '000' and '000000' to properly describe the columns.
5) Next, I cleaned the Loan End Date column. I formatted the date properly and then updated the Loan End Date column to properly mention that when a Player is Free, the Loan End Date is not applicable and when the Player is on a Contract, then such a Player is described as Permanent.
6) I also cleaned the Contract column. I updated it to show a Free Player when there is no Contract. I also remove the special character and replaced it with an hyphen(-) to indicate the contract start and end year.
7) Next I cleaned the weight and height columns. I updated both columns for consistency. For the weight column, I updated all fields to lbs, initially some were in kgs and they got updated to lbs. For the height column, I updated all fields to feet and inches from centimeters.
8) I cleaned the weakfoot, injuringrating and skillmoves field. I removed all special characters.
9) Next I cleaned the Hits column. I updated the Null fields to represent zero(0) and converted the data type to int, so fields with 1.1k are converted to 1100.
10) Remove duplicates. There was no duplicate using the ID. When you use the Player name, it will result in duplicates, however when you check the contract or club or dates, it was in a different club at a different date or contract, thus indicating there is no duplicate in the dataset.
11) Lastly I deleted some columns that were no longer of use. The columns deleted were PlayerUrl, PhotoUrl, FullName, Name and some new columns created.


Results
After cleaning the dataset, the data was more reliable and consistent. The dataset could now be used for future analysis.

Conclusion
In conclusion, cleaning the FIFA 21 dataset using SQL was a necessary step to obtain a reliable dataset for analysis. By following the steps outlined in this documentation, the dataset was successfully cleaned and prepared for analysis.













































































