# Effect of manure on soil organic carbon concentration in dryland soils: a small descriptive meta-analysis of 4 field studies, with a 7-study fertilizer-matched analysis

Small, descriptive, preregistered meta-analysis.

**Version:** preprint v1.0, code release v1.0.1

**OSF registration:** https://doi.org/10.17605/OSF.IO/F784B (registered 05 Oct 2026)

**Code and data (GitHub):** https://github.com/hussanafzal/SOC-meta-analysis

**Zenodo (cite all versions) DOI:** https://doi.org/10.5281/zenodo.23283038 (always resolves to the latest version)

**This release (v1.0.1) DOI:** https://doi.org/10.5281/zenodo.23306490

**Earlier release (v1.0.0) DOI:** https://doi.org/10.5281/zenodo.23283039

**Preprint:** https://doi.org/10.5281/zenodo.23306828

## How to reproduce

1. Install R.
2. Install the required package: `install.packages("metafor")`
3. Open R with the repository root as the working directory (the folder containing `data/` and `R/`).
4. Run: `source("R/SOC_analysis.R")`
5. The script writes 9 files to `results/`: 6 CSV files, 2 funnel plots (PNG), and `sessionInfo.txt`.

## Files

Renamed files since v1.0.0: see CHANGELOG.md

### Analysis

| File                            | Content                                                                                                                                                          |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `R/SOC_analysis.R`              | Analysis script: data import, lnRR calculations, multilevel models, heterogeneity, subgroup eligibility checks, sensitivity analyses, funnel plots, and exports. |
| `data/SOC_extraction_final.csv` | Master extraction file: 20 effect-size rows from 7 studies. The only input read by the analysis script.                                                          |

### Search and screening

| File                             | Rows | Content                                                                                                                                                                                                             |
| -------------------------------- | ---: | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `data/S2a_search_strings.txt`     |    6 | The 6 search strings with hit counts (Google Scholar about 7,800, 19,800 and 3,530; CORE 66; AGRIS 13 and 48) and the two changes logged during search-string testing. |
| `data/S2b_raw_search_records.csv` |  427 | Raw search records (Google Scholar 300, CORE 66, AGRIS 61), recorded on 07 Oct 2026. Only `Record_ID`, `Source`, `Search_date`, `Rank` and `Title` are filled; the other columns are empty.                                                                                                                              |
| `data/S2c_search_records_cleaned.csv`            |  427 | `Dup_flag` marks 70 duplicates and 8 records with no title. `Status` holds keyword-based pre-screen flags, not final screening decisions.                                                                              |
| `data/S2d_stageA_screening.csv`   |  357 | Non-duplicate records: Include 56, Unsure 207, Exclude 94. Priorities: A 56, B-high 66, B-low 141. This is the only file listing the B-low records.                                                                 |
| `data/S3a_title_screening.csv`       |  128 | Second title-screening round: 122 priority records plus 6 Stage A exclusions rechecked. Decisions: Strong 54, Possible 68, Exclude 6. Waves: Wave 1 = 31, Wave 2 = 23, Wave 3 = 68. Does not include B-low records. |
| `data/S3b_wave1_pdf_status.csv`    |   31 | Wave 1 records, with PDF status: 15 found and 16 not found.                                                                                                                                                         |
| `data/S3c_fulltext_decisions.csv`            |   15 | Full-text decisions for the 15 PDFs found: 8 included and 7 excluded, with reason codes and notes. IDs use the format `ID_###`.                                                                                     |
| `data/S3d_fulltext_exclusions.csv` | 8 | The 7 records excluded at full text, plus study 276 (excluded at extraction), with reason codes and notes. |
| `data/S3e_pdf_not_found.csv`     | 16 | The 16 Wave 1 records whose PDF could not be found. |

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
| 102      | Zhang et al. (2024), Journal of Environmental Management 365: 121571  | 10.1016/j.jenvman.2024.121571    |
| 179      | Srinivasarao et al. (2012), J. Plant Nutrition and Soil Science 175(5): 681 to 688 | 10.1002/jpln.201000429 |
| 184      | Srinivasarao et al. (2014), Land Degradation and Development 25: 173 to 183 | 10.1002/ldr.1158           |
| 196      | Su et al. (2006), Nutrient Cycling in Agroecosystems 75: 285 to 295   | 10.1007/s10705-006-9034-x        |

Study 276 passed full-text inclusion but was excluded at extraction (no variance data). It is not in the analysis, so it is not listed above. Its decision is in `data/S3c_fulltext_decisions.csv`.

## Screening and analysis notes

* Eight records (IDs 317, 319, 324, 330, 334, 349, 350, 360) had no title in the source and could not be screened. Therefore, 349 of the 357 non-duplicate records had titles available for screening. These eight records are marked Unsure in `S2d_stageA_screening.csv` and Possible (Wave 3) in `S3a_title_screening.csv`. 94 records were excluded at title screening. 263 records were carried forward.
* A total of 232 records were not assessed at full text: Wave 2 = 23, Wave 3 = 68, and B-low = 141.
* Study 276 passed full-text inclusion but was excluded during extraction because variance data were unavailable. Seven studies contributed to the analysis.
* Screening waves: Wave 1 and Wave 2 are both "Strong" title-screen records. Wave 1 titles clearly showed an organic amendment, a dryland or saline setting, and an SOC outcome. Wave 2 titles or screening notes flagged a possible eligibility risk (for example a confound, a sub-outcome focus, a depth concern, a matched-control requirement, or an unclear dryland/saline label). The split reflects the author's own judgement and was not a pre-set rule. The `Reason` column in `data/S3a_title_screening.csv` shows the note behind each record (Wave 1 rows give a short reason, Wave 2 rows carry a caveat such as "aggregate focus", "needs N-matched control", "gypsum confound" or "dryland label unclear"). The sequential-wave approach is reported as deviation D2 in the preprint.
* Aridity Index, study 041 (Chen et al. 2019): the value 0.24 was calculated as reported mean annual precipitation (413.7 mm) divided by reported annual potential evaporation (1702.44 mm). The evaporation figure is the paper's own pan-type value, not a reference-ET PET, so 0.24 is an approximate ratio and not a strict UNEP index. The authors describe the site only as "dry".
* Software: R 4.6.1 and metafor 5.2-1 (see `results/sessionInfo.txt`); WebPlotDigitizer 5.2 for digitising figures; Zotero 10.0.6 (64-bit) for reference management.
* For studies 101 and 196, the reported variance type was unclear. The main analysis treats these values as SD; sensitivity analyses treat them as SE (study 101 alone, then studies 196 and 101 together).
* The two comparison sets are analysed separately:

  * Manure vs unamended: 4 studies, 5 rows, +51.4% (95% CI, z based: 38.4 to 65.6; t based, df 3: 30.9 to 75.1; 95% prediction interval: +9.6 to +109.1)
  * Amendment + fertilizer vs same fertilizer: 7 studies, 15 rows, +47.9% (95% CI, z based: 25.7 to 74.1; t based, df 6: 20.7 to 81.4; 95% prediction interval: -24.7 to +190.5)
* Label legend (data and result files). In `data/SOC_extraction_final.csv` the `control_type` column takes two values: `unamended` = control plots received no organic amendment and no fertilizer; `fert_only` = control plots received the same fertilizer as the treatment but no organic amendment. The main set (manure vs unamended) is `control_type = unamended`; the fertilizer-matched set is `control_type = fert_only`, so its treatment is organic amendment plus that same fertilizer. In the result files (`results/S6_main_results.csv`, `results/S6_sensitivity.csv`) the `set` column labels the main set `pooled` and the fertilizer-matched set `fert_only`. In every case `fert_only` names the fertilizer-only control, never a fertilizer-only treatment.
* Results include z-based confidence intervals (the metafor default for the registered model, primary) and, as unregistered small-sample checks (deviation D5), t-based confidence intervals with study-level degrees of freedom (`test = "t", dfs = "contain"`, added in v1.0.1) and 95% prediction intervals. In v1.0.0 the t-based intervals used row-level degrees of freedom, which was too optimistic.
* The script compares its lnRR with metafor's `escalc`: variances match exactly and lnRR differs by at most 0.004, which is the small bias correction that `escalc` adds.
* No subgroup test was run, because no subgroup had 3 or more studies per level. The script still prints a subgroup eligibility check. The `soil_type` table for the pooled set prints empty because soil type is missing for all 4 studies in it (EC and ESP were not reported), and the eligibility result is `FALSE`. This is expected, not an error. No SOC stock analysis was run (stock values were not extracted). No Egger test was run (7 studies; registered threshold is 10).
* Study identifiers appear in different formats across files, including `101`, `ID_101`, and `101_1`. The R output files in `results/` write study IDs as plain numbers without leading zeros (for example `41` and `33` for studies 041 and 033). A study ID is the same number as its `Record_ID` in the screening files (for example, study 101 is record 101). Effect IDs such as `101_1` are comparison rows within a study.

## Registration and timeline

The protocol was registered on OSF on 05 Oct 2026 (https://doi.org/10.17605/OSF.IO/F784B). Search results were recorded on 07 Oct 2026, after registration. The exact search strings were not part of the OSF registration. They were drafted and tested after registration with an AI assistant (Claude); two strings were changed during testing before any screening: AGRIS string 1 (quotation marks removed because the first version returned 0 results) and Google Scholar string 3 (the term "calcareous" removed). See `data/S2a_search_strings.txt`. Screening, full-text assessment, extraction and analysis followed. The project was closed for new searching, screening and extraction on 09 Oct 2026. Departures from the registered protocol are listed as deviations D1 to D6 in the preprint.

## Deviations from the registered protocol

Full detail is in the preprint (Table 1). In summary:

- **D1** — Zotero did not capture full metadata; records were kept manually (title, source, rank) and duplicates removed by matching cleaned titles. *(Low risk)*
- **D2** — Screening was sequential, in waves, and full text was assessed for Wave 1 only; the project stopped at 7 usable studies rather than the planned 10, and 232 records were never assessed at full text. *(High — the biggest limitation)*
- **D3** — 8 records had no title in the source and could not be screened (carried forward, not assessed). *(Low to medium)*
- **D4** — 16 of 31 Wave 1 PDFs could not be retrieved. *(Medium — possible bias toward accessible papers)*
- **D5** — t-based confidence intervals (study-level degrees of freedom) and 95% prediction intervals were added as unregistered small-sample checks, after seeing the number of studies; the z-based intervals remain the registered result. *(Low)*
- **D6** — The registration said that with fewer than 10 studies results should be descriptive only. Pooled multilevel models were still fitted, so confidence intervals, Q, I² and p-values are reported but are treated as descriptive.

## Licences

* Code (`R/`): MIT licence, see `LICENSE`.
* Data (`data/`, `results/`): CC BY 4.0, see `DATA_LICENSE.txt`.
* Original research PDFs are not included in this repository.
