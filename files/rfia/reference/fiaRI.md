# FIADB for Rhode Island 2013 - 2018

Subset of the Forest Inventory and Analysis Database for the state of
Rhode Island. Reporting years range from 2013 - 2018. Specify `fiaRI` as
the `db` argument in any `rFIA` function to produce estimates for the
state of Rhode Island. NOTE: the fiaRI object was updated in v1.1.0 to
reflect changes in the FIA Database that took place since creation of
the original object.

Download other subsets of the FIA Database from the FIA Datamart:
<https://apps.fs.usda.gov/fia/datamart/datamart.html>. Once downloaded,
unzip the directory, and read into R using [`readFIA`](readFIA.md).

## Usage

``` r
data("fiaRI")
```

## Format

—- FIA Database Object —– Reporting Years: 2013 2014 2015 2016 2017 2018
States: RHODE ISLAND Total Plots: 769 Memory Used: 20.1 Mb Tables:
COND_DWM_CALC COND INVASIVE_SUBPLOT_SPP P2VEG_SUBP_STRUCTURE PLOT
PLOTGEOM POP_ESTN_UNIT POP_EVAL_GRP POP_EVAL_TYP POP_EVAL
POP_PLOT_STRATUM_ASSGN POP_STRATUM SEEDLING SUBP_COND_CHNG_MTRX
SUBP_COND SUBPLOT SURVEY TREE_GRM_BEGIN TREE_GRM_COMPONENT
TREE_GRM_MIDPT TREE

## Examples

``` r
data(fiaRI)
summary(fiaRI)
#> ---- FIA Database Object ----- 
#> Reporting Years:  2013 2014 2015 2016 2017 2018 
#> States:           RHODE ISLAND 
#> Total Plots:      225 
#> Memory Used:      20 Mb 
#> Tables:           COND_DWM_CALC COND INVASIVE_SUBPLOT_SPP P2VEG_SUBP_STRUCTURE PLOT PLOTGEOM POP_ESTN_UNIT POP_EVAL_GRP POP_EVAL_TYP POP_EVAL POP_PLOT_STRATUM_ASSGN POP_STRATUM SEEDLING SUBP_COND_CHNG_MTRX SUBP_COND SUBPLOT SURVEY TREE_GRM_BEGIN TREE_GRM_COMPONENT TREE_GRM_MIDPT TREE 
print(fiaRI)
#> ---- FIA Database Object ----- 
#> Reporting Years:  2013 2014 2015 2016 2017 2018 
#> States:           RHODE ISLAND 
#> Total Plots:      225 
#> Memory Used:      20 Mb 
#> Tables:           COND_DWM_CALC COND INVASIVE_SUBPLOT_SPP P2VEG_SUBP_STRUCTURE PLOT PLOTGEOM POP_ESTN_UNIT POP_EVAL_GRP POP_EVAL_TYP POP_EVAL POP_PLOT_STRATUM_ASSGN POP_STRATUM SEEDLING SUBP_COND_CHNG_MTRX SUBP_COND SUBPLOT SURVEY TREE_GRM_BEGIN TREE_GRM_COMPONENT TREE_GRM_MIDPT TREE 
#>  
#> $COND_DWM_CALC
#> # A tibble: 124 × 104
#>         CN STATECD COUNTYCD  PLOT MEASYEAR INVYR CONDID EVALID  PLT_CN  CND_CN
#>      <dbl>   <int>    <int> <dbl>    <int> <int>  <int>  <int>   <dbl>   <dbl>
#>  1 1.76e15      44        5   302     2009  2009      1 441007 1.45e14 2.25e14
#>  2 1.76e15      44        7   113     2009  2009      1 441007 1.45e14 2.25e14
#>  3 1.76e15      44        3   335     2010  2010      1 441007 1.69e14 2.45e14
#>  4 1.76e15      44        7    47     2010  2010      1 441007 1.69e14 2.45e14
#>  5 1.76e15      44        3   231     2012  2012      1 441507 2.47e14 1.95e14
#>  6 1.76e15      44        3   231     2012  2012      1 441607 2.47e14 1.95e14
#>  7 1.76e15      44        3   231     2012  2012      1 441707 2.47e14 1.95e14
#>  8 1.76e15      44        9   239     2012  2012      1 441507 2.47e14 1.95e14
#>  9 1.76e15      44        9   239     2012  2012      1 441607 2.47e14 1.95e14
#> 10 1.76e15      44        9   239     2012  2012      1 441707 2.47e14 1.95e14
#> # ℹ 114 more rows
#> # ℹ 94 more variables: STRATUM_CN <dbl>, PHASE <lgl>, CONDPROP_CWD <dbl>,
#> #   CONDPROP_FWD_SM <dbl>, CONDPROP_FWD_MD <dbl>, CONDPROP_FWD_LG <dbl>,
#> #   CONDPROP_DUFF <dbl>, CWD_TL_COND <dbl>, CWD_TL_UNADJ <dbl>,
#> #   CWD_TL_ADJ <dbl>, CWD_LPA_COND <dbl>, CWD_LPA_UNADJ <dbl>,
#> #   CWD_LPA_ADJ <dbl>, CWD_VOLCF_COND <dbl>, CWD_VOLCF_UNADJ <dbl>,
#> #   CWD_VOLCF_ADJ <dbl>, CWD_DRYBIO_COND <dbl>, CWD_DRYBIO_UNADJ <dbl>, …
#> 
#> $COND
#> # A tibble: 908 × 151
#>         CN  PLT_CN INVYR STATECD UNITCD COUNTYCD  PLOT CONDID COND_STATUS_CD
#>      <dbl>   <dbl> <int>   <int>  <int>    <int> <int>  <int>          <int>
#>  1 6.22e13 5.59e13  2004      44      1        3    52      1              1
#>  2 6.22e13 5.59e13  2004      44      1        3    52      2              1
#>  3 6.22e13 5.59e13  2004      44      1        3    55      1              2
#>  4 6.22e13 5.59e13  2004      44      1        3   129      1              1
#>  5 6.22e13 5.59e13  2004      44      1        3   152      1              2
#>  6 6.22e13 5.59e13  2004      44      1        5   130      1              2
#>  7 6.22e13 5.59e13  2004      44      1        5   130      2              2
#>  8 6.22e13 5.59e13  2004      44      1        5   302      1              2
#>  9 1.64e14 1.64e14  2004      44      1        5   355      1              4
#> 10 6.22e13 5.59e13  2004      44      1        7   100      1              2
#> # ℹ 898 more rows
#> # ℹ 142 more variables: COND_NONSAMPLE_REASN_CD <int>, RESERVCD <int>,
#> #   OWNCD <int>, OWNGRPCD <int>, ADFORCD <lgl>, FORTYPCD <int>, FLDTYPCD <int>,
#> #   MAPDEN <int>, STDAGE <int>, STDSZCD <int>, FLDSZCD <int>, SITECLCD <int>,
#> #   SICOND <int>, SIBASE <int>, SISP <int>, STDORGCD <int>, STDORGSP <dbl>,
#> #   PROP_BASIS <chr>, CONDPROP_UNADJ <dbl>, MICRPROP_UNADJ <dbl>,
#> #   SUBPPROP_UNADJ <dbl>, MACRPROP_UNADJ <lgl>, SLOPE <int>, ASPECT <int>, …
#> 
#> $INVASIVE_SUBPLOT_SPP
#> # A tibble: 42 × 15
#>         CN  PLT_CN INVYR STATECD UNITCD COUNTYCD  PLOT  SUBP CONDID VEG_FLDSPCD
#>      <dbl>   <dbl> <int>   <int>  <int>    <int> <dbl> <dbl>  <int> <chr>      
#>  1 2.26e14 1.45e14  2009      44      1        9   240     3      1 ELUM       
#>  2 2.26e14 1.45e14  2009      44      1        9   240     3      1 ROMU       
#>  3 2.26e14 1.45e14  2009      44      1        7    29     3      1 CEOR7      
#>  4 2.26e14 1.45e14  2009      44      1        7   113     1      1 ROMU       
#>  5 2.26e14 1.45e14  2009      44      1        7    72     1      1 FRAL4      
#>  6 2.26e14 1.45e14  2009      44      1        7    72     2      1 FRAL4      
#>  7 2.26e14 1.45e14  2009      44      1        9   205     2      1 FRAL4      
#>  8 2.26e14 1.45e14  2009      44      1        7   194     1      2 CEOR7      
#>  9 2.26e14 1.45e14  2009      44      1        7   194     1      2 ROMU       
#> 10 2.26e14 1.45e14  2009      44      1        7   194     3      2 ELUM       
#> # ℹ 32 more rows
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
#> # A tibble: 702 × 61
#>         CN  SRV_CN        CTY_CN PREV_PLT_CN INVYR STATECD UNITCD COUNTYCD  PLOT
#>      <dbl>   <dbl>         <dbl>       <dbl> <int>   <int>  <int>    <int> <int>
#>  1 1.45e14 1.45e14 1320609010538     6.23e13  2009      44      1        1   155
#>  2 1.45e14 1.45e14 1320609010538     1.64e14  2009      44      1        1   326
#>  3 1.45e14 1.45e14 1320610010538     6.23e13  2009      44      1        3    19
#>  4 1.45e14 1.45e14 1320610010538     5.59e13  2009      44      1        3    52
#>  5 1.45e14 1.45e14 1320610010538     5.59e13  2009      44      1        3    55
#>  6 1.45e14 1.45e14 1320610010538     5.59e13  2009      44      1        3   129
#>  7 1.45e14 1.45e14 1320610010538     6.23e13  2009      44      1        3   135
#>  8 1.45e14 1.45e14 1320610010538     5.59e13  2009      44      1        3   152
#>  9 1.45e14 1.45e14 1320610010538     1.64e14  2009      44      1        3   323
#> 10 1.45e14 1.45e14 1320611010538     5.59e13  2009      44      1        5   130
#> # ℹ 692 more rows
#> # ℹ 52 more variables: PLOT_STATUS_CD <int>, PLOT_NONSAMPLE_REASN_CD <int>,
#> #   MEASYEAR <int>, MEASMON <int>, MEASDAY <int>, REMPER <dbl>, KINDCD <int>,
#> #   DESIGNCD <int>, RDDISTCD <int>, WATERCD <int>, LAT <dbl>, LON <dbl>,
#> #   ELEV <int>, GROW_TYP_CD <int>, MORT_TYP_CD <int>, P2PANEL <int>,
#> #   P3PANEL <int>, MANUAL <dbl>, KINDCD_NC <lgl>, QA_STATUS <int>,
#> #   MICROPLOT_LOC <chr>, DECLINATION <lgl>, SAMP_METHOD_CD <int>, …
#> 
#> $PLOTGEOM
#> # A tibble: 450 × 22
#>         CN STATECD INVYR UNITCD COUNTYCD  PLOT   LAT   LON CONGCD ECOSUBCD
#>      <dbl>   <dbl> <dbl>  <dbl>    <dbl> <dbl> <dbl> <dbl>  <dbl> <chr>   
#>  1 1.45e14      44  2009      1        1   155  41.7 -71.3   4401 221Ac   
#>  2 1.45e14      44  2009      1        1   326  41.7 -71.3   4401 221Ac   
#>  3 1.45e14      44  2009      1        3    19  41.6 -71.4   4402 221Ac   
#>  4 1.45e14      44  2009      1        3    52  41.7 -71.7   4402 221Ag   
#>  5 1.45e14      44  2009      1        3    55  41.8 -71.4   4402 221Ac   
#>  6 1.45e14      44  2009      1        3   129  41.7 -71.7   4402 221Ag   
#>  7 1.45e14      44  2009      1        3   135  41.6 -71.7   4402 221Ag   
#>  8 1.45e14      44  2009      1        3   152  41.7 -71.5   4402 221Ag   
#>  9 1.45e14      44  2009      1        3   323  41.7 -71.3   4401 221Ac   
#> 10 1.45e14      44  2009      1        5   130  41.5 -71.2   4401 221Ac   
#> # ℹ 440 more rows
#> # ℹ 12 more variables: HUC <dbl>, EMAP_HEX <dbl>, FIPSCOUNTY <dbl>,
#> #   ROADLESSCD <lgl>, ALP_ADFORCD <lgl>, FVS_VARIANT <chr>, FVS_LOC_CD <int>,
#> #   FVS_REGION <int>, FVS_FOREST <int>, FVS_DISTRICT <lgl>, ECO_UNIT_PNW <lgl>,
#> #   PRECIPITATION <lgl>
#> 
#> $POP_ESTN_UNIT
#> # A tibble: 78 × 13
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
#> # ℹ 5 more variables: AREATOT_EU <dbl>, AREA_USED <dbl>, AREA_SOURCE <chr>,
#> #   P1PNTCNT_EU <int>, P1SOURCE <chr>
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
#> # A tibble: 54 × 4
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
#> # ℹ 44 more rows
#> 
#> $POP_EVAL
#> # A tibble: 30 × 15
#>         CN EVAL_GRP_CN  RSCD EVALID EVAL_DESCR               STATECD LOCATION_NM
#>      <dbl>       <dbl> <int>  <int> <chr>                      <int> <chr>      
#>  1 4.68e14     4.68e14    24 441601 RHODE ISLAND 2016: 2011…      44 Rhode Isla…
#>  2 4.68e14     4.68e14    24 441603 RHODE ISLAND 2016: 2006…      44 Rhode Isla…
#>  3 4.68e14     4.68e14    24 441607 RHODE ISLAND 2016: 2012…      44 Rhode Isla…
#>  4 4.68e14     4.68e14    24 441608 RHODE ISLAND 2016: 2012…      44 Rhode Isla…
#>  5 5.33e14     5.33e14    24 441700 RHODE ISLAND 2017: 2011…      44 Rhode Isla…
#>  6 5.33e14     5.33e14    24 441701 RHODE ISLAND 2017: 2011…      44 Rhode Isla…
#>  7 5.33e14     5.33e14    24 441703 RHODE ISLAND 2017: 2007…      44 Rhode Isla…
#>  8 5.33e14     5.33e14    24 441707 RHODE ISLAND 2017: 2012…      44 Rhode Isla…
#>  9 5.33e14     5.33e14    24 441708 RHODE ISLAND 2017: 2012…      44 Rhode Isla…
#> 10 6.68e14     6.68e14    24 441801 RHODE ISLAND 2018: 2012…      44 Rhode Isla…
#> # ℹ 20 more rows
#> # ℹ 8 more variables: REPORT_YEAR_NM <chr>, START_INVYR <int>, END_INVYR <dbl>,
#> #   LAND_ONLY <chr>, TIMBERLAND_ONLY <chr>, GROWTH_ACCT <chr>,
#> #   ESTN_METHOD <chr>, NOTES <lgl>
#> 
#> $POP_PLOT_STRATUM_ASSGN
#> # A tibble: 4,282 × 12
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
#>  9 26333517…    2.63e14 1.45e13      44  2013      1        1   356    24 441300
#> 10 26333660…    2.63e14 2.21e14      44  2011      1        3     9    24 441300
#> # ℹ 4,272 more rows
#> # ℹ 2 more variables: ESTN_UNIT <int>, STRATUMCD <int>
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
#> # A tibble: 479 × 26
#>         CN  PLT_CN INVYR STATECD UNITCD COUNTYCD  PLOT  SUBP CONDID  SPCD
#>      <dbl>   <dbl> <int>   <int>  <int>    <int> <int> <int>  <int> <dbl>
#>  1 2.25e14 1.45e14  2009      44      1        3    52     1      1   129
#>  2 2.25e14 1.45e14  2009      44      1        3    52     2      1   316
#>  3 2.25e14 1.45e14  2009      44      1        3    52     2      1   531
#>  4 2.25e14 1.45e14  2009      44      1        3    52     4      2   129
#>  5 2.25e14 1.45e14  2009      44      1        3    52     4      2   371
#>  6 2.25e14 1.45e14  2009      44      1        3   129     1      1   129
#>  7 2.25e14 1.45e14  2009      44      1        3   129     3      1   129
#>  8 2.25e14 1.45e14  2009      44      1        3   135     1      1   531
#>  9 2.25e14 1.45e14  2009      44      1        3   135     2      1   129
#> 10 2.25e14 1.45e14  2009      44      1        3   135     2      1   531
#> # ℹ 469 more rows
#> # ℹ 16 more variables: SPGRPCD <int>, STOCKING <dbl>, TREECOUNT <int>,
#> #   TOTAGE <lgl>, TREECOUNT_CALC <dbl>, TPA_UNADJ <dbl>, CYCLE <int>,
#> #   SUBCYCLE <int>, DAMAGE_AGENT_CD1_SRS <lgl>,
#> #   PCT_AFFECTED_DAMAGE_AGENT1_SRS <lgl>, DAMAGE_AGENT_CD2_SRS <lgl>,
#> #   PCT_AFFECTED_DAMAGE_AGENT2_SRS <lgl>, DAMAGE_AGENT_CD3_SRS <lgl>,
#> #   PCT_AFFECTED_DAMAGE_AGENT3_SRS <lgl>, AGECD_RMRS <lgl>, …
#> 
#> $SUBP_COND_CHNG_MTRX
#> # A tibble: 3,158 × 9
#>         CN STATECD  SUBP SUBPTYP  PLT_CN CONDID PREV_PLT_CN PREVCOND
#>      <dbl>   <int> <int>   <int>   <dbl>  <int>       <dbl>    <int>
#>  1 1.82e15      44     2       2 1.45e14      1     5.59e13        1
#>  2 1.82e15      44     3       2 1.45e14      1     5.59e13        1
#>  3 1.82e15      44     4       2 1.45e14      1     5.59e13        1
#>  4 1.82e15      44     1       1 1.45e14      1     5.59e13        1
#>  5 1.82e15      44     2       1 1.45e14      1     5.59e13        1
#>  6 1.82e15      44     3       1 1.45e14      1     5.59e13        1
#>  7 1.82e15      44     4       1 1.45e14      1     5.59e13        1
#>  8 1.82e15      44     1       2 1.45e14      1     5.59e13        1
#>  9 1.82e15      44     2       2 1.45e14      1     5.59e13        1
#> 10 1.82e15      44     3       2 1.45e14      1     5.59e13        1
#> # ℹ 3,148 more rows
#> # ℹ 1 more variable: SUBPTYP_PROP_CHNG <dbl>
#> 
#> $SUBP_COND
#> # A tibble: 1,869 × 16
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
#>  9 2.26e14 1.45e14  2009      44      1        3    19     1      1
#> 10 2.26e14 1.45e14  2009      44      1        3    19     2      1
#> # ℹ 1,859 more rows
#> # ℹ 7 more variables: MICRCOND_PROP <dbl>, SUBPCOND_PROP <dbl>,
#> #   MACRCOND_PROP <lgl>, NONFR_INCL_PCT_SUBP <lgl>, NONFR_INCL_PCT_MACRO <lgl>,
#> #   CYCLE <int>, SUBCYCLE <int>
#> 
#> $SUBPLOT
#> # A tibble: 1,800 × 46
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
#>  9 2.25e14 1.45e14 NA           2009      44      1        3    19     1
#> 10 2.25e14 1.45e14 NA           2009      44      1        3    19     2
#> # ℹ 1,790 more rows
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
#> # A tibble: 5,141 × 66
#>     TRE_CN PREV_TRE_CN  PLT_CN STATECD SUBPTYP  SPCD STATUSCD   DIA    HT
#>      <dbl>       <dbl>   <dbl>   <int> <lgl>   <int>    <int> <dbl> <int>
#>  1 2.45e14     6.23e13 1.69e14      44 NA        316        1  8.4     54
#>  2 2.45e14     6.23e13 1.69e14      44 NA        316        1  9.1     52
#>  3 2.45e14     6.23e13 1.69e14      44 NA        806        1  7.4     43
#>  4 2.45e14     6.23e13 1.69e14      44 NA        802        1 13       62
#>  5 2.45e14     6.23e13 1.69e14      44 NA        316        1  6       44
#>  6 2.45e14     6.23e13 1.69e14      44 NA        316        1  6.1     47
#>  7 2.45e14     6.23e13 1.69e14      44 NA        316        1  3.3     31
#>  8 2.45e14    NA       1.69e14      44 NA        316        1  4.76    34
#>  9 2.45e14     6.23e13 1.69e14      44 NA        316        1  6.4     42
#> 10 2.45e14     6.23e13 1.69e14      44 NA        316        1  7.1     37
#> # ℹ 5,131 more rows
#> # ℹ 57 more variables: ACTUALHT <int>, CR <int>, STANDING_DEAD_CD <int>,
#> #   DIAHTCD <int>, CULL <int>, ROUGHCULL <int>, CULLFORM <lgl>,
#> #   CULLMSTOP <lgl>, DECAYCD <lgl>, TREECLCD <int>, HTDMP <dbl>,
#> #   WDLDSTEM <lgl>, STDORGCD <int>, SITREE <int>, BALIVE <dbl>, VOLTSGRS <dbl>,
#> #   VOLTSGRS_BARK <dbl>, VOLTSSND <dbl>, VOLTSSND_BARK <dbl>,
#> #   VOLCFGRS_STUMP <dbl>, VOLCFGRS_STUMP_BARK <dbl>, VOLCFSND_STUMP <dbl>, …
#> 
#> $TREE_GRM_COMPONENT
#> # A tibble: 5,527 × 76
#>     TRE_CN PREV_TRE_CN  PLT_CN STATECD DIA_BEGIN DIA_MIDPT DIA_END
#>      <dbl>       <dbl>   <dbl>   <dbl>     <dbl>     <dbl>   <dbl>
#>  1 2.25e14     6.23e13 1.45e14      44     15.7      16.6     17.4
#>  2 2.25e14     6.23e13 1.45e14      44     12.2      12.3     12.4
#>  3 2.25e14     6.23e13 1.45e14      44     10        10       10  
#>  4 2.25e14     6.23e13 1.45e14      44     13.2      13.8     14.4
#>  5 2.25e14     6.23e13 1.45e14      44      6.4       6.5      6.6
#>  6 2.25e14    NA       1.45e14      44      0.96      0.98     1  
#>  7 2.25e14     6.23e13 1.45e14      44      8.6       8.8      9  
#>  8 2.25e14     6.23e13 1.45e14      44      7.5       7.54     7.4
#>  9 2.25e14     6.23e13 1.45e14      44     16.3      16.8     17.4
#> 10 2.25e14     6.23e13 1.45e14      44     10.7      10.9     11.1
#> # ℹ 5,517 more rows
#> # ℹ 69 more variables: ANN_DIA_GROWTH <dbl>, ANN_HT_GROWTH <dbl>,
#> #   SUBPTYP_BEGIN <lgl>, SUBPTYP_MIDPT <lgl>, SUBPTYP_END <lgl>,
#> #   MICR_COMPONENT_AL_FOREST <chr>, MICR_SUBPTYP_GRM_AL_FOREST <int>,
#> #   MICR_TPAGROW_UNADJ_AL_FOREST <dbl>, MICR_TPAREMV_UNADJ_AL_FOREST <dbl>,
#> #   MICR_TPAMORT_UNADJ_AL_FOREST <dbl>, SUBP_COMPONENT_AL_FOREST <chr>,
#> #   SUBP_SUBPTYP_GRM_AL_FOREST <int>, SUBP_TPAGROW_UNADJ_AL_FOREST <dbl>, …
#> 
#> $TREE_GRM_MIDPT
#> # A tibble: 5,141 × 66
#>     TRE_CN PREV_TRE_CN  PLT_CN STATECD SUBPTYP  SPCD STATUSCD   DIA    HT
#>      <dbl>       <dbl>   <dbl>   <int> <lgl>   <int>    <int> <dbl> <int>
#>  1 2.94e13    NA       2.21e14      44 NA        261        1  5.13    23
#>  2 2.94e13     7.43e13 2.21e14      44 NA        806        1 10.3     52
#>  3 2.94e13     7.43e13 2.21e14      44 NA        372        1  1.05    15
#>  4 2.94e13     7.43e13 2.21e14      44 NA        372        1  1.2     16
#>  5 2.94e13    NA       2.21e14      44 NA        261        1  1.33    13
#>  6 2.94e13    NA       2.21e14      44 NA        261        1  5.25    34
#>  7 2.94e13    NA       2.21e14      44 NA        806        1  5.15    37
#>  8 2.94e13     7.43e13 2.21e14      44 NA        372        1  1.4     18
#>  9 2.94e13     7.43e13 2.21e14      44 NA        372        1  1.95    22
#> 10 2.94e13    NA       2.21e14      44 NA        372        1  1.15    16
#> # ℹ 5,131 more rows
#> # ℹ 57 more variables: ACTUALHT <int>, CR <int>, STANDING_DEAD_CD <int>,
#> #   DIAHTCD <int>, CULL <int>, ROUGHCULL <int>, CULLFORM <lgl>,
#> #   CULLMSTOP <lgl>, DECAYCD <lgl>, TREECLCD <int>, HTDMP <dbl>,
#> #   WDLDSTEM <lgl>, STDORGCD <int>, SITREE <int>, BALIVE <dbl>, VOLTSGRS <dbl>,
#> #   VOLTSGRS_BARK <dbl>, VOLTSSND <dbl>, VOLTSSND_BARK <dbl>,
#> #   VOLCFGRS_STUMP <dbl>, VOLCFGRS_STUMP_BARK <dbl>, VOLCFSND_STUMP <dbl>, …
#> 
#> $TREE
#> # A tibble: 10,644 × 194
#>         CN  PLT_CN PREV_TRE_CN INVYR STATECD UNITCD COUNTYCD  PLOT  SUBP  TREE
#>      <dbl>   <dbl>       <dbl> <int>   <int>  <int>    <int> <int> <int> <int>
#>  1 6.22e13 5.59e13          NA  2004      44      1        3    52     1     2
#>  2 6.22e13 5.59e13          NA  2004      44      1        3    52     1     3
#>  3 6.22e13 5.59e13          NA  2004      44      1        3    52     1     4
#>  4 6.22e13 5.59e13          NA  2004      44      1        3    52     1     6
#>  5 6.22e13 5.59e13          NA  2004      44      1        3    52     1     7
#>  6 6.22e13 5.59e13          NA  2004      44      1        3    52     1     8
#>  7 6.22e13 5.59e13          NA  2004      44      1        3    52     2     1
#>  8 6.22e13 5.59e13          NA  2004      44      1        3    52     2     2
#>  9 6.22e13 5.59e13          NA  2004      44      1        3    52     2     3
#> 10 6.22e13 5.59e13          NA  2004      44      1        3    52     2     4
#> # ℹ 10,634 more rows
#> # ℹ 184 more variables: CONDID <int>, PREVCOND <int>, STATUSCD <int>,
#> #   SPCD <dbl>, SPGRPCD <int>, DIA <dbl>, DIAHTCD <int>, HT <int>, HTCD <int>,
#> #   ACTUALHT <int>, TREECLCD <int>, CR <int>, CCLCD <int>, TREEGRCD <int>,
#> #   AGENTCD <int>, CULL <int>, DAMLOC1 <int>, DAMTYP1 <int>, DAMSEV1 <int>,
#> #   DAMLOC2 <int>, DAMTYP2 <int>, DAMSEV2 <int>, DECAYCD <int>, STOCKING <dbl>,
#> #   WDLDSTEM <lgl>, VOLCFNET <dbl>, VOLCFGRS <dbl>, VOLCSNET <dbl>, …
#> 
#> 
```
