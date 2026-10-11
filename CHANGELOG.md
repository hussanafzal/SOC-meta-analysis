# Changelog

## v1.0.1

### Changed: data/ files renamed (contents unchanged)
The data files carried over from v1.0.0 were renamed so they sort in workflow
order. Each file's contents are byte-for-byte identical to v1.0.0 (verified by
SHA-256 against the v1.0.0 release); no data values were changed.

| v1.0.0 name | v1.0.1 name |
|---|---|
| S2_search_strings.txt | S2a_search_strings.txt |
| S2_raw_search_records.csv | S2b_raw_search_records.csv |
| S2_cleaned.csv | S2c_search_records_cleaned.csv |
| S2_StageA_screening.csv | S2d_stageA_screening.csv |
| S3_title_screen.csv | S3a_title_screening.csv |
| S3_title_screen_v2.csv | S3b_wave1_pdf_status.csv |
| S3b_log_v2.csv | S3c_fulltext_decisions.csv |
| SOC_extraction_final.csv | SOC_extraction_final.csv (unchanged) |

Note on labels: in v1.0.0 the only lettered S3 file was S3b_log_v2.csv (the
full-text log), which is S3c_fulltext_decisions.csv in v1.0.1. When comparing
with the v1.0.0 DOI (10.5281/zenodo.23283039), use the table above rather than
matching S3 letters.

### Added: two screening-transparency files (not present in v1.0.0)
- S3d_fulltext_exclusions.csv - the 7 records excluded at full text, plus
  study 276 (excluded at extraction), with reason codes.
- S3e_pdf_not_found.csv - the 16 Wave 1 records whose PDF could not be found.

### Changed: t-based intervals and prediction intervals (deviation D5)
The t-based confidence intervals now use study-level degrees of freedom (number
of studies minus 1), implemented with dfs = "contain". This replaces the
row-level degrees of freedom used in v1.0.0, which was too optimistic; for the
pooled set the t-based CI widens accordingly (v1.0.0: 33.3 to 71.9; v1.0.1:
30.9 to 75.1). 95% prediction intervals, also on study-level degrees of
freedom, were added (pooled: +9.6 to +109.1; fertilizer-matched: -24.7 to
+190.5). The z-based intervals remain the registered primary result and are
unchanged. These corrected result values are locked and should remain unchanged
unless an explicitly documented correction is required.

## v1.0.0
Initial release.
