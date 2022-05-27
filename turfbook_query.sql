WITH voters AS (
  SELECT 
   dnc_precinct_id, 
   count(DISTINCT myv_van_id) AS reg_voters
  FROM
    `democrats.analytics_ks.person`
  WHERE
    is_deceased IS FALSE
    AND reg_voter_flag IS TRUE
  GROUP BY
    dnc_precinct_id
)

SELECT DISTINCT 
  vf.dnc_precinct_id, 
  vf.van_precinct_id, 
  vf.county, 
  vf.van_precinct_name, 
  voters.reg_voters,
  pcs.precinct_avg_dnc_2020_dem_party_support AS avg_dem_score_dnc_2020,
  pcs.precinct_avg_clarity_2020_turnout AS avg_turnout_clarity_2020,
  pcd.precinct_avg_age_buckets_narrow_24_and_under AS avg_24_and_under,
  pcd.precinct_avg_ethnicity_b AS avg_ethnicity_b,
  pcd.precinct_avg_ethnicity_h AS avg_ethnicity_h,
  pcd.precinct_avg_voting_address_type_highrise AS avg_highrise,
  pcd.precinct_avg_voting_address_multi_tenant AS avg_multi_tenant


FROM `democrats.voter_file_ks.precinct` vf

INNER JOIN voters ON
  vf.dnc_precinct_id = voters.dnc_precinct_id

INNER JOIN `democrats.blueprint_ks_rollups.precinct_scores` pcs ON
  vf.dnc_precinct_id = pcs.dnc_precinct_id

INNER JOIN `democrats.blueprint_ks_rollups.precinct_demographics` pcd ON
  vf.dnc_precinct_id = pcd.dnc_precinct_id

WHERE 
  vf.is_active IS TRUE

ORDER BY 3,4 ASC
