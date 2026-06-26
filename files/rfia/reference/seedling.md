# Estimate seedling abundance per acre from FIADB

Produces seedling (\< 1 inch DBH) tree per acre (TPA) estimates from FIA
data, along with population totals. Estimates can be produced for
regions defined within the FIA Database (e.g. counties), at the plot
level, or within user-defined areal units. Options to group estimates by
species and other variables defined in the FIADB. If multiple reporting
years (EVALIDs) are included in the data, estimates will be output as a
time series. If multiple states are represented by the data, estimates
will be output for the full region (all area combined), unless specified
otherwise (e.g. `grpBy = STATECD`). Easy options to implement parallel
processing.

## Usage

``` r
seedling(db, grpBy = NULL, polys = NULL, returnSpatial = FALSE,
         bySpecies = FALSE, landType = "forest", method = 'TI',
         lambda = 0.5, treeDomain = NULL, areaDomain = NULL,
         totals = FALSE, variance = FALSE, byPlot = FALSE,
         treeList = FALSE, nCores = 1)
```

## Arguments

- db:

  `FIA.Database` or `Remote.FIA.Database` object produced from
  [`readFIA`](readFIA.md) or [`getFIA`](getFIA.md). If a
  `Remote.FIA.Database`, data will be read in and processed
  state-by-state to conserve RAM (see details for an example).

- grpBy:

  variables from PLOT, PLOTGEOM, COND, or SEEDLING tables to group
  estimates by (NOT quoted). Multiple grouping variables should be
  combined with [`c()`](https://rdrr.io/r/base/c.html), and grouping
  will occur heirarchically. For example, to produce seperate estimates
  for each ownership group within methods of stand regeneration, specify
  `c(STDORGCD, OWNGRPCD)`.

- polys:

  `sp` or `sf` Polygon/MultiPolgyon object; Areal units to bin data for
  estimation. Seperate estimates will be produced for region encompassed
  by each areal unit. FIA plot locations will be reprojected to match
  projection of `polys` object.

- returnSpatial:

  logical; if TRUE, merge population estimates with `polys` and return
  as `sf` multipolygon object. When `byPlot = TRUE`, return plot-level
  estimates as `sf` spatial points.

- bySpecies:

  logical; if TRUE, returns estimates grouped by species.

- landType:

  character ("forest" or "timber"); Type of land that estimates will be
  produced for. Timberland is a subset of forestland (default) which has
  high site potential and non-reserve status (see details).

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
  compute estimates using mulitple weighting schemes, and use `plotFIA`
  with `grp` set to `lambda` to produce moving average ribbon plots. See
  [Stanke et al 2020](https://research.fs.usda.gov/treesearch/59521) for
  examples.

- treeDomain:

  logical predicates defined in terms of the variables in PLOT,
  SEEDLING, and/or COND tables. Used to define the type of trees for
  which estimates will be produced (e.g. white pine: `SPCD == 129`).
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

  logical; if TRUE, return total population estimates (e.g. total area)
  along with ratio estimates (e.g. mean trees per acre).

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
  use with `customPSE`.

- nCores:

  numeric; number of cores to use for parallel implementation. Check
  available cores using `detectCores`. Default = 1, serial processing.

## Details

**Estimation Details**

Estimation of forest variables follows the procedures documented in
Bechtold and Patterson (2005) and [Stanke et al
2020](https://research.fs.usda.gov/treesearch/59521).

Specifically, TPA is computed using a sample-based ratio-of-means
estimator of total seedlings / total land area within the domain of
interest. Percentages of live TPA in the domain of interest are
represented as the total number of trees of a particular type (e.g.,
white pine) / total number of trees (live, all species) within the
region. The total populations used to compute these percentages will
vary if the user specifies an areaDomain or treeDomain.

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

- **TPA**: estimate of mean trees per acre

- **TPA_PERC**: estimate of mean proportion of live trees falling within
  the domain of interest, with respect to trees per acre

- **nPlots_SEEDLING**: number of non-zero plots used to compute tpa
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
## Load data from the rFIA package
data(fiaRI)
data(countiesRI)

## Most recents subset
fiaRI_mr <- clipFIA(fiaRI)


## Most recent estimates on timber land by species
seedling(db = fiaRI_mr,
    landType = 'timber')
#> # A tibble: 1 × 6
#>    YEAR   TPA TPA_SE nPlots_TREE nPlots_AREA     N
#>   <dbl> <dbl>  <dbl>       <int>       <int> <int>
#> 1  2018  798.   21.4         127         127   199

# \donttest{
## Same as above at the plot-level
seedling(db = fiaRI_mr,
         landType = 'timber',
         byPlot = TRUE)
#> # A tibble: 127 × 5
#>     YEAR pltID       PLT_CN    TPA PROP_FOREST
#>    <int> <chr>        <dbl>  <dbl>       <dbl>
#>  1  2013 1_44_1_228 1.45e13  900.        0.667
#>  2  2013 1_44_3_144 1.45e13  225.        0.170
#>  3  2013 1_44_7_126 2.47e14 1199.        0.5  
#>  4  2013 1_44_7_169 1.45e13 6597.        1    
#>  5  2013 1_44_7_177 2.47e14  375.        0.25 
#>  6  2013 1_44_7_229 1.45e13 1649.        1    
#>  7  2013 1_44_7_245 1.45e13   75.0       0.25 
#>  8  2013 1_44_7_306 1.45e13    0         0.217
#>  9  2013 1_44_7_341 2.47e14  450.        1    
#> 10  2013 1_44_7_61  1.45e13  675.        1    
#> # ℹ 117 more rows

## Estimates for white pine on forested mesic sites (all available inventories)
seedling(fiaRI_mr,
    treeDomain = SPCD == 129, # Species code for white pine
    areaDomain = PHYSCLCD %in% 21:29) # Mesic Physiographic classes
#> # A tibble: 1 × 6
#>    YEAR   TPA TPA_SE nPlots_TREE nPlots_AREA     N
#>   <dbl> <dbl>  <dbl>       <int>       <int> <int>
#> 1  2018  605.   29.9         127         127   199

## Most recent estimates grouped by stand age on forest land
# Make a categorical variable which represents stand age (grouped by 10 yr intervals)
fiaRI_mr$COND$STAND_AGE <- makeClasses(fiaRI_mr$COND$STDAGE, interval = 10)
seedling(db = fiaRI_mr,
    grpBy = STAND_AGE)
#> # A tibble: 11 × 7
#>     YEAR STAND_AGE   TPA       TPA_SE nPlots_TREE nPlots_AREA     N
#>    <dbl> <chr>     <dbl>        <dbl>       <int>       <int> <int>
#>  1  2018 [0,10)       0  NaN                    2           2    32
#>  2  2018 [20,30)    901.   0.00000177           1           1   167
#>  3  2018 [30,40)    331.  36.6                  5           5   167
#>  4  2018 [40,50)   1173.  24.9                  7           7   199
#>  5  2018 [50,60)    248.  38.3                 11          12   199
#>  6  2018 [60,70)    850.  33.0                 22          23   199
#>  7  2018 [70,80)   1224.  36.1                 42          43   199
#>  8  2018 [80,90)    429.  35.4                 27          27   199
#>  9  2018 [90,100)   504.  42.3                 11          12   199
#> 10  2018 [100,110)  619.  87.3                  3           3   199
#> 11  2018 [110,120]  150.   0.00000160           1           1    32

## Most recent estimates for live stems on forest land by species
seedling(db = fiaRI_mr,
    landType = 'forest',
    bySpecies = TRUE)
#> # A tibble: 31 × 9
#>     YEAR  SPCD COMMON_NAME        SCIENTIFIC_NAME         TPA TPA_SE nPlots_TREE
#>    <dbl> <dbl> <chr>              <chr>                 <dbl>  <dbl>       <int>
#>  1  2018    68 eastern redcedar   Juniperus virginia…   3.39    58.5           3
#>  2  2018   126 pitch pine         Pinus rigida         13.5     93.6           2
#>  3  2018   129 eastern white pine Pinus strobus       534.      29.9          46
#>  4  2018   261 eastern hemlock    Tsuga canadensis      3.14    59.1           3
#>  5  2018   316 red maple          Acer rubrum          27.5     33.3          20
#>  6  2018   318 sugar maple        Acer saccharum        0.665   99.9           1
#>  7  2018   320 Norway maple       Acer platanoides      4.82    95.4           1
#>  8  2018   356 serviceberry spp.  Amelanchier spp.      5.86    60.0           5
#>  9  2018   371 yellow birch       Betula alleghanien…   5.62    61.4           3
#> 10  2018   372 sweet birch        Betula lenta         26.6     38.2          10
#> # ℹ 21 more rows
#> # ℹ 2 more variables: nPlots_AREA <int>, N <int>

## Same as above, but implemented in parallel (much quicker)
# parallel::detectCores(logical = FALSE) # 4 cores available, we will take 2
# seedling(db = fiaRI_mr,
#     landType = 'forest',
#     bySpecies = TRUE,
#     nCores = 2)


## Most recent estimates for all stems on forest land grouped by user-defined areal units
ctSF <- seedling(fiaRI_mr,
            polys = countiesRI,
            returnSpatial = TRUE)
plot(ctSF) # Plot multiple variables simultaneously

plotFIA(ctSF, TPA) # Plot of TPA with color scale

# }
```
