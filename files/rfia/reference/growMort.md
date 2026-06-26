# Estimate growth, recruitment, mortality, and harvest rates from FIADB

Produces estimates of annual growth, recruitment, natural mortality, and
harvest rates from the Forest Inventory and Analysis Database (FIADB),
along with population estimates for each variable. Estimates can be
produced for regions defined within the FIA Database (e.g. counties), at
the plot level, or within user-defined areal units. Options to group
estimates by species, size class, and other variables defined in the
FIADB. If multiple reporting years (EVALIDs) are included in the data,
estimates will be output as a time series. If multiple states are
represented by the data, estimates will be output for the full region
(all area combined), unless specified otherwise (e.g.
`grpBy = STATECD`).

## Usage

``` r
growMort(db, grpBy = NULL, polys = NULL, returnSpatial = FALSE, bySpecies = FALSE,
         bySizeClass = FALSE, landType = 'forest', treeType = 'all',
         method = 'TI', lambda = 0.5, stateVar = 'TPA', treeDomain = NULL,
         areaDomain = NULL, totals = FALSE, variance = FALSE,
         byPlot = FALSE, treeList = FALSE, nCores = 1)
```

## Arguments

- db:

  `FIA.Database` or `Remote.FIA.Database` object produced from
  [`readFIA()`](readFIA.md) or [`getFIA()`](getFIA.md). If a
  `Remote.FIA.Database`, data will be read in and processed
  state-by-state to conserve RAM (see details for an example).

- grpBy:

  variables from PLOT, PLOTGEOM, COND, or TREE tables to group estimates
  by (NOT quoted). Multiple grouping variables should be combined with
  [`c()`](https://rdrr.io/r/base/c.html), and grouping will occur
  heirarchically. For example, to produce seperate estimates for each
  ownership group within methods of stand regeneration, specify
  `c(STDORGCD, OWNGRPCD)`.

- polys:

  `sp` or `sf` Polygon/MultiPolgyon object; Areal units to bin data for
  estimation. Separate estimates will be produced for region encompassed
  by each areal unit. FIA plot locations will be reprojected to match
  projection of `polys` object.

- returnSpatial:

  logical; if TRUE, merge population estimates with `polys` and return
  as `sf` multipolygon object. When `byPlot = TRUE`, return plot-level
  estimates as `sf` spatial points.

- bySpecies:

  logical; if TRUE, returns estimates grouped by species.

- bySizeClass:

  logical; if TRUE, returns estimates grouped by size class (2-inch
  intervals, see [`makeClasses()`](makeClasses.md) to compute different
  size class intervals).

- landType:

  character ("forest" or "timber"); Type of land that estimates will be
  produced for. Timberland is a subset of forestland (default) which has
  high site potential and non-reserve status (see details).

- treeType:

  character ("all" or "gs"); Type of tree that estimates will be
  produced for. All (default) includes all stems, live and dead, greater
  than 5 in. DBH (or those that grow to 5in by the end of time period
  2). GS (growing-stock) includes live stems greater than 5 in. DBH
  which contain at least one 8 ft merchantable log.

- method:

  character; design-based estimator to use. One of: "TI" (temporally
  indifferent, default), "annual" (annual), "SMA" (simple moving
  average), "LMA" (linear moving average), or "EMA" (exponential moving
  average). See [Stanke et al
  2020](https://research.fs.usda.gov/treesearch/59521) for a complete
  description of these estimators.

- lambda:

  numeric (0,1); if `method = 'EMA'`, the decay parameter used to define
  weighting scheme for annual panels. Low values place higher weight on
  more recent panels, and vice versa. Specify a vector of values to
  compute estimates using mulitple wieghting schemes, and use
  [`plotFIA()`](plotFIA.md) with `grp` set to `lambda` to produce moving
  average ribbon plots. See [Stanke et al
  2020](https://research.fs.usda.gov/treesearch/59521) for examples.

- stateVar:

  character; State variable for reporting GRM estimates. One of: TPA,
  BAA, BIO_AG, BIO_BG, BIO, CARB_AG, CARB_BG, CARB, NETVOL, SNDVOL,
  SAWVOL, SAWVOL_BF (board feet).

- treeDomain:

  logical predicates defined in terms of the variables in PLOT, TREE,
  and/or COND tables. Used to define the type of trees for which
  estimates will be produced (e.g. DBH greater than 20 inches:
  `DIA > 20`, Dominant/Co-dominant crowns only: `CCLCD %in% c(2,3)`.
  Multiple conditions are combined with `&` (and) or `|` (or). Only
  trees where the condition evaluates to TRUE are used in producing
  estimates. Should NOT be quoted.

- areaDomain:

  logical predicates defined in terms of the variables in PLOT and/or
  COND tables. Used to define the area for which estimates will be
  produced (e.g. within 1 mile of improved road: `RDDISTCD %in% c(1:6)`,
  Hard maple/basswood forest type: `FORTYPCD == 805`. Multiple
  conditions are combined with `&` (and) or `|` (or). Only plots within
  areas where the condition evaluates to TRUE are used in producing
  estimates. Should NOT be quoted.

- totals:

  logical; if TRUE, return population estimates (e.g. total area, total
  mortality) along with ratio estimates (e.g. mean mortality trees per
  acre).

- variance:

  logical; if TRUE, return estimated variance (`VAR`) and sample size
  (`N`). If FALSE, return 'sampling error' (`SE`) as returned by
  EVALIDator. Note: sampling error cannot be used to construct
  confidence intervals.

- byPlot:

  logical; if TRUE, returns estimates for individual plot locations
  instead of population estimates.

- treeList:

  logical; if TRUE, returns tree-level summaries intended for subsequent
  use with [`customPSE()`](customPSE.md).

- nCores:

  numeric; number of cores to use for parallel implementation. Check
  available cores using `detectCores()`. Default = 1, serial processing.

## Details

**Estimation Details**

Estimation of forest variables follows the procedures documented in
Bechtold and Patterson (2005) and [Stanke et al
2020](https://research.fs.usda.gov/treesearch/59521).

Average annual rates are computed using a sample-based ratio of means
estimator of total trees subject to an event (e.g. recruitment,
mortality) annually / total area. Similarly, the proportion of
individuals subject to each event annually is computed as the total
trees subject to the event between time 1 and time 2 / total live trees
at time 1. All estimates are returned as average annual rates. Only
conditions which were forested in time 1 and in time 2 are included in
estimates (excluding converted stands).

Recruitment events are defined as when a live stem that is less than 5
inches DBH at time 1, grows to or beyond 5 inches DBH by time 2. This
does NOT include stems that grow beyond the 5-inch diameter criteria and
are then subject to mortality (both natural and harvest) prior to
remeasurement. Natural mortality is defined as when a live stem is
subject to non-harvest mortality between successive measurement periods.
Finally, harvest is defined as when a live stem is cut and removed
between successive measurements.

Users may specify alternatives to the 'Temporally Indifferent' estimator
using the `method` argument. Alternative design-based estimators include
the annual estimator ("ANNUAL"; annual panels, or estimates from plots
measured in the same year), simple moving average ("SMA"; combines
annual panels with equal weight), linear moving average ("LMA"; combine
annual panels with weights that decay *linearly* with time since
measurement), and exponential moving average ("EMA"; combine annual
panels with weights that decay *exponentially* with time since
measurement). The "best" estimator depends entirely on user-objectives,
see [Stanke et al 2020](https://research.fs.usda.gov/treesearch/59521)
for a complete description of these estimators and tradeoffs between
precision and temporal specificity.

When `byPlot = FALSE` (i.e., population estimates are returned), the
"YEAR" column in the resulting dataframe indicates the final year of the
inventory cycle that estimates are produced for. For example, an
estimate of current forest area (e.g., 2018) may draw on data collected
from 2008-2018, and "YEAR" will be listed as 2018 (consistent with
EVALIDator). However, when `byPlot = TRUE` (i.e., plot-level estimates
returned), the "YEAR" column denotes the year that each plot was
measured (MEASYEAR), which may differ slightly from its associated
inventory year (INVYR).

Stratified random sampling techniques are most often employed to compute
estimates in recent inventories, although double sampling and simple
random sampling may be employed for early inventories. Estimates are
adjusted for non-response bias by assuming attributes of non-response
plot locations to be equal to the mean of other plots included within
thier respective stratum or population.

**Working with "Big Data"**

If FIA data are too large to hold in memory (e.g., R throws the "cannot
allocate vector of size ..." errors), use larger-than-RAM options. See
documentation of `link{readFIA}` for examples of how to set up a
`Remote.FIA.Database`. As a reference, we have used rFIA's
larger-than-RAM methods to estimate forest variables using the entire
FIA Database (~50GB) on a standard desktop computer with 16GB of RAM.
Check out [our website](https://doserlab.com/files/rfia/) for more
details and examples.

Easy, efficient parallelization is implemented with the `parallel`
package. Users must only specify the `nCores` argument with a value
greater than 1 in order to implement parallel processing on their
machines. Parallel implementation is achieved using a snow type cluster
on any Windows OS, and with multicore forking on any Unix OS (Linux,
Mac). Implementing parallel processing may substantially decrease free
memory during processing, particularly on Windows OS. Thus, users should
be cautious when running in parallel, and consider implementing serial
processing for this task if computational resources are limited
(`nCores = 1`).

**Definition of forestland**

Forest land must have at least 10-percent canopy cover by live tally
trees of any size, including land that formerly had such tree cover and
that will be naturally or artificially regenerated. Forest land includes
transition zones, such as areas between heavily forest and non-forested
lands that meet the mimium tree canopy cover and forest areas adjacent
to urban and built-up lands. The minimum area for classification of
forest land is 1 acre in size and 120 feet wide measured stem-to-stem
from the outer-most edge. Roadside, streamside, and shelterbelt strips
of trees must have a width of at least 120 feet and continuous length of
at least 363 feet to qualify as forest land. Tree-covered areas in
agricultural production settings, such as fruit orchards, or
tree-covered areas in urban settings, such as city parks, are not
considered forest land.

Timber land is a subset of forest land that is producing or is capable
of producing crops of industrial wood and not withdrawn from timber
utilization by statute or administrative regulation. (Note: Areas
qualifying as timberland are capable of producing at least 20 cubic feet
per acre per year of industrial wood in natural stands. Currently
inaccessible and inoperable areas are NOT included).

## Value

Dataframe or sf object (if `returnSpatial = TRUE`). If `byPlot = TRUE`,
values are returned for each plot (`PLOT_STATUS_CD = 1` when forest
exists at the plot location). All variables with names ending in `SE`,
represent the estimate of sampling error (%) of the variable. When
`variance = TRUE`, variables ending in `VAR` denote the variance of the
variable and `N` is the total sample size (i.e., including non-zero
plots).

- **YEAR**: reporting year associated with estimates

- **RECR\_\***: estimate of mean annual recruitment

- **MORT\_\***: estimate of mean annual mortality

- **REMV\_\***: estimate of mean annual removals (harvest)

- **GROW\_\***: estimate of mean annual growth on survivors

- **CHNG\_\***: estimate of mean annual net change (i.e., growth +
  recruitment - mortality - removals)

- **RECR_PERC**: estimate of mean percent of individuals subject to
  recruitment annually (recruitment / previous total)

- **MORT_PERC**: estimate of mean percent of individuals subject to
  mortality annually (mortality / previous total)

- **REMV_PERC**: estimate of mean percent of individuals subject to
  removal (harvest) annually (removals / previous total)

- **GROW_PERC**: estimate of mean annual growth on survivors (%) (growth
  / previous total)

- **CHNG_PERC**: estimate of mean annual net change (%) (net change /
  previous total)

- **nPlots_TREE**: number of non-zero plots used to compute total tree
  estimates

- **nPlots_RECR**: number of non-zero plots used to compute recruitment
  estimates

- **nPlots_MORT**: number of non-zero plots used to compute mortality
  estimates

- **nPlots_REMV**: number of non-zero plots used to compute removal
  estimates

- **nPlots_AREA**: number of non-zero plots used to compute land area
  estimates

## References

rFIA website: <https://doserlab.com/files/rfia/>

FIA Database User Guide:
<https://research.fs.usda.gov/understory/forest-inventory-and-analysis-database-user-guide-nfi>

Bechtold, W.A.; Patterson, P.L., eds. 2005. The Enhanced Forest
Inventory and Analysis Program - National Sampling Design and Estimation
Procedures. Gen. Tech. Rep. SRS - 80. Asheville, NC: U.S. Department of
Agriculture, Forest Service, Southern Research Station. 85 p.
<https://www.srs.fs.usda.gov/pubs/gtr/gtr_srs080/gtr_srs080.pdf>

Stanke, H., Finley, A. O., Weed, A. S., Walters, B. F., & Domke, G. M.
(2020). rFIA: An R package for estimation of forest attributes with the
US Forest Inventory and Analysis database. Environmental Modelling &
Software, 127, 104664.

## Author

Hunter Stanke and Andrew Finley

## Note

All sampling error estimates (SE) are returned as the "percent
coefficient of variation" (standard deviation / mean \* 100) for
consistency with EVALIDator. IMPORTANT: sampling error cannot be used to
construct confidence intervals. Please use `variance = TRUE` for that
(i.e., return variance and sample size instead of sampling error).

## Examples

``` r
# Load data from the rFIA package
data(fiaRI)
data(countiesRI)

# Most recents subset
fiaRI_mr <- clipFIA(fiaRI)


# Most recent estimates for growing-stock on timber land by species
growMort(db = fiaRI_mr,
         landType = 'timber',
         treeType = 'gs')
#> # A tibble: 1 × 23
#>    YEAR RECR_TPA MORT_TPA REMV_TPA GROW_TPA CHNG_TPA RECR_PERC MORT_PERC
#>   <dbl>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>     <dbl>     <dbl>
#> 1  2018     1.01     1.50    0.443        0   -0.926     0.760      1.12
#> # ℹ 15 more variables: REMV_PERC <dbl>, GROW_PERC <dbl>, CHNG_PERC <dbl>,
#> #   RECR_TPA_SE <dbl>, MORT_TPA_SE <dbl>, REMV_TPA_SE <dbl>, GROW_TPA_SE <dbl>,
#> #   RECR_PERC_SE <dbl>, MORT_PERC_SE <dbl>, REMV_PERC_SE <dbl>,
#> #   GROW_PERC_SE <dbl>, CHNG_PERC_SE <dbl>, nPlots_TREE <int>,
#> #   nPlots_AREA <int>, N <int>
# \donttest{
# Same as above at the plot-level
growMort(db = fiaRI_mr,
         landType = 'timber',
         treeType = 'gs',
         byPlot = TRUE)
#> # A tibble: 114 × 17
#>     PLT_CN  YEAR pltID      REMPER RECR_TPA MORT_TPA REMV_TPA GROW_TPA CHNG_TPA
#>      <dbl> <int> <chr>       <dbl>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>
#>  1 1.45e13  2013 1_44_1_228    4.2     0        0           0        0     0   
#>  2 1.45e13  2013 1_44_3_144    4.1     0        0           0        0     0   
#>  3 2.47e14  2013 1_44_7_126    5.6     1.07     0           0        0     1.07
#>  4 1.45e13  2013 1_44_7_169    4.3     0        7.00        0        0    -7.00
#>  5 2.47e14  2013 1_44_7_177    5.6     1.07     0           0        0     1.07
#>  6 1.45e13  2013 1_44_7_229    4.3     0        0           0        0     0   
#>  7 1.45e13  2013 1_44_7_245    4.1     0        0           0        0     0   
#>  8 1.45e13  2013 1_44_7_306    4.9     0        0           0        0     0   
#>  9 2.47e14  2013 1_44_7_341    6.2     0        0           0        0     0   
#> 10 1.45e13  2013 1_44_7_77     4.7     1.28     0           0        0     1.28
#> # ℹ 104 more rows
#> # ℹ 8 more variables: RECR_PERC <dbl>, MORT_PERC <dbl>, REMV_PERC <dbl>,
#> #   GROW_PERC <dbl>, CHNG_PERC <dbl>, PREV_TPA <dbl>, CURR_TPA <dbl>,
#> #   PROP_FOREST <dbl>

# Estimates for white pine ( > 12" DBH) on forested mesic sites
growMort(fiaRI_mr,
         treeType = 'all',
         treeDomain = SPCD == 129 & DIA > 12, # Species code for white pine
         areaDomain = PHYSCLCD %in% 21:29) # Mesic Physiographic classes
#> # A tibble: 1 × 23
#>    YEAR RECR_TPA MORT_TPA REMV_TPA GROW_TPA CHNG_TPA RECR_PERC MORT_PERC
#>   <dbl>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>     <dbl>     <dbl>
#> 1  2018        0   0.0154   0.0156        0  -0.0310         0     0.188
#> # ℹ 15 more variables: REMV_PERC <dbl>, GROW_PERC <dbl>, CHNG_PERC <dbl>,
#> #   RECR_TPA_SE <dbl>, MORT_TPA_SE <dbl>, REMV_TPA_SE <dbl>, GROW_TPA_SE <dbl>,
#> #   RECR_PERC_SE <dbl>, MORT_PERC_SE <dbl>, REMV_PERC_SE <dbl>,
#> #   GROW_PERC_SE <dbl>, CHNG_PERC_SE <dbl>, nPlots_TREE <int>,
#> #   nPlots_AREA <int>, N <int>

# Most recent estimates grouped by stand age on forest land
# Make a categorical variable which represents stand age (grouped by 10 yr intervals)
fiaRI_mr$COND$STAND_AGE <- makeClasses(fiaRI_mr$COND$STDAGE, interval = 10)
growMort(db = fiaRI_mr,
         grpBy = STAND_AGE)
#> # A tibble: 11 × 24
#>     YEAR STAND_AGE RECR_TPA MORT_TPA REMV_TPA GROW_TPA CHNG_TPA RECR_PERC
#>    <dbl> <chr>        <dbl>    <dbl>    <dbl>    <dbl>    <dbl>     <dbl>
#>  1  2018 [0,10)       1.25     0        0            0    1.25    Inf    
#>  2  2018 [20,30)      0        0        0            0    0         0    
#>  3  2018 [30,40)      4.06     1.12     0            0    2.94      2.46 
#>  4  2018 [40,50)      4.17     0        0            0    4.17      2.43 
#>  5  2018 [50,60)      0.793    1.04     0            0   -0.247     0.468
#>  6  2018 [60,70)      1.84     2.37     1.04         0   -1.58      0.925
#>  7  2018 [70,80)      1.56     2.86     0.410        0   -1.71      0.806
#>  8  2018 [80,90)      1.32     2.34     0.511        0   -1.54      0.764
#>  9  2018 [90,100)     1.13     1.95     0.424        0   -1.24      0.766
#> 10  2018 [100,110)    0.620    0.989    0            0   -0.369     0.438
#> 11  2018 [110,120]    0.885    1.77     0            0   -0.885     0.588
#> # ℹ 16 more variables: MORT_PERC <dbl>, REMV_PERC <dbl>, GROW_PERC <dbl>,
#> #   CHNG_PERC <dbl>, RECR_TPA_SE <dbl>, MORT_TPA_SE <dbl>, REMV_TPA_SE <dbl>,
#> #   GROW_TPA_SE <dbl>, RECR_PERC_SE <dbl>, MORT_PERC_SE <dbl>,
#> #   REMV_PERC_SE <dbl>, GROW_PERC_SE <dbl>, CHNG_PERC_SE <dbl>,
#> #   nPlots_TREE <int>, nPlots_AREA <int>, N <int>

# Most recent estimates for stems on forest land by species
growMort(db = fiaRI_mr,
         landType = 'forest',
         bySpecies = TRUE)
#> # A tibble: 41 × 26
#>     YEAR  SPCD COMMON_NAME   SCIENTIFIC_NAME RECR_TPA MORT_TPA REMV_TPA GROW_TPA
#>    <dbl> <dbl> <chr>         <chr>              <dbl>    <dbl>    <dbl>    <dbl>
#>  1  2018    12 balsam fir    Abies balsamea   0         0.0102   0             0
#>  2  2018    43 Atlantic whi… Chamaecyparis …  0         0        0             0
#>  3  2018    68 eastern redc… Juniperus virg…  0.00856   0        0             0
#>  4  2018   126 pitch pine    Pinus rigida     0.0134    0.0415   0.0134        0
#>  5  2018   129 eastern whit… Pinus strobus    0.299     0.343    0.0481        0
#>  6  2018   130 Scotch pine   Pinus sylvestr…  0         0        0             0
#>  7  2018   261 eastern heml… Tsuga canadens…  0.0903    0.0303   0             0
#>  8  2018   313 boxelder      Acer negundo     0         0        0             0
#>  9  2018   316 red maple     Acer rubrum      0.403     0.420    0.227         0
#> 10  2018   317 silver maple  Acer saccharin…  0.0159    0        0             0
#> # ℹ 31 more rows
#> # ℹ 18 more variables: CHNG_TPA <dbl>, RECR_PERC <dbl>, MORT_PERC <dbl>,
#> #   REMV_PERC <dbl>, GROW_PERC <dbl>, CHNG_PERC <dbl>, RECR_TPA_SE <dbl>,
#> #   MORT_TPA_SE <dbl>, REMV_TPA_SE <dbl>, GROW_TPA_SE <dbl>,
#> #   RECR_PERC_SE <dbl>, MORT_PERC_SE <dbl>, REMV_PERC_SE <dbl>,
#> #   GROW_PERC_SE <dbl>, CHNG_PERC_SE <dbl>, nPlots_TREE <int>,
#> #   nPlots_AREA <int>, N <int>

# Same as above, but implemented in parallel (much quicker)
# parallel::detectCores(logical = FALSE) # 4 cores available, we will take 2
# growMort(db = fiaRI_mr,
#          landType = 'forest',
#          bySpecies = TRUE,
#          nCores = 2)

# Most recent estimates for all stems on forest land grouped by user-defined areal units
ctSF <- growMort(fiaRI_mr,
                 polys = countiesRI,
                 returnSpatial = TRUE)
plot(ctSF) # Plot multiple variables simultaneously
#> Warning: plotting the first 9 out of 25 attributes; use max.plot = 25 to plot all

plotFIA(ctSF, MORT_TPA) # Plot of Mortality TPA with color scale

# }
```
