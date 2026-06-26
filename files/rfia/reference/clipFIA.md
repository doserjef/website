# Spatial and temporal queries for FIADB

Performs space-time queries on Forest Inventory and Analysis Database
(FIADB). Subset database to include only data associated with particular
inventory years (i.e., most recent), and/or only data within a
user-defined region.

## Usage

``` r
clipFIA(db, mostRecent = TRUE, mask = NULL, matchEval = FALSE,
        evalid = NULL, designCD = NULL, nCores = 1)
```

## Arguments

- db:

  `FIA.Database` or `Remote.FIA.Database` object produced from
  [`readFIA`](readFIA.md) or [`getFIA`](getFIA.md). If a
  `Remote.FIA.Database`, data will be read in and processed
  state-by-state to conserve RAM (see details for an example).

- mostRecent:

  logical; if TRUE, returns only data for most recent inventory.

- mask:

  sp or sf Polygon/MultiPolgyon object; defines the boundaries of
  spatial intersection with FIA tables.

- matchEval:

  logical; if TRUE, returns subset of data for which there are matching
  reporting years across states. Only useful if db contains mulitple
  state subsets of the FIA database.

- evalid:

  character; unique value which identifies an inventory year and
  inventory type for a state. If you would like to subset data for an
  inventory year other than the most recent, use
  [`findEVALID`](findEVALID.md) to look locate this value (see Examples
  below).

- designCD:

  character vector; plot designs to include. Default includes standard
  national plot design with other similar sampling designs. See FIA
  Database User Guide Appendix 1 for descriptions of plot designs (see
  References).

- nCores:

  numeric; number of cores to use for parallel implementation. Check
  available cores using `detectCores`. Default = 1, serial processing.

## Details

Not required to run other rFIA functions, but may help conserve free
memory and reduce processing time if user is interested in producing
estimates for a specific inventory year or within a region not
explicitly described in the database (w/in user defined polygons).

Spatial intersections do not adhere strictly to absolute plot locations,
all plots which fall within an estimation unit (often a county) which
intersects with a user defined region will be returned. The plots which
fall slightly outside of the region do NOT bias estimates (removed from
computations), but as FIA often employs stratified random sampling
estimators, all plots within intersecting estimation units must be
present to proudce unbiased variance estimates.

If specifying spatio-temporal intersections on a
`"Remote.FIA.Database"`, evaluation will occur state-by-state once
called by an estimator function.

## Value

List object containing spatially intersected FIADB tables.

## Author

Hunter Stanke and Andrew Finley

## References

FIA Database User Guide:
<https://research.fs.usda.gov/understory/forest-inventory-and-analysis-database-user-guide-nfi>

## See also

[`findEVALID`](findEVALID.md)

## Examples

``` r
## Load data from rFIA package
data(fiaRI)

## Most recent inventory
clipFIA(fiaRI, mostRecent = TRUE)
#> ---- FIA Database Object ----- 
#> Reporting Years:  2018 
#> States:           RHODE ISLAND 
#> Total Plots:      225 
#> Memory Used:      13.8 Mb 
#> Tables:           COND_DWM_CALC COND INVASIVE_SUBPLOT_SPP P2VEG_SUBP_STRUCTURE PLOT PLOTGEOM POP_ESTN_UNIT POP_EVAL_GRP POP_EVAL_TYP POP_EVAL POP_PLOT_STRATUM_ASSGN POP_STRATUM SEEDLING SUBP_COND_CHNG_MTRX SUBP_COND SUBPLOT SURVEY TREE_GRM_BEGIN TREE_GRM_COMPONENT TREE_GRM_MIDPT TREE mostRecent 
#>  
#> $COND_DWM_CALC
#> # A tibble: 114 × 104
#>         CN STATECD COUNTYCD  PLOT MEASYEAR INVYR CONDID EVALID  PLT_CN  CND_CN
#>      <dbl>   <int>    <int> <dbl>    <int> <int>  <int>  <int>   <dbl>   <dbl>
#>  1 1.76e15      44        9   239     2012  2012      1 441507 2.47e14 1.95e14
#>  2 1.76e15      44        9   239     2012  2012      1 441607 2.47e14 1.95e14
#>  3 1.76e15      44        9   239     2012  2012      1 441707 2.47e14 1.95e14
#>  4 1.76e15      44        9   239     2012  2012      1 441807 2.47e14 1.95e14
#>  5 1.76e15      44        5   344     2013  2013      1 441507 1.45e13 2.52e14
#>  6 1.76e15      44        5   344     2013  2013      1 441607 1.45e13 2.52e14
#>  7 1.76e15      44        5   344     2013  2013      1 441707 1.45e13 2.52e14
#>  8 1.76e15      44        5   344     2013  2013      1 441807 1.45e13 2.52e14
#>  9 1.76e15      44        5   344     2013  2013      1 441907 1.45e13 2.52e14
#> 10 1.76e15      44        7    42     2013  2013      1 441507 1.45e13 2.52e14
#> # ℹ 104 more rows
#> # ℹ 94 more variables: STRATUM_CN <dbl>, PHASE <lgl>, CONDPROP_CWD <dbl>,
#> #   CONDPROP_FWD_SM <dbl>, CONDPROP_FWD_MD <dbl>, CONDPROP_FWD_LG <dbl>,
#> #   CONDPROP_DUFF <dbl>, CWD_TL_COND <dbl>, CWD_TL_UNADJ <dbl>,
#> #   CWD_TL_ADJ <dbl>, CWD_LPA_COND <dbl>, CWD_LPA_UNADJ <dbl>,
#> #   CWD_LPA_ADJ <dbl>, CWD_VOLCF_COND <dbl>, CWD_VOLCF_UNADJ <dbl>,
#> #   CWD_VOLCF_ADJ <dbl>, CWD_DRYBIO_COND <dbl>, CWD_DRYBIO_UNADJ <dbl>, …
#> 
#> $COND
#> # A tibble: 668 × 151
#>         CN  PLT_CN INVYR STATECD UNITCD COUNTYCD  PLOT CONDID COND_STATUS_CD
#>      <dbl>   <dbl> <int>   <int>  <int>    <int> <int>  <int>          <int>
#>  1 1.64e14 1.23e14  2007      44      1        3   158      1              2
#>  2 1.64e14 1.23e14  2007      44      1        3   158      2              1
#>  3 1.64e14 1.23e14  2007      44      1        3   184      1              2
#>  4 1.64e14 1.23e14  2007      44      1        3   184      2              1
#>  5 1.64e14 1.23e14  2007      44      1        3   327      1              4
#>  6 1.64e14 1.23e14  2007      44      1        5   349      1              4
#>  7 1.64e14 1.23e14  2007      44      1        7     2      1              2
#>  8 1.64e14 1.23e14  2007      44      1        7    82      1              5
#>  9 1.64e14 1.23e14  2007      44      1        7   126      1              1
#> 10 1.64e14 1.23e14  2007      44      1        7   126      2              2
#> # ℹ 658 more rows
#> # ℹ 142 more variables: COND_NONSAMPLE_REASN_CD <int>, RESERVCD <int>,
#> #   OWNCD <int>, OWNGRPCD <int>, ADFORCD <lgl>, FORTYPCD <int>, FLDTYPCD <int>,
#> #   MAPDEN <int>, STDAGE <int>, STDSZCD <int>, FLDSZCD <int>, SITECLCD <int>,
#> #   SICOND <int>, SIBASE <int>, SISP <int>, STDORGCD <int>, STDORGSP <dbl>,
#> #   PROP_BASIS <chr>, CONDPROP_UNADJ <dbl>, MICRPROP_UNADJ <dbl>,
#> #   SUBPPROP_UNADJ <dbl>, MACRPROP_UNADJ <lgl>, SLOPE <int>, ASPECT <int>, …
#> 
#> $INVASIVE_SUBPLOT_SPP
#> # A tibble: 16 × 15
#>         CN  PLT_CN INVYR STATECD UNITCD COUNTYCD  PLOT  SUBP CONDID VEG_FLDSPCD
#>      <dbl>   <dbl> <int>   <int>  <int>    <int> <dbl> <dbl>  <int> <chr>      
#>  1 2.52e14 1.45e13  2013      44      1        7   169     1      1 CEOR7      
#>  2 2.52e14 1.45e13  2013      44      1        7   169     1      1 FRAL4      
#>  3 2.52e14 1.45e13  2013      44      1        7   169     2      1 FRAL4      
#>  4 2.52e14 1.45e13  2013      44      1        7   169     4      1 FRAL4      
#>  5 2.52e14 1.45e13  2013      44      1        7   169     1      1 ROMU       
#>  6 3.07e14 1.68e14  2014      44      1        7   254     1      1 CEOR7      
#>  7 3.07e14 1.68e14  2014      44      1        7   254     3      1 CEOR7      
#>  8 3.07e14 1.68e14  2014      44      1        7   254     4      1 CEOR7      
#>  9 3.07e14 1.68e14  2014      44      1        7   254     3      1 POCU6      
#> 10 3.07e14 1.68e14  2014      44      1        7   254     4      1 RHCA3      
#> 11 3.68e14 1.68e14  2015      44      1        7   113     1      1 BETH       
#> 12 3.68e14 1.68e14  2015      44      1        7   113     1      1 ROMU       
#> 13 5.31e14 3.74e14  2017      44      1        5   102     1      2 BETH       
#> 14 5.31e14 3.74e14  2017      44      1        5   102     1      2 CEOR7      
#> 15 5.31e14 3.74e14  2017      44      1        5   102     1      2 ROMU       
#> 16 5.31e14 3.74e14  2017      44      1        5   102     3      2 ROMU       
#> # ℹ 5 more variables: UNIQUE_SP_NBR <int>, VEG_SPCD <chr>, COVER_PCT <int>,
#> #   CYCLE <int>, SUBCYCLE <int>
#> 
#> $P2VEG_SUBP_STRUCTURE
#> # A tibble: 575 × 14
#>         CN  PLT_CN STATECD UNITCD COUNTYCD  PLOT INVYR  SUBP CONDID
#>      <dbl>   <dbl>   <int>  <int>    <int> <dbl> <int> <dbl>  <int>
#>  1 2.52e14 1.45e13      44      1        7   169  2013     1      1
#>  2 2.52e14 1.45e13      44      1        7   169  2013     1      1
#>  3 2.52e14 1.45e13      44      1        7   169  2013     1      1
#>  4 2.52e14 1.45e13      44      1        7   169  2013     1      1
#>  5 2.52e14 1.45e13      44      1        7   169  2013     1      1
#>  6 2.52e14 1.45e13      44      1        7   169  2013     1      1
#>  7 2.52e14 1.45e13      44      1        7   169  2013     1      1
#>  8 2.52e14 1.45e13      44      1        7   169  2013     1      1
#>  9 2.52e14 1.45e13      44      1        7   169  2013     1      1
#> 10 2.52e14 1.45e13      44      1        7   169  2013     1      1
#> # ℹ 565 more rows
#> # ℹ 5 more variables: GROWTH_HABIT_CD <chr>, LAYER <int>, COVER_PCT <int>,
#> #   CYCLE <int>, SUBCYCLE <int>
#> 
#> $PLOT
#> # A tibble: 520 × 64
#>         CN  SRV_CN        CTY_CN PREV_PLT_CN INVYR STATECD UNITCD COUNTYCD  PLOT
#>      <dbl>   <dbl>         <dbl>       <dbl> <int>   <int>  <int>    <int> <int>
#>  1 2.47e14 2.47e14 1320610010538     1.23e14  2012      44      1        3   158
#>  2 2.47e14 2.47e14 1320610010538     1.23e14  2012      44      1        3   184
#>  3 2.47e14 2.47e14 1320610010538     1.23e14  2012      44      1        3   327
#>  4 2.47e14 2.47e14 1320611010538     1.23e14  2012      44      1        5   349
#>  5 2.47e14 2.47e14 1320612010538     1.23e14  2012      44      1        7     2
#>  6 2.47e14 2.47e14 1320612010538     1.23e14  2012      44      1        7    82
#>  7 2.47e14 2.47e14 1320612010538     1.23e14  2012      44      1        7   126
#>  8 2.47e14 2.47e14 1320612010538     1.23e14  2012      44      1        7   177
#>  9 2.47e14 2.47e14 1320612010538     1.23e14  2012      44      1        7   214
#> 10 2.47e14 2.47e14 1320612010538     1.23e14  2012      44      1        7   246
#> # ℹ 510 more rows
#> # ℹ 55 more variables: PLOT_STATUS_CD <int>, PLOT_NONSAMPLE_REASN_CD <int>,
#> #   MEASYEAR <int>, MEASMON <int>, MEASDAY <int>, REMPER <dbl>, KINDCD <int>,
#> #   DESIGNCD <int>, RDDISTCD <int>, WATERCD <int>, LAT <dbl>, LON <dbl>,
#> #   ELEV <int>, GROW_TYP_CD <int>, MORT_TYP_CD <int>, P2PANEL <int>,
#> #   P3PANEL <int>, MANUAL <dbl>, KINDCD_NC <lgl>, QA_STATUS <int>,
#> #   MICROPLOT_LOC <chr>, DECLINATION <lgl>, SAMP_METHOD_CD <int>, …
#> 
#> $PLOTGEOM
#> # A tibble: 262 × 22
#>         CN STATECD INVYR UNITCD COUNTYCD  PLOT   LAT   LON CONGCD ECOSUBCD
#>      <dbl>   <dbl> <dbl>  <dbl>    <dbl> <dbl> <dbl> <dbl>  <dbl> <chr>   
#>  1 2.47e14      44  2012      1        3   158  41.6 -71.5   4402 221Ag   
#>  2 2.47e14      44  2012      1        3   184  41.7 -71.6   4402 221Ag   
#>  3 2.47e14      44  2012      1        3   327  41.7 -71.4   4402 221Ac   
#>  4 2.47e14      44  2012      1        5   349  41.5 -71.3   4401 221Ac   
#>  5 2.47e14      44  2012      1        7     2  41.8 -71.4   4402 221Ac   
#>  6 2.47e14      44  2012      1        7    82  41.8 -71.8   4402 221Ag   
#>  7 2.47e14      44  2012      1        7   126  41.9 -71.6   4402 221Ag   
#>  8 2.47e14      44  2012      1        7   177  42.0 -71.5   4401 221Ag   
#>  9 2.47e14      44  2012      1        7   214  41.9 -71.6   4402 221Ag   
#> 10 2.47e14      44  2012      1        7   246  41.8 -71.5   4401 221Ac   
#> # ℹ 252 more rows
#> # ℹ 12 more variables: HUC <dbl>, EMAP_HEX <dbl>, FIPSCOUNTY <dbl>,
#> #   ROADLESSCD <lgl>, ALP_ADFORCD <lgl>, FVS_VARIANT <chr>, FVS_LOC_CD <int>,
#> #   FVS_REGION <int>, FVS_FOREST <int>, FVS_DISTRICT <lgl>, ECO_UNIT_PNW <lgl>,
#> #   PRECIPITATION <lgl>
#> 
#> $POP_ESTN_UNIT
#> # A tibble: 19 × 13
#>         CN EVAL_CN  RSCD EVALID ESTN_UNIT ESTN_UNIT_DESCR    STATECD AREALAND_EU
#>      <dbl>   <dbl> <int>  <int>     <int> <chr>                <int>       <dbl>
#>  1 6.68e14 6.68e14    24 441800         1 Inland Census Wat…      44          NA
#>  2 6.68e14 6.68e14    24 441800         2 Private Unit 1          44          NA
#>  3 6.68e14 6.68e14    24 441800         3 Public Unit 1           44          NA
#>  4 6.68e14 6.68e14    24 441801         1 Inland Census Wat…      44          NA
#>  5 6.68e14 6.68e14    24 441801         2 Private Unit 1          44          NA
#>  6 6.68e14 6.68e14    24 441801         3 Public Unit 1           44          NA
#>  7 6.68e14 6.68e14    24 441803         1 Inland Census Wat…      44          NA
#>  8 6.68e14 6.68e14    24 441803         2 Private Unit 1          44          NA
#>  9 6.68e14 6.68e14    24 441803         3 Public Unit 1           44          NA
#> 10 6.68e14 6.68e14    24 441807         1 Inland Census Wat…      44          NA
#> 11 6.68e14 6.68e14    24 441807         2 Public Private St…      44          NA
#> 12 6.68e14 6.68e14    24 441812         1 Inland Census Wat…      44          NA
#> 13 6.68e14 6.68e14    24 441812         2 Public Private St…      44          NA
#> 14 8.10e14 8.10e14    24 441808         1 Inland Census Wat…      44          NA
#> 15 8.10e14 8.10e14    24 441808         2 Public Private St…      44          NA
#> 16 6.94e14 6.94e14    24 441810         1 Inland Census Wat…      44          NA
#> 17 6.94e14 6.94e14    24 441810         2 Public Private St…      44          NA
#> 18 6.94e14 6.94e14    24 441809         1 Inland Census Wat…      44          NA
#> 19 6.94e14 6.94e14    24 441809         2 Public Private St…      44          NA
#> # ℹ 5 more variables: AREATOT_EU <dbl>, AREA_USED <dbl>, AREA_SOURCE <chr>,
#> #   P1PNTCNT_EU <int>, P1SOURCE <chr>
#> 
#> $POP_EVAL_GRP
#> # A tibble: 1 × 6
#>        CN  RSCD EVAL_GRP EVAL_GRP_DESCR                            STATECD NOTES
#>     <dbl> <int>    <int> <chr>                                       <int> <chr>
#> 1 6.68e14    24   442018 RHODE ISLAND 2018: ALL AREA, CURRENT ARE…      44 RI: …
#> 
#> $POP_EVAL_TYP
#> # A tibble: 12 × 4
#>         CN EVAL_GRP_CN EVAL_CN EVAL_TYP
#>      <dbl>       <dbl>   <dbl> <chr>   
#>  1 6.68e14     6.68e14 6.68e14 EXPALL  
#>  2 6.68e14     6.68e14 6.68e14 EXPCURR 
#>  3 6.68e14     6.68e14 6.68e14 EXPVOL  
#>  4 6.68e14     6.68e14 6.68e14 EXPCHNG 
#>  5 6.68e14     6.68e14 6.68e14 EXPGROW 
#>  6 6.68e14     6.68e14 6.68e14 EXPMORT 
#>  7 6.68e14     6.68e14 6.68e14 EXPREMV 
#>  8 6.68e14     6.68e14 6.68e14 EXPDWM  
#>  9 6.68e14     6.68e14 6.68e14 EXPCRWN 
#> 10 8.10e14     6.68e14 8.10e14 EXPREGEN
#> 11 6.94e14     6.68e14 6.94e14 EXPP2VEG
#> 12 6.94e14     6.68e14 6.94e14 EXPINV  
#> 
#> $POP_EVAL
#> # A tibble: 8 × 15
#>        CN EVAL_GRP_CN  RSCD EVALID EVAL_DESCR STATECD LOCATION_NM REPORT_YEAR_NM
#>     <dbl>       <dbl> <int>  <int> <chr>        <int> <chr>       <chr>         
#> 1 6.68e14     6.68e14    24 441801 RHODE ISL…      44 Rhode Isla… 2012;2013;201…
#> 2 6.68e14     6.68e14    24 441803 RHODE ISL…      44 Rhode Isla… 2012;2013;201…
#> 3 6.68e14     6.68e14    24 441807 RHODE ISL…      44 Rhode Isla… 2012;2013;201…
#> 4 6.68e14     6.68e14    24 441812 RHODE ISL…      44 Rhode Isla… 2012;2013;201…
#> 5 8.10e14     6.68e14    24 441808 RHODE ISL…      44 Rhode Isla… 2012;2013;201…
#> 6 6.94e14     6.68e14    24 441810 RHODE ISL…      44 Rhode Isla… 2012;2013;201…
#> 7 6.94e14     6.68e14    24 441809 RHODE ISL…      44 Rhode Isla… 2012;2013;201…
#> 8 6.68e14     6.68e14    24 441800 RHODE ISL…      44 Rhode Isla… 2012;2013;201…
#> # ℹ 7 more variables: START_INVYR <int>, END_INVYR <dbl>, LAND_ONLY <chr>,
#> #   TIMBERLAND_ONLY <chr>, GROWTH_ACCT <chr>, ESTN_METHOD <chr>, NOTES <lgl>
#> 
#> $POP_PLOT_STRATUM_ASSGN
#> # A tibble: 769 × 12
#>    CN        STRATUM_CN  PLT_CN STATECD INVYR UNITCD COUNTYCD  PLOT  RSCD EVALID
#>    <chr>          <dbl>   <dbl>   <int> <int>  <int>    <int> <int> <int>  <int>
#>  1 66810717…    6.68e14 4.46e14      44  2018      1        1    91    24 441800
#>  2 66810709…    6.68e14 1.68e14      44  2014      1        1   155    24 441800
#>  3 66810717…    6.68e14 1.45e13      44  2013      1        1   228    24 441800
#>  4 66810708…    6.68e14 3.05e14      44  2016      1        1   253    24 441800
#>  5 66810704…    6.68e14 4.46e14      44  2018      1        1   277    24 441800
#>  6 66810718…    6.68e14 1.68e14      44  2014      1        1   326    24 441800
#>  7 66810713…    6.68e14 3.05e14      44  2016      1        1   332    24 441800
#>  8 66810715…    6.68e14 3.74e14      44  2017      1        1   333    24 441800
#>  9 66810702…    6.68e14 1.45e13      44  2013      1        1   356    24 441800
#> 10 66810714…    6.68e14 4.46e14      44  2018      1        1  9233    24 441800
#> # ℹ 759 more rows
#> # ℹ 2 more variables: ESTN_UNIT <int>, STRATUMCD <int>
#> 
#> $POP_STRATUM
#> # A tibble: 31 × 24
#>         CN ESTN_UNIT_CN  RSCD EVALID ESTN_UNIT STRATUMCD STRATUM_DESCR   STATECD
#>      <dbl>        <dbl> <int>  <int>     <int>     <int> <chr>             <int>
#>  1 6.68e14      6.68e14    24 441800         1     12345 Canopy cover 0…      44
#>  2 6.68e14      6.68e14    24 441800         2         1 Canopy cover 0…      44
#>  3 6.68e14      6.68e14    24 441800         2         2 Canopy cover 6…      44
#>  4 6.68e14      6.68e14    24 441800         2         3 Canopy cover 5…      44
#>  5 6.68e14      6.68e14    24 441800         2         4 Canopy cover 6…      44
#>  6 6.68e14      6.68e14    24 441800         2         5 Canopy cover 8…      44
#>  7 6.68e14      6.68e14    24 441800         3     12345 Canopy cover 0…      44
#>  8 6.68e14      6.68e14    24 441801         1     12345 Canopy cover 0…      44
#>  9 6.68e14      6.68e14    24 441801         2         1 Canopy cover 0…      44
#> 10 6.68e14      6.68e14    24 441801         2         2 Canopy cover 6…      44
#> # ℹ 21 more rows
#> # ℹ 16 more variables: P1POINTCNT <int>, P2POINTCNT <int>, EXPNS <dbl>,
#> #   ADJ_FACTOR_MACR <dbl>, ADJ_FACTOR_SUBP <dbl>, ADJ_FACTOR_MICR <dbl>,
#> #   ADJ_FACTOR_CWD <dbl>, ADJ_FACTOR_FWD_SM <dbl>, ADJ_FACTOR_FWD_LG <dbl>,
#> #   ADJ_FACTOR_DUFF <dbl>, ADJ_FACTOR_PILE <dbl>, ADJ_FACTOR_REGEN_MICR <dbl>,
#> #   ADJ_FACTOR_INV_SUBP <dbl>, ADJ_FACTOR_P2VEG_SUBP <dbl>,
#> #   ADJ_FACTOR_GRNDLYR_MICROQUAD <lgl>, ADJ_FACTOR_SOIL <lgl>
#> 
#> $SEEDLING
#> # A tibble: 262 × 26
#>         CN  PLT_CN INVYR STATECD UNITCD COUNTYCD  PLOT  SUBP CONDID  SPCD
#>      <dbl>   <dbl> <int>   <int>  <int>    <int> <int> <int>  <int> <dbl>
#>  1 1.95e14 2.47e14  2012      44      1        7   126     1      1   129
#>  2 1.95e14 2.47e14  2012      44      1        7   126     1      1   372
#>  3 1.95e14 2.47e14  2012      44      1        7   126     3      1   129
#>  4 1.95e14 2.47e14  2012      44      1        7   177     3      2   407
#>  5 1.95e14 2.47e14  2012      44      1        7   177     3      2   421
#>  6 1.95e14 2.47e14  2012      44      1        7   177     3      2   806
#>  7 1.95e14 2.47e14  2012      44      1        7   177     3      2   931
#>  8 1.95e14 2.47e14  2012      44      1        7   341     2      1   129
#>  9 2.52e14 1.45e13  2013      44      1        1   228     1      1   316
#> 10 2.52e14 1.45e13  2013      44      1        1   228     1      1   693
#> # ℹ 252 more rows
#> # ℹ 16 more variables: SPGRPCD <int>, STOCKING <dbl>, TREECOUNT <int>,
#> #   TOTAGE <lgl>, TREECOUNT_CALC <dbl>, TPA_UNADJ <dbl>, CYCLE <int>,
#> #   SUBCYCLE <int>, DAMAGE_AGENT_CD1_SRS <lgl>,
#> #   PCT_AFFECTED_DAMAGE_AGENT1_SRS <lgl>, DAMAGE_AGENT_CD2_SRS <lgl>,
#> #   PCT_AFFECTED_DAMAGE_AGENT2_SRS <lgl>, DAMAGE_AGENT_CD3_SRS <lgl>,
#> #   PCT_AFFECTED_DAMAGE_AGENT3_SRS <lgl>, AGECD_RMRS <lgl>, …
#> 
#> $SUBP_COND_CHNG_MTRX
#> # A tibble: 1,899 × 9
#>         CN STATECD  SUBP SUBPTYP  PLT_CN CONDID PREV_PLT_CN PREVCOND
#>      <dbl>   <int> <int>   <int>   <dbl>  <int>       <dbl>    <int>
#>  1 1.82e15      44     4       1 3.74e14      1     2.21e14        1
#>  2 1.82e15      44     1       2 3.74e14      1     2.21e14        1
#>  3 1.82e15      44     2       2 3.74e14      1     2.21e14        1
#>  4 1.82e15      44     3       2 3.74e14      1     2.21e14        1
#>  5 1.82e15      44     4       2 3.74e14      1     2.21e14        1
#>  6 1.82e15      44     1       1 3.74e14      1     2.21e14        1
#>  7 1.82e15      44     2       1 3.74e14      1     2.21e14        1
#>  8 1.82e15      44     3       1 3.74e14      2     2.21e14        2
#>  9 1.82e15      44     4       1 3.74e14      1     2.21e14        1
#> 10 1.82e15      44     1       2 3.74e14      1     2.21e14        1
#> # ℹ 1,889 more rows
#> # ℹ 1 more variable: SUBPTYP_PROP_CHNG <dbl>
#> 
#> $SUBP_COND
#> # A tibble: 1,088 × 16
#>         CN  PLT_CN INVYR STATECD UNITCD COUNTYCD  PLOT  SUBP CONDID
#>      <dbl>   <dbl> <int>   <int>  <int>    <int> <int> <int>  <int>
#>  1 1.95e14 2.47e14  2012      44      1        3   158     1      1
#>  2 1.95e14 2.47e14  2012      44      1        3   158     2      1
#>  3 1.95e14 2.47e14  2012      44      1        3   158     3      1
#>  4 1.95e14 2.47e14  2012      44      1        3   158     4      1
#>  5 1.95e14 2.47e14  2012      44      1        3   184     1      1
#>  6 1.95e14 2.47e14  2012      44      1        3   184     2      1
#>  7 1.95e14 2.47e14  2012      44      1        3   184     3      1
#>  8 1.95e14 2.47e14  2012      44      1        3   184     4      1
#>  9 1.95e14 2.47e14  2012      44      1        3   327     1      1
#> 10 1.95e14 2.47e14  2012      44      1        3   327     2      1
#> # ℹ 1,078 more rows
#> # ℹ 7 more variables: MICRCOND_PROP <dbl>, SUBPCOND_PROP <dbl>,
#> #   MACRCOND_PROP <lgl>, NONFR_INCL_PCT_SUBP <lgl>, NONFR_INCL_PCT_MACRO <lgl>,
#> #   CYCLE <int>, SUBCYCLE <int>
#> 
#> $SUBPLOT
#> # A tibble: 1,048 × 46
#>         CN  PLT_CN PREV_SBP_CN INVYR STATECD UNITCD COUNTYCD  PLOT  SUBP
#>      <dbl>   <dbl> <lgl>       <int>   <int>  <int>    <int> <int> <int>
#>  1 1.95e14 2.47e14 NA           2012      44      1        3   158     1
#>  2 1.95e14 2.47e14 NA           2012      44      1        3   158     2
#>  3 1.95e14 2.47e14 NA           2012      44      1        3   158     3
#>  4 1.95e14 2.47e14 NA           2012      44      1        3   158     4
#>  5 1.95e14 2.47e14 NA           2012      44      1        3   184     1
#>  6 1.95e14 2.47e14 NA           2012      44      1        3   184     2
#>  7 1.95e14 2.47e14 NA           2012      44      1        3   184     3
#>  8 1.95e14 2.47e14 NA           2012      44      1        3   184     4
#>  9 1.95e14 2.47e14 NA           2012      44      1        3   327     1
#> 10 1.95e14 2.47e14 NA           2012      44      1        3   327     2
#> # ℹ 1,038 more rows
#> # ℹ 37 more variables: SUBP_STATUS_CD <int>, POINT_NONSAMPLE_REASN_CD <int>,
#> #   MICRCOND <int>, SUBPCOND <int>, MACRCOND <lgl>, CONDLIST <int>,
#> #   SLOPE <int>, ASPECT <int>, WATERDEP <dbl>, P2A_GRM_FLG <chr>, CYCLE <int>,
#> #   SUBCYCLE <int>, ROOT_DIS_SEV_CD_PNWRS <lgl>, NF_SUBP_STATUS_CD <lgl>,
#> #   NF_SUBP_NONSAMPLE_REASN_CD <lgl>, P2VEG_SUBP_STATUS_CD <int>,
#> #   P2VEG_SUBP_NONSAMPLE_REASN_CD <int>, INVASIVE_SUBP_STATUS_CD <int>, …
#> 
#> $SURVEY
#> # A tibble: 42 × 12
#>         CN INVYR P3_OZONE_IND STATECD STATEAB STATENM   RSCD ANN_INVENTORY NOTES
#>      <dbl> <int> <chr>          <int> <chr>   <chr>    <int> <chr>         <chr>
#>  1 1.59e14  1997 Y                 44 RI      Rhode I…    24 Y             "Ozo…
#>  2 1.59e14  1994 Y                 44 RI      Rhode I…    24 Y             "Ozo…
#>  3 5.59e13  2003 N                 44 RI      Rhode I…    24 Y             "Cyc…
#>  4 6.23e13  2005 N                 44 RI      Rhode I…    24 Y             "Ann…
#>  5 5.59e13  2004 N                 44 RI      Rhode I…    24 Y             "Cyc…
#>  6 7.43e13  2006 N                 44 RI      Rhode I…    24 Y             "Ann…
#>  7 1.21e14  2007 N                 44 RI      Rhode I…    24 Y             "Ann…
#>  8 1.20e14  2008 N                 44 RI      Rhode I…    24 Y             "Ann…
#>  9 1.45e14  2009 N                 44 RI      Rhode I…    24 Y             "Ann…
#> 10 1.69e14  2010 N                 44 RI      Rhode I…    24 Y             "Ann…
#> # ℹ 32 more rows
#> # ℹ 3 more variables: CYCLE <int>, SUBCYCLE <int>, PRJ_CN <dbl>
#> 
#> $TREE_GRM_BEGIN
#> # A tibble: 3,080 × 66
#>     TRE_CN PREV_TRE_CN  PLT_CN STATECD SUBPTYP  SPCD STATUSCD   DIA    HT
#>      <dbl>       <dbl>   <dbl>   <int> <lgl>   <int>    <int> <dbl> <int>
#>  1 2.52e14     2.06e14 1.45e13      44 NA        126        1   6.9    37
#>  2 2.52e14     2.06e14 1.45e13      44 NA        126        1   9.8    46
#>  3 2.52e14     2.06e14 1.45e13      44 NA        802        1   8      33
#>  4 2.52e14     2.06e14 1.45e13      44 NA        126        1   9.2    43
#>  5 2.52e14     2.06e14 1.45e13      44 NA        806        1   5.5    30
#>  6 2.52e14     2.06e14 1.45e13      44 NA        129        1   8      29
#>  7 2.52e14     2.06e14 1.45e13      44 NA        126        1   8.5    33
#>  8 2.52e14     2.06e14 1.45e13      44 NA        129        1   7.2    35
#>  9 2.52e14     2.06e14 1.45e13      44 NA        129        1  12.4    34
#> 10 2.52e14     2.06e14 1.45e13      44 NA        802        1   6      25
#> # ℹ 3,070 more rows
#> # ℹ 57 more variables: ACTUALHT <int>, CR <int>, STANDING_DEAD_CD <int>,
#> #   DIAHTCD <int>, CULL <int>, ROUGHCULL <int>, CULLFORM <lgl>,
#> #   CULLMSTOP <lgl>, DECAYCD <lgl>, TREECLCD <int>, HTDMP <dbl>,
#> #   WDLDSTEM <lgl>, STDORGCD <int>, SITREE <int>, BALIVE <dbl>, VOLTSGRS <dbl>,
#> #   VOLTSGRS_BARK <dbl>, VOLTSSND <dbl>, VOLTSSND_BARK <dbl>,
#> #   VOLCFGRS_STUMP <dbl>, VOLCFGRS_STUMP_BARK <dbl>, VOLCFSND_STUMP <dbl>, …
#> 
#> $TREE_GRM_COMPONENT
#> # A tibble: 3,319 × 76
#>     TRE_CN PREV_TRE_CN  PLT_CN STATECD DIA_BEGIN DIA_MIDPT DIA_END
#>      <dbl>       <dbl>   <dbl>   <dbl>     <dbl>     <dbl>   <dbl>
#>  1 1.95e14    NA       2.47e14      44      6.7       6.95     7.2
#>  2 1.95e14    NA       2.47e14      44     10.4      10.8     11.1
#>  3 1.95e14    NA       2.47e14      44     13.2      13.7     14.2
#>  4 1.95e14    NA       2.47e14      44      2.95      3.08     3.2
#>  5 2.52e14     2.06e14 1.45e13      44     11.1      11.2     11.4
#>  6 2.52e14     2.06e14 1.45e13      44      2.4       2.4      2.4
#>  7 2.52e14     2.06e14 1.45e13      44      2.7       2.8      2.9
#>  8 2.52e14     2.06e14 1.45e13      44      5.5       5.5      5.5
#>  9 2.52e14     2.06e14 1.45e13      44     12.3      12.6     12.9
#> 10 2.52e14     2.06e14 1.45e13      44      6         6.3      6.6
#> # ℹ 3,309 more rows
#> # ℹ 69 more variables: ANN_DIA_GROWTH <dbl>, ANN_HT_GROWTH <dbl>,
#> #   SUBPTYP_BEGIN <lgl>, SUBPTYP_MIDPT <lgl>, SUBPTYP_END <lgl>,
#> #   MICR_COMPONENT_AL_FOREST <chr>, MICR_SUBPTYP_GRM_AL_FOREST <int>,
#> #   MICR_TPAGROW_UNADJ_AL_FOREST <dbl>, MICR_TPAREMV_UNADJ_AL_FOREST <dbl>,
#> #   MICR_TPAMORT_UNADJ_AL_FOREST <dbl>, SUBP_COMPONENT_AL_FOREST <chr>,
#> #   SUBP_SUBPTYP_GRM_AL_FOREST <int>, SUBP_TPAGROW_UNADJ_AL_FOREST <dbl>, …
#> 
#> $TREE_GRM_MIDPT
#> # A tibble: 3,080 × 66
#>     TRE_CN PREV_TRE_CN  PLT_CN STATECD SUBPTYP  SPCD STATUSCD   DIA    HT
#>      <dbl>       <dbl>   <dbl>   <int> <lgl>   <int>    <int> <dbl> <int>
#>  1 2.52e14     2.06e14 1.45e13      44 NA        372        1  6.65    61
#>  2 2.52e14     2.06e14 1.45e13      44 NA        372        1  4.2     36
#>  3 2.52e14     2.06e14 1.45e13      44 NA        372        1  4.8     40
#>  4 2.52e14     2.06e14 1.45e13      44 NA        372        1  5.75    62
#>  5 2.52e14     2.06e14 1.45e13      44 NA        372        1  5.75    53
#>  6 2.52e14     2.06e14 1.45e13      44 NA        833        1  7.55    58
#>  7 2.52e14     2.06e14 1.45e13      44 NA        832        1  8.1     48
#>  8 2.52e14     2.06e14 1.45e13      44 NA        832        1  6.1     43
#>  9 2.52e14     2.06e14 1.45e13      44 NA        806        1  7.35    49
#> 10 2.52e14     2.06e14 1.45e13      44 NA        806        1  7.5     42
#> # ℹ 3,070 more rows
#> # ℹ 57 more variables: ACTUALHT <int>, CR <int>, STANDING_DEAD_CD <int>,
#> #   DIAHTCD <int>, CULL <int>, ROUGHCULL <int>, CULLFORM <lgl>,
#> #   CULLMSTOP <lgl>, DECAYCD <lgl>, TREECLCD <int>, HTDMP <dbl>,
#> #   WDLDSTEM <lgl>, STDORGCD <int>, SITREE <int>, BALIVE <dbl>, VOLTSGRS <dbl>,
#> #   VOLTSGRS_BARK <dbl>, VOLTSSND <dbl>, VOLTSSND_BARK <dbl>,
#> #   VOLCFGRS_STUMP <dbl>, VOLCFGRS_STUMP_BARK <dbl>, VOLCFSND_STUMP <dbl>, …
#> 
#> $TREE
#> # A tibble: 8,284 × 194
#>         CN  PLT_CN PREV_TRE_CN INVYR STATECD UNITCD COUNTYCD  PLOT  SUBP  TREE
#>      <dbl>   <dbl>       <dbl> <int>   <int>  <int>    <int> <int> <int> <int>
#>  1 1.64e14 1.23e14          NA  2007      44      1        3   158     1    10
#>  2 1.64e14 1.23e14          NA  2007      44      1        3   158     1    22
#>  3 1.64e14 1.23e14          NA  2007      44      1        3   158     1    23
#>  4 1.64e14 1.23e14          NA  2007      44      1        3   158     1    24
#>  5 1.64e14 1.23e14          NA  2007      44      1        3   158     1    26
#>  6 1.64e14 1.23e14          NA  2007      44      1        3   158     1    28
#>  7 1.64e14 1.23e14          NA  2007      44      1        3   158     2     1
#>  8 1.64e14 1.23e14          NA  2007      44      1        3   158     2     2
#>  9 1.64e14 1.23e14          NA  2007      44      1        3   158     2     3
#> 10 1.64e14 1.23e14          NA  2007      44      1        3   158     2     4
#> # ℹ 8,274 more rows
#> # ℹ 184 more variables: CONDID <int>, PREVCOND <int>, STATUSCD <int>,
#> #   SPCD <dbl>, SPGRPCD <int>, DIA <dbl>, DIAHTCD <int>, HT <int>, HTCD <int>,
#> #   ACTUALHT <int>, TREECLCD <int>, CR <int>, CCLCD <int>, TREEGRCD <int>,
#> #   AGENTCD <int>, CULL <int>, DAMLOC1 <int>, DAMTYP1 <int>, DAMSEV1 <int>,
#> #   DAMLOC2 <int>, DAMTYP2 <int>, DAMSEV2 <int>, DECAYCD <int>, STOCKING <dbl>,
#> #   WDLDSTEM <lgl>, VOLCFNET <dbl>, VOLCFGRS <dbl>, VOLCSNET <dbl>, …
#> 
#> $mostRecent
#> # A tibble: 1 × 1
#>   value
#>   <lgl>
#> 1 TRUE 
#> 
#> 

# \donttest{
## Only plots w/in estimation units w/in a user defined polygon
clipFIA(fiaRI, mask = countiesRI[1,], mostRecent = FALSE)
#> ---- FIA Database Object ----- 
#> Reporting Years:  2013 2014 2015 2016 2017 2018 
#> States:           RHODE ISLAND 
#> Total Plots:      225 
#> Memory Used:      0.7 Mb 
#> Tables:           COND_DWM_CALC COND INVASIVE_SUBPLOT_SPP P2VEG_SUBP_STRUCTURE PLOT PLOTGEOM POP_ESTN_UNIT POP_EVAL_GRP POP_EVAL_TYP POP_EVAL POP_PLOT_STRATUM_ASSGN POP_STRATUM SEEDLING SUBP_COND_CHNG_MTRX SUBP_COND SUBPLOT SURVEY TREE_GRM_BEGIN TREE_GRM_COMPONENT TREE_GRM_MIDPT TREE mask 
#>  
#> $COND_DWM_CALC
#> # A tibble: 0 × 104
#> # ℹ 104 variables: CN <dbl>, STATECD <int>, COUNTYCD <int>, PLOT <dbl>,
#> #   MEASYEAR <int>, INVYR <int>, CONDID <int>, EVALID <int>, PLT_CN <dbl>,
#> #   CND_CN <dbl>, STRATUM_CN <dbl>, PHASE <lgl>, CONDPROP_CWD <dbl>,
#> #   CONDPROP_FWD_SM <dbl>, CONDPROP_FWD_MD <dbl>, CONDPROP_FWD_LG <dbl>,
#> #   CONDPROP_DUFF <dbl>, CWD_TL_COND <dbl>, CWD_TL_UNADJ <dbl>,
#> #   CWD_TL_ADJ <dbl>, CWD_LPA_COND <dbl>, CWD_LPA_UNADJ <dbl>,
#> #   CWD_LPA_ADJ <dbl>, CWD_VOLCF_COND <dbl>, CWD_VOLCF_UNADJ <dbl>, …
#> 
#> $COND
#> # A tibble: 28 × 151
#>         CN  PLT_CN INVYR STATECD UNITCD COUNTYCD  PLOT CONDID COND_STATUS_CD
#>      <dbl>   <dbl> <int>   <int>  <int>    <int> <int>  <int>          <int>
#>  1 6.23e13 6.23e13  2005      44      1        1   155      1              2
#>  2 1.64e14 1.64e14  2005      44      1        1   326      1              4
#>  3 7.43e13 7.43e13  2006      44      1        1   253      1              2
#>  4 1.64e14 1.64e14  2006      44      1        1   332      1              4
#>  5 1.64e14 1.23e14  2007      44      1        1    91      1              1
#>  6 1.64e14 1.23e14  2007      44      1        1   277      1              1
#>  7 1.64e14 1.23e14  2007      44      1        1   277      2              4
#>  8 2.06e14 1.20e14  2008      44      1        1   228      1              2
#>  9 2.06e14 1.20e14  2008      44      1        1   228      2              1
#> 10 2.25e14 1.45e14  2009      44      1        1   155      1              2
#> # ℹ 18 more rows
#> # ℹ 142 more variables: COND_NONSAMPLE_REASN_CD <int>, RESERVCD <int>,
#> #   OWNCD <int>, OWNGRPCD <int>, ADFORCD <lgl>, FORTYPCD <int>, FLDTYPCD <int>,
#> #   MAPDEN <int>, STDAGE <int>, STDSZCD <int>, FLDSZCD <int>, SITECLCD <int>,
#> #   SICOND <int>, SIBASE <int>, SISP <int>, STDORGCD <int>, STDORGSP <dbl>,
#> #   PROP_BASIS <chr>, CONDPROP_UNADJ <dbl>, MICRPROP_UNADJ <dbl>,
#> #   SUBPPROP_UNADJ <dbl>, MACRPROP_UNADJ <lgl>, SLOPE <int>, ASPECT <int>, …
#> 
#> $INVASIVE_SUBPLOT_SPP
#> # A tibble: 0 × 15
#> # ℹ 15 variables: CN <dbl>, PLT_CN <dbl>, INVYR <int>, STATECD <int>,
#> #   UNITCD <int>, COUNTYCD <int>, PLOT <dbl>, SUBP <dbl>, CONDID <int>,
#> #   VEG_FLDSPCD <chr>, UNIQUE_SP_NBR <int>, VEG_SPCD <chr>, COVER_PCT <int>,
#> #   CYCLE <int>, SUBCYCLE <int>
#> 
#> $P2VEG_SUBP_STRUCTURE
#> # A tibble: 0 × 14
#> # ℹ 14 variables: CN <dbl>, PLT_CN <dbl>, STATECD <int>, UNITCD <int>,
#> #   COUNTYCD <int>, PLOT <dbl>, INVYR <int>, SUBP <dbl>, CONDID <int>,
#> #   GROWTH_HABIT_CD <chr>, LAYER <int>, COVER_PCT <int>, CYCLE <int>,
#> #   SUBCYCLE <int>
#> 
#> $PLOT
#> # A tibble: 23 × 64
#>         CN  SRV_CN        CTY_CN PREV_PLT_CN INVYR STATECD UNITCD COUNTYCD  PLOT
#>      <dbl>   <dbl>         <dbl>       <dbl> <int>   <int>  <int>    <int> <int>
#>  1 1.45e14 1.45e14 1320609010538     6.23e13  2009      44      1        1   155
#>  2 1.45e14 1.45e14 1320609010538     1.64e14  2009      44      1        1   326
#>  3 1.69e14 1.69e14 1320609010538     7.43e13  2010      44      1        1   253
#>  4 1.69e14 1.69e14 1320609010538     1.64e14  2010      44      1        1   332
#>  5 2.21e14 2.21e14 1320609010538    NA        2011      44      1        1   333
#>  6 2.47e14 2.47e14 1320609010538     1.23e14  2012      44      1        1    91
#>  7 2.47e14 2.47e14 1320609010538     1.23e14  2012      44      1        1   277
#>  8 1.45e13 1.45e13 1320609010538     1.20e14  2013      44      1        1   228
#>  9 1.68e14 1.68e14 1320609010538     1.45e14  2014      44      1        1   155
#> 10 1.68e14 1.68e14 1320609010538     1.45e14  2014      44      1        1   326
#> # ℹ 13 more rows
#> # ℹ 55 more variables: PLOT_STATUS_CD <int>, PLOT_NONSAMPLE_REASN_CD <int>,
#> #   MEASYEAR <int>, MEASMON <int>, MEASDAY <int>, REMPER <dbl>, KINDCD <int>,
#> #   DESIGNCD <int>, RDDISTCD <int>, WATERCD <int>, LAT <dbl>, LON <dbl>,
#> #   ELEV <int>, GROW_TYP_CD <int>, MORT_TYP_CD <int>, P2PANEL <int>,
#> #   P3PANEL <int>, MANUAL <dbl>, KINDCD_NC <lgl>, QA_STATUS <int>,
#> #   MICROPLOT_LOC <chr>, DECLINATION <lgl>, SAMP_METHOD_CD <int>, …
#> 
#> $PLOTGEOM
#> # A tibble: 16 × 22
#>         CN STATECD INVYR UNITCD COUNTYCD  PLOT   LAT   LON CONGCD ECOSUBCD
#>      <dbl>   <dbl> <dbl>  <dbl>    <dbl> <dbl> <dbl> <dbl>  <dbl> <chr>   
#>  1 1.45e14      44  2009      1        1   155  41.7 -71.3   4401 221Ac   
#>  2 1.45e14      44  2009      1        1   326  41.7 -71.3   4401 221Ac   
#>  3 1.69e14      44  2010      1        1   253  41.7 -71.3   4401 221Ac   
#>  4 1.69e14      44  2010      1        1   332  41.7 -71.3   4401 221Ac   
#>  5 2.21e14      44  2011      1        1   333  41.7 -71.2   4401 221Ac   
#>  6 2.47e14      44  2012      1        1    91  41.8 -71.3   4401 221Ac   
#>  7 2.47e14      44  2012      1        1   277  41.7 -71.2   4401 221Ac   
#>  8 1.45e13      44  2013      1        1   228  41.7 -71.3   4401 221Ac   
#>  9 1.68e14      44  2014      1        1   155  41.7 -71.3   4401 221Ac   
#> 10 1.68e14      44  2014      1        1   326  41.7 -71.3   4401 221Ac   
#> 11 3.05e14      44  2016      1        1   253  41.7 -71.3   4401 221Ac   
#> 12 3.05e14      44  2016      1        1   332  41.7 -71.3   4401 221Ac   
#> 13 3.74e14      44  2017      1        1   333  41.7 -71.2   4401 221Ac   
#> 14 4.46e14      44  2018      1        1    91  41.8 -71.3   4401 221Ac   
#> 15 4.46e14      44  2018      1        1   277  41.7 -71.2   4401 221Ac   
#> 16 4.46e14      44  2018      1        1  9233  41.7 -71.3   4401 221Ac   
#> # ℹ 12 more variables: HUC <dbl>, EMAP_HEX <dbl>, FIPSCOUNTY <dbl>,
#> #   ROADLESSCD <lgl>, ALP_ADFORCD <lgl>, FVS_VARIANT <chr>, FVS_LOC_CD <int>,
#> #   FVS_REGION <int>, FVS_FOREST <int>, FVS_DISTRICT <lgl>, ECO_UNIT_PNW <lgl>,
#> #   PRECIPITATION <lgl>
#> 
#> $POP_ESTN_UNIT
#> # A tibble: 78 × 15
#>         CN EVAL_CN  RSCD EVALID ESTN_UNIT ESTN_UNIT_DESCR    STATECD AREALAND_EU
#>      <dbl>   <dbl> <int>  <int>     <int> <chr>                <int>       <dbl>
#>  1 2.63e14 2.63e14    24 441300         1 Inland Census Wat…      44          NA
#>  2 2.63e14 2.63e14    24 441300         2 Private Unit 1          44          NA
#>  3 2.63e14 2.63e14    24 441300         3 Public Unit 1           44          NA
#>  4 2.63e14 2.63e14    24 441301         1 Inland Census Wat…      44          NA
#>  5 2.63e14 2.63e14    24 441301         2 Private Unit 1          44          NA
#>  6 2.63e14 2.63e14    24 441301         3 Public Unit 1           44          NA
#>  7 2.63e14 2.63e14    24 441303         1 Inland Census Wat…      44          NA
#>  8 2.63e14 2.63e14    24 441303         2 Private Unit 1          44          NA
#>  9 2.63e14 2.63e14    24 441303         3 Public Unit 1           44          NA
#> 10 3.10e14 3.10e14    24 441400         1 Inland Census Wat…      44          NA
#> # ℹ 68 more rows
#> # ℹ 7 more variables: AREATOT_EU <dbl>, AREA_USED <dbl>, AREA_SOURCE <chr>,
#> #   P1PNTCNT_EU <int>, P1SOURCE <chr>, p2eu <int>, nStrata <int>
#> 
#> $POP_EVAL_GRP
#> # A tibble: 6 × 6
#>        CN  RSCD EVAL_GRP EVAL_GRP_DESCR                            STATECD NOTES
#>     <dbl> <int>    <int> <chr>                                       <int> <chr>
#> 1 2.63e14    24   442013 RHODE ISLAND 2013: ALL AREA, CURRENT ARE…      44 Rhod…
#> 2 3.10e14    24   442014 RHODE ISLAND 2014: ALL AREA, CURRENT ARE…      44 RI 2…
#> 3 3.73e14    24   442015 RHODE ISLAND 2015: ALL AREA, CURRENT ARE…      44 RI: …
#> 4 4.68e14    24   442016 RHODE ISLAND 2016: ALL AREA, CURRENT ARE…      44 RI: …
#> 5 5.33e14    24   442017 RHODE ISLAND 2017: ALL AREA, CURRENT ARE…      44 RI:2…
#> 6 6.68e14    24   442018 RHODE ISLAND 2018: ALL AREA, CURRENT ARE…      44 RI: …
#> 
#> $POP_EVAL_TYP
#> # A tibble: 42 × 4
#>         CN EVAL_GRP_CN EVAL_CN EVAL_TYP
#>      <dbl>       <dbl>   <dbl> <chr>   
#>  1 2.63e14     2.63e14 2.63e14 EXPALL  
#>  2 2.63e14     2.63e14 2.63e14 EXPCURR 
#>  3 2.63e14     2.63e14 2.63e14 EXPVOL  
#>  4 2.63e14     2.63e14 2.63e14 EXPGROW 
#>  5 2.63e14     2.63e14 2.63e14 EXPMORT 
#>  6 2.63e14     2.63e14 2.63e14 EXPREMV 
#>  7 2.63e14     2.63e14 2.63e14 EXPCHNG 
#>  8 3.10e14     3.10e14 3.10e14 EXPALL  
#>  9 3.10e14     3.10e14 3.10e14 EXPCURR 
#> 10 3.10e14     3.10e14 3.10e14 EXPVOL  
#> # ℹ 32 more rows
#> 
#> $POP_EVAL
#> # A tibble: 18 × 15
#>         CN EVAL_GRP_CN  RSCD EVALID EVAL_DESCR               STATECD LOCATION_NM
#>      <dbl>       <dbl> <int>  <int> <chr>                      <int> <chr>      
#>  1 4.68e14     4.68e14    24 441601 RHODE ISLAND 2016: 2011…      44 Rhode Isla…
#>  2 4.68e14     4.68e14    24 441603 RHODE ISLAND 2016: 2006…      44 Rhode Isla…
#>  3 5.33e14     5.33e14    24 441700 RHODE ISLAND 2017: 2011…      44 Rhode Isla…
#>  4 5.33e14     5.33e14    24 441701 RHODE ISLAND 2017: 2011…      44 Rhode Isla…
#>  5 5.33e14     5.33e14    24 441703 RHODE ISLAND 2017: 2007…      44 Rhode Isla…
#>  6 6.68e14     6.68e14    24 441801 RHODE ISLAND 2018: 2012…      44 Rhode Isla…
#>  7 6.68e14     6.68e14    24 441803 RHODE ISLAND 2018: 2007…      44 Rhode Isla…
#>  8 6.68e14     6.68e14    24 441800 RHODE ISLAND 2018: 2012…      44 Rhode Isla…
#>  9 2.63e14     2.63e14    24 441300 RHODE ISLAND 2013: 2009…      44 Rhode Isla…
#> 10 2.63e14     2.63e14    24 441301 RHODE ISLAND 2013: 2009…      44 Rhode Isla…
#> 11 2.63e14     2.63e14    24 441303 RHODE ISLAND 2013: 2004…      44 Rhode Isla…
#> 12 3.10e14     3.10e14    24 441400 RHODE ISLAND 2014: 2009…      44 Rhode Isla…
#> 13 3.10e14     3.10e14    24 441401 RHODE ISLAND 2014: 2009…      44 Rhode Isla…
#> 14 3.10e14     3.10e14    24 441403 RHODE ISLAND 2014: 2004…      44 Rhode Isla…
#> 15 3.73e14     3.73e14    24 441500 RHODE ISLAND 2015: 2010…      44 Rhode Isla…
#> 16 3.73e14     3.73e14    24 441501 RHODE ISLAND 2015: 2010…      44 Rhode Isla…
#> 17 3.73e14     3.73e14    24 441503 RHODE ISLAND 2015: 2005…      44 Rhode Isla…
#> 18 4.68e14     4.68e14    24 441600 RHODE ISLAND 2016: 2011…      44 Rhode Isla…
#> # ℹ 8 more variables: REPORT_YEAR_NM <chr>, START_INVYR <int>, END_INVYR <dbl>,
#> #   LAND_ONLY <chr>, TIMBERLAND_ONLY <chr>, GROWTH_ACCT <chr>,
#> #   ESTN_METHOD <chr>, NOTES <lgl>
#> 
#> $POP_PLOT_STRATUM_ASSGN
#> # A tibble: 142 × 15
#>    CN        STRATUM_CN  PLT_CN STATECD INVYR UNITCD COUNTYCD  PLOT  RSCD EVALID
#>    <chr>          <dbl>   <dbl>   <int> <int>  <int>    <int> <int> <int>  <int>
#>  1 26333517…    2.63e14 2.47e14      44  2012      1        1    91    24 441300
#>  2 26333517…    2.63e14 1.45e14      44  2009      1        1   155    24 441300
#>  3 26333517…    2.63e14 1.45e13      44  2013      1        1   228    24 441300
#>  4 26333517…    2.63e14 1.69e14      44  2010      1        1   253    24 441300
#>  5 26333517…    2.63e14 2.47e14      44  2012      1        1   277    24 441300
#>  6 26333517…    2.63e14 1.45e14      44  2009      1        1   326    24 441300
#>  7 26333517…    2.63e14 1.69e14      44  2010      1        1   332    24 441300
#>  8 26333658…    2.63e14 2.21e14      44  2011      1        1   333    24 441300
#>  9 26333684…    2.63e14 2.47e14      44  2012      1        1    91    24 441301
#> 10 26333684…    2.63e14 1.45e14      44  2009      1        1   155    24 441301
#> # ℹ 132 more rows
#> # ℹ 5 more variables: ESTN_UNIT <int>, STRATUMCD <int>, p2eu_INVYR <int>,
#> #   nStrata_INVYR <int>, P2POINTCNT_INVYR <int>
#> 
#> $POP_STRATUM
#> # A tibble: 150 × 24
#>         CN ESTN_UNIT_CN  RSCD EVALID ESTN_UNIT STRATUMCD STRATUM_DESCR   STATECD
#>      <dbl>        <dbl> <int>  <int>     <int>     <int> <chr>             <int>
#>  1 2.63e14      2.63e14    24 441301         1     12345 Canopy cover 0…      44
#>  2 2.63e14      2.63e14    24 441301         2         1 Canopy cover 0…      44
#>  3 2.63e14      2.63e14    24 441301         2         2 Canopy cover 6…      44
#>  4 2.63e14      2.63e14    24 441301         2         3 Canopy cover 5…      44
#>  5 2.63e14      2.63e14    24 441301         2         4 Canopy cover 6…      44
#>  6 2.63e14      2.63e14    24 441301         2         5 Canopy cover 8…      44
#>  7 2.63e14      2.63e14    24 441301         3         5 Canopy cover 8…      44
#>  8 2.63e14      2.63e14    24 441301         3      1234 Canopy cover 0…      44
#>  9 2.63e14      2.63e14    24 441303         1     12345 Canopy cover 0…      44
#> 10 2.63e14      2.63e14    24 441303         2         1 Canopy cover 0…      44
#> # ℹ 140 more rows
#> # ℹ 16 more variables: P1POINTCNT <int>, P2POINTCNT <int>, EXPNS <dbl>,
#> #   ADJ_FACTOR_MACR <dbl>, ADJ_FACTOR_SUBP <dbl>, ADJ_FACTOR_MICR <dbl>,
#> #   ADJ_FACTOR_CWD <dbl>, ADJ_FACTOR_FWD_SM <dbl>, ADJ_FACTOR_FWD_LG <dbl>,
#> #   ADJ_FACTOR_DUFF <dbl>, ADJ_FACTOR_PILE <dbl>, ADJ_FACTOR_REGEN_MICR <dbl>,
#> #   ADJ_FACTOR_INV_SUBP <dbl>, ADJ_FACTOR_P2VEG_SUBP <dbl>,
#> #   ADJ_FACTOR_GRNDLYR_MICROQUAD <lgl>, ADJ_FACTOR_SOIL <lgl>
#> 
#> $SEEDLING
#> # A tibble: 13 × 26
#>         CN  PLT_CN INVYR STATECD UNITCD COUNTYCD  PLOT  SUBP CONDID  SPCD
#>      <dbl>   <dbl> <int>   <int>  <int>    <int> <int> <int>  <int> <dbl>
#>  1 1.95e14 2.47e14  2012      44      1        1    91     3      1   762
#>  2 1.95e14 2.47e14  2012      44      1        1   277     4      1    68
#>  3 1.95e14 2.47e14  2012      44      1        1   277     4      1   762
#>  4 2.52e14 1.45e13  2013      44      1        1   228     1      1   316
#>  5 2.52e14 1.45e13  2013      44      1        1   228     1      1   693
#>  6 2.52e14 1.45e13  2013      44      1        1   228     1      1   762
#>  7 2.52e14 1.45e13  2013      44      1        1   228     1      1   931
#>  8 2.52e14 1.45e13  2013      44      1        1   228     4      1   762
#>  9 2.52e14 1.45e13  2013      44      1        1   228     4      1   802
#> 10 2.52e14 1.45e13  2013      44      1        1   228     4      1   931
#> 11 6.38e14 4.46e14  2018      44      1        1    91     2      1   931
#> 12 6.38e14 4.46e14  2018      44      1        1    91     3      1   931
#> 13 6.38e14 4.46e14  2018      44      1        1   277     4      1   762
#> # ℹ 16 more variables: SPGRPCD <int>, STOCKING <dbl>, TREECOUNT <int>,
#> #   TOTAGE <lgl>, TREECOUNT_CALC <dbl>, TPA_UNADJ <dbl>, CYCLE <int>,
#> #   SUBCYCLE <int>, DAMAGE_AGENT_CD1_SRS <lgl>,
#> #   PCT_AFFECTED_DAMAGE_AGENT1_SRS <lgl>, DAMAGE_AGENT_CD2_SRS <lgl>,
#> #   PCT_AFFECTED_DAMAGE_AGENT2_SRS <lgl>, DAMAGE_AGENT_CD3_SRS <lgl>,
#> #   PCT_AFFECTED_DAMAGE_AGENT3_SRS <lgl>, AGECD_RMRS <lgl>,
#> #   COUNTCHKCD_RMRS <lgl>
#> 
#> $SUBP_COND_CHNG_MTRX
#> # A tibble: 118 × 9
#>         CN STATECD  SUBP SUBPTYP  PLT_CN CONDID PREV_PLT_CN PREVCOND
#>      <dbl>   <int> <int>   <int>   <dbl>  <int>       <dbl>    <int>
#>  1 1.82e15      44     1       1 1.45e14      1     1.64e14        1
#>  2 1.82e15      44     2       1 1.45e14      1     1.64e14        1
#>  3 1.82e15      44     3       1 1.45e14      1     1.64e14        1
#>  4 1.82e15      44     4       1 1.45e14      1     1.64e14        1
#>  5 1.82e15      44     1       2 1.45e14      1     1.64e14        1
#>  6 1.82e15      44     2       2 1.45e14      1     1.64e14        1
#>  7 1.82e15      44     3       2 1.45e14      1     1.64e14        1
#>  8 1.82e15      44     4       2 1.45e14      1     1.64e14        1
#>  9 1.82e15      44     1       1 3.74e14      1     2.21e14        1
#> 10 1.82e15      44     2       1 3.74e14      1     2.21e14        1
#> # ℹ 108 more rows
#> # ℹ 1 more variable: SUBPTYP_PROP_CHNG <dbl>
#> 
#> $SUBP_COND
#> # A tibble: 68 × 16
#>         CN  PLT_CN INVYR STATECD UNITCD COUNTYCD  PLOT  SUBP CONDID
#>      <dbl>   <dbl> <int>   <int>  <int>    <int> <int> <int>  <int>
#>  1 2.26e14 1.45e14  2009      44      1        1   155     4      1
#>  2 2.26e14 1.45e14  2009      44      1        1   155     1      1
#>  3 2.26e14 1.45e14  2009      44      1        1   155     2      1
#>  4 2.26e14 1.45e14  2009      44      1        1   155     3      1
#>  5 2.26e14 1.45e14  2009      44      1        1   326     1      1
#>  6 2.26e14 1.45e14  2009      44      1        1   326     2      1
#>  7 2.26e14 1.45e14  2009      44      1        1   326     3      1
#>  8 2.26e14 1.45e14  2009      44      1        1   326     4      1
#>  9 2.45e14 1.69e14  2010      44      1        1   253     1      1
#> 10 2.45e14 1.69e14  2010      44      1        1   253     2      1
#> # ℹ 58 more rows
#> # ℹ 7 more variables: MICRCOND_PROP <dbl>, SUBPCOND_PROP <dbl>,
#> #   MACRCOND_PROP <lgl>, NONFR_INCL_PCT_SUBP <lgl>, NONFR_INCL_PCT_MACRO <lgl>,
#> #   CYCLE <int>, SUBCYCLE <int>
#> 
#> $SUBPLOT
#> # A tibble: 64 × 46
#>         CN  PLT_CN PREV_SBP_CN INVYR STATECD UNITCD COUNTYCD  PLOT  SUBP
#>      <dbl>   <dbl> <lgl>       <int>   <int>  <int>    <int> <int> <int>
#>  1 2.25e14 1.45e14 NA           2009      44      1        1   155     1
#>  2 2.25e14 1.45e14 NA           2009      44      1        1   155     2
#>  3 2.25e14 1.45e14 NA           2009      44      1        1   155     3
#>  4 2.25e14 1.45e14 NA           2009      44      1        1   155     4
#>  5 2.25e14 1.45e14 NA           2009      44      1        1   326     1
#>  6 2.25e14 1.45e14 NA           2009      44      1        1   326     2
#>  7 2.25e14 1.45e14 NA           2009      44      1        1   326     3
#>  8 2.25e14 1.45e14 NA           2009      44      1        1   326     4
#>  9 2.45e14 1.69e14 NA           2010      44      1        1   253     1
#> 10 2.45e14 1.69e14 NA           2010      44      1        1   253     2
#> # ℹ 54 more rows
#> # ℹ 37 more variables: SUBP_STATUS_CD <int>, POINT_NONSAMPLE_REASN_CD <int>,
#> #   MICRCOND <int>, SUBPCOND <int>, MACRCOND <lgl>, CONDLIST <int>,
#> #   SLOPE <int>, ASPECT <int>, WATERDEP <dbl>, P2A_GRM_FLG <chr>, CYCLE <int>,
#> #   SUBCYCLE <int>, ROOT_DIS_SEV_CD_PNWRS <lgl>, NF_SUBP_STATUS_CD <lgl>,
#> #   NF_SUBP_NONSAMPLE_REASN_CD <lgl>, P2VEG_SUBP_STATUS_CD <int>,
#> #   P2VEG_SUBP_NONSAMPLE_REASN_CD <int>, INVASIVE_SUBP_STATUS_CD <int>, …
#> 
#> $SURVEY
#> # A tibble: 42 × 12
#>         CN INVYR P3_OZONE_IND STATECD STATEAB STATENM   RSCD ANN_INVENTORY NOTES
#>      <dbl> <int> <chr>          <int> <chr>   <chr>    <int> <chr>         <chr>
#>  1 1.59e14  1997 Y                 44 RI      Rhode I…    24 Y             "Ozo…
#>  2 1.59e14  1994 Y                 44 RI      Rhode I…    24 Y             "Ozo…
#>  3 5.59e13  2003 N                 44 RI      Rhode I…    24 Y             "Cyc…
#>  4 6.23e13  2005 N                 44 RI      Rhode I…    24 Y             "Ann…
#>  5 5.59e13  2004 N                 44 RI      Rhode I…    24 Y             "Cyc…
#>  6 7.43e13  2006 N                 44 RI      Rhode I…    24 Y             "Ann…
#>  7 1.21e14  2007 N                 44 RI      Rhode I…    24 Y             "Ann…
#>  8 1.20e14  2008 N                 44 RI      Rhode I…    24 Y             "Ann…
#>  9 1.45e14  2009 N                 44 RI      Rhode I…    24 Y             "Ann…
#> 10 1.69e14  2010 N                 44 RI      Rhode I…    24 Y             "Ann…
#> # ℹ 32 more rows
#> # ℹ 3 more variables: CYCLE <int>, SUBCYCLE <int>, PRJ_CN <dbl>
#> 
#> $TREE_GRM_BEGIN
#> # A tibble: 121 × 66
#>     TRE_CN PREV_TRE_CN  PLT_CN STATECD SUBPTYP  SPCD STATUSCD   DIA    HT
#>      <dbl>       <dbl>   <dbl>   <int> <lgl>   <int>    <int> <dbl> <int>
#>  1 1.95e14     1.64e14 2.47e14      44 NA        837        1   8.6    54
#>  2 1.95e14     1.64e14 2.47e14      44 NA        837        1   6.8    52
#>  3 1.95e14     1.64e14 2.47e14      44 NA        837        1   8      48
#>  4 1.95e14     1.64e14 2.47e14      44 NA        837        1  10.2    54
#>  5 1.95e14     1.64e14 2.47e14      44 NA        837        1   5.7    38
#>  6 1.95e14     1.64e14 2.47e14      44 NA        837        1  14.5    58
#>  7 1.95e14     1.64e14 2.47e14      44 NA        837        1  14.9    57
#>  8 1.95e14     1.64e14 2.47e14      44 NA        837        1  10.5    64
#>  9 1.95e14     1.64e14 2.47e14      44 NA        837        1  12.3    67
#> 10 1.95e14     1.64e14 2.47e14      44 NA         68        1   2      17
#> # ℹ 111 more rows
#> # ℹ 57 more variables: ACTUALHT <int>, CR <int>, STANDING_DEAD_CD <int>,
#> #   DIAHTCD <int>, CULL <int>, ROUGHCULL <int>, CULLFORM <lgl>,
#> #   CULLMSTOP <lgl>, DECAYCD <lgl>, TREECLCD <int>, HTDMP <dbl>,
#> #   WDLDSTEM <lgl>, STDORGCD <int>, SITREE <int>, BALIVE <dbl>, VOLTSGRS <dbl>,
#> #   VOLTSGRS_BARK <dbl>, VOLTSSND <dbl>, VOLTSSND_BARK <dbl>,
#> #   VOLCFGRS_STUMP <dbl>, VOLCFGRS_STUMP_BARK <dbl>, VOLCFSND_STUMP <dbl>, …
#> 
#> $TREE_GRM_COMPONENT
#> # A tibble: 136 × 76
#>     TRE_CN PREV_TRE_CN  PLT_CN STATECD DIA_BEGIN DIA_MIDPT DIA_END
#>      <dbl>       <dbl>   <dbl>   <dbl>     <dbl>     <dbl>   <dbl>
#>  1 1.95e14     1.64e14 2.47e14      44      16.9     17.4     17.8
#>  2 1.95e14     1.64e14 2.47e14      44       8.6      8.8      9  
#>  3 1.95e14     1.64e14 2.47e14      44       8        8.15     8.3
#>  4 1.95e14     1.64e14 2.47e14      44       7.6      7.75     7.9
#>  5 1.95e14     1.64e14 2.47e14      44       6.2      6.25     6.3
#>  6 1.95e14     1.64e14 2.47e14      44      16.1     16.4     16.7
#>  7 1.95e14     1.64e14 2.47e14      44       7.4      7.4      7.4
#>  8 1.95e14     1.64e14 2.47e14      44      15.3     15.8     16.2
#>  9 1.95e14     1.64e14 2.47e14      44       5.7      6        6.3
#> 10 1.95e14     1.64e14 2.47e14      44      10.5     10.8     11.2
#> # ℹ 126 more rows
#> # ℹ 69 more variables: ANN_DIA_GROWTH <dbl>, ANN_HT_GROWTH <dbl>,
#> #   SUBPTYP_BEGIN <lgl>, SUBPTYP_MIDPT <lgl>, SUBPTYP_END <lgl>,
#> #   MICR_COMPONENT_AL_FOREST <chr>, MICR_SUBPTYP_GRM_AL_FOREST <int>,
#> #   MICR_TPAGROW_UNADJ_AL_FOREST <dbl>, MICR_TPAREMV_UNADJ_AL_FOREST <dbl>,
#> #   MICR_TPAMORT_UNADJ_AL_FOREST <dbl>, SUBP_COMPONENT_AL_FOREST <chr>,
#> #   SUBP_SUBPTYP_GRM_AL_FOREST <int>, SUBP_TPAGROW_UNADJ_AL_FOREST <dbl>, …
#> 
#> $TREE_GRM_MIDPT
#> # A tibble: 121 × 66
#>     TRE_CN PREV_TRE_CN  PLT_CN STATECD SUBPTYP  SPCD STATUSCD   DIA    HT
#>      <dbl>       <dbl>   <dbl>   <int> <lgl>   <int>    <int> <dbl> <int>
#>  1 2.52e14     2.06e14 1.45e13      44 NA        372        1  6.65    61
#>  2 2.52e14     2.06e14 1.45e13      44 NA        372        1  4.2     36
#>  3 2.52e14     2.06e14 1.45e13      44 NA        372        1  4.8     40
#>  4 2.52e14     2.06e14 1.45e13      44 NA        372        1  5.75    62
#>  5 2.52e14     2.06e14 1.45e13      44 NA        372        1  5.75    53
#>  6 2.52e14     2.06e14 1.45e13      44 NA        833        1  7.55    58
#>  7 1.95e14     1.64e14 2.47e14      44 NA        833        1 24.2     86
#>  8 1.95e14     1.64e14 2.47e14      44 NA        316        1 10.2     59
#>  9 1.95e14     1.64e14 2.47e14      44 NA        837        1  8.8     58
#> 10 1.95e14     1.64e14 2.47e14      44 NA        837        1  6.85    53
#> # ℹ 111 more rows
#> # ℹ 57 more variables: ACTUALHT <int>, CR <int>, STANDING_DEAD_CD <int>,
#> #   DIAHTCD <int>, CULL <int>, ROUGHCULL <int>, CULLFORM <lgl>,
#> #   CULLMSTOP <lgl>, DECAYCD <lgl>, TREECLCD <int>, HTDMP <dbl>,
#> #   WDLDSTEM <lgl>, STDORGCD <int>, SITREE <int>, BALIVE <dbl>, VOLTSGRS <dbl>,
#> #   VOLTSGRS_BARK <dbl>, VOLTSSND <dbl>, VOLTSSND_BARK <dbl>,
#> #   VOLCFGRS_STUMP <dbl>, VOLCFGRS_STUMP_BARK <dbl>, VOLCFSND_STUMP <dbl>, …
#> 
#> $TREE
#> # A tibble: 226 × 194
#>         CN  PLT_CN PREV_TRE_CN INVYR STATECD UNITCD COUNTYCD  PLOT  SUBP  TREE
#>      <dbl>   <dbl>       <dbl> <int>   <int>  <int>    <int> <int> <int> <int>
#>  1 1.64e14 1.23e14          NA  2007      44      1        1    91     1     3
#>  2 1.64e14 1.23e14          NA  2007      44      1        1    91     1     4
#>  3 1.64e14 1.23e14          NA  2007      44      1        1    91     1     5
#>  4 1.64e14 1.23e14          NA  2007      44      1        1    91     1    14
#>  5 1.64e14 1.23e14          NA  2007      44      1        1    91     1    20
#>  6 1.64e14 1.23e14          NA  2007      44      1        1    91     1    22
#>  7 1.64e14 1.23e14          NA  2007      44      1        1    91     1    29
#>  8 1.64e14 1.23e14          NA  2007      44      1        1    91     1    31
#>  9 1.64e14 1.23e14          NA  2007      44      1        1    91     1    32
#> 10 1.64e14 1.23e14          NA  2007      44      1        1    91     1    33
#> # ℹ 216 more rows
#> # ℹ 184 more variables: CONDID <int>, PREVCOND <int>, STATUSCD <int>,
#> #   SPCD <dbl>, SPGRPCD <int>, DIA <dbl>, DIAHTCD <int>, HT <int>, HTCD <int>,
#> #   ACTUALHT <int>, TREECLCD <int>, CR <int>, CCLCD <int>, TREEGRCD <int>,
#> #   AGENTCD <int>, CULL <int>, DAMLOC1 <int>, DAMTYP1 <int>, DAMSEV1 <int>,
#> #   DAMLOC2 <int>, DAMTYP2 <int>, DAMSEV2 <int>, DECAYCD <int>, STOCKING <dbl>,
#> #   WDLDSTEM <lgl>, VOLCFNET <dbl>, VOLCFGRS <dbl>, VOLCSNET <dbl>, …
#> 
#> $mask
#> # A tibble: 1 × 1
#>   value
#>   <lgl>
#> 1 TRUE 
#> 
#> 
# }
```
