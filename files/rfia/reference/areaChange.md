# Estimate land area change from the FIADB

Produces estimates of annual net and component change in land area
(acreage) from FIA data. Estimates can be produced for regions defined
within the FIA Database (e.g. counties), at the plot level, or within
user-defined areal units. Options to group estimates by land type and
other variables defined in the FIADB. If multiple reporting years
(EVALIDs) are included in the data, estimates will be output as a time
series. If multiple states are represented by the data, estimates will
be output for the full region (all area combined), unless specified
otherwise (e.g. grpBy = STATECD).

## Usage

``` r
areaChange(db, grpBy = NULL, polys = NULL, returnSpatial = FALSE,
           byLandType = FALSE, landType = "forest", method = "TI",
           lambda = 0.5, treeDomain = NULL, areaDomain = NULL,
           variance = FALSE, byPlot = FALSE,
           condList = FALSE, chngType = 'net', nCores = 1)
```

## Arguments

- db:

  `FIA.Database` or `Remote.FIA.Database` object produced from
  [`readFIA()`](readFIA.md) or [`getFIA()`](getFIA.md). If a
  `Remote.FIA.Database`, data will be read in and processed
  state-by-state to conserve RAM (see details for an example).

- grpBy:

  variables from PLOT, PLOTGEOM, or COND tables to group estimates by
  (NOT quoted). Multiple grouping variables should be combined with
  [`c()`](https://rdrr.io/r/base/c.html), and grouping will occur
  hierarchically. For example, to produce separate estimates for each
  ownership group within methods of stand regeneration, specify
  `c(STDORGCD, OWNGRPCD)`.

- polys:

  `sp` or `sf` Polygon/MultiPolgyon object; Areal units to bin data for
  estimation. Separate estimates will be produces for region encompassed
  by each areal unit. FIA plot locations will be reprojected to match
  projection of `polys` object.

- returnSpatial:

  logical; if TRUE, merge population estimates with `polys` and return
  as `sf` multipolygon object. When `byPlot = TRUE`, return plot-level
  estimates as `sf` spatial points.

- byLandType:

  logical; if TRUE, return estimates grouped by individual land type
  classes ("timberland", "non-timberland forest", "non-forest", and
  "water").

- landType:

  character, one of: "forest", "non-forest", "water", or "all"; Type of
  land that estimates will be produced for. Timberland is a subset of
  forestland (default) which has high site potential and non-reserve
  status (see details).

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
  compute estimates using mulitple weighting schemes, and use
  [`plotFIA()`](plotFIA.md) with `grp` set to `lambda` to produce moving
  average ribbon plots. See [Stanke et al
  2020](https://research.fs.usda.gov/treesearch/59521) for examples.

- treeDomain:

  logical predicates defined in terms of the variables in PLOT, TREE,
  and/or COND tables. Used to define the type of trees for which
  estimates will be produced (e.g. DBH greater than 20 inches:
  `DIA > 20`, Dominant/Co-dominant crowns only: `CCLCD %in% 2:3`.
  Multiple conditions are combined with `&` (and) or `|` (or). Only
  trees where the condition evaluates to TRUE are used in producing
  estimates. Should NOT be quoted.

- areaDomain:

  logical predicates defined in terms of the variables in PLOT and/or
  COND tables. Used to define the area for which estimates will be
  produced (e.g. within 1 mile of improved road: `RDDISTCD %in% 1:6`,
  Hard maple/basswood forest type: `FORTYPCD == 805`. Multiple
  conditions are combined with `&` (and) or `|` (or). Only plots within
  areas where the condition evaluates to TRUE are used in producing
  estimates. Should NOT be quoted.

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

- chngType:

  character, one of "net" or "component"; if "net", produce estimates of
  net change in land area, and if "component", produce estimates of
  component change in land area (i.e., showing all shifts across
  classified attributes).

- nCores:

  numeric; number of cores to use for parallel implementation. Check
  available cores using `detectCores()`. Default = 1, serial processing.

## Details

**Estimation Details**

Estimation of forest variables follows the procedures documented in
Bechtold and Patterson (2005) and [Stanke et al
2020](https://research.fs.usda.gov/treesearch/59521).

Estimates are returned in terms of *net* annual change in land area by
default, however users may choose to estimate components of land area
change by setting `chngType = 'component'`. For example, imagine we are
interested in estimating the change in forestland area across a region.
During our sampling period, 4000 acres of forestland was *diverted* to
non-forest and an additional 6000 acres of non-forest *reverted* to
forestland. rFIA considers these shifts in land classifications change
*components*, and hence these point estimates would be returned when
`chngType = 'component'`. However, we are often interested in *net*
change in land area, rather than individual components. Here net change
in forestland area is +2000 acres (6000-4000) and represents the net
result of diversion and reversion processes in the region over our study
period.

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

- **PERC_CHNG**: estimate of annual percent change in land area within
  domain of interest (% of previous)

- **AREA_CHNG**: estimate of annual change in land area within domain of
  interest (acres)

- **PREV_AREA**: estimate of total land area within domain of interest
  at first measurement (acres)

- **nPlots**: number of non-zero plots used to compute area change
  estimates

Importantly, when `chngType = 'component'`, individual change components
will be returned. If no grouping variables are specified in `grpBy`,
results will be grouped by variables named **STATUS1** and **STATUS2**,
indicating the land classification at first and second measurements,
respectively. Otherwise, if `grpBy` is specified, change components will
be estimated for all shifts in land area across classified attributes
represented by the variables (first and second measurements again
denoted by the suffix 1 and 2). This is also the case for when
additional criteria are specified to the tree, condition, or area
domains using `treeDomain` and/or `areaDomain`.

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

# Most recent estimates of change in forested area in RI
areaChange(db = fiaRI_mr)
#> # A tibble: 1 × 9
#>    YEAR PERC_CHNG AREA_CHNG PREV_AREA PERC_CHNG_SE AREA_CHNG_SE PREV_AREA_SE
#>   <dbl>     <dbl>     <dbl>     <dbl>        <dbl>        <dbl>        <dbl>
#> 1  2018   -0.0656     -238.   363831.         533.         535.         3.85
#> # ℹ 2 more variables: nPlots_AREA <int>, N <int>

# \donttest{
# Same as above grouped by land class
areaChange(db = fiaRI_mr, byLandType = TRUE)
#> # A tibble: 4 × 10
#>    YEAR landType         PERC_CHNG AREA_CHNG PREV_AREA PERC_CHNG_SE AREA_CHNG_SE
#>   <dbl> <chr>                <dbl>     <dbl>     <dbl>        <dbl>        <dbl>
#> 1  2018 Non-Forest           0.274      849.   309804.        137.         136. 
#> 2  2018 Non-Timber Fore…     0            0     18404.        NaN          NaN  
#> 3  2018 Timber               0.177      602.   340739.        196.         194. 
#> 4  2018 Water               -1.28     -1451.   113025.         61.1         65.6
#> # ℹ 3 more variables: PREV_AREA_SE <dbl>, nPlots_AREA <int>, N <int>

# Estimates for change in forest area where stems greater than 20 in DBH
# occur for all available inventories (time-series)
areaChange(db = fiaRI,
           landType = 'forest',
           treeDomain = DIA > 20)
#> # A tibble: 6 × 9
#>    YEAR PERC_CHNG AREA_CHNG PREV_AREA PERC_CHNG_SE AREA_CHNG_SE PREV_AREA_SE
#>   <dbl>     <dbl>     <dbl>     <dbl>        <dbl>        <dbl>        <dbl>
#> 1  2013      6.39     7571.   118470.         37.6         31.5         15.0
#> 2  2014      6.24     7940.   127280.         37.6         31.6         14.5
#> 3  2015      4.20     5928.   141209.         42.2         37.2         13.2
#> 4  2016      3.46     5102.   147485.         44.1         39.6         12.6
#> 5  2017      3.82     5725.   149807.         39.7         34.8         12.3
#> 6  2018      4.42     6535.   147855.         36.0         30.9         12.4
#> # ℹ 2 more variables: nPlots_AREA <int>, N <int>

# Return estimates at the plot-level
areaChange(db = fiaRI,
           byPlot = TRUE)
#> # A tibble: 352 × 6
#>     YEAR pltID       PLT_CN REMPER PROP_CHNG PREV_PROP_FOREST
#>    <int> <chr>        <dbl>  <dbl>     <dbl>            <dbl>
#>  1  2009 1_44_1_155 1.45e14    4           0                0
#>  2  2009 1_44_1_326 1.45e14    1.8         0                0
#>  3  2009 1_44_3_135 1.45e14    4.2         0                1
#>  4  2009 1_44_3_152 1.45e14    4.7         0                0
#>  5  2009 1_44_3_19  1.45e14    3.9         0                0
#>  6  2009 1_44_3_323 1.45e14    1.8         0                0
#>  7  2009 1_44_3_55  1.45e14    4.7         0                0
#>  8  2009 1_44_5_130 1.45e14    4.6         0                0
#>  9  2009 1_44_5_257 1.45e14    3.8         0                0
#> 10  2009 1_44_5_302 1.45e14    4.9         0                0
#> # ℹ 342 more rows
  # }
```
