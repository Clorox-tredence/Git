WITH TABLE AS
(
SELECT
  *,
  CASE
    WHEN Compensation_Grade="26" THEN "GL26"
    WHEN CAST(Compensation_Grade AS INT64)<26
  OR Compensation_Grade="99" THEN "Below GL26"
    ELSE "GL27+"
  END AS GL_Brackets,
  CASE
    WHEN Primary_Work_Address_Country="United States of America" AND Employee_Type="Regular" AND Class="Non Production" THEN CASE
    WHEN Combined_Race_Ethnicity="Not Hispanic or Latino - Black (USA)" THEN "Total Minority"
    WHEN Combined_Race_Ethnicity="Not Hispanic or Latino - Asian (USA)" THEN "Total Minority"
    WHEN Combined_Race_Ethnicity="Not Hispanic or Latino - Other (USA)" THEN "Total Minority"
    WHEN Combined_Race_Ethnicity="Hispanic or Latino (USA)" THEN "Total Minority"
    WHEN Combined_Race_Ethnicity="Hispanic or Latino (Puerto Rico)" THEN "Total Minority"
    WHEN Combined_Race_Ethnicity="African / Black (South Africa)" THEN "Total Minority"
  END
  END AS MINORITY,
  CASE
    WHEN Primary_Work_Address_Country="United States of America" AND Employee_Type="Regular" AND Class="Non Production" THEN 
    concat(Gender," ", CASE
    WHEN Compensation_Grade="26" THEN "GL26"
    WHEN CAST(Compensation_Grade AS INT64)<26
  OR Compensation_Grade="99" THEN "Below GL26"
    ELSE "GL27+"
  END)
  END AS Female_27,
  CASE when (CASE
    WHEN Primary_Work_Address_Country="United States of America" AND Employee_Type="Regular" AND Class="Non Production" THEN CASE
    WHEN Combined_Race_Ethnicity="Not Hispanic or Latino - Black (USA)" THEN "Total Minority"
    WHEN Combined_Race_Ethnicity="Not Hispanic or Latino - Asian (USA)" THEN "Total Minority"
    WHEN Combined_Race_Ethnicity="Not Hispanic or Latino - Other (USA)" THEN "Total Minority"
    WHEN Combined_Race_Ethnicity="Hispanic or Latino (USA)" THEN "Total Minority"
    WHEN Combined_Race_Ethnicity="Hispanic or Latino (Puerto Rico)" THEN "Total Minority"
    WHEN Combined_Race_Ethnicity="African / Black (South Africa)" THEN "Total Minority"
  END
  END)="Total Minority" THEN
  CONCAT("Minority ", CASE
    WHEN Compensation_Grade="26" THEN "GL26"
    WHEN CAST(Compensation_Grade AS INT64)<26
  OR Compensation_Grade="99" THEN "Below GL26"
    ELSE "GL27+"
  END)
  END AS Minority_27
FROM
  `Working.Final_data_unpivot` 
)
SELECT DISTINCT * FROM TABLE