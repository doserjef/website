# Estimate merchantable tree volume from the FIADB

Produces estimates of merchantable tree volume (i.e., merchantable bole
volume and sawlog volume) on a per acre basis from FIA data, along with
population estimates for each variable. Estimates can be produced for
regions defined within the FIA Database (e.g. counties), at the plot
level, or within user-defined areal units. Options to group estimates by
species, size class, and other variables defined in the FIADB. If
multiple reporting years (EVALIDs) are included in the data, estimates
will be output as a time series. If multiple states are represented by
the data, estimates will be output for the full region (all area
combined), unless specified otherwise (e.g. `grpBy = STATECD`).

## Usage

``` r
volume(db, grpBy = NULL, polys = NULL, returnSpatial = FALSE,
       bySpecies = FALSE, bySizeClass = FALSE, landType = "forest",
       treeType = "live", volType = "NET", method = "TI",
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

  variables from PLOT, PLOTGEOM, COND, or TREE tables to group estimates
  by (NOT quoted). Multiple grouping variables should be combined with
  [`c()`](https://rdrr.io/r/base/c.html), and grouping will occur
  heirarchically. For example, to produce seperate estimates for each
  ownership group within methods of stand regeneration, specify
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

- bySizeClass:

  logical; if TRUE, returns estimates grouped by size class (2-inch
  intervals, see [`makeClasses`](makeClasses.md) to compute different
  size class intervals).

- landType:

  character ("forest" or "timber"); Type of land that estimates will be
  produced for. Timberland is a subset of forestland (default) which has
  high site potential and non-reserve status (see details).

- treeType:

  character ("all", "live", "dead", or "gs"); Type of tree which
  estimates will be produced for. All includes all stems, live and dead,
  greater than 1 in. DBH. Live/Dead includes all stems greater than 1
  in. DBH which are live (default) or dead (leaning less than 45
  degrees), respectively. GS (growing-stock) includes live stems greater
  than 5 in. DBH which contain at least one 8 ft merchantable log.

- volType:

  character, one of: "NET", "SOUND", or "GROSS"; merchantable volume
  definition to use in estimation. See details for more info.

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
  compute estimates using mulitple wieghting schemes, and use `plotFIA`
  with `grp` set to `lambda` to produce moving average ribbon plots. See
  [Stanke et al 2020](https://research.fs.usda.gov/treesearch/59521) for
  examples.

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
  use with `customPSE`

.

- nCores:

  numeric; number of cores to use for parallel implementation. Check
  available cores using `detectCores`. Default = 1, serial processing.

## Details

**Estimation Details**

Estimation of forest variables follows the procedures documented in
Bechtold and Patterson (2005) and [Stanke et al
2020](https://research.fs.usda.gov/treesearch/59521). Specifically, tree
volume per acre is computed using a sample-based ratio-of-means
estimator of total volume / total land area within the domain of
interest.

Estimates of total merchantable volume are in units of cubic feet (CF),
and estimates of sawlog volume in terms of cubic feet and thousand board
feet (MBF; International 1/4 inch rule). FIA's net volume definition is
used by default (`volType = "NET"`): "net volume of wood in the central
stem of a sample tree 5.0 inches d.b.h., from a 1-foot stump to a
minimum 4-inch top diameter, or to where the central stem breaks into
limbs all of which are \<4.0 inches in diameter... Does not include
rotten, missing, and form cull (volume loss due to rotten, missing, and
form cull defect has been deducted)". Users opt to use two alternative
definitions: sound volume (`volType = "SOUND"`) or gross volume
(`volType = "GROSS"`). Sound volume is identical to net volume except
that sound includes volume from portions of the stem that can be
considered "form cull" under the net volume definition (e.g., sweep). In
contrast, gross volume is identical to the net volume definition except
that gross includes volume from portions of the stem that are rotten,
missing, and considered form cull.

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

- **BOLE_CF_ACRE**: estimate of mean merchantable bole volume per acre
  (cu.ft./acre)

- **SAW_CF_ACRE**: estimate of mean merchantable sawtimber volume per
  acre (cu.ft./acre)

- **SAW_MBF_ACRE**: estimate of mean merchantable sawtimber volume per
  acre (thousand board feet/acre; International 1/4 inch rule)

- **nPlots_TREE**: number of non-zero plots used to compute volume
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


# Most recent estimates for growing-stock trees on timber land
volume(db = fiaRI_mr,
       landType = 'timber',
       treeType = 'gs')
#> # A tibble: 1 × 10
#>    YEAR BOLE_CF_ACRE SAW_CF_ACRE SAW_MBF_ACRE BOLE_CF_ACRE_SE SAW_CF_ACRE_SE
#>   <dbl>        <dbl>       <dbl>        <dbl>           <dbl>          <dbl>
#> 1  2018        2208.       1521.         7.76            6.03           8.36
#> # ℹ 4 more variables: SAW_MBF_ACRE_SE <dbl>, nPlots_TREE <int>,
#> #   nPlots_AREA <int>, N <int>
# \donttest{

# Same as above, but using the gross volume definition
volume(db = fiaRI_mr,
       landType = 'timber',
       treeType = 'gs',
       volType = 'gross')
#> # A tibble: 1 × 10
#>    YEAR BOLE_CF_ACRE SAW_CF_ACRE SAW_MBF_ACRE BOLE_CF_ACRE_SE SAW_CF_ACRE_SE
#>   <dbl>        <dbl>       <dbl>        <dbl>           <dbl>          <dbl>
#> 1  2018        2480.       1730.         8.83            6.06           8.29
#> # ℹ 4 more variables: SAW_MBF_ACRE_SE <dbl>, nPlots_TREE <int>,
#> #   nPlots_AREA <int>, N <int>

# Same as above, but at the plot-level
volume(db = fiaRI_mr,
       landType = 'timber',
       treeType = 'gs',
       volType = 'gross',
       byPlot = TRUE)
#> # A tibble: 127 × 7
#>     YEAR pltID       PLT_CN BOLE_CF_ACRE SAW_CF_ACRE SAW_MBF_ACRE PROP_FOREST
#>    <int> <chr>        <dbl>        <dbl>       <dbl>        <dbl>       <dbl>
#>  1  2013 1_44_1_228 1.45e13         758.       290.         1.35        0.667
#>  2  2013 1_44_3_144 1.45e13         270.        48.5        0.285       0.170
#>  3  2013 1_44_7_126 2.47e14         131.        64.9        0.273       0.5  
#>  4  2013 1_44_7_169 1.45e13        5948.      5205.        23.1         1    
#>  5  2013 1_44_7_177 2.47e14         116.         0          0           0.25 
#>  6  2013 1_44_7_229 1.45e13        2407.      1815.         9.55        1    
#>  7  2013 1_44_7_245 1.45e13         291.       202.         1.22        0.25 
#>  8  2013 1_44_7_306 1.45e13        1447.      1239.         5.77        0.217
#>  9  2013 1_44_7_341 2.47e14        3662.      2847.        13.6         1    
#> 10  2013 1_44_7_61  1.45e13        1254.       247.         1.15        1    
#> # ℹ 117 more rows

# Estimates for live white pine ( > 12" DBH) on forested mesic sites (all available inventories)
volume(fiaRI_mr,
       treeType = 'live',
       treeDomain = SPCD == 129 & DIA > 12, # Species code for white pine
       areaDomain = PHYSCLCD %in% 21:29) # Mesic Physiographic classes
#> # A tibble: 1 × 10
#>    YEAR BOLE_CF_ACRE SAW_CF_ACRE SAW_MBF_ACRE BOLE_CF_ACRE_SE SAW_CF_ACRE_SE
#>   <dbl>        <dbl>       <dbl>        <dbl>           <dbl>          <dbl>
#> 1  2018         524.        507.         2.39            21.6           21.6
#> # ℹ 4 more variables: SAW_MBF_ACRE_SE <dbl>, nPlots_TREE <int>,
#> #   nPlots_AREA <int>, N <int>

# Most recent estimates grouped by stand age on forest land
# Make a categorical variable which represents stand age (grouped by 10 yr intervals)
fiaRI_mr$COND$STAND_AGE <- makeClasses(fiaRI_mr$COND$STDAGE, interval = 10)
volume(db = fiaRI_mr,
       grpBy = STAND_AGE)
#> # A tibble: 11 × 11
#>     YEAR STAND_AGE BOLE_CF_ACRE SAW_CF_ACRE SAW_MBF_ACRE BOLE_CF_ACRE_SE
#>    <dbl> <chr>            <dbl>       <dbl>        <dbl>           <dbl>
#>  1  2018 [0,10)            3.51          0         0         35.9       
#>  2  2018 [20,30)          60.1           0         0          0.00000166
#>  3  2018 [30,40)         866.          150.        0.847     21.2       
#>  4  2018 [40,50)        1128.          297.        1.58      17.6       
#>  5  2018 [50,60)        1923.          782.        4.58      14.3       
#>  6  2018 [60,70)        2624.         1405.        7.48       8.59      
#>  7  2018 [70,80)        2433.         1415.        6.93       8.76      
#>  8  2018 [80,90)        2887.         1971.       10.1        9.81      
#>  9  2018 [90,100)       2720.         1869.        9.90       9.68      
#> 10  2018 [100,110)      4305.         3582.       16.9       21.9       
#> 11  2018 [110,120]      3105.         2370.       13.0        0         
#> # ℹ 5 more variables: SAW_CF_ACRE_SE <dbl>, SAW_MBF_ACRE_SE <dbl>,
#> #   nPlots_TREE <int>, nPlots_AREA <int>, N <int>

# Estimates for snags greater than 20 in DBH on forestland for all
#  available inventories (time-series)
volume(db = fiaRI,
       landType = 'forest',
       treeType = 'dead',
       treeDomain = DIA > 20)
#> # A tibble: 6 × 10
#>    YEAR BOLE_CF_ACRE SAW_CF_ACRE SAW_MBF_ACRE BOLE_CF_ACRE_SE SAW_CF_ACRE_SE
#>   <dbl>        <dbl>       <dbl>        <dbl>           <dbl>          <dbl>
#> 1  2013        0.508           0            0            75.9            NaN
#> 2  2014        0.507           0            0            75.7            NaN
#> 3  2015        0.495           0            0            76.9            NaN
#> 4  2016        0.444           0            0            84.3            NaN
#> 5  2017        4.45            0            0            85.1            NaN
#> 6  2018        7.06            0            0            65.2            NaN
#> # ℹ 4 more variables: SAW_MBF_ACRE_SE <dbl>, nPlots_TREE <int>,
#> #   nPlots_AREA <int>, N <int>

# Most recent estimates for live stems on forest land by species
volume(db = fiaRI_mr,
       landType = 'forest',
       treeType = 'live',
       bySpecies = TRUE)
#> # A tibble: 45 × 13
#>     YEAR  SPCD COMMON_NAME SCIENTIFIC_NAME BOLE_CF_ACRE SAW_CF_ACRE SAW_MBF_ACRE
#>    <dbl> <dbl> <chr>       <chr>                  <dbl>       <dbl>        <dbl>
#>  1  2018    12 balsam fir  Abies balsamea         0.377       0          0      
#>  2  2018    43 Atlantic w… Chamaecyparis …        2.35        0.819      0.00314
#>  3  2018    68 eastern re… Juniperus virg…        1.26        0          0      
#>  4  2018   126 pitch pine  Pinus rigida          57.4        47.5        0.209  
#>  5  2018   129 eastern wh… Pinus strobus        550.        492.         2.31   
#>  6  2018   130 Scotch pine Pinus sylvestr…        0.154       0          0      
#>  7  2018   261 eastern he… Tsuga canadens…       40.8        24.3        0.105  
#>  8  2018   313 boxelder    Acer negundo           0.600       0          0      
#>  9  2018   316 red maple   Acer rubrum          498.        154.         0.906  
#> 10  2018   317 silver map… Acer saccharin…        3.38        0          0      
#> # ℹ 35 more rows
#> # ℹ 6 more variables: BOLE_CF_ACRE_SE <dbl>, SAW_CF_ACRE_SE <dbl>,
#> #   SAW_MBF_ACRE_SE <dbl>, nPlots_TREE <int>, nPlots_AREA <int>, N <int>

# Same as above, but implemented in parallel (much quicker)
# parallel::detectCores(logical = FALSE) # 4 cores available, we will take 2
# volume(db = fiaRI_mr,
#        landType = 'forest',
#        treeType = 'live',
#        bySpecies = TRUE,
#        nCores = 2)


# Most recent estimates for all stems on forest land grouped by user-defined areal units
ctSF <- volume(fiaRI_mr,
               polys = countiesRI,
               returnSpatial = TRUE)
plot(ctSF) # Plot multiple variables simultaneously
#> Warning: plotting the first 9 out of 12 attributes; use max.plot = 12 to plot all

plotFIA(ctSF, SAW_MBF_ACRE) # Plot of saw volume, in board feet

# }
```
