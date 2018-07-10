WITH TABLE_6 AS
( 
WITH
      TABLE_5 AS (
      WITH
        TABLE_4 AS (
        WITH
          TABLE_3 AS (
          WITH
            TABLE_2 AS (
            WITH
              TABLE_1 AS (
              SELECT
                a.*,
                CASE
                  WHEN b.Employee_ID IS NOT NULL AND 
				        b.Termination_date >= "2017-01-01T00:00:00"
                  AND b.Termination_date <= "2017-09-01T00:00:00"
                  AND a.Location = '"Meriden, CT - USA"'
                  OR a.Location = '"Meriden, CT (US51 Non-Prod) - USA"'
                  OR a.Location = '"Meriden, CT (US50 Non-Prod) - USA"'
                  OR a.Location = '"Prichard, WV - USA"'
				  THEN "Planned Closures"
                  ELSE "Not Applicable"
                END AS Other_Exclusions
              FROM
                FY18Q3.Snapshot a
              LEFT JOIN (
                SELECT
                  a.EMPLOYEE_ID,Termination_date
                FROM
                  `FY18Q3.Terminations` a
				   ) b
              ON
                a.EMPLOYEE_ID = b.EMPLOYEE_ID )
           
            SELECT
              a.*,
              CASE
                WHEN Compensation_Grade = 99 THEN 10
                WHEN Compensation_Grade IS NULL THEN 33
                ELSE Compensation_Grade
              END AS Compensation_Grade_INT
            FROM
              TABLE_1 a )
          SELECT
            a.*,
            b.Compensation_Grade_INT AS Previous_Grade
          FROM
            TABLE_2 a left join TABLE_2 b
			on
			a.EMPLOYEE_ID = b.EMPLOYEE_ID AND 
			EXTRACT(MONTH FROM a.Report_effective_date) = EXTRACT(MONTH FROM DATE_ADD(CAST(b.Report_effective_date AS DATE), INTERVAL 1 MONTH)) AND 
			EXTRACT(YEAR FROM a.Report_effective_date) = EXTRACT(YEAR FROM DATE_ADD(CAST(b.Report_effective_date AS DATE), INTERVAL 1 MONTH)) )
        SELECT
          a.*EXCEPT(Compensation_Grade_INT),
          CASE
            WHEN (Compensation_Grade_INT-Previous_Grade) >0 THEN "Positive GL"
            WHEN (Compensation_Grade_INT-Previous_Grade) =0 THEN "No Change"
            WHEN (Compensation_Grade_INT-Previous_Grade) <0 THEN "Negative GL"
            WHEN Previous_Grade IS NULL THEN "No Change"
          END AS CHANGE_IN_GL_TEXT,
          CASE
            WHEN Compensation_Grade_INT<26 THEN "Below_26"
            WHEN Compensation_Grade_INT>26 THEN "GL27+"
            ELSE "GL26"
          END AS Grade_Group,
          CASE
            WHEN Primary_work_address_Country!="United States of America" THEN "International"
            ELSE "United States Of America"
          END AS Country_Group,
          Max_Month,
          CASE WHEN (CASE WHEN EXTRACT(MONTH FROM Report_effective_date)>6 then EXTRACT(MONTH FROM Report_effective_date)-6
          ELSE EXTRACT(MONTH FROM Report_effective_date)+6 END)<=(CASE WHEN Max_Month>6 then Max_Month-6 ELSE Max_Month+6 END) 
            THEN CONCAT('FYTD - ',CAST(SUBSTR(CAST(EXTRACT(YEAR FROM FY) AS STRING),3,2) AS STRING)) END AS FYTD
          FROM
          TABLE_3 a 
          CROSS JOIN(SELECT EXTRACT(MONTH FROM max(report_effective_date)) AS Max_Month from `FY18Q3.Snapshot` ) )
      SELECT
        a.*,
        EOP,
        CAST(Base_Date AS DATETIME) AS Base_Date,
        EOP_FYTD,
        CAST(Base_Date_FYTD AS DATETIME) AS Base_Date_FYTD
      FROM
        TABLE_4 a
      LEFT JOIN (
        SELECT
          Report_effective_date,
          MAX(Report_effective_date) AS EOP,
          DATE_SUB(CAST(MIN(Report_effective_date) AS DATE), INTERVAL CAST(SUBSTR(CAST(MIN(Report_effective_date) AS STRING),9,2) AS INT64) DAY) AS Base_Date
        FROM
          TABLE_4
        GROUP BY
          Report_effective_date) b
      ON
        a.Report_effective_date=b.Report_effective_date
      LEFT JOIN (
        SELECT
          FYTD,
          MAX(Report_effective_date) AS EOP_FYTD,
          DATE_SUB(CAST(MIN(Report_effective_date) AS DATE), INTERVAL CAST(SUBSTR(CAST(MIN(Report_effective_date) AS STRING),9,2) AS INT64) DAY) AS Base_Date_FYTD
        FROM
          TABLE_4
        GROUP BY
          FYTD ) c
      ON
        a.FYTD=c.FYTD)
    SELECT
      a.*,
      b.EMPLOYEE_ID AS ADJ_Current,
      c.EMPLOYEE_ID AS ADJ_Base,
      d.EMPLOYEE_ID AS ADJ_Current_FYTD,
      e.EMPLOYEE_ID AS ADJ_Base_FYTD
    FROM
      TABLE_5 a
    LEFT JOIN
      TABLE_5 b
    ON
      a.EOP=b.Report_effective_date
      AND a.EMPLOYEE_ID = b.EMPLOYEE_ID
    LEFT JOIN
      TABLE_5 c
    ON
      a.Base_Date=c.Report_effective_date
      AND a.EMPLOYEE_ID = c.EMPLOYEE_ID
    LEFT JOIN
      TABLE_5 d
    ON
      a.EOP_FYTD=d.Report_effective_date
      AND a.EMPLOYEE_ID = d.EMPLOYEE_ID
    LEFT JOIN
      TABLE_5 e
    ON
      a.Base_Date_FYTD=e.Report_effective_date
      AND a.EMPLOYEE_ID = e.EMPLOYEE_ID  
)

SELECT DISTINCT * from TABLE_6
