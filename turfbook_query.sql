SELECT DISTINCT 
  p.dnc_precinct_id, 
  p.van_precinct_id, 
  p.county_name, 
  p.van_precinct_name, 
  count(DISTINCT p.myv_van_id) AS voters_reg,
  pcs.precinct_avg_dnc_2020_dem_party_support AS avg_dem_score_dnc_2020,
  pcs.precinct_avg_clarity_2020_turnout AS avg_turnout_clarity_2020,
  pcs.precinct_avg_ts_tsmart_midterm_general_turnout_score AS avg_turnout_midterm_ts, --we don't need two turnout scores, I would just keep the clarity score so it's consistently using 2020 scores
  pcd.precinct_avg_age_buckets_narrow_24_and_under AS avg_24_and_under,
  pcd.precinct_avg_ethnicity_b AS avg_ethnicity_b,
  pcd.precinct_avg_ethnicity_h AS avg_ethnicity_h,
  pcd.precinct_avg_voting_address_type_highrise AS avg_highrise,
  pcd.precinct_avg_voting_address_multi_tenant AS avg_multi_tenant


FROM `democrats.analytics_ks.person` p --I don't 100% trust the precinct assignments and VAN/DNC precinct id crosswalks in the person table - can you change the leftmost table to voter_file_ks.precinct, left join person on VAN precinct id and left join the demographics/scores tables on DNC precinct id? 

INNER JOIN `democrats.blueprint_ks_rollups.precinct_scores` pcs ON 
  p.dnc_precinct_id = pcs.dnc_precinct_id

INNER JOIN `democrats.blueprint_ks_rollups.precinct_demographics` pcd ON
  p.dnc_precinct_id = pcd.dnc_precinct_id

WHERE is_deceased IS FALSE --remember to use person table alias in columns (or use a CTE). also, newline + indent the first where condition
  AND reg_voter_flag IS TRUE

GROUP BY --so I think the use of group by here could potentially lead to issues. instead, I would use a CTE from the person table to group the number of voters by van_precinct_id only and join it to the other tables
  1,2,3,4,6,7,8,9,10,11,12,13

ORDER BY 3,4 DESC --change to asc
