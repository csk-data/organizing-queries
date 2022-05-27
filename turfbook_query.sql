SELECT DISTINCT 
  p.dnc_precinct_id, 
  p.van_precinct_id, 
  p.county_name, 
  p.van_precinct_name, 
  count(DISTINCT p.myv_van_id) AS voters_reg,
  pcs.precinct_avg_dnc_2020_dem_party_support AS avg_dem_score_dnc_2020,
  pcs.precinct_avg_clarity_2020_turnout AS avg_turnout_clarity_2020,
  pcs.precinct_avg_ts_tsmart_midterm_general_turnout_score AS avg_turnout_midterm_ts,
  pcd.precinct_avg_age_buckets_narrow_24_and_under AS avg_24_and_under,
  pcd.precinct_avg_ethnicity_b AS avg_ethnicity_b,
  pcd.precinct_avg_ethnicity_h AS avg_ethnicity_h,
  pcd.precinct_avg_voting_address_type_highrise AS avg_highrise,
  pcd.precinct_avg_voting_address_multi_tenant AS avg_multi_tenant


FROM `democrats.analytics_ks.person` p

INNER JOIN `democrats.blueprint_ks_rollups.precinct_scores` pcs ON
  p.dnc_precinct_id = pcs.dnc_precinct_id

INNER JOIN `democrats.blueprint_ks_rollups.precinct_demographics` pcd ON
  p.dnc_precinct_id = pcd.dnc_precinct_id

WHERE is_deceased IS FALSE
  AND reg_voter_flag IS TRUE

GROUP BY 
  1,2,3,4,6,7,8,9,10,11,12,13

ORDER BY 3,4 DESC
