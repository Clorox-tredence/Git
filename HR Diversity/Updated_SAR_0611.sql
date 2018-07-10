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
                  Working.With_GL_Columns
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
                  Working.With_GL_Columns a
                LEFT JOIN
                  Working.With_GL_Columns b
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
                    DISTINCT FYTD AS Report_Effective_Date
                  FROM
                    `Working.With_GL_Columns` ) a
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
              IFNULL(Current_HC,
                0) AS Current_HC
            FROM
              TABLE_6 a
            LEFT JOIN (
              SELECT
                FYTD AS Report_Effective_Date,
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
                Count (DISTINCT
                  CASE
                    WHEN EOP_FYTD=REPORT_EFFECTIVE_DATE THEN EMPLOYEE_ID END) AS Current_HC,  Other_Exclusions,  CHANGE_IN_GL_TEXT  FROM  Working.With_GL_Columns  GROUP BY  FYTD,  Compensation_Grade,  Time_Type,  Class,  FLSA,  Gender,  Generation,  Functional_Organization,  Primary_Work_Address_Country,  Employee_Type,  Combined_Race_Ethnicity,  Other_Exclusions,  CHANGE_IN_GL_TEXT ) b ON  a.Report_Effective_Date = b.Report_Effective_Date AND IFNULL(CAST(a.Compensation_Grade AS STRING ),  "No Data") = IFNULL(CAST(b.Compensation_Grade AS STRING ),  "No Data") AND IFNULL(CAST(a.Time_Type AS STRING),  "No Data") = IFNULL(CAST(b.Time_Type AS STRING),  "No Data") AND IFNULL(CAST(a.Class AS STRING),  "No Data") = IFNULL(CAST(b.Class AS STRING),  "No Data") AND IFNULL(CAST(a.FLSA AS STRING),  "No Data") = IFNULL(CAST(b.FLSA AS STRING),  "No Data") AND IFNULL(CAST(a.Gender AS STRING),  "No Data") = IFNULL(CAST(b.Gender AS STRING),  "No Data") AND IFNULL(CAST(a.Generation AS STRING),  "No Data") = IFNULL(CAST(b.Generation AS STRING),  "No Data") AND IFNULL(CAST(a.Functional_Organization AS STRING),  "No Data") = IFNULL(CAST(b.Functional_Organization AS STRING),  "No Data") AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),  "No Data") = IFNULL(CAST(b.Primary_Work_Address_Country AS STRING),  "No Data") AND IFNULL(CAST(a.Employee_Type AS STRING),  "No Data") = IFNULL(CAST(b.Employee_Type AS STRING),  "No Data") AND IFNULL(CAST(a.Combined_Race_Ethnicity AS STRING),  "No Data") = IFNULL(CAST(b.Combined_Race_Ethnicity AS STRING),  "No Data") AND IFNULL(CAST(a.Other_Exclusions AS STRING),  "No Data") = IFNULL(CAST(b.Other_Exclusions AS STRING),  "No Data") AND IFNULL(CAST(a.CHANGE_IN_GL_TEXT AS STRING),  "No Data") = IFNULL(CAST(b.CHANGE_IN_GL_TEXT AS STRING),  "No Data") ) (  SELECT  a.*,  IFNULL(Base_HC,  0) AS Base_HC  FROM  TABLE_7 a  LEFT JOIN (  SELECT  b.FYTD AS Report_effective_date,  a.Compensation_Grade,  a.Time_Type,  a.Class,  a.FLSA,  a.Gender,  a.Generation,  a.Functional_Organization,  a.Primary_Work_Address_Country,  a.Employee_Type,  a.Combined_Race_Ethnicity,  a.Other_Exclusions,  a.CHANGE_IN_GL_TEXT,  Count (DISTINCT CASE
                    WHEN b.BASE_DATE_FYTD=a.REPORT_EFFECTIVE_DATE THEN a.EMPLOYEE_ID END) AS BASE_HC
              FROM
                Working.With_GL_Columns a
              LEFT JOIN (
                SELECT
                  DISTINCT Report_effective_date,
                  FYTD,
                  BASE_DATE_FYTD
                FROM
                  `Working.With_GL_Columns` ) b
              ON
                CAST(a.REPORT_EFFECTIVE_DATE AS DATE) = DATE_SUB(CAST(b.REPORT_EFFECTIVE_DATE AS DATE), INTERVAL 1 MONTH)
              GROUP BY
                b.FYTD,
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
              a.Report_Effective_Date = b.Report_Effective_Date
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
                "No Data") ) ) (
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
              SUM(CASE
                  WHEN ADJ_CURRENT_FYTD IS NULL THEN 1
                  ELSE 0 END) AS ADJ_current_Hire,
              FYTD,
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
                a.FYTD,
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
                a.Other_Exclusions,
                a.CHANGE_IN_GL_TEXT,
                a.ADJ_current_FYTD
              FROM
                `Working.With_GL_Columns` a
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
              FYTD,
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
            a.Report_Effective_Date = b.FYTD
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
              "No Data") ) )
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
          COUNT( DISTINCT EMPLOYEE_ID ) AS TERMS,
          SUM(CASE
              WHEN ADJ_Base_FYTD IS NULL THEN 1
              ELSE 0 END) AS ADJ_Base_Terms,
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
          CHANGE_IN_GL_TEXT,
          c.FYTD
        FROM (
          SELECT
            a.EMPLOYEE_ID,
            DATE_ADD(CAST(a.Report_effective_date AS DATE),INTERVAL 1 MONTH) AS Report_effective_date,
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
            a.Other_Exclusions,
            a.CHANGE_IN_GL_TEXT,
            a.ADJ_Base_FYTD
          FROM
            `Working.With_GL_Columns` a
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
            END ) a
        LEFT JOIN (
          SELECT
            Report_effective_date,
            FYTD
          FROM
            `Working.With_GL_Columns`
          GROUP BY
            Report_effective_date,
            FYTD ) c
        ON
          EXTRACT(MONTH
          FROM
            a.Report_effective_date) = EXTRACT(MONTH
          FROM
            CAST(c.Report_effective_date AS DATE))
          AND EXTRACT(YEAR
          FROM
            a.Report_effective_date) = EXTRACT(YEAR
          FROM
            CAST(c.Report_effective_date AS DATE))
        GROUP BY
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
          CHANGE_IN_GL_TEXT,
          c.FYTD ) b
      ON
        a.REPORT_EFFECTIVE_DATE=b.FYTD
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
        COUNT( DISTINCT EMPLOYEE_ID ) AS TERMS,
        SUM(CASE
            WHEN ADJ_Base_FYTD IS NULL THEN 1
            ELSE 0 END) AS ADJ_Base_Terms,
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
        CHANGE_IN_GL_TEXT,
        c.FYTD
      FROM (
        SELECT
          a.EMPLOYEE_ID,
          DATE_ADD(CAST(a.Report_effective_date AS DATE),INTERVAL 1 MONTH) AS Report_effective_date,
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
          a.Other_Exclusions,
          a.CHANGE_IN_GL_TEXT,
          a.ADJ_Base_FYTD
        FROM
          `Working.With_GL_Columns` a
        LEFT JOIN (
          SELECT
            EMPLOYEE_ID,
            TERMINATION_DATE,
            Regrettable_Non_Regrettable
          FROM
            FY18Q3.Terminations ) b
        ON
          a.EMPLOYEE_ID=b.EMPLOYEE_ID
        WHERE
          b.Regrettable_Non_Regrettable = "Regrettable"
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
          END ) a
      LEFT JOIN (
        SELECT
          Report_effective_date,
          FYTD
        FROM
          `Working.With_GL_Columns`
        GROUP BY
          Report_effective_date,
          FYTD ) c
      ON
        EXTRACT(MONTH
        FROM
          a.Report_effective_date) = EXTRACT(MONTH
        FROM
          CAST(c.Report_effective_date AS DATE))
        AND EXTRACT(YEAR
        FROM
          a.Report_effective_date) = EXTRACT(YEAR
        FROM
          CAST(c.Report_effective_date AS DATE))
      GROUP BY
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
        CHANGE_IN_GL_TEXT,
        c.FYTD ) b
    ON
      a.report_effective_date = b.FYTD
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
    IFNULL(b.Promo_Out,
      0) AS Count_Promo_Out,
    IFNULL(b.Promo_Within,
      0) AS Count_Promo_Within,
    IFNULL(b.Promo_total,
      0) AS Count_Promo_total,
    IFNULL(b.Promo_Within_ADJ,
      0) AS Count_Promo_Within_ADJ,
    IFNULL(b.Promo_total_ADJ,
      0) AS Count_Promo_total_ADJ,
    IFNULL(b.Promo_In_gg,
      0) AS Count_Promo_In_gg,
    IFNULL(b.Promo_In_ggi,
      0) AS Count_Promo_In_ggi,
    IFNULL(b.Promo_In_i,
      0) AS Count_Promo_In_i,
    IFNULL(b.Promo_Within_gg,
      0) AS Count_Promo_Within_gg,
    IFNULL(b.Promo_Within_ggi,
      0) AS Count_Promo_Within_ggi,
    IFNULL(b.Promo_Within_i,
      0) AS Count_Promo_Within_i,
    IFNULL(b.Promo_Out_gg,
      0) AS Count_Promo_Out_gg,
    IFNULL(b.Promo_Out_ggi,
      0) AS Count_Promo_Out_ggi,
    IFNULL(b.Promo_Out_i,
      0) AS Count_Promo_Out_i,
    IFNULL(b.Promo_In_ADJ,
      0) AS Count_Promo_In_ADJ,
    IFNULL(b.Promo_Out_ADJ,
      0) AS Count_Promo_Out_ADJ,
    IFNULL(b.Promo_In_gg_ADJ,
      0) AS Count_Promo_In_gg_ADJ,
    IFNULL(b.Promo_In_ggi_ADJ,
      0) AS Count_Promo_In_ggi_ADJ,
    IFNULL(b.Promo_In_i_ADJ,
      0) AS Count_Promo_In_i_ADJ,
    IFNULL(b.Promo_Out_gg_ADJ,
      0) AS Count_Promo_Out_gg_ADJ,
    IFNULL(b.Promo_Out_ggi_ADJ,
      0) AS Count_Promo_Out_ggi_ADJ,
    IFNULL(b.Promo_Out_i_ADJ,
      0) AS Count_Promo_Out_i_ADJ,
    IFNULL(b.Promo_Within_gg_ADJ,
      0) AS Count_Promo_Within_gg_ADJ,
    IFNULL(b.Promo_Within_ggi_ADJ,
      0) AS Count_Promo_Within_ggi_ADJ,
    IFNULL(b.Promo_Within_i_ADJ,
      0) AS Count_Promo_Within_i_ADJ
  FROM
    TABLE_11 a
  LEFT JOIN (
    WITH
      TABLE AS (
      WITH
        TABLE AS (
        SELECT
          a.*,
          c.Employee_id AS TYPE,
          b.EMPLOYEE_ID AS Activity,
          d.EMPLOYEE_ID AS Type_gg,
          e.EMPLOYEE_ID AS Type_ggi,
          f.EMPLOYEE_ID AS Type_i
        FROM
          `Working.With_GL_Columns` a
        LEFT JOIN
          `Working.With_GL_Columns` c
        ON
          a.EMPLOYEE_ID = c.EMPLOYEE_ID
          AND EXTRACT(MONTH
          FROM
            a.report_effective_date) = EXTRACT( MONTH
          FROM
            DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH))
          AND EXTRACT(YEAR
          FROM
            a.report_effective_date) = EXTRACT( YEAR
          FROM
            DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH))
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
          `FY18Q3.Promotions` b
        ON
          CAST(a.EMPLOYEE_ID AS STRING) = b.EMPLOYEE_ID
          AND EXTRACT (MONTH
          FROM
            a.Report_effective_date) = EXTRACT (MONTH
          FROM
            b.BUSINESS_PROCESS_EFFECTIVE_DATE)
          AND EXTRACT (YEAR
          FROM
            a.Report_effective_date) = EXTRACT (YEAR
          FROM
            b.BUSINESS_PROCESS_EFFECTIVE_DATE)
        LEFT JOIN
          `Working.With_GL_Columns` d
        ON
          a.EMPLOYEE_ID = d.EMPLOYEE_ID
          AND EXTRACT(MONTH
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
          AND IFNULL(CAST(a.grade_group AS STRING ),
            "No Data") = IFNULL(CAST(d.Grade_Group AS STRING ),
            "No Data")
          AND IFNULL(CAST(a.Time_Type AS STRING),
            "No Data") = IFNULL(CAST(d.Time_Type AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Class AS STRING),
            "No Data") = IFNULL(CAST(d.Class AS STRING),
            "No Data")
          AND IFNULL(CAST(a.FLSA AS STRING),
            "No Data") = IFNULL(CAST(d.FLSA AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Functional_Organization AS STRING),
            "No Data") = IFNULL(CAST(d.Functional_Organization AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
            "No Data") = IFNULL(CAST(d.Primary_Work_Address_Country AS STRING),
            "No Data")
          AND IFNULL(CAST(a.Employee_Type AS STRING),
            "No Data") = IFNULL(CAST(d.Employee_Type AS STRING),
            "No Data")
        LEFT JOIN
          `Working.With_GL_Columns` e
        ON
          a.EMPLOYEE_ID = e.EMPLOYEE_ID
          AND EXTRACT(MONTH
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
          a.EMPLOYEE_ID = f.EMPLOYEE_ID
          AND EXTRACT(MONTH
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
            "No Data") )
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
        'IN' AS Promo_type
      FROM
        TABLE a
      WHERE
        Activity IS NOT NULL
        AND TYPE IS NULL
        AND FYTD IS NOT NULL
        AND PREVIOUS_GRADE IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
        'IN_gg' AS Promo_type
      FROM
        TABLE a
      WHERE
        Activity IS NOT NULL
        AND TYPE_gg IS NULL
        AND FYTD IS NOT NULL
        AND PREVIOUS_GRADE IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
        'IN_ggi' AS Promo_type
      FROM
        TABLE a
      WHERE
        Activity IS NOT NULL
        AND TYPE_ggi IS NULL
        AND FYTD IS NOT NULL
        AND PREVIOUS_GRADE IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
        'IN_i' AS Promo_type
      FROM
        TABLE a
      WHERE
        Activity IS NOT NULL
        AND TYPE_i IS NULL
        AND FYTD IS NOT NULL
        AND PREVIOUS_GRADE IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
        'WITHIN' AS Promo_type
      FROM
        TABLE a
      WHERE
        Activity IS NOT NULL
        AND TYPE IS NOT NULL
        AND FYTD IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
        'WITHIN' AS Promo_type
      FROM
        TABLE a
      WHERE
        Activity IS NOT NULL
        AND PREVIOUS_GRADE IS NULL
        AND FYTD IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
        'WITHIN_gg' AS Promo_type
      FROM
        TABLE a
      WHERE
        Activity IS NOT NULL
        AND TYPE_gg IS NOT NULL
        AND FYTD IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
        'WITHIN_gg' AS Promo_type
      FROM
        TABLE a
      WHERE
        Activity IS NOT NULL
        AND PREVIOUS_GRADE IS NULL
        AND FYTD IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
        'WITHIN_ggi' AS Promo_type
      FROM
        TABLE a
      WHERE
        Activity IS NOT NULL
        AND TYPE_ggi IS NOT NULL
        AND FYTD IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
        'WITHIN_ggi' AS Promo_type
      FROM
        TABLE a
      WHERE
        Activity IS NOT NULL
        AND PREVIOUS_GRADE IS NULL
        AND FYTD IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
        'WITHIN_i' AS Promo_type
      FROM
        TABLE a
      WHERE
        Activity IS NOT NULL
        AND TYPE_i IS NOT NULL
        AND FYTD IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
        'WITHIN_i' AS Promo_type
      FROM
        TABLE a
      WHERE
        Activity IS NOT NULL
        AND PREVIOUS_GRADE IS NULL
        AND FYTD IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        d.COMPENSATION_GRADE,
        d.Time_Type,
        d.Class,
        d.FLSA,
        d.Functional_Organization,
        d.Primary_Work_Address_Country,
        d.Employee_Type,
        d.Grade_Group,
        d.Country_group,
        'OUT' AS Promo_type
      FROM
        TABLE a
      LEFT JOIN
        TABLE d
      ON
        a.Employee_ID=d.EMPLOYEE_ID
        AND EXTRACT(MONTH
        FROM
          a.Report_effective_date) = EXTRACT(MONTH
        FROM
          DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
        AND EXTRACT(YEAR
        FROM
          a.Report_effective_date) = EXTRACT(YEAR
        FROM
          DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
      WHERE
        a.Activity IS NOT NULL
        AND a.TYPE IS NULL
        AND a.FYTD IS NOT NULL
        AND a.PREVIOUS_GRADE IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        d.COMPENSATION_GRADE,
        d.Time_Type,
        d.Class,
        d.FLSA,
        d.Functional_Organization,
        d.Primary_Work_Address_Country,
        d.Employee_Type,
        d.Grade_Group,
        d.Country_group,
        'OUT_gg' AS Promo_type
      FROM
        TABLE a
      LEFT JOIN
        TABLE d
      ON
        a.Employee_ID=d.EMPLOYEE_ID
        AND EXTRACT(MONTH
        FROM
          a.Report_effective_date) = EXTRACT(MONTH
        FROM
          DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
        AND EXTRACT(YEAR
        FROM
          a.Report_effective_date) = EXTRACT(YEAR
        FROM
          DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
      WHERE
        a.Activity IS NOT NULL
        AND a.TYPE_gg IS NULL
        AND a.FYTD IS NOT NULL
        AND a.PREVIOUS_GRADE IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        d.COMPENSATION_GRADE,
        d.Time_Type,
        d.Class,
        d.FLSA,
        d.Functional_Organization,
        d.Primary_Work_Address_Country,
        d.Employee_Type,
        d.Grade_Group,
        d.Country_group,
        'OUT_ggi' AS Promo_type
      FROM
        TABLE a
      LEFT JOIN
        TABLE d
      ON
        a.Employee_ID=d.EMPLOYEE_ID
        AND EXTRACT(MONTH
        FROM
          a.Report_effective_date) = EXTRACT(MONTH
        FROM
          DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
        AND EXTRACT(YEAR
        FROM
          a.Report_effective_date) = EXTRACT(YEAR
        FROM
          DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
      WHERE
        a.Activity IS NOT NULL
        AND a.TYPE_ggi IS NULL
        AND a.FYTD IS NOT NULL
        AND a.PREVIOUS_GRADE IS NOT NULL
      UNION ALL
      SELECT
        a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        d.COMPENSATION_GRADE,
        d.Time_Type,
        d.Class,
        d.FLSA,
        d.Functional_Organization,
        d.Primary_Work_Address_Country,
        d.Employee_Type,
        d.Grade_Group,
        d.Country_group,
        'OUT_i' AS Promo_type
      FROM
        TABLE a
      LEFT JOIN
        TABLE d
      ON
        a.Employee_ID=d.EMPLOYEE_ID
        AND EXTRACT(MONTH
        FROM
          a.Report_effective_date) = EXTRACT(MONTH
        FROM
          DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
        AND EXTRACT(YEAR
        FROM
          a.Report_effective_date) = EXTRACT(YEAR
        FROM
          DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
      WHERE
        a.Activity IS NOT NULL
        AND a.TYPE_i IS NULL
        AND a.FYTD IS NOT NULL
        AND a.PREVIOUS_GRADE IS NOT NULL )
    SELECT
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'IN' THEN Employee_ID END) AS Promo_in,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'IN'
        AND ADJ_Current_FYTD IS NULL THEN Employee_ID END) AS Promo_In_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'OUT' THEN Employee_ID END) AS Promo_out,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'OUT'
        AND ADJ_Base_FYTD IS NULL THEN Employee_ID END) AS Promo_out_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'WITHIN' THEN Employee_ID END) AS Promo_within,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'IN_gg'
        OR Promo_type = 'OUT_gg'
        OR Promo_type = 'WITHIN_gg' THEN Employee_ID END) AS Promo_Total,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'WITHIN' AND ADJ_BASE_FYTD IS NULL THEN Employee_ID END) AS Promo_within_ADJ,  COUNT (DISTINCT CASE
          WHEN ADJ_BASE_FYTD IS NULL
        AND Promo_type = 'IN_gg'
        OR Promo_type = 'OUT_gg'
        OR Promo_type = 'WITHIN_gg' THEN Employee_ID END) AS Promo_Total_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'IN_gg' THEN Employee_ID END) AS Promo_in_gg,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'IN_gg'
        AND ADJ_CURRENT_FYTD IS NULL THEN Employee_ID END) AS Promo_in_gg_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'IN_ggi' THEN Employee_ID END) AS Promo_in_ggi,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'IN_ggi'
        AND ADJ_CURRENT_FYTD IS NULL THEN Employee_ID END) AS Promo_in_ggi_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'IN_i' THEN Employee_ID END) AS Promo_in_i,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'IN_i'
        AND ADJ_CURRENT_FYTD IS NULL THEN Employee_ID END) AS Promo_in_i_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'WITHIN_gg' THEN Employee_ID END) AS Promo_within_gg,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'WITHIN_ggi' THEN Employee_ID END) AS Promo_within_ggi,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'WITHIN_i' THEN Employee_ID END) AS Promo_within_i,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'OUT_gg' THEN Employee_ID END) AS Promo_out_gg,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'OUT_gg' AND ADJ_Base_FYTD IS NULL THEN Employee_ID END) AS Promo_out_gg_ADJ,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'OUT_ggi' THEN Employee_ID END) AS Promo_out_ggi,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'OUT_ggi' AND ADJ_Base_FYTD IS NULL THEN Employee_ID END) AS Promo_out_ggi_ADJ,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'OUT_i' THEN Employee_ID END) AS Promo_out_i,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'OUT_i' AND ADJ_Base_FYTD IS NULL THEN Employee_ID END) AS Promo_out_i_ADJ,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'WITHIN_gg'
        AND ADJ_BASE_FYTD IS NULL THEN Employee_ID END) AS Promo_within_gg_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'WITHIN_ggi' AND ADJ_BASE_FYTD IS NULL THEN Employee_ID END) AS Promo_within_ggi_ADJ,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'WITHIN_i'
        AND ADJ_BASE_FYTD IS NULL THEN Employee_ID END) AS Promo_within_i_ADJ,
      FYTD,
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
      TABLE
    GROUP BY
      FYTD,
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
      CHANGE_IN_GL_TEXT ) b
  ON
    a.report_effective_date = b.FYTD
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
  IFNULL(b.Demo_In,
    0) AS Count_Demo_In,
  IFNULL(b.Demo_Out,
    0) AS Count_Demo_Out,
  IFNULL(b.Demo_Within,
    0) AS Count_Demo_Within,
  IFNULL(b.Demo_total,
    0) AS Count_Demo_total,
  IFNULL(b.Demo_Within_ADJ,
    0) AS Count_Demo_Within_ADJ,
  IFNULL(b.Demo_total_ADJ,
    0) AS Count_Demo_total_ADJ,
  IFNULL(b.Demo_In_gg,
    0) AS Count_Demo_In_gg,
  IFNULL(b.Demo_In_ggi,
    0) AS Count_Demo_In_ggi,
  IFNULL(b.Demo_In_i,
    0) AS Count_Demo_In_i,
  IFNULL(b.Demo_Within_gg,
    0) AS Count_Demo_Within_gg,
  IFNULL(b.Demo_Within_ggi,
    0) AS Count_Demo_Within_ggi,
  IFNULL(b.Demo_Within_i,
    0) AS Count_Demo_Within_i,
  IFNULL(b.Demo_Within_gg_ADJ,
    0) AS Count_Demo_Within_gg_ADJ,
  IFNULL(b.Demo_Within_ggi_ADJ,
    0) AS Count_Demo_Within_ggi_ADJ,
  IFNULL(b.Demo_Within_i_ADJ,
    0) AS Count_Demo_Within_i_ADJ,
  IFNULL(b.Demo_Out_gg,
    0) AS Count_Demo_Out_gg,
  IFNULL(b.Demo_Out_ggi,
    0) AS Count_Demo_Out_ggi,
  IFNULL(b.Demo_Out_i,
    0) AS Count_Demo_Out_i,
  IFNULL(b.Demo_In_ADJ,
    0) AS Count_Demo_In_ADJ,
  IFNULL(b.Demo_Out_ADJ,
    0) AS Count_Demo_Out_ADJ,
  IFNULL(b.Demo_In_gg_ADJ,
    0) AS Count_Demo_In_gg_ADJ,
  IFNULL(b.Demo_In_ggi_ADJ,
    0) AS Count_Demo_In_ggi_ADJ,
  IFNULL(b.Demo_In_i_ADJ,
    0) AS Count_Demo_In_i_ADJ,
  IFNULL(b.Demo_Out_gg_ADJ,
    0) AS Count_Demo_Out_gg_ADJ,
  IFNULL(b.Demo_Out_ggi_ADJ,
    0) AS Count_Demo_Out_ggi_ADJ,
  IFNULL(b.Demo_Out_i_ADJ,
    0) AS Count_Demo_Out_i_ADJ
FROM
  TABLE_12 a
LEFT JOIN (
  WITH
    TABLE AS (
    WITH
      TABLE AS (
      SELECT
        a.*,
        c.Employee_id AS TYPE,
        b.EMPLOYEE_ID AS Activity,
        d.EMPLOYEE_ID AS Type_gg,
        e.EMPLOYEE_ID AS Type_ggi,
        f.EMPLOYEE_ID AS Type_i
      FROM
        `Working.With_GL_Columns` a
      LEFT JOIN
        `Working.With_GL_Columns` c
      ON
        a.EMPLOYEE_ID = c.EMPLOYEE_ID
        AND EXTRACT(MONTH
        FROM
          a.report_effective_date) = EXTRACT( MONTH
        FROM
          DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH))
        AND EXTRACT(YEAR
        FROM
          a.report_effective_date) = EXTRACT( YEAR
        FROM
          DATE_ADD(CAST(c.report_effective_date AS DATE),INTERVAL 1 MONTH))
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
        `FY18Q3.Demotions` b
      ON
        a.EMPLOYEE_ID = b.EMPLOYEE_ID
        AND EXTRACT (MONTH
        FROM
          a.Report_effective_date) = EXTRACT (MONTH
        FROM
          b.BUSINESS_PROCESS_EFFECTIVE_DATE)
        AND EXTRACT (YEAR
        FROM
          a.Report_effective_date) = EXTRACT (YEAR
        FROM
          b.BUSINESS_PROCESS_EFFECTIVE_DATE)
      LEFT JOIN
        `Working.With_GL_Columns` d
      ON
        a.EMPLOYEE_ID = d.EMPLOYEE_ID
        AND EXTRACT(MONTH
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
        AND IFNULL(CAST(a.grade_group AS STRING ),
          "No Data") = IFNULL(CAST(d.Grade_Group AS STRING ),
          "No Data")
        AND IFNULL(CAST(a.Time_Type AS STRING),
          "No Data") = IFNULL(CAST(d.Time_Type AS STRING),
          "No Data")
        AND IFNULL(CAST(a.Class AS STRING),
          "No Data") = IFNULL(CAST(d.Class AS STRING),
          "No Data")
        AND IFNULL(CAST(a.FLSA AS STRING),
          "No Data") = IFNULL(CAST(d.FLSA AS STRING),
          "No Data")
        AND IFNULL(CAST(a.Functional_Organization AS STRING),
          "No Data") = IFNULL(CAST(d.Functional_Organization AS STRING),
          "No Data")
        AND IFNULL(CAST(a.Primary_Work_Address_Country AS STRING),
          "No Data") = IFNULL(CAST(d.Primary_Work_Address_Country AS STRING),
          "No Data")
        AND IFNULL(CAST(a.Employee_Type AS STRING),
          "No Data") = IFNULL(CAST(d.Employee_Type AS STRING),
          "No Data")
      LEFT JOIN
        `Working.With_GL_Columns` e
      ON
        a.EMPLOYEE_ID = e.EMPLOYEE_ID
        AND EXTRACT(MONTH
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
        a.EMPLOYEE_ID = f.EMPLOYEE_ID
        AND EXTRACT(MONTH
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
          "No Data") )
    SELECT
    a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
      'IN' AS Promo_type
    FROM
      TABLE a
    WHERE
      Activity IS NOT NULL
      AND TYPE IS NULL
      AND FYTD IS NOT NULL
      AND PREVIOUS_GRADE IS NOT NULL
    UNION ALL
    SELECT
    a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
      'IN_gg' AS Promo_type
    FROM
      TABLE a
    WHERE
      Activity IS NOT NULL
      AND TYPE_gg IS NULL
      AND FYTD IS NOT NULL
      AND PREVIOUS_GRADE IS NOT NULL
    UNION ALL
    SELECT
    a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
      'IN_ggi' AS Promo_type
    FROM
      TABLE a
    WHERE
      Activity IS NOT NULL
      AND TYPE_ggi IS NULL
      AND FYTD IS NOT NULL
      AND PREVIOUS_GRADE IS NOT NULL
    UNION ALL
    SELECT
    a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
      'IN_i' AS Promo_type
    FROM
      TABLE a
    WHERE
      Activity IS NOT NULL
      AND TYPE_i IS NULL
      AND FYTD IS NOT NULL
      AND PREVIOUS_GRADE IS NOT NULL
    UNION ALL
    SELECT
    a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
      'WITHIN' AS Promo_type
    FROM
      TABLE a
    WHERE
      Activity IS NOT NULL
      AND TYPE IS NOT NULL
      AND FYTD IS NOT NULL
    UNION ALL
    SELECT
    a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
      'WITHIN' AS Promo_type
    FROM
      TABLE a
    WHERE
      Activity IS NOT NULL
      AND PREVIOUS_GRADE IS NULL
      AND FYTD IS NOT NULL
    UNION ALL
    SELECT
    a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
      'WITHIN_gg' AS Promo_type
    FROM
      TABLE a
    WHERE
      Activity IS NOT NULL
      AND TYPE_gg IS NOT NULL
      AND FYTD IS NOT NULL
    UNION ALL
    SELECT
    a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
      'WITHIN_gg' AS Promo_type
    FROM
      TABLE a
    WHERE
      Activity IS NOT NULL
      AND PREVIOUS_GRADE IS NULL
      AND FYTD IS NOT NULL
    UNION ALL
    SELECT
    a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
      'WITHIN_ggi' AS Promo_type
    FROM
      TABLE a
    WHERE
      Activity IS NOT NULL
      AND TYPE_ggi IS NOT NULL
      AND FYTD IS NOT NULL
    UNION ALL
    SELECT
    a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
      'WITHIN_ggi' AS Promo_type
    FROM
      TABLE a
    WHERE
      Activity IS NOT NULL
      AND PREVIOUS_GRADE IS NULL
      AND FYTD IS NOT NULL
    UNION ALL
    SELECT
    a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
      'WITHIN_i' AS Promo_type
    FROM
      TABLE a
    WHERE
      Activity IS NOT NULL
      AND TYPE_i IS NOT NULL
      AND FYTD IS NOT NULL
    UNION ALL
    SELECT
    a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        a.COMPENSATION_GRADE,
        a.Time_Type,
        a.Class,
        a.FLSA,
        a.Functional_Organization,
        a.Primary_Work_Address_Country,
        a.Employee_Type,
        a.Grade_Group,
        a.Country_group,
        'WITHIN_i' AS Promo_type
    FROM
      TABLE a
    WHERE
      Activity IS NOT NULL
      AND PREVIOUS_GRADE IS NULL
      AND FYTD IS NOT NULL
    UNION ALL
    SELECT
     a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        d.COMPENSATION_GRADE,
        d.Time_Type,
        d.Class,
        d.FLSA,
        d.Functional_Organization,
        d.Primary_Work_Address_Country,
        d.Employee_Type,
        d.Grade_Group,
        d.Country_group,
       'OUT' AS Promo_type
    FROM
      TABLE a
    LEFT JOIN
      TABLE d
    ON
      a.Employee_ID=d.EMPLOYEE_ID
      AND EXTRACT(MONTH
      FROM
        a.Report_effective_date) = EXTRACT(MONTH
      FROM
        DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
      AND EXTRACT(YEAR
      FROM
        a.Report_effective_date) = EXTRACT(YEAR
      FROM
        DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
    WHERE
      a.Activity IS NOT NULL
      AND a.TYPE IS NULL
      AND a.FYTD IS NOT NULL
      AND a.PREVIOUS_GRADE IS NOT NULL
    UNION ALL
    SELECT
     a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        d.COMPENSATION_GRADE,
        d.Time_Type,
        d.Class,
        d.FLSA,
        d.Functional_Organization,
        d.Primary_Work_Address_Country,
        d.Employee_Type,
        d.Grade_Group,
        d.Country_group,
       'OUT_gg' AS Promo_type
    FROM
      TABLE a
    LEFT JOIN
      TABLE d
    ON
      a.Employee_ID=d.EMPLOYEE_ID
      AND EXTRACT(MONTH
      FROM
        a.Report_effective_date) = EXTRACT(MONTH
      FROM
        DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
      AND EXTRACT(YEAR
      FROM
        a.Report_effective_date) = EXTRACT(YEAR
      FROM
        DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
    WHERE
      a.Activity IS NOT NULL
      AND a.TYPE_gg IS NULL
      AND a.FYTD IS NOT NULL
      AND a.PREVIOUS_GRADE IS NOT NULL
    UNION ALL
    SELECT
    a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        d.COMPENSATION_GRADE,
        d.Time_Type,
        d.Class,
        d.FLSA,
        d.Functional_Organization,
        d.Primary_Work_Address_Country,
        d.Employee_Type,
        d.Grade_Group,
        d.Country_group,
        'OUT_ggi' AS Promo_type
    FROM
      TABLE a
    LEFT JOIN
      TABLE d
    ON
      a.Employee_ID=d.EMPLOYEE_ID
      AND EXTRACT(MONTH
      FROM
        a.Report_effective_date) = EXTRACT(MONTH
      FROM
        DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
      AND EXTRACT(YEAR
      FROM
        a.Report_effective_date) = EXTRACT(YEAR
      FROM
        DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
    WHERE
      a.Activity IS NOT NULL
      AND a.TYPE_ggi IS NULL
      AND a.FYTD IS NOT NULL
      AND a.PREVIOUS_GRADE IS NOT NULL
    UNION ALL
    SELECT
      a.*EXCEPT(COMPENSATION_GRADE,
          Time_Type,
          Class,
          FLSA,
          Functional_Organization,
          Primary_Work_Address_Country,
          Employee_Type,
          Grade_Group,
          Country_group),
        d.COMPENSATION_GRADE,
        d.Time_Type,
        d.Class,
        d.FLSA,
        d.Functional_Organization,
        d.Primary_Work_Address_Country,
        d.Employee_Type,
        d.Grade_Group,
        d.Country_group,
        'OUT_i' AS Promo_type
    FROM
      TABLE a
    LEFT JOIN
      TABLE d
    ON
      a.Employee_ID=d.EMPLOYEE_ID
      AND EXTRACT(MONTH
      FROM
        a.Report_effective_date) = EXTRACT(MONTH
      FROM
        DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
      AND EXTRACT(YEAR
      FROM
        a.Report_effective_date) = EXTRACT(YEAR
      FROM
        DATE_ADD(CAST(d.Report_effective_date AS DATE), INTERVAL 1 MONTH))
    WHERE
      a.Activity IS NOT NULL
      AND a.TYPE_i IS NULL
      AND a.FYTD IS NOT NULL
      AND a.PREVIOUS_GRADE IS NOT NULL )
  SELECT
    COUNT (DISTINCT
      CASE
		  WHEN Promo_type = 'IN' THEN Employee_ID END) AS Demo_in,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'IN' AND ADJ_Current_FYTD IS NULL THEN Employee_ID END) AS Demo_In_ADJ,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'OUT' THEN Employee_ID END) AS Demo_out,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'OUT' AND ADJ_Base_FYTD IS NULL THEN Employee_ID END) AS Demo_out_ADJ,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'WITHIN' THEN Employee_ID END) AS Demo_within,
      COUNT (DISTINCT CASE WHEN Promo_type = 'IN_gg' OR Promo_type = 'OUT_gg' OR Promo_type = 'WITHIN_gg' THEN Employee_ID END) AS Demo_Total,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'WITHIN' AND ADJ_Base_FYTD IS NULL THEN Employee_ID END) AS Demo_within_ADJ,  COUNT (DISTINCT CASE
          WHEN ADJ_Base_FYTD IS NULL AND Promo_type = 'IN_gg' OR Promo_type = 'OUT_gg' OR Promo_type = 'WITHIN_gg' THEN Employee_ID  END) AS Demo_Total_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'IN_gg' THEN Employee_ID END) AS Demo_in_gg,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'IN_gg'
        AND ADJ_CURRENT_FYTD IS NULL THEN Employee_ID END) AS Demo_in_gg_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'IN_ggi' THEN Employee_ID END) AS Demo_in_ggi,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'IN_ggi'
        AND ADJ_CURRENT_FYTD IS NULL THEN Employee_ID END) AS Demo_in_ggi_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'IN_i' THEN Employee_ID END) AS Demo_in_i,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'IN_i'
        AND ADJ_CURRENT_FYTD IS NULL THEN Employee_ID END) AS Demo_in_i_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'WITHIN_gg' THEN Employee_ID END) AS Demo_within_gg,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'WITHIN_ggi' THEN Employee_ID END) AS Demo_within_ggi,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'WITHIN_i' THEN Employee_ID END) AS Demo_within_i,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'WITHIN_gg'
        AND ADJ_Base_FYTD IS NULL THEN Employee_ID END) AS Demo_within_gg_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'WITHIN_ggi' AND ADJ_Base_FYTD IS NULL THEN Employee_ID END) AS Demo_within_ggi_ADJ,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'WITHIN_i'
        AND ADJ_Base_FYTD IS NULL THEN Employee_ID END) AS Demo_within_i_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'OUT_gg' THEN Employee_ID END) AS Demo_out_gg,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'OUT_gg'
        AND ADJ_Base_FYTD IS NULL THEN Employee_ID END) AS Demo_out_gg_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'OUT_ggi' THEN Employee_ID END) AS Demo_out_ggi,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'OUT_ggi'
        AND ADJ_Base_FYTD IS NULL THEN Employee_ID END) AS Demo_out_ggi_ADJ,
      COUNT (DISTINCT
        CASE
          WHEN Promo_type = 'OUT_i' THEN Employee_ID END) AS Demo_out_i,  COUNT (DISTINCT CASE
          WHEN Promo_type = 'OUT_i'
        AND ADJ_Base_FYTD IS NULL THEN Employee_ID END) AS Demo_out_i_ADJ,
      FYTD,
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
      TABLE
    GROUP BY
      FYTD,
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
      CHANGE_IN_GL_TEXT ) b
  ON
    a.report_effective_date = b.FYTD
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
      "No Data")
