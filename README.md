# SOC meta-analysis: organic amendments in dryland and saline/sodic soils

Small, descriptive, preregistered meta-analysis.

**OSF registration:** https://doi.org/10.17605/OSF.IO/F784B (registered 05 Oct 2026)

**Preprint:** To be added after upload.

## How to reproduce

1. Install R.
2. Install the required package: `install.packages("metafor")`
3. Open R with the repository root as the working directory (the folder containing `data/` and `R/`).
4. Run: `source("R/SOC_analysis.R")`
5. The script writes 9 files to `results/`: 6 CSV files, 2 funnel plots (PNG), and `sessionInfo.txt`.

## Files

### Analysis

| File                            | Content                                                                                                                                                          |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `R/SOC_analysis.R`              | Analysis script: data import, lnRR calculations, multilevel models, heterogeneity, subgroup eligibility checks, sensitivity analyses, funnel plots, and exports. |
| `data/SOC_extraction_final.csv` | Master extraction file: 20 effect-size rows from 7 studies. The only input read by the analysis script.                                                          |

### Search and screening

| File                             | Rows | Content                                                                                                                                                                                                             |
| -------------------------------- | ---: | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `data/S2_search_strings.txt`     |    6 | The 6 search strings with hit counts (Google Scholar about 7,800, 19,800 and 3,530; CORE 66; AGRIS 13 and 48) and the two changes logged during search-string testing. |
| `data/S2_raw_search_records.csv` |  427 | Raw search records (Google Scholar 300, CORE 66, AGRIS 61), recorded on 07 Oct 2026. Only `Record_ID`, `Source`, `Search_date`, `Rank` and `Title` are filled; the other columns are empty.                                                                                                                              |
| `data/S2_cleaned.csv`            |  427 | `Dup_flag` marks 70 duplicates and 8 records with no title. `Status` holds keyword-based pre-screen flags, not final screening decisions.                                                                              |
| `data/S2_StageA_screening.csv`   |  357 | Non-duplicate records: Include 56, Unsure 207, Exclude 94. Priorities: A 56, B-high 66, B-low 141. This is the only file listing the B-low records.                                                                 |
| `data/S3_title_screen.csv`       |  128 | Second title-screening round: 122 priority records plus 6 Stage A exclusions rechecked. Decisions: Strong 54, Possible 68, Exclude 6. Waves: Wave 1 = 31, Wave 2 = 23, Wave 3 = 68. Does not include B-low records. |
| `data/S3_title_screen_v2.csv`    |   31 | Wave 1 records, with PDF status: 15 found and 16 not found.                                                                                                                                                         |
| `data/S3b_log_v2.csv`            |   15 | Full-text decisions for the 15 PDFs found: 8 included and 7 excluded, with reason codes and notes. IDs use the format `ID_###`.                                                                                     |

### Results (`results/`)

| File                        | Content                                                                                                                             |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `S6_effect_sizes.csv`       | lnRR (`yi`) and variance (`vi`) for all 20 effect-size rows.                                                                        |
| `S6_main_results.csv`       | Results for the pooled and fertilizer-matched sets, including estimates, z-based and t-based confidence intervals, tau², Q, and I². |
| `S6_sensitivity.csv`        | Main analyses, variance-type sensitivity checks for studies 101 and 196, and leave-one-study-out analyses for both sets.            |
| `S6_fert_descriptive.csv`   | Percentage change per row for the fertilizer-matched set; descriptive only.                                                         |
| `S7_funnel_data_pooled.csv` | Effect sizes and standard errors used for the pooled funnel plot.                                                                   |
| `S7_funnel_data_fert.csv`   | Effect sizes and standard errors used for the fertilizer-matched funnel plot.                                                       |
| `S7_funnel_pooled.png`      | Funnel plot for the pooled set.                                                                                                     |
| `S7_funnel_fert.png`        | Funnel plot for the fertilizer-matched set.                                                                                         |
| `sessionInfo.txt`           | R and package version information.                                                                                                  |

## Included studies

The extraction file identifies studies by number only. This table links each study ID to its paper. Full references are in the preprint.

| Study ID | Study                                                                 | DOI                              |
| -------- | --------------------------------------------------------------------- | -------------------------------- |
| 033      | Li et al. (2026), Agriculture 16(15): 1658                            | 10.3390/agriculture16151658      |
| 041      | Chen et al. (2019), Sustainability 11(24): 7088                       | 10.3390/su11247088               |
| 101      | Liu et al. (2013), PLoS ONE 8(2): e56536                              | 10.1371/journal.pone.0056536     |
| 102      | Zhang et al. (2024), Journal of Environmental Management 365: 121571  | No DOI listed in the preprint    |
| 179      | Srinivasarao et al. (2012), J. Plant Nutrition and Soil Science 175(5): 681 to 688 | 10.1002/jpln.201000429 |
| 184      | Srinivasarao et al. (2014), Land Degradation and Development 25: 173 to 183 | 10.1002/ldr.1158           |
| 196      | Su et al. (2006), Nutrient Cycling in Agroecosystems 75: 285 to 295   | No DOI listed in the preprint    |

Study 276 passed full-text inclusion but was excluded at extraction (no variance data). It is not in the analysis, so it is not listed above. Its decision is in `data/S3b_log_v2.csv`.

## Screening and analysis notes

* Eight records (IDs 317, 319, 324, 330, 334, 349, 350, 360) had no title in the source and could not be screened. Therefore, 349 of the 357 non-duplicate records had titles available for screening. These eight records are marked Unsure in `S2_StageA_screening.csv` and Possible (Wave 3) in `S3_title_screen.csv`.
* A total of 232 records were not assessed at full text: Wave 2 = 23, Wave 3 = 68, and B-low = 141.
* Study 276 passed full-text inclusion but was excluded during extraction because variance data were unavailable. Seven studies contributed to the analysis.
* For studies 101 and 196, the reported variance type was unclear. The main analysis treats these values as SD; sensitivity analyses treat them as SE (study 101 alone, then studies 196 and 101 together).
* The two comparison sets are analysed separately:

  * Manure versus unamended control: 4 studies and 5 effect-size rows.
  * Amendment plus fertilizer versus the same fertilizer alone: 7 studies and 15 effect-size rows.
* Results include z-based confidence intervals (the metafor default for the registered model) and t-based confidence intervals as a small-sample check.
* No subgroup test was run, because no subgroup had 3 or more studies per level. The script still prints a subgroup eligibility check. The `soil_type` table for the pooled set prints empty because soil type is missing for all 4 studies in it (EC and ESP were not reported), and the eligibility result is `FALSE`. This is expected, not an error.
* Study identifiers appear in different formats across files, including `101`, `ID_101`, and `101_1`. The R output files in `results/` write study IDs as plain numbers without leading zeros (for example `41` and `33` for studies 041 and 033). A study ID is the same number as its `Record_ID` in the screening files (for example, study 101 is record 101). Effect IDs such as `101_1` are comparison rows within a study.

## Registration and timeline

The protocol was registered on OSF on 05 Oct 2026 (https://doi.org/10.17605/OSF.IO/F784B). Search results were recorded on 07 Oct 2026, after registration. The exact search strings were not part of the OSF registration. They were drafted and tested after registration with an AI assistant (Claude); initial versions that returned no results were revised before screening. Screening, full-text assessment, extraction and analysis followed. The project was closed for new searching, screening and extraction on 09 Oct 2026. Departures from the registered protocol are listed as deviations D1 to D4 in the preprint.

## Licences

* Code (`R/`): MIT licence, see `LICENSE`.
* Data (`data/`, `results/`): CC BY 4.0, see `DATA_LICENSE.txt`.
* Original research PDFs are not included in this repository.