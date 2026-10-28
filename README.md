# Lathika Elangovan | Clinical Statistical Programming Portfolio (R & SAS)

B.Pharm graduate building a career as a **Statistical Programmer in clinical research**. This repository is my working portfolio: **8 R scripts and 10 SAS programs** that mirror the day-to-day tasks of a clinical programming team, from preparing raw study data to deriving analysis variables, checking data quality and producing tables, listings and graphs.

**10 months of hands-on R practice** (plus 6 months of formal R training) and foundational Base SAS, applied to clinical-style datasets: demographics, visits, screening, medication, disposition and adverse events.

---

## What this portfolio demonstrates

| Skill | Evidence in this repository |
| --- | --- |
| **R programming** | Joins, grouped operations, string cleaning with regular expressions, date handling, conditional logic, loops, custom functions and data labelling using `dplyr`, `tidyr`, `stringr`, `lubridate`, `haven`, `readxl` and `openxlsx` |
| **SAS programming** | DATA steps, BY-group processing, `PROC SQL`, macros, `PROC FORMAT`, `PROC TRANSPOSE`, `PROC TABULATE`, `PROC REPORT`, `PROC GCHART` and ODS output |
| **Clinical data preparation** | Importing CSV, Excel, text and SAS datasets; combining sources; standardising variables; applying formats and labels |
| **Derivations** | BMI, age, treatment dates, relative study days, event duration, partial-date handling and first-occurrence flags |
| **Data quality checks** | Duplicates, missing values, identifier patterns, date-order problems, sex and range checks, repeated AE records |
| **Tables, Listings, Figures (TLF)** | Demographic tables, screening and eligibility listings, treatment and medication summaries, adverse event summaries (SOC/PT) and bar charts |

---

## Featured work

If you have only a few minutes, start here:

| Program | What it shows |
| --- | --- |
| [Subject-level preparation (SAS)](SAS%20program/SL.sas) | Combining sources, separating duplicate records, handling partial dates and times, and deriving subject-level variables |
| [Adverse event summary (SAS)](SAS%20program/CS009.sas) | Treatment-emergent event filtering and distinct-subject counts and percentages by treatment, system organ class and preferred term |
| [AE analysis dataset (R)](R%20program/adam_ae.R) | Joining AE and subject-level data, deriving treatment variables, analysis days, duration and first-occurrence flags, and attaching variable labels (ADaM-style exercise) |
| Demographics in [SAS](SAS%20program/case_study_1.sas) and [R](R%20program/CS001.R) | The same demographic preparation and listing task implemented in both languages |

---

## Repository structure

- **`SAS program/`**: clinical case studies, summaries, listings and graphs
- **`R program/`**: clinical data exercises and R fundamentals

### SAS programs

| File | Focus |
| --- | --- |
| [case_study_1.sas](SAS%20program/case_study_1.sas) | Demographic and visit preparation, BMI and age derivations, listings with Excel and RTF output |
| [case study 2.sas](SAS%20program/case%20study%202.sas) | Data quality checks: duplicates, BMI and age ranges, date order, sex values, repeated AE records, blood pressure; Excel review datasets |
| [CS003.sas](SAS%20program/CS003.sas) | Screening, medication and disposition data; import and sort macros; inclusion, exclusion and disposition datasets |
| [aesumm.sas](SAS%20program/aesumm.sas) | Demographic summary: age statistics and gender frequencies by treatment arm, transposition and RTF table |
| [CS005.sas](SAS%20program/CS005.sas) | Screening volunteer listing combining subject characteristics with laboratory test names |
| [SL.sas](SAS%20program/SL.sas) | Subject-level preparation, duplicate separation, partial date and time handling, age and interval derivations |
| [CS007.sas](SAS%20program/CS007.sas) | Treatment summaries with `PROC TABULATE`, descriptive statistics, counts, percentages and SQL grouped summaries |
| [CS008.sas](SAS%20program/CS008.sas) | Medication summaries with `PROC SUMMARY`, transposition, totals and `PROC REPORT` layouts |
| [CS009.sas](SAS%20program/CS009.sas) | AE summary by treatment, SOC and PT with count-and-percentage display preparation |
| [Graphs.sas](SAS%20program/Graphs.sas) | Vertical bar charts with `PROC GCHART`, month formats and patterns |

### R scripts

| File | Focus |
| --- | --- |
| [CS001.R](R%20program/CS001.R) | Demographic and visit joins, BMI and age derivations, CSV and Excel exports, demographic listing |
| [adam_ae.R](R%20program/adam_ae.R) | AE analysis dataset: treatment variables, analysis dates and days, duration, first-occurrence flags, dermatologic event grouping, labels |
| [date_imputation.R](R%20program/date_imputation.R) | In-progress functions for partial start and end date imputation using treatment dates |
| [test_02 r.R](R%20program/test_02%20r.R) | Clinical data cleaning: case conversion, whitespace cleanup, regular expressions, identifier checks, filtering, CSV export |
| [test_01.r](R%20program/test_01.r) | Conditional processing, age categories, safety and laboratory flags, visit labels, missing-value checks, assertions, error handling |
| [dates wrkout.R](R%20program/dates%20wrkout.R) | Date and time creation, formatting, arithmetic, sequences and loops |
| [assignment1.R](R%20program/assignment1.R) | Indexing and subsetting vectors, matrices, lists and data frames |
| [mario.R](R%20program/mario.R) | Console pyramid exercises using `for` and `repeat` loops (programming fundamentals) |

---

## Tools and techniques

**R:** base R, `dplyr`, `tidyr`, `stringr`, `lubridate`, `haven`, `readxl`, `openxlsx`

**SAS:** DATA steps, BY-group operations, `PROC IMPORT`, `PROC EXPORT`, `PROC SORT`, `PROC SQL`, `PROC FORMAT`, `PROC MEANS`, `PROC FREQ`, `PROC SUMMARY`, `PROC TRANSPOSE`, `PROC TABULATE`, `PROC REPORT`, `PROC GCHART`, macros, ODS

**Clinical context:** ICH E6(R3) GCP, CDISC concepts (SDTM, ADaM), clinical trial documents (protocols, CRFs)

---

## Scope and transparency

This is a **learning portfolio of source code**. Practice implementations were written against case-study requirements; they are not validated, submission-ready or CDISC-conformant deliverables. Source datasets and generated outputs are not included. A few exercises are still being completed: `adam_ae.R` relies on helper functions that are not yet in the repository, and `date_imputation.R` contains draft logic.

---

## Connect

- GitHub: [lathikaelangovan](https://github.com/lathikaelangovan)
- Email: lathikaes2004@gmail.com
- LinkedIn: [Lathika Elangovan](https://www.linkedin.com/in/lathika-elangovan-670090230)
