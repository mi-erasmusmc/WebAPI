SELECT
  concept_hierarchy.concept_id                        AS conceptId,
  isnull(concept_hierarchy.level4_concept_name, 'NA') + '||' +
  isnull(concept_hierarchy.level3_concept_name, 'NA') + '||' +
  isnull(concept_hierarchy.level2_concept_name, 'NA') + '||' +
  isnull(concept_hierarchy.level1_concept_name, 'NA') + '||' +
  concept_hierarchy.concept_name               AS conceptPath,
  ar1.count_value                                     AS numPersons,
  round(1.0 * ar1.count_value / denom.count_value, 5) AS percentPersons,
  round(1.0 * ar2.count_value / ar1.count_value, 5)   AS recordsPerPerson
FROM (SELECT *
      FROM @results_database_schema.ACHILLES_results WHERE analysis_id = 700) ar1
  INNER JOIN
  (SELECT *
   FROM @results_database_schema.ACHILLES_results WHERE analysis_id = 701) ar2
    ON ar1.stratum_1 = ar2.stratum_1
  INNER JOIN
  @results_database_schema.concept_hierarchy AS concept_hierarchy
    ON CAST(ar1.stratum_1 AS INT) = concept_hierarchy.concept_id
  AND concept_hierarchy.treemap='Drug'
  ,
  (SELECT count_value
   FROM @results_database_schema.ACHILLES_results WHERE analysis_id = 1) denom

ORDER BY ar1.count_value DESC