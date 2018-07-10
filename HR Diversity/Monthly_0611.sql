WITH TABLE_17 AS
(
WITH
  TABLE_16 AS (
  WITH
    TABLE_15 AS (
    WITH
      TABLE_14 AS (
      WITH
        TABLE_13 AS (
        WITH
          TABLE_12 AS (
          WITH
            TABLE_11 AS (
            WITH
              TABLE_10 AS (
              WITH
                TABLE_9 AS (
                WITH
                  TABLE_8 AS (
                  WITH
                    TABLE_7 AS (
                    WITH
                      TABLE_6 AS (
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
                                    WHEN b.Employee_ID IS NOT NULL THEN "Planned Closures"
                                    ELSE "Not Applicable"
                                  END AS Other_Exclusions
                                FROM
                                  FY18Q3.Snapshot a
                                LEFT JOIN (
                                  SELECT
                                    a.EMPLOYEE_ID
                                  FROM
                                    `FY18Q3.Terminations` a
                                  LEFT JOIN
                                    FY18Q3.Snapshot b
                                  ON
                                    a.EMPLOYEE_ID = b.EMPLOYEE_ID
                                  WHERE
                                    a.Termination_date >= "2017-01-01T00:00:00"
                                    AND a.Termination_date <= "2017-09-01T00:00:00"
                                    AND b.Location = '"Meriden, CT - USA"'
                                    OR b.Location = '"Meriden, CT (US51 Non-Prod) - USA"'
                                    OR b.Location = '"Meriden, CT (US50 Non-Prod) - USA"'
                                    OR b.Location = '"Prichard, WV - USA"' ) b
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
                              LAG(Compensation_Grade_INT) OVER (PARTITION BY EMPLOYEE_ID ORDER BY Report_effective_date) AS Previous_Grade
                            FROM
                              TABLE_2 a )
                          SELECT
                            a.*EXCEPT(Compensation_Grade_INT,
                              Previous_Grade),
                            CASE
                              WHEN (Compensation_Grade_INT-Previous_Grade) >0 THEN "Positive GL"
                              WHEN (Compensation_Grade_INT-Previous_Grade) =0 THEN "No Change"
                              WHEN (Compensation_Grade_INT-Previous_Grade) <0 THEN "Negative GL"
                              WHEN Previous_Grade IS NULL THEN "No Change"
                            END AS CHANGE_IN_GL_TEXT
                          FROM
                            TABLE_3 a )
                        SELECT
                          CAST(Compensation_Grade AS STRING) AS Compensation_Grade,
                          Time_Type,
                          Class,
                          FLSA,
                          Gender,
                          Generation,
                          Functional_Organization,
                          Primary_Work_Address_Country,
                          Employee_Type,
                          Combined_Race_Ethnicity,
                          Other_Exclusions,
                          CHANGE_IN_GL_TEXT
                        FROM
                          TABLE_4
                        GROUP BY
                          CAST(Compensation_Grade AS STRING),
                          Time_Type,
                          Class,
                          FLSA,
                          Gender,
                          Generation,
                          Functional_Organization,
                          Primary_Work_Address_Country,
                          Employee_Type,
                          Combined_Race_Ethnicity,
                          Other_Exclusions,
                          CHANGE_IN_GL_TEXT
                        UNION ALL
                        SELECT
                          CAST(b.Compensation_Grade AS STRING) AS Compensation_Grade,
                          b.Time_Type,
                          b.Class,
                          b.FLSA,
                          a.Gender,
                          a.Generation,
                          b.Functional_Organization,
                          b.Primary_Work_Address_Country,
                          b.Employee_Type,
                          a.Combined_Race_Ethnicity,
                          a.Other_Exclusions,
                          a.CHANGE_IN_GL_TEXT
                        FROM
                          TABLE_4 a
                        LEFT JOIN
                          TABLE_4 b
                        ON
                          a.Employee_ID =b.EMPLOYEE_ID
                          AND EXTRACT(MONTH
                          FROM
                            a.Report_effective_date) = EXTRACT(MONTH
                          FROM
                            DATE_ADD(CAST(b.report_effective_date AS DATE), INTERVAL 1 month))
                          AND EXTRACT(YEAR
                          FROM
                            a.Report_effective_date) = EXTRACT(YEAR
                          FROM
                            DATE_ADD(CAST(b.report_effective_date AS DATE), INTERVAL 1 month))
                        GROUP BY
                          CAST(b.Compensation_Grade AS STRING),
                          b.Time_Type,
                          b.Class,
                          b.FLSA,
                          a.Gender,
                          a.Generation,
                          b.Functional_Organization,
                          b.Primary_Work_Address_Country,
                          b.Employee_Type,
                          a.Combined_Race_Ethnicity,
                          a.Other_Exclusions,
                          a.CHANGE_IN_GL_TEXT )
                      SELECT
                        Report_Effective_Date,
                        Compensation_Grade,
                        Time_Type,
                        Class,
                        FLSA,
                        Gender,
                        Generation,
                        Functional_Organization,
                        Primary_Work_Address_Country,
                        Employee_Type,
                        Combined_Race_Ethnicity,
                        Other_Exclusions,
                        CHANGE_IN_GL_TEXT
                      FROM (
                        SELECT
                          a.Report_Effective_Date,
                          CASE
                            WHEN b.Compensation_Grade = "EX" THEN NULL
                            ELSE b.Compensation_Grade
                          END AS Compensation_Grade,
                          b.Time_Type,
                          b.Class,
                          b.FLSA,
                          b.Gender,
                          b.Generation,
                          b.Functional_Organization,
                          b.Primary_Work_Address_Country,
                          b.Employee_Type,
                          b.Combined_Race_Ethnicity,
                          b.Other_Exclusions,
                          b.CHANGE_IN_GL_TEXT
                        FROM (
                          SELECT
                            DISTINCT Report_Effective_Date
                          FROM
                            FY18Q3.Snapshot) a
                        CROSS JOIN
                          TABLE_5 b
                        WHERE
                          Report_Effective_Date IS NOT NULL)
                      GROUP BY
                        Report_Effective_Date,
                        Compensation_Grade,
                        Time_Type,
                        Class,
                        FLSA,
                        Gender,
                        Generation,
                        Functional_Organization,
                        Primary_Work_Address_Country,
                        Employee_Type,
                        Combined_Race_Ethnicity,
                        Other_Exclusions,
                        CHANGE_IN_GL_TEXT )
                    SELECT
                      a.Report_Effective_Date,
                      a.Compensation_Grade,
                      a.Time_Type,
                      a.Class,
                      a.FLSA,
                      a.Gender,
                      a.Generation,
                      a.Functional_Organization,
                      a.Primary_Work_Address_Country,
                      a.Employee_Type,
                      a.Combined_Race_Ethnicity,
                      a.Other_Exclusions,
                      a.CHANGE_IN_GL_TEXT,
                      IFNULL(b.Current_HC,
                        0) AS Current_HC
                    FROM
                      TABLE_6 a
                    LEFT JOIN (
                      SELECT
                        Report_Effective_Date,
                        Compensation_Grade,
                        Time_Type,
                        Class,
                        FLSA,
                        Gender,
                        Generation,
                        Functional_Organization,
                        Primary_Work_Address_Country,
                        Employee_Type,
                        Combined_Race_Ethnicity,
                        Count (DISTINCT a.EMPLOYEE_ID) AS Current_HC,
                        Other_Exclusions,
                        CHANGE_IN_GL_TEXT
                      FROM
                        `Working.With_GL_Columns`  a
                      GROUP BY
                        Report_Effective_Date,
                        Compensation_Grade,
                        Time_Type,
                        Class,
                        FLSA,
                        Gender,
                        Generation,
                        Functional_Organization,
                        Primary_Work_Address_Country,
                        Employee_Type,
                        Combined_Race_Ethnicity,
                        Other_Exclusions,
                        CHANGE_IN_GL_TEXT ) b
                    ON
                      CAST(a.Report_Effective_Date AS DATETIME) = CAST(b.Report_Effective_Date AS DATETIME)
                      AND IFNULL(CAST(a.Compensation_Grade AS STRING ),
                        "No Data") = IFNULL(CAST(b.Compensation_Grade AS STRING ),
                        "No Data")
                      AND IFNULL(CAST(a.Time_Type AS STRING),
                        "No Data") = IFNULL(CAST(b.Time_Type AS STRING),
                        "No Data")
                      AND IFNULL(CAST(a.Class AS STRING),
                        "No Data") = IFNULL(CAST(b.Class AS STRING),
                        "No Data")
                      AND IFNULL(CAST(a.FLSA AS STRING),
                        "No Data") = IFNULL(CAST(b.FLSA AS STRING),
                        "No Data")
                      AND IFNULL(CAST(a.Gender AS STRING),
                        "No Data") = IFNULL(CAST(b.Gender AS STRING),
                        "No Data")
                      AND IFNULL(CAST(a.Generation AS STRING),
                        "No Data") = IFNULL(CAST(b.Generation AS STRING),
                        "No Data")
                      AND IFNULL(CAST(a.Functional_Organization AS STRING),
                        "No Data") = IFNULL(CAST(b.Functional_Organization AS STRING),
                        "No Data")
                      AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
                        "No Data") = IFNULL(CAST(b.Primary_Work_Address_Country AS STRING),
                        "No Data")
                      AND IFNULL(CAST(a.Employee_Type AS STRING),
                        "No Data") = IFNULL(CAST(b.Employee_Type AS STRING),
                        "No Data")
                      AND IFNULL(CAST(a.Combined_Race_Ethnicity AS STRING),
                        "No Data") = IFNULL(CAST(b.Combined_Race_Ethnicity AS STRING),
                        "No Data")
                      AND IFNULL(CAST(a.Other_Exclusions AS STRING),
                        "No Data") = IFNULL(CAST(b.Other_Exclusions AS STRING),
                        "No Data")
                      AND IFNULL(CAST(a.CHANGE_IN_GL_TEXT AS STRING),
                        "No Data") = IFNULL(CAST(b.CHANGE_IN_GL_TEXT AS STRING),
                        "No Data") ) (
                    SELECT
                      *,
                      LAG(Current_HC) OVER (PARTITION BY Compensation_Grade, Time_Type, Class, FLSA, Gender, Generation, Functional_Organization, Primary_Work_Address_Country, Employee_Type, Combined_Race_Ethnicity, Other_Exclusions, CHANGE_IN_GL_TEXT ORDER BY Report_Effective_Date ASC ) AS Base_HC
                    FROM
                      TABLE_7 ) )
                SELECT
                  a.*,
                  IFNULL(b.HIRES,
                    0) AS Count_Hire,
					IFNULL(b.ADJ_current_Hire,
                    0) AS Count_ADJ_current_Hire
                FROM
                  TABLE_8 a
                LEFT JOIN (
                  SELECT
                    COUNT( DISTINCT EMPLOYEE_ID ) AS HIRES,
					SUM(CASE WHEN ADJ_CURRENT IS NULL THEN 1 ELSE 0 END) AS ADJ_current_Hire,
					EXTRACT(MONTH
                    FROM
                      CAST(CURRENT_HIRE_DATE AS DATE)) AS MONTH,
                    EXTRACT(YEAR
                    FROM
                      CAST(CURRENT_HIRE_DATE AS DATE)) AS YEAR,
                    COMPENSATION_GRADE,
                    Time_Type,
                    Class,
                    FLSA,
                    Gender,
                    Generation,
                    Functional_Organization,
                    Primary_Work_Address_Country,
                    Employee_Type,
                    Combined_Race_Ethnicity,
                    Other_Exclusions,
                    CHANGE_IN_GL_TEXT
                  FROM (
                    SELECT
                      a.EMPLOYEE_ID,
                      a.COMPENSATION_GRADE,
                      a.Time_Type,
                      a.Class,
                      a.FLSA,
                      a.Gender,
                      a.Generation,
                      a.Functional_Organization,
                      a.Primary_Work_Address_Country,
                      a.Employee_Type,
                      a.Combined_Race_Ethnicity,
                      b.Current_hire_date,
                      a.Other_Exclusions,
					            a.ADJ_Current ,
                      a.CHANGE_IN_GL_TEXT
                    FROM
                      Working.With_GL_Columns a
                    LEFT JOIN (
                      SELECT
                        EMPLOYEE_ID,
                        Current_hire_date
                      FROM
                        `FY18Q3.ExternalHires`) b
                    ON
                      a.EMPLOYEE_ID=b.EMPLOYEE_ID
                    WHERE
                      EXTRACT(MONTH
                      FROM
                        CAST(b.CURRENT_HIRE_DATE AS DATE)) = EXTRACT(MONTH
                      FROM
                        CAST(a.Report_effective_date AS DATE))
                      AND EXTRACT(YEAR
                      FROM
                        CAST(b.CURRENT_HIRE_DATE AS DATE)) = EXTRACT(YEAR
                      FROM
                        CAST(a.Report_effective_date AS DATE)) )
                  GROUP BY
                    EXTRACT(MONTH
                    FROM
                      CAST(CURRENT_HIRE_DATE AS DATE)),
                    EXTRACT(YEAR
                    FROM
                      CAST(CURRENT_HIRE_DATE AS DATE)),
                    Compensation_grade,
                    Time_Type,
                    Class,
                    FLSA,
                    Gender,
                    Generation,
                    Functional_Organization,
                    Primary_Work_Address_Country,
                    Employee_Type,
                    Combined_Race_Ethnicity,
                    Other_Exclusions,
                    CHANGE_IN_GL_TEXT ) b
                ON
                  CASE
                    WHEN a.Report_Effective_Date IS NOT NULL THEN EXTRACT(MONTH  FROM  CAST(a.Report_Effective_Date AS DATETIME))
                    ELSE NULL
                  END = b.MONTH
                  AND
                  CASE
                    WHEN a.Report_Effective_Date IS NOT NULL THEN EXTRACT(YEAR  FROM  CAST(a.Report_Effective_Date AS DATETIME))
                    ELSE NULL
                  END = b.YEAR
                  AND IFNULL(CAST(a.Compensation_Grade AS STRING ),
                    "No Data") = IFNULL(CAST(b.Compensation_Grade AS STRING ),
                    "No Data")
                  AND IFNULL(CAST(a.Time_Type AS STRING),
                    "No Data") = IFNULL(CAST(b.Time_Type AS STRING),
                    "No Data")
                  AND IFNULL(CAST(a.Class AS STRING),
                    "No Data") = IFNULL(CAST(b.Class AS STRING),
                    "No Data")
                  AND IFNULL(CAST(a.FLSA AS STRING),
                    "No Data") = IFNULL(CAST(b.FLSA AS STRING),
                    "No Data")
                  AND IFNULL(CAST(a.Gender AS STRING),
                    "No Data") = IFNULL(CAST(b.Gender AS STRING),
                    "No Data")
                  AND IFNULL(CAST(a.Generation AS STRING),
                    "No Data") = IFNULL(CAST(b.Generation AS STRING),
                    "No Data")
                  AND IFNULL(CAST(a.Functional_Organization AS STRING),
                    "No Data") = IFNULL(CAST(b.Functional_Organization AS STRING),
                    "No Data")
                  AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
                    "No Data") = IFNULL(CAST(b.Primary_Work_Address_Country AS STRING),
                    "No Data")
                  AND IFNULL(CAST(a.Employee_Type AS STRING),
                    "No Data") = IFNULL(CAST(b.Employee_Type AS STRING),
                    "No Data")
                  AND IFNULL(CAST(a.Combined_Race_Ethnicity AS STRING),
                    "No Data") = IFNULL(CAST(b.Combined_Race_Ethnicity AS STRING),
                    "No Data")
                  AND IFNULL(CAST(a.Other_Exclusions AS STRING),
                    "No Data") = IFNULL(CAST(b.Other_Exclusions AS STRING),
                    "No Data")
                  AND IFNULL(CAST(a.CHANGE_IN_GL_TEXT AS STRING),
                    "No Data") = IFNULL(CAST(b.CHANGE_IN_GL_TEXT AS STRING),
                    "No Data") )
              SELECT
                a.*,
                IFNULL(b.TERMS,
                  0) AS Count_TERMS,
				  IFNULL(b.ADJ_Base_Terms,
                  0) AS Count_ADJ_Base_Terms
              FROM
                TABLE_9 a
              LEFT JOIN (
                SELECT
                  COUNT( DISTINCT a.EMPLOYEE_ID ) AS TERMS,
				  SUM(CASE WHEN ADJ_Base IS NULL THEN 1 ELSE 0 END) AS ADJ_Base_Terms,
				  EXTRACT(MONTH
                  FROM
                    CAST(TERMINATION_DATE AS DATE)) AS MONTH,
                  EXTRACT(YEAR
                  FROM
                    CAST(TERMINATION_DATE AS DATE)) AS YEAR,
                  COMPENSATION_GRADE,
                  Time_Type,
                  Class,
                  FLSA,
                  Gender,
                  Generation,
                  Functional_Organization,
                  Primary_Work_Address_Country,
                  Employee_Type,
                  Combined_Race_Ethnicity,
                  Other_Exclusions,
                  CHANGE_IN_GL_TEXT
                FROM
                  Working.With_GL_Columns a
                LEFT JOIN (
                  SELECT
                    EMPLOYEE_ID,
                    TERMINATION_DATE
                  FROM
                    FY18Q3.Terminations ) b
                ON
                  a.EMPLOYEE_ID=b.EMPLOYEE_ID
                WHERE
                  CASE
                    WHEN EXTRACT(MONTH  FROM  CAST(TERMINATION_DATE AS DATE))=1 THEN 12 = EXTRACT(MONTH  FROM  CAST(a.Report_effective_date AS DATE)) AND EXTRACT(YEAR  FROM  CAST(TERMINATION_DATE AS DATE))-1 = EXTRACT(YEAR  FROM  CAST(a.Report_effective_date AS DATE))
                    ELSE EXTRACT(MONTH
                  FROM
                    CAST(TERMINATION_DATE AS DATE))-1 = EXTRACT(MONTH
                  FROM
                    CAST(a.Report_effective_date AS DATE))
                  AND EXTRACT(YEAR
                  FROM
                    CAST(TERMINATION_DATE AS DATE)) = EXTRACT(YEAR
                  FROM
                    CAST(a.Report_effective_date AS DATE))
                  END
                GROUP BY
                  EXTRACT(MONTH
                  FROM
                    CAST(TERMINATION_DATE AS DATE)),
                  EXTRACT(YEAR
                  FROM
                    CAST(TERMINATION_DATE AS DATE)),
                  Compensation_grade,
                  Time_Type,
                  Class,
                  FLSA,
                  Gender,
                  Generation,
                  Functional_Organization,
                  Primary_Work_Address_Country,
                  Employee_Type,
                  Combined_Race_Ethnicity,
                  Other_Exclusions,
                  CHANGE_IN_GL_TEXT ) b
              ON
                CASE
                  WHEN a.Report_Effective_Date IS NOT NULL THEN EXTRACT(MONTH  FROM  CAST(a.Report_Effective_Date AS DATETIME))
                  ELSE NULL
                END = b.MONTH
                AND
                CASE
                  WHEN a.Report_Effective_Date IS NOT NULL THEN EXTRACT(YEAR  FROM  CAST(a.Report_Effective_Date AS DATETIME))
                  ELSE NULL
                END = b.YEAR
                AND IFNULL(CAST(a.Compensation_Grade AS STRING ),
                  "No Data") = IFNULL(CAST(b.Compensation_Grade AS STRING ),
                  "No Data")
                AND IFNULL(CAST(a.Time_Type AS STRING),
                  "No Data") = IFNULL(CAST(b.Time_Type AS STRING),
                  "No Data")
                AND IFNULL(CAST(a.Class AS STRING),
                  "No Data") = IFNULL(CAST(b.Class AS STRING),
                  "No Data")
                AND IFNULL(CAST(a.FLSA AS STRING),
                  "No Data") = IFNULL(CAST(b.FLSA AS STRING),
                  "No Data")
                AND IFNULL(CAST(a.Gender AS STRING),
                  "No Data") = IFNULL(CAST(b.Gender AS STRING),
                  "No Data")
                AND IFNULL(CAST(a.Generation AS STRING),
                  "No Data") = IFNULL(CAST(b.Generation AS STRING),
                  "No Data")
                AND IFNULL(CAST(a.Functional_Organization AS STRING),
                  "No Data") = IFNULL(CAST(b.Functional_Organization AS STRING),
                  "No Data")
                AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
                  "No Data") = IFNULL(CAST(b.Primary_Work_Address_Country AS STRING),
                  "No Data")
                AND IFNULL(CAST(a.Employee_Type AS STRING),
                  "No Data") = IFNULL(CAST(b.Employee_Type AS STRING),
                  "No Data")
                AND IFNULL(CAST(a.Combined_Race_Ethnicity AS STRING),
                  "No Data") = IFNULL(CAST(b.Combined_Race_Ethnicity AS STRING),
                  "No Data")
                AND IFNULL(CAST(a.Other_Exclusions AS STRING),
                  "No Data") = IFNULL(CAST(b.Other_Exclusions AS STRING),
                  "No Data")
                AND IFNULL(CAST(a.CHANGE_IN_GL_TEXT AS STRING),
                  "No Data") = IFNULL(CAST(b.CHANGE_IN_GL_TEXT AS STRING),
                  "No Data") )
            SELECT
              a.*,
              IFNULL(b.TERMS,
                0) AS Count_TERMS_regret,
				IFNULL(b.ADJ_Base_Terms,
                0) AS Count_ADJ_Base_Terms_regret
            FROM
              TABLE_10 a
            LEFT JOIN (
              SELECT
                COUNT( DISTINCT a.EMPLOYEE_ID ) AS TERMS,
				SUM(CASE WHEN ADJ_Base IS NULL THEN 1 ELSE 0 END) AS ADJ_Base_Terms,
				EXTRACT(MONTH
                FROM
                  CAST(TERMINATION_DATE AS DATE)) AS MONTH,
                EXTRACT(YEAR
                FROM
                  CAST(TERMINATION_DATE AS DATE)) AS YEAR,
                COMPENSATION_GRADE,
                Time_Type,
                Class,
                FLSA,
                Gender,
                Generation,
                Functional_Organization,
                Primary_Work_Address_Country,
                Employee_Type,
                Combined_Race_Ethnicity,
                Other_Exclusions,
                CHANGE_IN_GL_TEXT
              FROM
                Working.With_GL_Columns a
              LEFT JOIN (
                SELECT
                  EMPLOYEE_ID,
                  TERMINATION_DATE,
                  Regrettable_Non_Regrettable
                FROM
                  `FY18Q3.Terminations` ) b
              ON
                a.EMPLOYEE_ID=b.EMPLOYEE_ID
              WHERE
                Regrettable_Non_Regrettable = "Regrettable"
                AND
                CASE
                  WHEN EXTRACT(MONTH  FROM  CAST(TERMINATION_DATE AS DATE))=1 THEN 12 = EXTRACT(MONTH  FROM  CAST(a.Report_effective_date AS DATE)) AND EXTRACT(YEAR  FROM  CAST(TERMINATION_DATE AS DATE))-1 = EXTRACT(YEAR  FROM  CAST(a.Report_effective_date AS DATE))
                  ELSE EXTRACT(MONTH
                FROM
                  CAST(TERMINATION_DATE AS DATE))-1 = EXTRACT(MONTH
                FROM
                  CAST(a.Report_effective_date AS DATE))
                AND EXTRACT(YEAR
                FROM
                  CAST(TERMINATION_DATE AS DATE)) = EXTRACT(YEAR
                FROM
                  CAST(a.Report_effective_date AS DATE))
                END
              GROUP BY
                EXTRACT(MONTH
                FROM
                  CAST(TERMINATION_DATE AS DATE)),
                EXTRACT(YEAR
                FROM
                  CAST(TERMINATION_DATE AS DATE)),
                Compensation_grade,
                Time_Type,
                Class,
                FLSA,
                Gender,
                Generation,
                Functional_Organization,
                Primary_Work_Address_Country,
                Employee_Type,
                Combined_Race_Ethnicity,
                Other_Exclusions,
                CHANGE_IN_GL_TEXT ) b
            ON
              CASE
                WHEN a.Report_Effective_Date IS NOT NULL THEN EXTRACT(MONTH  FROM  CAST(a.Report_Effective_Date AS DATETIME))
                ELSE NULL
              END = b.MONTH
              AND
              CASE
                WHEN a.Report_Effective_Date IS NOT NULL THEN EXTRACT(YEAR  FROM  CAST(a.Report_Effective_Date AS DATETIME))
                ELSE NULL
              END = b.YEAR
              AND IFNULL(CAST(a.Compensation_Grade AS STRING ),
                "No Data") = IFNULL(CAST(b.Compensation_Grade AS STRING ),
                "No Data")
              AND IFNULL(CAST(a.Time_Type AS STRING),
                "No Data") = IFNULL(CAST(b.Time_Type AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Class AS STRING),
                "No Data") = IFNULL(CAST(b.Class AS STRING),
                "No Data")
              AND IFNULL(CAST(a.FLSA AS STRING),
                "No Data") = IFNULL(CAST(b.FLSA AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Gender AS STRING),
                "No Data") = IFNULL(CAST(b.Gender AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Generation AS STRING),
                "No Data") = IFNULL(CAST(b.Generation AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Functional_Organization AS STRING),
                "No Data") = IFNULL(CAST(b.Functional_Organization AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
                "No Data") = IFNULL(CAST(b.Primary_Work_Address_Country AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Employee_Type AS STRING),
                "No Data") = IFNULL(CAST(b.Employee_Type AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Combined_Race_Ethnicity AS STRING),
                "No Data") = IFNULL(CAST(b.Combined_Race_Ethnicity AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Other_Exclusions AS STRING),
                "No Data") = IFNULL(CAST(b.Other_Exclusions AS STRING),
                "No Data")
              AND IFNULL(CAST(a.CHANGE_IN_GL_TEXT AS STRING),
                "No Data") = IFNULL(CAST(b.CHANGE_IN_GL_TEXT AS STRING),
                "No Data") )
          SELECT
            a.*,
            IFNULL(b.Promo_In,
              0) AS Count_Promo_In,
            IFNULL(b.Promo_In_gg,
              0) AS Count_Promo_In_gg,
            IFNULL(b.Promo_In_ggi,
              0) AS Count_Promo_In_ggi,
            IFNULL(b.Promo_In_i,
              0) AS Count_Promo_In_i,
			IFNULL(b.Promo_In_ADJ,
              0) AS Count_Promo_In_ADJ,
			  IFNULL(b.Promo_In_gg_ADJ,
              0) AS Count_Promo_In_gg_ADJ,
			   IFNULL(b.Promo_In_ggi_ADJ,
              0) AS Count_Promo_In_ggi_ADJ,
			   IFNULL(b.Promo_In_i_ADJ,
              0) AS Count_Promo_In_i_ADJ,
			    IFNULL(b.Promo_Within,  0) AS Count_Promo_Within,  
				  IFNULL(b.Promo_Within_gg,  0) AS Count_Promo_Within_gg,  
				  IFNULL(b.Promo_Within_ggi,  0) AS Count_Promo_Within_ggi,  
				  IFNULL(b.Promo_Within_i,  0) AS Count_Promo_Within_i, 
  IFNULL(b.Promo_Total_ADJ,  0) AS Count_Promo_Total_ADJ,  
				  IFNULL(b.Promo_Within_ADJ,  0) AS Count_Promo_Within_ADJ,  
				  IFNULL(b.Promo_Within_gg_ADJ,  0) AS Count_Promo_Within_gg_ADJ,  
				  IFNULL(b.Promo_Within_ggi_ADJ,  0) AS Count_Promo_Within_ggi_ADJ,  
				  IFNULL(b.Promo_Within_i_ADJ,  0) AS Count_Promo_Within_i_ADJ
				        FROM
            TABLE_11 a
          LEFT JOIN (
            SELECT
            COUNT( DISTINCT
                CASE
                  WHEN TYPE IS NULL AND Previous_Grade IS NOT NULL THEN Activity END) AS Promo_In,
			COUNT( DISTINCT
                CASE
                  WHEN TYPE IS NULL AND ADJ_Current IS NULL AND Previous_Grade IS NOT NULL THEN Activity END) AS Promo_In_ADJ,
			COUNT( DISTINCT CASE
                  WHEN TYPE_gg IS NULL
                AND Previous_Grade IS NOT NULL THEN Activity END) AS Promo_In_gg,
			COUNT( DISTINCT CASE
                  WHEN TYPE_gg IS NULL AND ADJ_current IS NULL AND Previous_Grade IS NOT NULL THEN Activity END) AS Promo_In_gg_ADJ,
			COUNT( DISTINCT CASE
                  WHEN TYPE_ggi IS NULL AND Previous_Grade IS NOT NULL THEN Activity END) AS Promo_In_ggi,
			COUNT( DISTINCT CASE
                  WHEN TYPE_ggi IS NULL AND ADJ_CURRENT IS NULL AND Previous_Grade IS NOT NULL THEN Activity END) AS Promo_In_ggi_ADJ,
			  COUNT( DISTINCT CASE
                  WHEN TYPE_i IS NULL
                AND Previous_Grade IS NOT NULL THEN Activity END) AS Promo_In_i,
			 COUNT( DISTINCT CASE
                  WHEN TYPE_i IS NULL AND ADJ_CURRENT IS NULL
                AND Previous_Grade IS NOT NULL THEN Activity END) AS Promo_In_i_ADJ,
					COUNT( DISTINCT CASE
                WHEN COMPENSATION_GRADE IS NULL
              OR TYPE IS NOT NULL THEN Activity END) AS Promo_Within,
            COUNT( DISTINCT
              CASE
                WHEN TYPE_gg IS NOT NULL OR COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Promo_Within_gg,
			COUNT( DISTINCT CASE
                WHEN TYPE_ggi IS NOT NULL
              OR COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Promo_Within_ggi,
            COUNT( DISTINCT
              CASE
                WHEN TYPE_i IS NOT NULL OR COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Promo_Within_i,
				COUNT( DISTINCT CASE WHEN ADJ_BASE IS NULL THEN Activity END ) AS Promo_Total_ADJ,  
			COUNT( DISTINCT CASE
                WHEN COMPENSATION_GRADE IS NULL
              OR TYPE IS NOT NULL AND ADJ_BASE IS NULL THEN Activity END) AS Promo_Within_ADJ,
            COUNT( DISTINCT
              CASE
                WHEN TYPE_gg IS NOT NULL AND ADJ_BASE IS NULL OR COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Promo_Within_gg_ADJ,
			COUNT( DISTINCT CASE
                WHEN TYPE_ggi IS NOT NULL AND ADJ_BASE IS NULL
              OR COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Promo_Within_ggi_ADJ,
            COUNT( DISTINCT
              CASE
                WHEN TYPE_i IS NOT NULL AND ADJ_BASE IS NULL OR COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Promo_Within_i_ADJ,
			Report_effective_date,  COMPENSATION_GRADE,  Time_Type,  Class,  FLSA,  Gender,  Generation,  Functional_Organization,  Primary_Work_Address_Country,  Employee_Type,  Combined_Race_Ethnicity,  Other_Exclusions,  CHANGE_IN_GL_TEXT  FROM ( SELECT  a.*, b.Employee_ID AS Activity, c.EMPLOYEE_ID AS TYPE, d.EMPLOYEE_ID AS TYPE_gg, e.EMPLOYEE_ID AS TYPE_ggi, f.EMPLOYEE_ID AS TYPE_i  FROM  `Working.With_GL_Columns` a  LEFT JOIN  `FY18Q3.Promotions` b ON  CAST(a.EMPLOYEE_ID AS STRING)= CAST(b.EMPLOYEE_ID AS STRING) AND EXTRACT(MONTH  FROM  a.REPORT_EFFECTIVE_DATE) = EXTRACT(MONTH  FROM  b.Business_process_effective_date) AND EXTRACT(YEAR  FROM  a.REPORT_EFFECTIVE_DATE) = EXTRACT(YEAR  FROM  b.Business_process_effective_date)  LEFT JOIN  `Working.With_GL_Columns` c ON  EXTRACT(MONTH  FROM  a.report_effective_date) = EXTRACT( MONTH  FROM  DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND EXTRACT(YEAR  FROM  a.report_effective_date) = EXTRACT( YEAR  FROM  DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND a.employee_ID = c.employee_ID AND IFNULL(CAST(a.Compensation_grade AS STRING ), "No Data") = IFNULL(CAST(c.Compensation_grade AS STRING ), "No Data") AND IFNULL(CAST(a.Time_Type AS STRING), "No Data") = IFNULL(CAST(c.Time_Type AS STRING), "No Data") AND IFNULL(CAST(a.Class AS STRING), "No Data") = IFNULL(CAST(c.Class AS STRING), "No Data") AND IFNULL(CAST(a.FLSA AS STRING), "No Data") = IFNULL(CAST(c.FLSA AS STRING), "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING), "No Data") = IFNULL(CAST(c.Functional_Organization AS STRING), "No Data") AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING), "No Data") = IFNULL(CAST(c.Primary_Work_Address_Country AS STRING), "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING), "No Data") = IFNULL(CAST(c.Employee_Type AS STRING), "No Data")  LEFT JOIN  `Working.With_GL_Columns` d ON  EXTRACT(MONTH  FROM  a.report_effective_date) = EXTRACT( MONTH  FROM  DATE_ADD(CAST(d.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND EXTRACT(YEAR  FROM  a.report_effective_date) = EXTRACT( YEAR  FROM  DATE_ADD(CAST(d.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND a.employee_ID = d.employee_ID AND IFNULL(CAST(a.grade_group AS STRING ), "No Data") = IFNULL(CAST(d.Grade_Group AS STRING ), "No Data") AND IFNULL(CAST(a.Time_Type AS STRING), "No Data") = IFNULL(CAST(d.Time_Type AS STRING), "No Data") AND IFNULL(CAST(a.Class AS STRING), "No Data") = IFNULL(CAST(d.Class AS STRING), "No Data") AND IFNULL(CAST(a.FLSA AS STRING), "No Data") = IFNULL(CAST(d.FLSA AS STRING), "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING), "No Data") = IFNULL(CAST(d.Functional_Organization AS STRING), "No Data") AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING), "No Data") = IFNULL(CAST(d.Primary_Work_Address_Country AS STRING), "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING), "No Data") = IFNULL(CAST(d.Employee_Type AS STRING), "No Data")  LEFT JOIN  `Working.With_GL_Columns` e ON  EXTRACT(MONTH  FROM  a.report_effective_date) = EXTRACT( MONTH  FROM  DATE_ADD(CAST(e.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND EXTRACT(YEAR  FROM  a.report_effective_date) = EXTRACT( YEAR  FROM  DATE_ADD(CAST(e.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND a.employee_ID = e.employee_ID AND IFNULL(CAST(a.grade_group AS STRING ), "No Data") = IFNULL(CAST(e.Grade_Group AS STRING ), "No Data") AND IFNULL(CAST(a.Time_Type AS STRING), "No Data") = IFNULL(CAST(e.Time_Type AS STRING), "No Data") AND IFNULL(CAST(a.Class AS STRING), "No Data") = IFNULL(CAST(e.Class AS STRING), "No Data") AND IFNULL(CAST(a.FLSA AS STRING), "No Data") = IFNULL(CAST(e.FLSA AS STRING), "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING), "No Data") = IFNULL(CAST(e.Functional_Organization AS STRING), "No Data") AND IFNULL(CAST(a.Country_group AS STRING), "No Data") = IFNULL(CAST(e.Country_group AS STRING), "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING), "No Data") = IFNULL(CAST(e.Employee_Type AS STRING), "No Data")  LEFT JOIN  `Working.With_GL_Columns` f ON  EXTRACT(MONTH  FROM  a.report_effective_date) = EXTRACT( MONTH  FROM  DATE_ADD(CAST(f.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND EXTRACT(YEAR  FROM  a.report_effective_date) = EXTRACT( YEAR  FROM  DATE_ADD(CAST(f.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND a.employee_ID = f.employee_ID AND IFNULL(CAST(a.Compensation_grade AS STRING ), "No Data") = IFNULL(CAST(f.Compensation_grade AS STRING ), "No Data") AND IFNULL(CAST(a.Time_Type AS STRING), "No Data") = IFNULL(CAST(f.Time_Type AS STRING), "No Data") AND IFNULL(CAST(a.Class AS STRING), "No Data") = IFNULL(CAST(f.Class AS STRING), "No Data") AND IFNULL(CAST(a.FLSA AS STRING), "No Data") = IFNULL(CAST(f.FLSA AS STRING), "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING), "No Data") = IFNULL(CAST(f.Functional_Organization AS STRING), "No Data") AND IFNULL(CAST(a.Country_group AS STRING), "No Data") = IFNULL(CAST(f.Country_group AS STRING), "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING), "No Data") = IFNULL(CAST(f.Employee_Type AS STRING), "No Data") )  GROUP BY  Report_effective_date,  Compensation_grade,  Time_Type,  Class,  FLSA,  Gender,  Generation,  Functional_Organization,  Primary_Work_Address_Country,  Employee_Type,  Combined_Race_Ethnicity,  Other_Exclusions,  CHANGE_IN_GL_TEXT ) b ON  IFNULL(CAST(a.report_effective_date AS STRING ),  "No Data") = IFNULL(CAST(b.report_effective_date AS STRING ),  "No Data") AND IFNULL(CAST(a.Compensation_Grade AS STRING ),  "No Data") = IFNULL(CAST(b.Compensation_Grade AS STRING ),  "No Data") AND IFNULL(CAST(a.Time_Type AS STRING),  "No Data") = IFNULL(CAST(b.Time_Type AS STRING),  "No Data") AND IFNULL(CAST(a.Class AS STRING),  "No Data") = IFNULL(CAST(b.Class AS STRING),  "No Data") AND IFNULL(CAST(a.FLSA AS STRING),  "No Data") = IFNULL(CAST(b.FLSA AS STRING),  "No Data") AND IFNULL(CAST(a.Gender AS STRING),  "No Data") = IFNULL(CAST(b.Gender AS STRING),  "No Data") AND IFNULL(CAST(a.Generation AS STRING),  "No Data") = IFNULL(CAST(b.Generation AS STRING),  "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING),  "No Data") = IFNULL(CAST(b.Functional_Organization AS STRING),  "No Data") AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),  "No Data") = IFNULL(CAST(b.Primary_Work_Address_Country AS STRING),  "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING),  "No Data") = IFNULL(CAST(b.Employee_Type AS STRING),  "No Data") AND IFNULL(CAST(a.Combined_Race_Ethnicity AS STRING),  "No Data") = IFNULL(CAST(b.Combined_Race_Ethnicity AS STRING),  "No Data") AND IFNULL(CAST(a.Other_Exclusions AS STRING),  "No Data") = IFNULL(CAST(b.Other_Exclusions AS STRING),  "No Data") AND IFNULL(CAST(a.CHANGE_IN_GL_TEXT AS STRING),  "No Data") = IFNULL(CAST(b.CHANGE_IN_GL_TEXT AS STRING),  "No Data"))  
				  SELECT  a.*, 
				  IFNULL(b.Promo_Out,  0) AS Count_Promo_Out,  
				  IFNULL(b.Promo_Out_gg,  0) AS Count_Promo_Out_gg,  
				  IFNULL(b.Promo_Out_ggi,  0) AS Count_Promo_Out_ggi,  
				  IFNULL(b.Promo_Out_i,  0) AS Count_Promo_Out_i,  
				  IFNULL(b.Promo_Total,  0) AS Count_Promo_Total,  
				  IFNULL(b.Promo_Out_ADJ,  0) AS Count_Promo_Out_ADJ,  
				  IFNULL(b.Promo_Out_gg_ADJ,  0) AS Count_Promo_Out_gg_ADJ,  
				  IFNULL(b.Promo_Out_ggi_ADJ,  0) AS Count_Promo_Out_ggi_ADJ,  
				  IFNULL(b.Promo_Out_i_ADJ,  0) AS Count_Promo_Out_i_ADJ
				    FROM  TABLE_12 a  
				  LEFT JOIN (  
				  SELECT  COUNT( DISTINCT CASE
                WHEN TYPE IS NULL
              AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Promo_Out,
			  COUNT( DISTINCT CASE
                WHEN TYPE IS NULL AND ADJ_Base IS NULL
              AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Promo_Out_ADJ,
            COUNT( DISTINCT
              CASE
                WHEN TYPE_gg IS NULL AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Promo_Out_gg,
 COUNT( DISTINCT
              CASE
                WHEN TYPE_gg IS NULL AND ADJ_Base IS NULL AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Promo_Out_gg_ADJ,			
			COUNT( DISTINCT CASE
                WHEN TYPE_ggi IS NULL
              AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Promo_Out_ggi,
			  COUNT( DISTINCT CASE
                WHEN TYPE_ggi IS NULL
              AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Promo_Out_ggi_ADJ,
            COUNT( DISTINCT
              CASE
                WHEN TYPE_i IS NULL AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Promo_Out_i,
				COUNT( DISTINCT
              CASE
                WHEN TYPE_i IS NULL AND ADJ_Base IS NULL AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Promo_Out_i_ADJ,
			COUNT( DISTINCT Activity ) AS Promo_Total,  
            Report_effective_date,
            COMPENSATION_GRADE,
            Time_Type,
            Class,
            FLSA,
            Gender,
            Generation,
            Functional_Organization,
            Primary_Work_Address_Country,
            Employee_Type,
            Combined_Race_Ethnicity,
            Other_Exclusions,
            CHANGE_IN_GL_TEXT
          FROM (
            SELECT
              a.*EXCEPT(COMPENSATION_GRADE,
                Time_Type,
                Class,
                FLSA,
                Functional_Organization,
                Primary_Work_Address_Country,
                Employee_Type),
              d.COMPENSATION_GRADE,
              d.Time_Type,
              d.Class,
              d.FLSA,
              d.Functional_Organization,
              d.Primary_Work_Address_Country,
              d.Employee_Type,
              b.Employee_ID AS Activity,
              c.EMPLOYEE_ID AS TYPE,
              g.EMPLOYEE_ID AS TYPE_gg,
              e.EMPLOYEE_ID AS TYPE_ggi,
              f.EMPLOYEE_ID AS TYPE_i
            FROM
              `Working.With_GL_Columns` a
            LEFT JOIN
              `FY18Q3.Promotions` b
            ON
              CAST(a.EMPLOYEE_ID AS STRING)= CAST(b.EMPLOYEE_ID AS STRING)
              AND EXTRACT(MONTH
              FROM
                a.REPORT_EFFECTIVE_DATE) = EXTRACT(MONTH
              FROM
                b.Business_process_effective_date)
              AND EXTRACT(YEAR
              FROM
                a.REPORT_EFFECTIVE_DATE) = EXTRACT(YEAR
              FROM
                b.Business_process_effective_date)
            LEFT JOIN
              `Working.With_GL_Columns` c
            ON
              EXTRACT(MONTH
              FROM
                a.report_effective_date) = EXTRACT( MONTH
              FROM
                DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH))
              AND EXTRACT(YEAR
              FROM
                a.report_effective_date) = EXTRACT( YEAR
              FROM
                DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH))
              AND a.employee_ID = c.employee_ID
              AND IFNULL(CAST(a.Compensation_grade AS STRING ),
                "No Data") = IFNULL(CAST(c.Compensation_grade AS STRING ),
                "No Data")
              AND IFNULL(CAST(a.Time_Type AS STRING),
                "No Data") = IFNULL(CAST(c.Time_Type AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Class AS STRING),
                "No Data") = IFNULL(CAST(c.Class AS STRING),
                "No Data")
              AND IFNULL(CAST(a.FLSA AS STRING),
                "No Data") = IFNULL(CAST(c.FLSA AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Functional_Organization AS STRING),
                "No Data") = IFNULL(CAST(c.Functional_Organization AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
                "No Data") = IFNULL(CAST(c.Primary_Work_Address_Country AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Employee_Type AS STRING),
                "No Data") = IFNULL(CAST(c.Employee_Type AS STRING),
                "No Data")
            LEFT JOIN
              Working.With_GL_Columns d
            ON
              EXTRACT(MONTH
              FROM
                a.report_effective_date) = EXTRACT( MONTH
              FROM
                DATE_ADD(CAST(d.report_effective_date AS DATE),INTERVAL 1 MONTH))
              AND EXTRACT(YEAR
              FROM
                a.report_effective_date) = EXTRACT( YEAR
              FROM
                DATE_ADD(CAST(d.report_effective_date AS DATE),INTERVAL 1 MONTH))
              AND a.employee_ID = d.employee_ID
            LEFT JOIN
              `Working.With_GL_Columns` e
            ON
              EXTRACT(MONTH
              FROM
                a.report_effective_date) = EXTRACT( MONTH
              FROM
                DATE_ADD(CAST(e.report_effective_date AS DATE),INTERVAL 1 MONTH))
              AND EXTRACT(YEAR
              FROM
                a.report_effective_date) = EXTRACT( YEAR
              FROM
                DATE_ADD(CAST(e.report_effective_date AS DATE),INTERVAL 1 MONTH))
              AND a.employee_ID = e.employee_ID
              AND IFNULL(CAST(a.grade_group AS STRING ),
                "No Data") = IFNULL(CAST(e.Grade_Group AS STRING ),
                "No Data")
              AND IFNULL(CAST(a.Time_Type AS STRING),
                "No Data") = IFNULL(CAST(e.Time_Type AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Class AS STRING),
                "No Data") = IFNULL(CAST(e.Class AS STRING),
                "No Data")
              AND IFNULL(CAST(a.FLSA AS STRING),
                "No Data") = IFNULL(CAST(e.FLSA AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Functional_Organization AS STRING),
                "No Data") = IFNULL(CAST(e.Functional_Organization AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Country_group AS STRING),
                "No Data") = IFNULL(CAST(e.Country_group AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Employee_Type AS STRING),
                "No Data") = IFNULL(CAST(e.Employee_Type AS STRING),
                "No Data")
            LEFT JOIN
              `Working.With_GL_Columns` f
            ON
              EXTRACT(MONTH
              FROM
                a.report_effective_date) = EXTRACT( MONTH
              FROM
                DATE_ADD(CAST(f.report_effective_date AS DATE),INTERVAL 1 MONTH))
              AND EXTRACT(YEAR
              FROM
                a.report_effective_date) = EXTRACT( YEAR
              FROM
                DATE_ADD(CAST(f.report_effective_date AS DATE),INTERVAL 1 MONTH))
              AND a.employee_ID = f.employee_ID
              AND IFNULL(CAST(a.Compensation_grade AS STRING ),
                "No Data") = IFNULL(CAST(f.Compensation_grade AS STRING ),
                "No Data")
              AND IFNULL(CAST(a.Time_Type AS STRING),
                "No Data") = IFNULL(CAST(f.Time_Type AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Class AS STRING),
                "No Data") = IFNULL(CAST(f.Class AS STRING),
                "No Data")
              AND IFNULL(CAST(a.FLSA AS STRING),
                "No Data") = IFNULL(CAST(f.FLSA AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Functional_Organization AS STRING),
                "No Data") = IFNULL(CAST(f.Functional_Organization AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Country_group AS STRING),
                "No Data") = IFNULL(CAST(f.Country_group AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Employee_Type AS STRING),
                "No Data") = IFNULL(CAST(f.Employee_Type AS STRING),
                "No Data")
            LEFT JOIN
              `Working.With_GL_Columns` g
            ON
              EXTRACT(MONTH
              FROM
                a.report_effective_date) = EXTRACT( MONTH
              FROM
                DATE_ADD(CAST(g.report_effective_date AS DATE),INTERVAL 1 MONTH))
              AND EXTRACT(YEAR
              FROM
                a.report_effective_date) = EXTRACT( YEAR
              FROM
                DATE_ADD(CAST(g.report_effective_date AS DATE),INTERVAL 1 MONTH))
              AND a.employee_ID = g.employee_ID
              AND IFNULL(CAST(a.grade_group AS STRING ),
                "No Data") = IFNULL(CAST(g.Grade_Group AS STRING ),
                "No Data")
              AND IFNULL(CAST(a.Time_Type AS STRING),
                "No Data") = IFNULL(CAST(g.Time_Type AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Class AS STRING),
                "No Data") = IFNULL(CAST(g.Class AS STRING),
                "No Data")
              AND IFNULL(CAST(a.FLSA AS STRING),
                "No Data") = IFNULL(CAST(g.FLSA AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Functional_Organization AS STRING),
                "No Data") = IFNULL(CAST(g.Functional_Organization AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
                "No Data") = IFNULL(CAST(g.Primary_Work_Address_Country AS STRING),
                "No Data")
              AND IFNULL(CAST(a.Employee_Type AS STRING),
                "No Data") = IFNULL(CAST(g.Employee_Type AS STRING),
                "No Data") )
          GROUP BY
            Report_effective_date,
            Compensation_grade,
            Time_Type,
            Class,
            FLSA,
            Gender,
            Generation,
            Functional_Organization,
            Primary_Work_Address_Country,
            Employee_Type,
            Combined_Race_Ethnicity,
            Other_Exclusions,
            CHANGE_IN_GL_TEXT) b
        ON
          IFNULL(CAST(a.Report_effective_date AS STRING ),
            "No Data") = IFNULL(CAST(b.Report_effective_date AS STRING ),
            "No Data")
          AND IFNULL(CAST(a.Compensation_Grade AS STRING ),
            "No Data") = IFNULL(CAST(b.Compensation_Grade AS STRING ),
            "No Data")
          AND IFNULL(CAST(a.Time_Type AS STRING),
            "No Data") = IFNULL(CAST(b.Time_Type AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Class AS STRING),
            "No Data") = IFNULL(CAST(b.Class AS STRING),
            "No Data")
          AND IFNULL(CAST(a.FLSA AS STRING),
            "No Data") = IFNULL(CAST(b.FLSA AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Gender AS STRING),
            "No Data") = IFNULL(CAST(b.Gender AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Generation AS STRING),
            "No Data") = IFNULL(CAST(b.Generation AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Functional_Organization AS STRING),
            "No Data") = IFNULL(CAST(b.Functional_Organization AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
            "No Data") = IFNULL(CAST(b.Primary_Work_Address_Country AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Employee_Type AS STRING),
            "No Data") = IFNULL(CAST(b.Employee_Type AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Combined_Race_Ethnicity AS STRING),
            "No Data") = IFNULL(CAST(b.Combined_Race_Ethnicity AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Other_Exclusions AS STRING),
            "No Data") = IFNULL(CAST(b.Other_Exclusions AS STRING),
            "No Data")
          AND IFNULL(CAST(a.CHANGE_IN_GL_TEXT AS STRING),
            "No Data") = IFNULL(CAST(b.CHANGE_IN_GL_TEXT AS STRING),
            "No Data"))
      SELECT
        a.*,
        IFNULL(b.Demo_In,
          0) AS Count_Demo_In,
        IFNULL(b.Demo_In_gg,
          0) AS Count_Demo_In_gg,
        IFNULL(b.Demo_In_ggi,
          0) AS Count_Demo_In_ggi,
        IFNULL(b.Demo_In_i,
          0) AS Count_Demo_In_i,
			IFNULL(b.Demo_In_ADJ,
              0) AS Count_Demo_In_ADJ,
			   IFNULL(b.Demo_In_gg_ADJ,
          0) AS Count_Demo_In_gg_ADJ,
        IFNULL(b.Demo_In_ggi_ADJ,
          0) AS Count_Demo_In_ggi_ADJ,
        IFNULL(b.Demo_In_i_ADJ,
          0) AS Count_Demo_In_i_ADJ,
		  IFNULL(b.Demo_Within,  0) AS Count_Demo_Within,
  IFNULL(b.Demo_Within_gg,  0) AS Count_Demo_Within_gg,
  IFNULL(b.Demo_Within_ggi,  0) AS Count_Demo_Within_ggi,
  IFNULL(b.Demo_Within_i,  0) AS Count_Demo_Within_i,
    IFNULL(b.Demo_Total_ADJ,  0) AS Count_Demo_Total_ADJ,
  IFNULL(b.Demo_Within_ADJ,  0) AS Count_Demo_Within_ADJ,
  IFNULL(b.Demo_Within_gg_ADJ,  0) AS Count_Demo_Within_gg_ADJ,
  IFNULL(b.Demo_Within_ggi_ADJ,  0) AS Count_Demo_Within_ggi_ADJ,
  IFNULL(b.Demo_Within_i_ADJ,  0) AS Count_Demo_Within_i_ADJ
      FROM
        TABLE_13 a
      LEFT JOIN (
        SELECT
		
          COUNT( DISTINCT
            CASE
              WHEN TYPE IS NULL AND Previous_Grade IS NOT NULL THEN Activity END) AS Demo_In,
		  COUNT( DISTINCT CASE
              WHEN TYPE_gg IS NULL
            AND Previous_Grade IS NOT NULL THEN Activity END) AS Demo_In_gg,
          COUNT( DISTINCT
            CASE
              WHEN TYPE_ggi IS NULL AND Previous_Grade IS NOT NULL THEN Activity END) AS Demo_In_ggi,
		  COUNT( DISTINCT CASE
              WHEN TYPE_i IS NULL
            AND Previous_Grade IS NOT NULL THEN Activity END) AS Demo_In_i,
         COUNT( DISTINCT
            CASE
              WHEN TYPE IS NULL AND ADJ_CURRENT IS NULL AND Previous_Grade IS NOT NULL THEN Activity END) AS Demo_In_ADJ,
		  COUNT( DISTINCT CASE
              WHEN TYPE_gg IS NULL AND ADJ_Current IS NULL
            AND Previous_Grade IS NOT NULL THEN Activity END) AS Demo_In_gg_ADJ,
          COUNT( DISTINCT
            CASE
              WHEN TYPE_ggi IS NULL AND ADJ_CURRENT IS NULL AND Previous_Grade IS NOT NULL THEN Activity END) AS Demo_In_ggi_ADJ,
		  COUNT( DISTINCT CASE
              WHEN TYPE_i IS NULL AND ADJ_Current IS NULL
            AND Previous_Grade IS NOT NULL THEN Activity END) AS Demo_In_i_ADJ,
				COUNT( DISTINCT CASE
            WHEN COMPENSATION_GRADE IS NULL
          OR TYPE IS NOT NULL THEN Activity END) AS Demo_Within,
        COUNT( DISTINCT
          CASE
            WHEN TYPE_gg IS NOT NULL OR COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Demo_Within_gg,
		COUNT( DISTINCT CASE
            WHEN TYPE_ggi IS NOT NULL
          OR COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Demo_Within_ggi,
        COUNT( DISTINCT
          CASE
            WHEN TYPE_i IS NOT NULL OR COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Demo_Within_i,
		COUNT( DISTINCT CASE WHEN ADJ_BASE IS NULL THEN Activity END ) AS Demo_Total_ADJ,
		COUNT( DISTINCT CASE
            WHEN COMPENSATION_GRADE IS NULL
          OR TYPE IS NOT NULL AND ADJ_BASE IS NULL THEN Activity END) AS Demo_Within_ADJ,
        COUNT( DISTINCT
          CASE
            WHEN TYPE_gg IS NOT NULL AND ADJ_BASE IS NULL OR COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Demo_Within_gg_ADJ,
		COUNT( DISTINCT CASE
            WHEN TYPE_ggi IS NOT NULL AND ADJ_BASE IS NULL
          OR COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Demo_Within_ggi_ADJ,
        COUNT( DISTINCT
          CASE
            WHEN TYPE_i IS NOT NULL AND ADJ_BASE IS NULL OR COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Demo_Within_i_ADJ,
			Report_effective_date,  COMPENSATION_GRADE,  Time_Type,  Class,  FLSA,  Gender,  Generation,  Functional_Organization,  Primary_Work_Address_Country,  Employee_Type,  Combined_Race_Ethnicity,  Other_Exclusions,  CHANGE_IN_GL_TEXT  FROM ( SELECT  a.*, b.Employee_ID AS Activity, c.EMPLOYEE_ID AS TYPE, d.EMPLOYEE_ID AS TYPE_gg, e.EMPLOYEE_ID AS TYPE_ggi, f.EMPLOYEE_ID AS TYPE_i  FROM  `Working.With_GL_Columns` a  LEFT JOIN  `FY18Q3.Demotions` b ON  CAST(a.EMPLOYEE_ID AS STRING)= CAST(b.EMPLOYEE_ID AS STRING) AND EXTRACT(MONTH  FROM  a.REPORT_EFFECTIVE_DATE) = EXTRACT(MONTH  FROM  b.Business_process_effective_date) AND EXTRACT(YEAR  FROM  a.REPORT_EFFECTIVE_DATE) = EXTRACT(YEAR  FROM  b.Business_process_effective_date)  LEFT JOIN  `Working.With_GL_Columns` c ON  EXTRACT(MONTH  FROM  a.report_effective_date) = EXTRACT( MONTH  FROM  DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND EXTRACT(YEAR  FROM  a.report_effective_date) = EXTRACT( YEAR  FROM  DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND a.employee_ID = c.employee_ID AND IFNULL(CAST(a.Compensation_grade AS STRING ), "No Data") = IFNULL(CAST(c.Compensation_grade AS STRING ), "No Data") AND IFNULL(CAST(a.Time_Type AS STRING), "No Data") = IFNULL(CAST(c.Time_Type AS STRING), "No Data") AND IFNULL(CAST(a.Class AS STRING), "No Data") = IFNULL(CAST(c.Class AS STRING), "No Data") AND IFNULL(CAST(a.FLSA AS STRING), "No Data") = IFNULL(CAST(c.FLSA AS STRING), "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING), "No Data") = IFNULL(CAST(c.Functional_Organization AS STRING), "No Data") AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING), "No Data") = IFNULL(CAST(c.Primary_Work_Address_Country AS STRING), "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING), "No Data") = IFNULL(CAST(c.Employee_Type AS STRING), "No Data")  LEFT JOIN  `Working.With_GL_Columns` d ON  EXTRACT(MONTH  FROM  a.report_effective_date) = EXTRACT( MONTH  FROM  DATE_ADD(CAST(d.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND EXTRACT(YEAR  FROM  a.report_effective_date) = EXTRACT( YEAR  FROM  DATE_ADD(CAST(d.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND a.employee_ID = d.employee_ID AND IFNULL(CAST(a.grade_group AS STRING ), "No Data") = IFNULL(CAST(d.Grade_Group AS STRING ), "No Data") AND IFNULL(CAST(a.Time_Type AS STRING), "No Data") = IFNULL(CAST(d.Time_Type AS STRING), "No Data") AND IFNULL(CAST(a.Class AS STRING), "No Data") = IFNULL(CAST(d.Class AS STRING), "No Data") AND IFNULL(CAST(a.FLSA AS STRING), "No Data") = IFNULL(CAST(d.FLSA AS STRING), "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING), "No Data") = IFNULL(CAST(d.Functional_Organization AS STRING), "No Data") AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING), "No Data") = IFNULL(CAST(d.Primary_Work_Address_Country AS STRING), "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING), "No Data") = IFNULL(CAST(d.Employee_Type AS STRING), "No Data")  LEFT JOIN  `Working.With_GL_Columns` e ON  EXTRACT(MONTH  FROM  a.report_effective_date) = EXTRACT( MONTH  FROM  DATE_ADD(CAST(e.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND EXTRACT(YEAR  FROM  a.report_effective_date) = EXTRACT( YEAR  FROM  DATE_ADD(CAST(e.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND a.employee_ID = e.employee_ID AND IFNULL(CAST(a.grade_group AS STRING ), "No Data") = IFNULL(CAST(e.Grade_Group AS STRING ), "No Data") AND IFNULL(CAST(a.Time_Type AS STRING), "No Data") = IFNULL(CAST(e.Time_Type AS STRING), "No Data") AND IFNULL(CAST(a.Class AS STRING), "No Data") = IFNULL(CAST(e.Class AS STRING), "No Data") AND IFNULL(CAST(a.FLSA AS STRING), "No Data") = IFNULL(CAST(e.FLSA AS STRING), "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING), "No Data") = IFNULL(CAST(e.Functional_Organization AS STRING), "No Data") AND IFNULL(CAST(a.Country_group AS STRING), "No Data") = IFNULL(CAST(e.Country_group AS STRING), "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING), "No Data") = IFNULL(CAST(e.Employee_Type AS STRING), "No Data")  LEFT JOIN  `Working.With_GL_Columns` f ON  EXTRACT(MONTH  FROM  a.report_effective_date) = EXTRACT( MONTH  FROM  DATE_ADD(CAST(f.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND EXTRACT(YEAR  FROM  a.report_effective_date) = EXTRACT( YEAR  FROM  DATE_ADD(CAST(f.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND a.employee_ID = f.employee_ID AND IFNULL(CAST(a.Compensation_grade AS STRING ), "No Data") = IFNULL(CAST(f.Compensation_grade AS STRING ), "No Data") AND IFNULL(CAST(a.Time_Type AS STRING), "No Data") = IFNULL(CAST(f.Time_Type AS STRING), "No Data") AND IFNULL(CAST(a.Class AS STRING), "No Data") = IFNULL(CAST(f.Class AS STRING), "No Data") AND IFNULL(CAST(a.FLSA AS STRING), "No Data") = IFNULL(CAST(f.FLSA AS STRING), "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING), "No Data") = IFNULL(CAST(f.Functional_Organization AS STRING), "No Data") AND IFNULL(CAST(a.Country_group AS STRING), "No Data") = IFNULL(CAST(f.Country_group AS STRING), "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING), "No Data") = IFNULL(CAST(f.Employee_Type AS STRING), "No Data") )  GROUP BY  Report_effective_date,  Compensation_grade,  Time_Type,  Class,  FLSA,  Gender,  Generation,  Functional_Organization,  Primary_Work_Address_Country,  Employee_Type,  Combined_Race_Ethnicity,  Other_Exclusions,  CHANGE_IN_GL_TEXT ) b ON  IFNULL(CAST(a.report_effective_date AS STRING ),  "No Data") = IFNULL(CAST(b.report_effective_date AS STRING ),  "No Data") AND IFNULL(CAST(a.Compensation_Grade AS STRING ),  "No Data") = IFNULL(CAST(b.Compensation_Grade AS STRING ),  "No Data") AND IFNULL(CAST(a.Time_Type AS STRING),  "No Data") = IFNULL(CAST(b.Time_Type AS STRING),  "No Data") AND IFNULL(CAST(a.Class AS STRING),  "No Data") = IFNULL(CAST(b.Class AS STRING),  "No Data") AND IFNULL(CAST(a.FLSA AS STRING),  "No Data") = IFNULL(CAST(b.FLSA AS STRING),  "No Data") AND IFNULL(CAST(a.Gender AS STRING),  "No Data") = IFNULL(CAST(b.Gender AS STRING),  "No Data") AND IFNULL(CAST(a.Generation AS STRING),  "No Data") = IFNULL(CAST(b.Generation AS STRING),  "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING),  "No Data") = IFNULL(CAST(b.Functional_Organization AS STRING),  "No Data") AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),  "No Data") = IFNULL(CAST(b.Primary_Work_Address_Country AS STRING),  "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING),  "No Data") = IFNULL(CAST(b.Employee_Type AS STRING),  "No Data") AND IFNULL(CAST(a.Combined_Race_Ethnicity AS STRING),  "No Data") = IFNULL(CAST(b.Combined_Race_Ethnicity AS STRING),  "No Data") AND IFNULL(CAST(a.Other_Exclusions AS STRING),  "No Data") = IFNULL(CAST(b.Other_Exclusions AS STRING),  "No Data") AND IFNULL(CAST(a.CHANGE_IN_GL_TEXT AS STRING),  "No Data") = IFNULL(CAST(b.CHANGE_IN_GL_TEXT AS STRING),  "No Data"))

  SELECT  a.*,
  IFNULL(b.Demo_Out,  0) AS Count_Demo_Out,
  IFNULL(b.Demo_Out_gg,  0) AS Count_Demo_Out_gg,
  IFNULL(b.Demo_Out_ggi,  0) AS Count_Demo_Out_ggi,
  IFNULL(b.Demo_Out_i,  0) AS Count_Demo_Out_i,
  IFNULL(b.Demo_Total,  0) AS Count_Demo_Total,
  IFNULL(b.Demo_Out_ADJ,  0) AS Count_Demo_Out_ADJ,
  IFNULL(b.Demo_Out_gg_ADJ,  0) AS Count_Demo_Out_gg_ADJ,
  IFNULL(b.Demo_Out_ggi_ADJ,  0) AS Count_Demo_Out_ggi_ADJ,
  IFNULL(b.Demo_Out_i_ADJ,  0) AS Count_Demo_Out_i_ADJ
  

  FROM  TABLE_14 a  LEFT JOIN (  SELECT  COUNT( DISTINCT CASE
            WHEN TYPE IS NULL
          AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Demo_Out,
        COUNT( DISTINCT
          CASE
            WHEN TYPE_gg IS NULL AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Demo_Out_gg,
		COUNT( DISTINCT CASE
            WHEN TYPE_ggi IS NULL
          AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Demo_Out_ggi,
        COUNT( DISTINCT
          CASE
            WHEN TYPE_i IS NULL AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Demo_Out_i,
		
		COUNT( DISTINCT Activity ) AS Demo_Total,  
	COUNT( DISTINCT CASE
            WHEN TYPE IS NULL
          AND COMPENSATION_GRADE IS NOT NULL AND ADJ_Base IS NULL THEN Activity END) AS Demo_Out_ADJ,
        COUNT( DISTINCT
          CASE
            WHEN TYPE_gg IS NULL AND ADJ_Base IS NULL AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Demo_Out_gg_ADJ,
		COUNT( DISTINCT CASE
            WHEN TYPE_ggi IS NULL AND ADJ_Base IS NULL
          AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Demo_Out_ggi_ADJ,
        COUNT( DISTINCT
          CASE
            WHEN TYPE_i IS NULL AND ADJ_Base IS NULL AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Demo_Out_i_ADJ,
        Report_effective_date,
        COMPENSATION_GRADE,
        Time_Type,
        Class,
        FLSA,
        Gender,
        Generation,
        Functional_Organization,
        Primary_Work_Address_Country,
        Employee_Type,
        Combined_Race_Ethnicity,
        Other_Exclusions,
        CHANGE_IN_GL_TEXT
      FROM (
        SELECT
          a.*EXCEPT(COMPENSATION_GRADE,
            Time_Type,
            Class,
            FLSA,
            Functional_Organization,
            Primary_Work_Address_Country,
            Employee_Type),
          d.COMPENSATION_GRADE,
          d.Time_Type,
          d.Class,
          d.FLSA,
          d.Functional_Organization,
          d.Primary_Work_Address_Country,
          d.Employee_Type,
          b.Employee_ID AS Activity,
          c.EMPLOYEE_ID AS TYPE,
          g.EMPLOYEE_ID AS TYPE_gg,
          e.EMPLOYEE_ID AS TYPE_ggi,
          f.EMPLOYEE_ID AS TYPE_i
        FROM
          `Working.With_GL_Columns` a
        LEFT JOIN
          `FY18Q3.Demotions` b
        ON
          CAST(a.EMPLOYEE_ID AS STRING)= CAST(b.EMPLOYEE_ID AS STRING)
          AND EXTRACT(MONTH
          FROM
            a.REPORT_EFFECTIVE_DATE) = EXTRACT(MONTH
          FROM
            b.Business_process_effective_date)
          AND EXTRACT(YEAR
          FROM
            a.REPORT_EFFECTIVE_DATE) = EXTRACT(YEAR
          FROM
            b.Business_process_effective_date)
        LEFT JOIN
          `Working.With_GL_Columns` c
        ON
          EXTRACT(MONTH
          FROM
            a.report_effective_date) = EXTRACT( MONTH
          FROM
            DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH))
          AND EXTRACT(YEAR
          FROM
            a.report_effective_date) = EXTRACT( YEAR
          FROM
            DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH))
          AND a.employee_ID = c.employee_ID
          AND IFNULL(CAST(a.Compensation_grade AS STRING ),
            "No Data") = IFNULL(CAST(c.Compensation_grade AS STRING ),
            "No Data")
          AND IFNULL(CAST(a.Time_Type AS STRING),
            "No Data") = IFNULL(CAST(c.Time_Type AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Class AS STRING),
            "No Data") = IFNULL(CAST(c.Class AS STRING),
            "No Data")
          AND IFNULL(CAST(a.FLSA AS STRING),
            "No Data") = IFNULL(CAST(c.FLSA AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Functional_Organization AS STRING),
            "No Data") = IFNULL(CAST(c.Functional_Organization AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
            "No Data") = IFNULL(CAST(c.Primary_Work_Address_Country AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Employee_Type AS STRING),
            "No Data") = IFNULL(CAST(c.Employee_Type AS STRING),
            "No Data")
        LEFT JOIN
          Working.With_GL_Columns d
        ON
          EXTRACT(MONTH
          FROM
            a.report_effective_date) = EXTRACT( MONTH
          FROM
            DATE_ADD(CAST(d.report_effective_date AS DATE),INTERVAL 1 MONTH))
          AND EXTRACT(YEAR
          FROM
            a.report_effective_date) = EXTRACT( YEAR
          FROM
            DATE_ADD(CAST(d.report_effective_date AS DATE),INTERVAL 1 MONTH))
          AND a.employee_ID = d.employee_ID
        LEFT JOIN
          `Working.With_GL_Columns` e
        ON
          EXTRACT(MONTH
          FROM
            a.report_effective_date) = EXTRACT( MONTH
          FROM
            DATE_ADD(CAST(e.report_effective_date AS DATE),INTERVAL 1 MONTH))
          AND EXTRACT(YEAR
          FROM
            a.report_effective_date) = EXTRACT( YEAR
          FROM
            DATE_ADD(CAST(e.report_effective_date AS DATE),INTERVAL 1 MONTH))
          AND a.employee_ID = e.employee_ID
          AND IFNULL(CAST(a.grade_group AS STRING ),
            "No Data") = IFNULL(CAST(e.Grade_Group AS STRING ),
            "No Data")
          AND IFNULL(CAST(a.Time_Type AS STRING),
            "No Data") = IFNULL(CAST(e.Time_Type AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Class AS STRING),
            "No Data") = IFNULL(CAST(e.Class AS STRING),
            "No Data")
          AND IFNULL(CAST(a.FLSA AS STRING),
            "No Data") = IFNULL(CAST(e.FLSA AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Functional_Organization AS STRING),
            "No Data") = IFNULL(CAST(e.Functional_Organization AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Country_group AS STRING),
            "No Data") = IFNULL(CAST(e.Country_group AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Employee_Type AS STRING),
            "No Data") = IFNULL(CAST(e.Employee_Type AS STRING),
            "No Data")
        LEFT JOIN
          `Working.With_GL_Columns` f
        ON
          EXTRACT(MONTH
          FROM
            a.report_effective_date) = EXTRACT( MONTH
          FROM
            DATE_ADD(CAST(f.report_effective_date AS DATE),INTERVAL 1 MONTH))
          AND EXTRACT(YEAR
          FROM
            a.report_effective_date) = EXTRACT( YEAR
          FROM
            DATE_ADD(CAST(f.report_effective_date AS DATE),INTERVAL 1 MONTH))
          AND a.employee_ID = f.employee_ID
          AND IFNULL(CAST(a.Compensation_grade AS STRING ),
            "No Data") = IFNULL(CAST(f.Compensation_grade AS STRING ),
            "No Data")
          AND IFNULL(CAST(a.Time_Type AS STRING),
            "No Data") = IFNULL(CAST(f.Time_Type AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Class AS STRING),
            "No Data") = IFNULL(CAST(f.Class AS STRING),
            "No Data")
          AND IFNULL(CAST(a.FLSA AS STRING),
            "No Data") = IFNULL(CAST(f.FLSA AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Functional_Organization AS STRING),
            "No Data") = IFNULL(CAST(f.Functional_Organization AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Country_group AS STRING),
            "No Data") = IFNULL(CAST(f.Country_group AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Employee_Type AS STRING),
            "No Data") = IFNULL(CAST(f.Employee_Type AS STRING),
            "No Data")
        LEFT JOIN
          `Working.With_GL_Columns` g
        ON
          EXTRACT(MONTH
          FROM
            a.report_effective_date) = EXTRACT( MONTH
          FROM
            DATE_ADD(CAST(g.report_effective_date AS DATE),INTERVAL 1 MONTH))
          AND EXTRACT(YEAR
          FROM
            a.report_effective_date) = EXTRACT( YEAR
          FROM
            DATE_ADD(CAST(g.report_effective_date AS DATE),INTERVAL 1 MONTH))
          AND a.employee_ID = g.employee_ID
          AND IFNULL(CAST(a.grade_group AS STRING ),
            "No Data") = IFNULL(CAST(g.Grade_Group AS STRING ),
            "No Data")
          AND IFNULL(CAST(a.Time_Type AS STRING),
            "No Data") = IFNULL(CAST(g.Time_Type AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Class AS STRING),
            "No Data") = IFNULL(CAST(g.Class AS STRING),
            "No Data")
          AND IFNULL(CAST(a.FLSA AS STRING),
            "No Data") = IFNULL(CAST(g.FLSA AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Functional_Organization AS STRING),
            "No Data") = IFNULL(CAST(g.Functional_Organization AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
            "No Data") = IFNULL(CAST(g.Primary_Work_Address_Country AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Employee_Type AS STRING),
            "No Data") = IFNULL(CAST(g.Employee_Type AS STRING),
            "No Data") )
      GROUP BY
        Report_effective_date,
        Compensation_grade,
        Time_Type,
        Class,
        FLSA,
        Gender,
        Generation,
        Functional_Organization,
        Primary_Work_Address_Country,
        Employee_Type,
        Combined_Race_Ethnicity,
        Other_Exclusions,
        CHANGE_IN_GL_TEXT) b
    ON
      IFNULL(CAST(a.Report_effective_date AS STRING ),
        "No Data") = IFNULL(CAST(b.Report_effective_date AS STRING ),
        "No Data")
      AND IFNULL(CAST(a.Compensation_Grade AS STRING ),
        "No Data") = IFNULL(CAST(b.Compensation_Grade AS STRING ),
        "No Data")
      AND IFNULL(CAST(a.Time_Type AS STRING),
        "No Data") = IFNULL(CAST(b.Time_Type AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Class AS STRING),
        "No Data") = IFNULL(CAST(b.Class AS STRING),
        "No Data")
      AND IFNULL(CAST(a.FLSA AS STRING),
        "No Data") = IFNULL(CAST(b.FLSA AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Gender AS STRING),
        "No Data") = IFNULL(CAST(b.Gender AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Generation AS STRING),
        "No Data") = IFNULL(CAST(b.Generation AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Functional_Organization AS STRING),
        "No Data") = IFNULL(CAST(b.Functional_Organization AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
        "No Data") = IFNULL(CAST(b.Primary_Work_Address_Country AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Employee_Type AS STRING),
        "No Data") = IFNULL(CAST(b.Employee_Type AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Combined_Race_Ethnicity AS STRING),
        "No Data") = IFNULL(CAST(b.Combined_Race_Ethnicity AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Other_Exclusions AS STRING),
        "No Data") = IFNULL(CAST(b.Other_Exclusions AS STRING),
        "No Data")
      AND IFNULL(CAST(a.CHANGE_IN_GL_TEXT AS STRING),
        "No Data") = IFNULL(CAST(b.CHANGE_IN_GL_TEXT AS STRING),
        "No Data"))
  SELECT
    a.*,
    IFNULL(b.Transfer_In,
      0) AS Count_Transfer_In,
    IFNULL(b.Transfer_In_gg,
      0) AS Count_Transfer_In_gg,
    IFNULL(b.Transfer_In_ggi,
      0) AS Count_Transfer_In_ggi,
    IFNULL(b.Transfer_In_i,
      0) AS Count_Transfer_In_i,
	IFNULL(b.Transfer_In_ADJ,
      0) AS Count_Transfer_In_ADJ,
    IFNULL(b.Transfer_In_gg_ADJ,
      0) AS Count_Transfer_In_gg_ADJ,
    IFNULL(b.Transfer_In_ggi_ADJ,
      0) AS Count_Transfer_In_ggi_ADJ,
    IFNULL(b.Transfer_In_i_ADJ,
      0) AS Count_Transfer_In_i_ADJ,
	  	  IFNULL(b.Transfer_Within,  0) AS Count_Transfer_Within,  
	  IFNULL(b.Transfer_Within_gg,  0) AS Count_Transfer_Within_gg,  
	  IFNULL(b.Transfer_Within_ggi,  0) AS Count_Transfer_Within_ggi,  
	  IFNULL(b.Transfer_Within_i,  0) AS Count_Transfer_Within_i,  
	  IFNULL(b.Transfer_Total_ADJ,  0) AS Count_Transfer_Total_ADJ,  
	  IFNULL(b.Transfer_Within_ADJ,  0) AS Count_Transfer_Within_ADJ,  
	  IFNULL(b.Transfer_Within_gg_ADJ,  0) AS Count_Transfer_Within_gg_ADJ,  
	  IFNULL(b.Transfer_Within_ggi_ADJ,  0) AS Count_Transfer_Within_ggi_ADJ,  
	  IFNULL(b.Transfer_Within_i_ADJ,  0) AS Count_Transfer_Within_i_ADJ
	   
		  FROM
    TABLE_15 a
  LEFT JOIN (
    SELECT
      COUNT( DISTINCT
        CASE
          WHEN TYPE IS NULL AND Previous_Grade IS NOT NULL THEN Activity END) AS Transfer_In,
	  COUNT( DISTINCT CASE
          WHEN TYPE_gg IS NULL
        AND Previous_Grade IS NOT NULL THEN Activity END) AS Transfer_In_gg,
      COUNT( DISTINCT
        CASE
          WHEN TYPE_ggi IS NULL AND Previous_Grade IS NOT NULL THEN Activity END) AS Transfer_In_ggi,
	  COUNT( DISTINCT CASE
          WHEN TYPE_i IS NULL
        AND Previous_Grade IS NOT NULL THEN Activity END) AS Transfer_In_i,
	COUNT( DISTINCT
        CASE
          WHEN TYPE IS NULL AND ADJ_CURRENT IS NULL AND Previous_Grade IS NOT NULL THEN Activity END) AS Transfer_In_ADJ,
	  COUNT( DISTINCT CASE
          WHEN TYPE_gg IS NULL
        AND Previous_Grade IS NOT NULL AND ADJ_Current IS NULL THEN Activity END) AS Transfer_In_gg_ADJ,
      COUNT( DISTINCT
        CASE
          WHEN TYPE_ggi IS NULL AND Previous_Grade IS NOT NULL AND ADJ_Current IS NULL THEN Activity END) AS Transfer_In_ggi_ADJ,
	  COUNT( DISTINCT CASE
          WHEN TYPE_i IS NULL AND ADJ_Current IS NULL
        AND Previous_Grade IS NOT NULL THEN Activity END) AS Transfer_In_i_ADJ,
	COUNT( DISTINCT CASE
        WHEN COMPENSATION_GRADE IS NULL
      OR TYPE IS NOT NULL THEN Activity END) AS Transfer_Within,
    COUNT( DISTINCT
      CASE
        WHEN TYPE_gg IS NOT NULL OR COMPENSATION_GRADE IS NULL THEN Activity END) AS Transfer_Within_gg,
	COUNT( DISTINCT CASE
        WHEN TYPE_ggi IS NOT NULL
      OR COMPENSATION_GRADE IS NULL THEN Activity END) AS Transfer_Within_ggi,
    COUNT( DISTINCT
      CASE
        WHEN TYPE_i IS NOT NULL OR COMPENSATION_GRADE IS NULL THEN Activity END) AS Transfer_Within_i,
	COUNT( DISTINCT CASE WHEN ADJ_BASE IS NULL THEN Activity END ) AS Transfer_Total_ADJ,
	COUNT( DISTINCT CASE WHEN
         COMPENSATION_GRADE IS NULL
      OR TYPE IS NOT NULL AND  ADJ_Base IS NULL THEN Activity END) AS Transfer_Within_ADJ,
    COUNT( DISTINCT
      CASE
        WHEN TYPE_gg IS NOT NULL AND ADJ_Base IS NULL OR COMPENSATION_GRADE IS NULL  THEN Activity END) AS Transfer_Within_gg_ADJ,
	COUNT( DISTINCT CASE
        WHEN TYPE_ggi IS NOT NULL AND ADJ_Base IS NULL OR COMPENSATION_GRADE IS NULL THEN Activity END) AS Transfer_Within_ggi_ADJ,
    COUNT( DISTINCT
      CASE
        WHEN ADJ_BASE IS NULL AND TYPE_i IS NOT NULL OR COMPENSATION_GRADE IS NULL THEN Activity END) AS Transfer_Within_i_ADJ,		
	  Report_effective_date,  COMPENSATION_GRADE,  Time_Type,  Class,  FLSA,  Gender,  Generation,  Functional_Organization,  Primary_Work_Address_Country,  Employee_Type,  Combined_Race_Ethnicity,  Other_Exclusions,  CHANGE_IN_GL_TEXT  FROM ( SELECT  a.*, b.Employee_ID AS Activity, c.EMPLOYEE_ID AS TYPE, d.EMPLOYEE_ID AS TYPE_gg, e.EMPLOYEE_ID AS TYPE_ggi, f.EMPLOYEE_ID AS TYPE_i  FROM  `Working.With_GL_Columns` a  LEFT JOIN  `FY18Q3.Transfers` b ON  CAST(a.EMPLOYEE_ID AS STRING)= CAST(b.EMPLOYEE_ID AS STRING) AND EXTRACT(MONTH  FROM  a.REPORT_EFFECTIVE_DATE) = EXTRACT(MONTH  FROM  b.Business_process_effective_date) AND EXTRACT(YEAR  FROM  a.REPORT_EFFECTIVE_DATE) = EXTRACT(YEAR  FROM  b.Business_process_effective_date)  LEFT JOIN  `Working.With_GL_Columns` c ON  EXTRACT(MONTH  FROM  a.report_effective_date) = EXTRACT( MONTH  FROM  DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND EXTRACT(YEAR  FROM  a.report_effective_date) = EXTRACT( YEAR  FROM  DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND a.employee_ID = c.employee_ID AND IFNULL(CAST(a.Compensation_grade AS STRING ), "No Data") = IFNULL(CAST(c.Compensation_grade AS STRING ), "No Data") AND IFNULL(CAST(a.Time_Type AS STRING), "No Data") = IFNULL(CAST(c.Time_Type AS STRING), "No Data") AND IFNULL(CAST(a.Class AS STRING), "No Data") = IFNULL(CAST(c.Class AS STRING), "No Data") AND IFNULL(CAST(a.FLSA AS STRING), "No Data") = IFNULL(CAST(c.FLSA AS STRING), "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING), "No Data") = IFNULL(CAST(c.Functional_Organization AS STRING), "No Data") AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING), "No Data") = IFNULL(CAST(c.Primary_Work_Address_Country AS STRING), "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING), "No Data") = IFNULL(CAST(c.Employee_Type AS STRING), "No Data")  LEFT JOIN  `Working.With_GL_Columns` d ON  EXTRACT(MONTH  FROM  a.report_effective_date) = EXTRACT( MONTH  FROM  DATE_ADD(CAST(d.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND EXTRACT(YEAR  FROM  a.report_effective_date) = EXTRACT( YEAR  FROM  DATE_ADD(CAST(d.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND a.employee_ID = d.employee_ID AND IFNULL(CAST(a.grade_group AS STRING ), "No Data") = IFNULL(CAST(d.Grade_Group AS STRING ), "No Data") AND IFNULL(CAST(a.Time_Type AS STRING), "No Data") = IFNULL(CAST(d.Time_Type AS STRING), "No Data") AND IFNULL(CAST(a.Class AS STRING), "No Data") = IFNULL(CAST(d.Class AS STRING), "No Data") AND IFNULL(CAST(a.FLSA AS STRING), "No Data") = IFNULL(CAST(d.FLSA AS STRING), "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING), "No Data") = IFNULL(CAST(d.Functional_Organization AS STRING), "No Data") AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING), "No Data") = IFNULL(CAST(d.Primary_Work_Address_Country AS STRING), "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING), "No Data") = IFNULL(CAST(d.Employee_Type AS STRING), "No Data")  LEFT JOIN  `Working.With_GL_Columns` e ON  EXTRACT(MONTH  FROM  a.report_effective_date) = EXTRACT( MONTH  FROM  DATE_ADD(CAST(e.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND EXTRACT(YEAR  FROM  a.report_effective_date) = EXTRACT( YEAR  FROM  DATE_ADD(CAST(e.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND a.employee_ID = e.employee_ID AND IFNULL(CAST(a.grade_group AS STRING ), "No Data") = IFNULL(CAST(e.Grade_Group AS STRING ), "No Data") AND IFNULL(CAST(a.Time_Type AS STRING), "No Data") = IFNULL(CAST(e.Time_Type AS STRING), "No Data") AND IFNULL(CAST(a.Class AS STRING), "No Data") = IFNULL(CAST(e.Class AS STRING), "No Data") AND IFNULL(CAST(a.FLSA AS STRING), "No Data") = IFNULL(CAST(e.FLSA AS STRING), "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING), "No Data") = IFNULL(CAST(e.Functional_Organization AS STRING), "No Data") AND IFNULL(CAST(a.Country_group AS STRING), "No Data") = IFNULL(CAST(e.Country_group AS STRING), "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING), "No Data") = IFNULL(CAST(e.Employee_Type AS STRING), "No Data")  LEFT JOIN  `Working.With_GL_Columns` f ON  EXTRACT(MONTH  FROM  a.report_effective_date) = EXTRACT( MONTH  FROM  DATE_ADD(CAST(f.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND EXTRACT(YEAR  FROM  a.report_effective_date) = EXTRACT( YEAR  FROM  DATE_ADD(CAST(f.report_effective_date AS DATE),INTERVAL 1 MONTH)) AND a.employee_ID = f.employee_ID AND IFNULL(CAST(a.Compensation_grade AS STRING ), "No Data") = IFNULL(CAST(f.Compensation_grade AS STRING ), "No Data") AND IFNULL(CAST(a.Time_Type AS STRING), "No Data") = IFNULL(CAST(f.Time_Type AS STRING), "No Data") AND IFNULL(CAST(a.Class AS STRING), "No Data") = IFNULL(CAST(f.Class AS STRING), "No Data") AND IFNULL(CAST(a.FLSA AS STRING), "No Data") = IFNULL(CAST(f.FLSA AS STRING), "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING), "No Data") = IFNULL(CAST(f.Functional_Organization AS STRING), "No Data") AND IFNULL(CAST(a.Country_group AS STRING), "No Data") = IFNULL(CAST(f.Country_group AS STRING), "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING), "No Data") = IFNULL(CAST(f.Employee_Type AS STRING), "No Data") )  GROUP BY  Report_effective_date,  Compensation_grade,  Time_Type,  Class,  FLSA,  Gender,  Generation,  Functional_Organization,  Primary_Work_Address_Country,  Employee_Type,  Combined_Race_Ethnicity,  Other_Exclusions,  CHANGE_IN_GL_TEXT ) b ON  IFNULL(CAST(a.report_effective_date AS STRING ),  "No Data") = IFNULL(CAST(b.report_effective_date AS STRING ),  "No Data") AND IFNULL(CAST(a.Compensation_Grade AS STRING ),  "No Data") = IFNULL(CAST(b.Compensation_Grade AS STRING ),  "No Data") AND IFNULL(CAST(a.Time_Type AS STRING),  "No Data") = IFNULL(CAST(b.Time_Type AS STRING),  "No Data") AND IFNULL(CAST(a.Class AS STRING),  "No Data") = IFNULL(CAST(b.Class AS STRING),  "No Data") AND IFNULL(CAST(a.FLSA AS STRING),  "No Data") = IFNULL(CAST(b.FLSA AS STRING),  "No Data") AND IFNULL(CAST(a.Gender AS STRING),  "No Data") = IFNULL(CAST(b.Gender AS STRING),  "No Data") AND IFNULL(CAST(a.Generation AS STRING),  "No Data") = IFNULL(CAST(b.Generation AS STRING),  "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING),  "No Data") = IFNULL(CAST(b.Functional_Organization AS STRING),  "No Data") AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),  "No Data") = IFNULL(CAST(b.Primary_Work_Address_Country AS STRING),  "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING),  "No Data") = IFNULL(CAST(b.Employee_Type AS STRING),  "No Data") AND IFNULL(CAST(a.Combined_Race_Ethnicity AS STRING),  "No Data") = IFNULL(CAST(b.Combined_Race_Ethnicity AS STRING),  "No Data") AND IFNULL(CAST(a.Other_Exclusions AS STRING),  "No Data") = IFNULL(CAST(b.Other_Exclusions AS STRING),  "No Data") AND IFNULL(CAST(a.CHANGE_IN_GL_TEXT AS STRING),  "No Data") = IFNULL(CAST(b.CHANGE_IN_GL_TEXT AS STRING),  "No Data"))  
	  
	  SELECT  a.*,
	  IFNULL(b.Transfer_Out,  0) AS Count_Transfer_Out,  
	  IFNULL(b.Transfer_Out_gg,  0) AS Count_Transfer_Out_gg,  
	  IFNULL(b.Transfer_Out_ggi,  0) AS Count_Transfer_Out_ggi,  
	  IFNULL(b.Transfer_Out_i,  0) AS Count_Transfer_Out_i,  
	  IFNULL(b.Transfer_Total,  0) AS Count_Transfer_Total,  
	  IFNULL(b.Transfer_Out_ADJ,  0) AS Count_Transfer_Out_ADJ,  
	  IFNULL(b.Transfer_Out_gg_ADJ,  0) AS Count_Transfer_Out_gg_ADJ,  
	  IFNULL(b.Transfer_Out_ggi_ADJ,  0) AS Count_Transfer_Out_ggi_ADJ,  
	  IFNULL(b.Transfer_Out_i_ADJ,  0) AS Count_Transfer_Out_i_ADJ	  
	  FROM  TABLE_16 a  LEFT JOIN (  SELECT  
	  
	  COUNT( DISTINCT CASE
        WHEN TYPE IS NULL
      AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Transfer_Out,
    COUNT( DISTINCT
      CASE
        WHEN TYPE_gg IS NULL AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Transfer_Out_gg,
	COUNT( DISTINCT CASE
        WHEN TYPE_ggi IS NULL
      AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Transfer_Out_ggi,
    COUNT( DISTINCT
      CASE
        WHEN TYPE_i IS NULL AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Transfer_Out_i,
	  COUNT( DISTINCT CASE
        WHEN TYPE IS NULL AND ADJ_Base IS NULL
      AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Transfer_Out_ADJ,
    COUNT( DISTINCT
      CASE
        WHEN TYPE_gg IS NULL AND ADJ_Base IS NULL AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Transfer_Out_gg_ADJ,
	COUNT( DISTINCT CASE
        WHEN TYPE_ggi IS NULL AND ADJ_Base IS NULL
      AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Transfer_Out_ggi_ADJ,
    COUNT( DISTINCT
      CASE
        WHEN TYPE_i IS NULL AND ADJ_BASE is NULL AND COMPENSATION_GRADE IS NOT NULL THEN Activity END) AS Transfer_Out_i_ADJ,
		
		COUNT( DISTINCT Activity ) AS Transfer_Total,
	Report_effective_date,
    COMPENSATION_GRADE,
    Time_Type,
    Class,
    FLSA,
    Gender,
    Generation,
    Functional_Organization,
    Primary_Work_Address_Country,
    Employee_Type,
    Combined_Race_Ethnicity,
    Other_Exclusions,
    CHANGE_IN_GL_TEXT
  FROM (
    SELECT
      a.*EXCEPT(COMPENSATION_GRADE,
        Time_Type,
        Class,
        FLSA,
        Functional_Organization,
        Primary_Work_Address_Country,
        Employee_Type),
      d.COMPENSATION_GRADE,
      d.Time_Type,
      d.Class,
      d.FLSA,
      d.Functional_Organization,
      d.Primary_Work_Address_Country,
      d.Employee_Type,
      b.Employee_ID AS Activity,
      c.EMPLOYEE_ID AS TYPE,
      g.EMPLOYEE_ID AS TYPE_gg,
      e.EMPLOYEE_ID AS TYPE_ggi,
      f.EMPLOYEE_ID AS TYPE_i
    FROM
      `Working.With_GL_Columns` a
    LEFT JOIN
      `FY18Q3.Transfers` b
    ON
      CAST(a.EMPLOYEE_ID AS STRING)= CAST(b.EMPLOYEE_ID AS STRING)
      AND EXTRACT(MONTH
      FROM
        a.REPORT_EFFECTIVE_DATE) = EXTRACT(MONTH
      FROM
        b.Business_process_effective_date)
      AND EXTRACT(YEAR
      FROM
        a.REPORT_EFFECTIVE_DATE) = EXTRACT(YEAR
      FROM
        b.Business_process_effective_date)
    LEFT JOIN
      `Working.With_GL_Columns` c
    ON
      EXTRACT(MONTH
      FROM
        a.report_effective_date) = EXTRACT( MONTH
      FROM
        DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH))
      AND EXTRACT(YEAR
      FROM
        a.report_effective_date) = EXTRACT( YEAR
      FROM
        DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH))
      AND a.employee_ID = c.employee_ID
      AND IFNULL(CAST(a.Compensation_grade AS STRING ),
        "No Data") = IFNULL(CAST(c.Compensation_grade AS STRING ),
        "No Data")
      AND IFNULL(CAST(a.Time_Type AS STRING),
        "No Data") = IFNULL(CAST(c.Time_Type AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Class AS STRING),
        "No Data") = IFNULL(CAST(c.Class AS STRING),
        "No Data")
      AND IFNULL(CAST(a.FLSA AS STRING),
        "No Data") = IFNULL(CAST(c.FLSA AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Functional_Organization AS STRING),
        "No Data") = IFNULL(CAST(c.Functional_Organization AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
        "No Data") = IFNULL(CAST(c.Primary_Work_Address_Country AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Employee_Type AS STRING),
        "No Data") = IFNULL(CAST(c.Employee_Type AS STRING),
        "No Data")
    LEFT JOIN
      Working.With_GL_Columns d
    ON
      EXTRACT(MONTH
      FROM
        a.report_effective_date) = EXTRACT( MONTH
      FROM
        DATE_ADD(CAST(d.report_effective_date AS DATE),INTERVAL 1 MONTH))
      AND EXTRACT(YEAR
      FROM
        a.report_effective_date) = EXTRACT( YEAR
      FROM
        DATE_ADD(CAST(d.report_effective_date AS DATE),INTERVAL 1 MONTH))
      AND a.employee_ID = d.employee_ID
    LEFT JOIN
      `Working.With_GL_Columns` e
    ON
      EXTRACT(MONTH
      FROM
        a.report_effective_date) = EXTRACT( MONTH
      FROM
        DATE_ADD(CAST(e.report_effective_date AS DATE),INTERVAL 1 MONTH))
      AND EXTRACT(YEAR
      FROM
        a.report_effective_date) = EXTRACT( YEAR
      FROM
        DATE_ADD(CAST(e.report_effective_date AS DATE),INTERVAL 1 MONTH))
      AND a.employee_ID = e.employee_ID
      AND IFNULL(CAST(a.grade_group AS STRING ),
        "No Data") = IFNULL(CAST(e.Grade_Group AS STRING ),
        "No Data")
      AND IFNULL(CAST(a.Time_Type AS STRING),
        "No Data") = IFNULL(CAST(e.Time_Type AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Class AS STRING),
        "No Data") = IFNULL(CAST(e.Class AS STRING),
        "No Data")
      AND IFNULL(CAST(a.FLSA AS STRING),
        "No Data") = IFNULL(CAST(e.FLSA AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Functional_Organization AS STRING),
        "No Data") = IFNULL(CAST(e.Functional_Organization AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Country_group AS STRING),
        "No Data") = IFNULL(CAST(e.Country_group AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Employee_Type AS STRING),
        "No Data") = IFNULL(CAST(e.Employee_Type AS STRING),
        "No Data")
    LEFT JOIN
      `Working.With_GL_Columns` f
    ON
      EXTRACT(MONTH
      FROM
        a.report_effective_date) = EXTRACT( MONTH
      FROM
        DATE_ADD(CAST(f.report_effective_date AS DATE),INTERVAL 1 MONTH))
      AND EXTRACT(YEAR
      FROM
        a.report_effective_date) = EXTRACT( YEAR
      FROM
        DATE_ADD(CAST(f.report_effective_date AS DATE),INTERVAL 1 MONTH))
      AND a.employee_ID = f.employee_ID
      AND IFNULL(CAST(a.Compensation_grade AS STRING ),
        "No Data") = IFNULL(CAST(f.Compensation_grade AS STRING ),
        "No Data")
      AND IFNULL(CAST(a.Time_Type AS STRING),
        "No Data") = IFNULL(CAST(f.Time_Type AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Class AS STRING),
        "No Data") = IFNULL(CAST(f.Class AS STRING),
        "No Data")
      AND IFNULL(CAST(a.FLSA AS STRING),
        "No Data") = IFNULL(CAST(f.FLSA AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Functional_Organization AS STRING),
        "No Data") = IFNULL(CAST(f.Functional_Organization AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Country_group AS STRING),
        "No Data") = IFNULL(CAST(f.Country_group AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Employee_Type AS STRING),
        "No Data") = IFNULL(CAST(f.Employee_Type AS STRING),
        "No Data")
    LEFT JOIN
      `Working.With_GL_Columns` g
    ON
      EXTRACT(MONTH
      FROM
        a.report_effective_date) = EXTRACT( MONTH
      FROM
        DATE_ADD(CAST(g.report_effective_date AS DATE),INTERVAL 1 MONTH))
      AND EXTRACT(YEAR
      FROM
        a.report_effective_date) = EXTRACT( YEAR
      FROM
        DATE_ADD(CAST(g.report_effective_date AS DATE),INTERVAL 1 MONTH))
      AND a.employee_ID = g.employee_ID
      AND IFNULL(CAST(a.grade_group AS STRING ),
        "No Data") = IFNULL(CAST(g.Grade_Group AS STRING ),
        "No Data")
      AND IFNULL(CAST(a.Time_Type AS STRING),
        "No Data") = IFNULL(CAST(g.Time_Type AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Class AS STRING),
        "No Data") = IFNULL(CAST(g.Class AS STRING),
        "No Data")
      AND IFNULL(CAST(a.FLSA AS STRING),
        "No Data") = IFNULL(CAST(g.FLSA AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Functional_Organization AS STRING),
        "No Data") = IFNULL(CAST(g.Functional_Organization AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
        "No Data") = IFNULL(CAST(g.Primary_Work_Address_Country AS STRING),
        "No Data")
      AND IFNULL(CAST(a.Employee_Type AS STRING),
        "No Data") = IFNULL(CAST(g.Employee_Type AS STRING),
        "No Data") )
  GROUP BY
    Report_effective_date,
    Compensation_grade,
    Time_Type,
    Class,
    FLSA,
    Gender,
    Generation,
    Functional_Organization,
    Primary_Work_Address_Country,
    Employee_Type,
    Combined_Race_Ethnicity,
    Other_Exclusions,
    CHANGE_IN_GL_TEXT) b
ON
  IFNULL(CAST(a.Report_effective_date AS STRING ),
    "No Data") = IFNULL(CAST(b.Report_effective_date AS STRING ),
    "No Data")
  AND IFNULL(CAST(a.Compensation_Grade AS STRING ),
    "No Data") = IFNULL(CAST(b.Compensation_Grade AS STRING ),
    "No Data")
  AND IFNULL(CAST(a.Time_Type AS STRING),
    "No Data") = IFNULL(CAST(b.Time_Type AS STRING),
    "No Data")
  AND IFNULL(CAST(a.Class AS STRING),
    "No Data") = IFNULL(CAST(b.Class AS STRING),
    "No Data")
  AND IFNULL(CAST(a.FLSA AS STRING),
    "No Data") = IFNULL(CAST(b.FLSA AS STRING),
    "No Data")
  AND IFNULL(CAST(a.Gender AS STRING),
    "No Data") = IFNULL(CAST(b.Gender AS STRING),
    "No Data")
  AND IFNULL(CAST(a.Generation AS STRING),
    "No Data") = IFNULL(CAST(b.Generation AS STRING),
    "No Data")
  AND IFNULL(CAST(a.Functional_Organization AS STRING),
    "No Data") = IFNULL(CAST(b.Functional_Organization AS STRING),
    "No Data")
  AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
    "No Data") = IFNULL(CAST(b.Primary_Work_Address_Country AS STRING),
    "No Data")
  AND IFNULL(CAST(a.Employee_Type AS STRING),
    "No Data") = IFNULL(CAST(b.Employee_Type AS STRING),
    "No Data")
  AND IFNULL(CAST(a.Combined_Race_Ethnicity AS STRING),
    "No Data") = IFNULL(CAST(b.Combined_Race_Ethnicity AS STRING),
    "No Data")
  AND IFNULL(CAST(a.Other_Exclusions AS STRING),
    "No Data") = IFNULL(CAST(b.Other_Exclusions AS STRING),
    "No Data")
  AND IFNULL(CAST(a.CHANGE_IN_GL_TEXT AS STRING),
    "No Data") = IFNULL(CAST(b.CHANGE_IN_GL_TEXT AS STRING),
    "No Data"))
	SELECT a.*EXCEPT(Count_Promo_Total,Count_Demo_Total,Count_Transfer_Total), (Count_Promo_In+Count_Promo_Out+Count_Promo_Within) as Count_Promo_Total,(Count_Demo_In+Count_Demo_Out+Count_Demo_Within) as Count_Demo_Total,(Count_Transfer_In+Count_Transfer_Out+Count_Transfer_Within) as Count_Transfer_Total
	from TABLE_17 a