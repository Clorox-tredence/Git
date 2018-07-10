SELECT
i.*EXCEPT(
  MINORITY,
  Female_27,
  Minority_27,
  key,
  value),
  i.Key AS Key,
  i.value AS Value,
  f.Rep_Goal_in_Hiring__US__Non_Prod__Reg_ AS F_Hiring,
  f.Rep_Goal_in_Promotions__US__Non_Prod__Reg_ AS F_Promo,
  f.Rep_Goal_in_Terminations__US__Non_Prod__Reg_ AS F_Term,
  tm.Rep_Goal_in_Hiring__US__Non_Prod__Reg_ AS TM_Hiring,
  tm.Rep_Goal_in_Promotions__US__Non_Prod__Reg_ AS TM_Promo,
  tm.Rep_Goal_in_Terminations__US__Non_Prod__Reg_ AS TM_Term,
  m.Rep_Goal_in_Hiring__US__Non_Prod__Reg_ AS M_Hiring,
  m.Rep_Goal_in_Promotions__US__Non_Prod__Reg_ AS M_Promo,
  m.Rep_Goal_in_Terminations__US__Non_Prod__Reg_ AS M_Term,
  fc.Rep_Goal_in_Hiring__US__Non_Prod__Reg_ AS Fc_Hiring,
  fc.Rep_Goal_in_Promotions__US__Non_Prod__Reg_ AS Fc_Promo,
  fc.Rep_Goal_in_Terminations__US__Non_Prod__Reg_ AS Fc_Term,
  tmc.Rep_Goal_in_Hiring__US__Non_Prod__Reg_ AS TMc_Hiring,
  tmc.Rep_Goal_in_Promotions__US__Non_Prod__Reg_ AS TMc_Promo,
  tmc.Rep_Goal_in_Terminations__US__Non_Prod__Reg_ AS TMc_Term,
  mc.Rep_Goal_in_Hiring__US__Non_Prod__Reg_ AS Mc_Hiring,
  mc.Rep_Goal_in_Promotions__US__Non_Prod__Reg_ AS Mc_Promo,
  mc.Rep_Goal_in_Terminations__US__Non_Prod__Reg_ AS Mc_Term
FROM
  `Working.Intermediate_For_Goal`  i
LEFT JOIN (
  SELECT
    *
  FROM
    `HR.Goals`
  WHERE
    Population_="Female GL27+") f
ON
  i.Female_27=f.Population_
  AND i.Functional_Organization=f.FUNCTION
LEFT JOIN (
  SELECT
    *
  FROM
    `HR.Goals`
  WHERE
    Population_="Total Minority") tm
ON
  i.MINORITY=tm.Population_
  AND i.Functional_Organization=tm.FUNCTION
LEFT JOIN (
  SELECT
    *
  FROM
    `HR.Goals`
  WHERE
    Population_="Minority GL27+") m
ON
  i.Minority_27 =m.Population_
  AND i.Functional_Organization=m.FUNCTION
LEFT JOIN (
  SELECT
    *
  FROM
    `HR.Goals`
  WHERE
    Population_="Female GL27+"
    AND FUNCTION="Company" ) fc
ON
  i.Female_27=fc.Population_
LEFT JOIN (
  SELECT
    *
  FROM
    `HR.Goals`
  WHERE
    Population_="Total Minority"
    AND FUNCTION="Company") tmc
ON
  i.MINORITY=tmc.Population_
LEFT JOIN (
  SELECT
    *
  FROM
    `HR.Goals`
  WHERE
    Population_="Minority GL27+"
    AND FUNCTION="Company") mc
ON
  i.Minority_27 =mc.Population_