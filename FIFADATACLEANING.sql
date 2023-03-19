
--DATA CLEANING IN SQL QUERIES

Select *
From DataCleaning..FifaData

-----------------------------------------------------------------------------------------------------------------------------------------
---EXTRACTING THE FULLNAME FROM THE PLAYERURL COLUMN

SELECT 
  ID, 
  PlayerUrl,
  SUBSTRING(PlayerUrl, CHARINDEX('/', PlayerUrl, 30) + 1, 
  CHARINDEX('/', PlayerUrl, CHARINDEX('/', PlayerUrl, 30) + 1) - CHARINDEX('/', PlayerUrl, 30) - 1) AS FullName
FROM DataCleaning..FifaData

Alter Table DataCleaning..FifaData
Add FullName nvarchar (255);

Update DataCleaning..FifaData
Set FullName = SUBSTRING(PlayerUrl, CHARINDEX('/', PlayerUrl, 30) + 1, 
			   CHARINDEX('/', PlayerUrl, CHARINDEX('/', PlayerUrl, 30) + 1) - CHARINDEX('/', PlayerUrl, 30) - 1)


--Removing Special Character

Update DataCleaning..FifaData
Set FullName = REPLACE (FullName, '-', ' ')


Select *
From DataCleaning..FifaData


---To Capitalize the first letter of each word in FullName

SELECT
    CONCAT(
        UPPER(LEFT(FullName, 1)),
        LOWER(SUBSTRING(FullName, 2, CHARINDEX(' ', FullName + ' ', 2) - 2)),
        ' ',
        UPPER(LEFT(SUBSTRING(FullName, CHARINDEX(' ', FullName + ' ', 2) + 1, LEN(FullName)), 1)),
        LOWER(SUBSTRING(SUBSTRING(FullName, CHARINDEX(' ', FullName + ' ', 2) + 1, LEN(FullName)), 2, LEN(FullName)))
    )
FROM FifaData

Update DataCleaning..FifaData
Set FullName = CONCAT(
        UPPER(LEFT(FullName, 1)),
        LOWER(SUBSTRING(FullName, 2, CHARINDEX(' ', FullName + ' ', 2) - 2)),
        ' ',
        UPPER(LEFT(SUBSTRING(FullName, CHARINDEX(' ', FullName + ' ', 2) + 1, LEN(FullName)), 1)),
        LOWER(SUBSTRING(SUBSTRING(FullName, CHARINDEX(' ', FullName + ' ', 2) + 1, LEN(FullName)), 2, LEN(FullName)))
    )



-- Swap columns between FullName and LongName
--Renaming the LongName column to PlayerName

UPDATE DataCleaning..FifaData
SET FulLName = LongName,
	LongName = FullName

	EXEC sp_rename 'DataCleaning..FifaData.LongName', 'PlayerName', 'COLUMN';



----------------------------------------------------------------------------------------------------------------------------------------------

--STANDARDISE THE JOINED DATE FORMAT

Select Joined, CONVERT(Date, Joined)
From DataCleaning..FifaData

Update DataCleaning..FifaData
SET Joined = CONVERT(Date, Joined)


EXEC sp_rename 'DataCleaning..FifaData.Joined', 'Joined_Date', 'COLUMN';

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--CLEANING THE CLUB COLUMN
--Removing Special Characters.


Select Club, MASTER.dbo.udfGetCharacters(Club,'a-z ')
From DataCleaning..FifaData

Update DataCleaning..FifaData
--Set Club = Replace(Club, 'ü ', 'u')
--Set Club = Replace(Club, 'é', 'e')
--Set Club = Replace(Club, 'ía', 'ia')
--Set Club = Replace(Club, 'ü', 'u')
--Set Club = Replace(Club, 'ñ', 'n')
--Set Club = Replace(Club, 'ö', 'o')
--Set Club = Replace(Club, 'ó', 'o')
--Set Club = Replace(Club, 'ę', 'e')
--Set Club = Replace(Club, 'â', 'a')
Set Club = Replace(Club, 'ș', 's')
    


Select Club, Nationality
From DataCleaning..FifaData

       

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--TO CLEAN THE WAGES FIELD

Select Wage
From DataCleaning..FifaData


--Removing String

Alter table DataCleaning..FifaData
Add Earnedwages nvarchar (255);

Update DataCleaning..FifaData
Set EarnedWages = REPLACE(Wage, '€', '')

Select EarnedWages, Wage
From DataCleaning..FifaData
order by EarnedWages desc

Update DataCleaning..FifaData
SET EarnedWages = REPLACE(EarnedWages,'K', '000')

UPDATE DataCleaning..FifaData
SET EarnedWages = CASE 
                   WHEN EarnedWages LIKE '%k' THEN CAST(REPLACE(EarnedWages, 'k', '') AS INT) * 1000 
                   ELSE CAST(EarnedWages AS INT) 
                 END
WHERE EarnedWages LIKE '%k'


---Swapping the Wage and EarnedWages columns

UPDATE DataCleaning..FifaData
SET Wage = Earnedwages,
	EarnedWages = Wage


---The EarnedWages column has been renamed to Weekly_wages_in_dollars

EXEC sp_rename 'DataCleaning..FifaData.Wage($)', 'Weekly_wages_in_dollars', 'COLUMN';

Select Weekly_wages_in_dollars, Earnedwages
From FifaData

----------------------------------------------------------------------------------------------------------------------------------------------------------

--TO CLEAN THE RELEASE CLAUSE FIELD

Select ReleaseClause
From DataCleaning..FifaData

Alter table DataCleaning..FifaData
Add Release_Clause_Money nvarchar(255);

Update DataCleaning..FifaData
Set Release_Clause_Money = REPLACE(ReleaseClause, '€', '')

Select Release_Clause_Money, ReleaseClause
From DataCleaning..FifaData


UPDATE DataCleaning..FifaData
SET Release_Clause_Money = CASE 
                   WHEN Release_Clause_Money LIKE '%k' THEN CAST(REPLACE(Release_Clause_Money, 'k', '') AS DECIMAL(18,0)) * 1000 
                   WHEN Release_Clause_Money LIKE '%m' THEN CAST(REPLACE(Release_Clause_Money, 'm', '') AS DECIMAL(18,0)) * 1000000 
                   ELSE CAST(Release_Clause_Money AS DECIMAL(18,0)) 
                 END
WHERE Release_Clause_Money LIKE '%k' OR Release_Clause_Money LIKE '%m';


Select *
From DataCleaning..FifaData

--Swapping columns

UPDATE DataCleaning..FifaData
SET ReleaseClause = Release_Clause_Money,
	Release_Clause_Money = ReleaseClause



----Renaming the column to Release_Clause_in_dollars

EXEC sp_rename 'DataCleaning..FifaData.Release_Clause ($)', 'Release_Clause_in_dollars', 'COLUMN'

Select Release_Clause_in_dollars
From FifaData

-----------------------------------------------------------------------------------------------------------------------------------------------------------

--TO CLEAN THE VALUE CLAUSE FIELD

Select Value
From DataCleaning..FifaData

Alter table DataCleaning..FifaData
Add Value_Worth nvarchar(255);

Update DataCleaning..FifaData
Set Value_Worth = REPLACE(Value, '€', '')

Select Value, Value_Worth
From DataCleaning..FifaData

UPDATE DataCleaning..FifaData
SET Value_Worth = CASE 
                   WHEN Value_Worth LIKE '%k' THEN CAST(REPLACE(Value_Worth, 'k', '') AS DECIMAL(18,0)) * 1000 
                   WHEN Value_Worth LIKE '%m' THEN CAST(REPLACE(Value_Worth, 'm', '') AS DECIMAL(18,0)) * 1000000 
                   ELSE CAST(Value_Worth AS DECIMAL(18,0)) 
                 END
WHERE Value_Worth LIKE '%k' OR Value_Worth LIKE '%m';

--Swapping columns

UPDATE DataCleaning..FifaData
SET Value = Value_Worth,
	Value_Worth = Value


select Value
from FifaData

--Renaming the Value column

EXEC sp_rename 'DataCleaning..FifaData.Value', 'Value_in_dollars', 'COLUMN'

------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CLEANING THE LOANENDDATE COLUMN
EXEC sp_rename 'DataCleaning..FifaData.LoanDateEnd', 'LoanEndDate', 'COLUMN';

Select *
From FifaData
Where Contract = 'Free'


Select LoanEndDate, CONVERT(Date, LoanEndDate)
From DataCleaning..FifaData

Update DataCleaning..FifaData
SET LoanEndDate = CONVERT(Date, LoanEndDate)

UPDATE DataCleaning..FifaData
SET LoanEndDate = CASE WHEN Contract = 'Free' THEN 'NotApplicable' 
					ELSE LoanEndDate
					END
WHERE Contract = 'Free';

Select LoanEndDate, Contract
From DataCleaning..FifaData

Update DataCleaning..FifaData
Set LoanEndDate = CASE 
					When LoanEndDate IS NULL Then  'Permanent'
					ELSE LoanEndDate
					END
Where LoanEndDate is NULL



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CLEANING THE CONTRACT COLUMN


SELECT 
    CASE
        WHEN Contract = 'Free' THEN 'Free'
        WHEN CHARINDEX('~', Contract) > 0 THEN SUBSTRING(Contract, 1, CHARINDEX('~', Contract) - 2) + ' - ' 
                                           + SUBSTRING(contract, CHARINDEX('~', Contract) + 2, LEN(Contract) - CHARINDEX('~', Contract) + 1)
       WHEN CHARINDEX(' On Loan', Contract) > 0 THEN SUBSTRING(Contract, 1, CHARINDEX(' On Loan', Contract) - 1)
       WHEN TRY_CONVERT(Date, Contract) IS NOT NULL THEN CONVERT(varchar, TRY_CONVERT(Date, Contract), 101)
       ELSE Contract
       END 

FROM DataCleaning..FifaData


UPDATE DataCleaning..FifaData
SET Contract = CASE
        WHEN Contract = 'Free' THEN 'Free'
        WHEN CHARINDEX('~', Contract) > 0 THEN SUBSTRING(Contract, 1, CHARINDEX('~', Contract) - 2) + ' - ' 
                                           + SUBSTRING(contract, CHARINDEX('~', Contract) + 2, LEN(Contract) - CHARINDEX('~', Contract) + 1)
       WHEN CHARINDEX(' On Loan', Contract) > 0 THEN SUBSTRING(Contract, 1, CHARINDEX(' On Loan', Contract) - 1)
       WHEN TRY_CONVERT(Date, Contract) IS NOT NULL THEN CONVERT(varchar, TRY_CONVERT(Date, Contract), 101)
       ELSE Contract
       END 


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---CLEANING WEIGHT COLUMN
--Weight has been converted to lbs unit

Select Weight
From DataCleaning..FifaData
Where Weight LIKE '%kg%'

Select Weight
From DataCleaning..FifaData
Where Weight LIKE '%lbs%'


UPDATE DataCleaning..FifaData
SET Weight = 
    CASE 
        WHEN Weight LIKE '%kg' THEN CAST(REPLACE(Weight, 'kg', '') AS FLOAT) * 2.20462
        ELSE CAST(REPLACE(weight, 'lbs', '') AS FLOAT)
    END



Select Weight
From DataCleaning..FifaData


--Renaming the Weight Column

EXEC sp_rename 'DataCleaning..FifaData.Weight', 'Weight_in_lbs', 'COLUMN'

-----------------------------------------------------------------------------------------------------------------------------------------------------------
--CLEANING HEIGHT COLUMN
--Height converted to Feets and Inches

Select Height
From DataCleaning..FifaData 
Where Height not like '%cm'


UPDATE DataCleaning..FifaData
SET Height = 
    CASE 
        WHEN Height LIKE '%cm' THEN CAST(REPLACE(Height, 'cm', '') AS FLOAT) / 30.48
        ELSE CAST(SUBSTRING(Height, 1, CHARINDEX('''', Height) - 1) AS FLOAT) + 
             CAST(SUBSTRING(Height, CHARINDEX('''', Height) + 1, LEN(Height) - CHARINDEX('''', Height) - 2) AS FLOAT) / 12
    END


SELECT CONCAT(FLOOR(Height), '\', FLOOR((Height - FLOOR(Height)) * 12), '"')
FROM DataCleaning..FifaData;

UPDATE DataCleaning..FifaData
SET Height = CONCAT(FLOOR(Height), '\', FLOOR((Height - FLOOR(Height)) * 12), '"')


--Renaming the Height Column
EXEC sp_rename 'DataCleaning..FifaData.Height', 'Height_in_ft_and_inches', 'COLUMN'


--------------------------------------------------------------------------------------------------------------------------------------------------
--TO CLEAN THE WEAKFOOT FIELD

Select *
From DataCleaning..FifaData


Select WeakFoot, MASTER.dbo.udfGetCharacters(WeakFoot,'0-9 ')
From DataCleaning..FifaData

Update DataCleaning..FifaData
Set WeakFoot = MASTER.dbo.udfGetCharacters(WeakFoot,'0-9 ')
Where WeakFoot ! = MASTER.dbo.udfGetCharacters(WeakFoot,'0-9 ')



-------------------------------------------------------------------------------------------------------------------------------------------
--TO CLEAN INJURINGRATING FIELD

Select *
From DataCleaning..FifaData


Select InjuringRating, MASTER.dbo.udfGetCharacters(InjuringRating,'0-9 ')
From DataCleaning..FifaData

Update DataCleaning..FifaData
Set InjuringRating = MASTER.dbo.udfGetCharacters(InjuringRating,'0-9 ')
Where InjuringRating ! = MASTER.dbo.udfGetCharacters(InjuringRating,'0-9 ')



------------------------------------------------------------------------------------------------------------------------------------------
--TO CLEAN SKILLMOVES

Select SkillMoves, MASTER.dbo.udfGetCharacters(SkillMoves,'0-9 ')
From DataCleaning..FifaData

Update DataCleaning..FifaData
Set SkillMoves = MASTER.dbo.udfGetCharacters(SkillMoves,'0-9 ')
Where SkillMoves ! = MASTER.dbo.udfGetCharacters(SkillMoves,'0-9 ')


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--REPLACE NULL VALUES WITH ZERO IN HITS COLUMN


SELECT COALESCE(Hits, 0)
FROM DataCleaning..FifaData;


UPDATE DataCleaning..FifaData
SET Hits = COALESCE(Hits, 0)



---------------------------------------------------------------------------------------------------------------------------------------------------------------

--REMOVE DUPLICATES


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY PlayerName,
				 Joined_Date,
				 ID,
				 Weekly_wages_in_dollars,
				 Contract
				 ORDER BY ID
					) row_num

From DataCleaning..FifaData
--order by Name
)
Select *
From RowNumCTE
Where row_num > 1
Order by PlayerName

--There is no Duplicate in the dataset.

-----------------------------------------------------------------------------------------------------------------------------------------------
--DELETE UNUSED COLUMNS

Select *
From DataCleaning..FifaData

Alter Table DataCleaning..FifaData
Drop Column Name, PhotoUrl, PlayerUrl, FullName, Earnedwages, Release_Clause_Money, Value_Worth

