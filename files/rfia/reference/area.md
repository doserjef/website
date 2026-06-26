# Estimate forest land area from FIADB

Produces estimates of total forest area (acreage) from FIA data.
Estimates can be produced for regions defined within the FIA Database
(e.g. counties), at the plot level, or within user-defined areal units.
Options to group estimates by variables defined in the FIADB. If
multiple reporting years (EVALIDs) are included in the data, estimates
will be output as a time series. If multiple states are represented by
the data, estimates will be output for the full region (all area
combined), unless specified otherwise (e.g. grpBy = STATECD).

## Usage

``` r
area(db, grpBy = NULL, polys = NULL, returnSpatial = FALSE,
     byLandType = FALSE, landType = 'forest',  method = 'TI',
     lambda = 0.5, treeDomain = NULL, areaDomain = NULL,
     totals = TRUE, variance = FALSE, byPlot = FALSE,
     condList = FALSE, nCores = 1)
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
  estimation. Separate estimates will be produced for regions
  encompassed by each areal unit. FIA plot locations will be reprojected
  to match projection of `polys` object.

- returnSpatial:

  logical; if TRUE, merge population estimates with `polys` and return
  as `sf` multipolygon object. When `byPlot = TRUE`, return plot-level
  estimates as `sf` spatial points.

- byLandType:

  logical; if TRUE, return estimates grouped by individual land type
  classes ("timberland", "non-timberland forest", "non-forest", and
  "water").

- landType:

  character, one of: "forest", "timber", "non-forest", "water", or
  "all"; Type of land that estimates will be produced for. Timberland is
  a subset of forestland (default) which has high site potential and
  non-reserve status (see details).

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
  `DIA > 20`, Dominant/Co-dominant crowns only: `CCLCD %in% 2:3`.
  Multiple conditions are combined with `&` (and) or `|` (or). Only
  plots with at least one tree where the condition evaluates to TRUE are
  used in producing estimates. Should NOT be quoted.

- areaDomain:

  logical predicates defined in terms of the variables in PLOT and/or
  COND tables. Used to define the area for which estimates will be
  produced (e.g. within 1 mile of improved road: `RDDISTCD %in% 1:6`,
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

- condList:

  logical; if TRUE, returns condition-level summaries intended for
  subsequent use with [`customPSE()`](customPSE.md).

- nCores:

  numeric; number of cores to use for parallel implementation. Check
  available cores using `detectCores`. Default = 1, serial processing.

## Details

**Estimation Details**

Estimation of forest variables follows the procedures documented in
Bechtold and Patterson (2005) and [Stanke et al
2020](https://research.fs.usda.gov/treesearch/59521). Area percentages
in the domain of interest are represented as the total number of forest
plots containing trees of a particular type (live, white pine) / total
number of forest plots within the region and area domain. The total
populations (e.g., the denominator of the ratio estimate) used to
compute these percentages will not change by changing treeDomain.
Instead, specifying treeDomain will change the specific plots used to
determine the total area (e.g., the numerator of the ratio estimate)
that meets the given tree requirements. The total population will change
if the user specifies an areaDomain or if changing landType.

Note that when using `grpBy` with a tree-level parameter (e.g., SPCD),
the total area across all groups will NOT be equal to the total area of
the given land type. This is because the groups are not mutually
exclusive (e.g., a plot can contain more than one species and thus be
counted in the area calculations for multiple SPCDs). If specifying
`grpBy` with a PLOT or COND level variable (e.g., forest type
\[FORTYPCD\]), the groups are mutually exclusive and the area across all
groups will sum to the total area of the given land type. When
specifying `grpBy` or `treeDomain`, percentages are calculated relative
to the total amount of land area specified by `landType`. For example,
if setting `treeDomain = SPCD == 121` and `landType = 'forest'`, the
area percentage returned will represent the estimated percentage of
forest land that contains at least one longleaf pine (`SPCD == 121`)
tree.

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
documentation of [`readFIA()`](readFIA.md) for examples of how to set up
a `Remote.FIA.Database`. As a reference, we have used rFIA's
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
values are returned for each plot (proportion of plot in domain of
interest; `PLOT_STATUS_CD = 1` when forest exists at the plot location).
All variables with names ending in `SE`, represent the estimate of
sampling error (%) of the variable. When `variance = TRUE`, variables
ending in `VAR` denote the variance of the variable and `N` is the total
sample size (i.e., including non-zero plots).

- **YEAR**: reporting year associated with estimates

- **PERC_AREA**: percent of area within the domain of interest

- **AREA_TOTAL**: estimate of total area within domain of interest
  (acres)

- **nPlots_AREA_NUM**: number of non-zero plots used to compute land
  area estimates within the domain of interest

- **nPlots_AREA_DEN**: number of non-zero plots used to compute land
  area estimates

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

Hunter Stanke, Andrew Finley, Jeffrey W. Doser

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

# Most recent estimates of forested area in RI
area(db = fiaRI_mr)
#> # A tibble: 1 × 8
#>    YEAR PERC_AREA AREA_TOTAL PERC_AREA_SE AREA_TOTAL_SE nPlots_AREA_NUM
#>   <dbl>     <dbl>      <dbl>        <dbl>         <dbl>           <int>
#> 1  2018       100    366959.            0          3.53             127
#> # ℹ 2 more variables: nPlots_AREA_DEN <int>, N <int>

# \donttest{
# Same as above grouped by land class
area(db = fiaRI_mr, byLandType = TRUE)
#> # A tibble: 4 × 9
#>    YEAR landType PERC_AREA AREA_TOTAL PERC_AREA_SE AREA_TOTAL_SE nPlots_AREA_NUM
#>   <dbl> <chr>        <dbl>      <dbl>        <dbl>         <dbl>           <int>
#> 1  2018 Non-For…    18.3       82338.        11.8          13.5               48
#> 2  2018 Non-Tim…     3.95      17814.        36.6          36.6                7
#> 3  2018 Timber      77.4      349145.         3.25          4.03             121
#> 4  2018 Water        0.383      1728.        68.7          69.0                3
#> # ℹ 2 more variables: nPlots_AREA_DEN <int>, N <int>

# Estimates for area where stems greater than 20 in DBH occur for
# available inventories (time-series)
area(db = fiaRI,
     landType = 'forest',
     treeDomain = DIA > 20)
#> # A tibble: 6 × 8
#>    YEAR PERC_AREA AREA_TOTAL PERC_AREA_SE AREA_TOTAL_SE nPlots_AREA_NUM
#>   <dbl>     <dbl>      <dbl>        <dbl>         <dbl>           <int>
#> 1  2013      41.7    153019.        11.1          11.5               47
#> 2  2014      44.6    163922.        10.5          11.1               49
#> 3  2015      46.2    170891.        10.1          10.7               51
#> 4  2016      48.8    178701.         9.50         10.1               54
#> 5  2017      52.0    191500.         8.82          9.46              58
#> 6  2018      52.7    193487.         8.59          9.25              60
#> # ℹ 2 more variables: nPlots_AREA_DEN <int>, N <int>

# Same as above, but implemented in parallel (much quicker)
# parallel::detectCores(logical = FALSE)
# area(db = fiaRI,
#      landType = 'forest',
#      treeDomain = DIA > 20,
#      nCores =2)

# Return estimates at the plot-level
area(db = fiaRI,
     byPlot = TRUE)
#> # A tibble: 215 × 5
#>     YEAR pltID      PLOT_STATUS_CD  PLT_CN PROP_FOREST
#>    <int> <chr>               <int>   <dbl>       <dbl>
#>  1  2009 1_44_3_129              1 1.45e14       1    
#>  2  2009 1_44_3_135              1 1.45e14       1    
#>  3  2009 1_44_3_52               1 1.45e14       1    
#>  4  2009 1_44_7_113              1 1.45e14       1    
#>  5  2009 1_44_7_156              1 1.45e14       0.913
#>  6  2009 1_44_7_194              1 1.45e14       0.341
#>  7  2009 1_44_7_218              1 1.45e14       0.75 
#>  8  2009 1_44_7_254              1 1.45e14       0.931
#>  9  2009 1_44_7_276              1 1.45e14       0.530
#> 10  2009 1_44_7_283              1 1.45e14       0.227
#> # ℹ 205 more rows
  # }
```
