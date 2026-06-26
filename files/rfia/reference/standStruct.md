# Estimate forest structural stage distribution from FIADB

Estimates the stand structural stage distribution of an area of forest/
timberland from FIA data. Estimates can be produced for regions defined
within the FIA Database (e.g. counties), at the plot level, or within
user-defined areal units. If multiple reporting years (EVALIDs) are
included in the data, estimates will be output as a time series. Easy
options to implement parallel processing. Stand structural stage is
classified for each stand (condition) using a method similar to that of
Frelich and Lorimer (1991) but substitute basal area for exposed crown
area (see Details, References). If multiple states are represented by
the data, estimates will be output for the full region (all area
combined), unless specified otherwise (e.g. `grpBy = STATECD`).

## Usage

``` r
standStruct(db, grpBy = NULL, polys = NULL, returnSpatial = FALSE,
            landType = 'forest', method = 'TI', lambda = 0.5,
            areaDomain = NULL, totals = FALSE, variance = FALSE,
            byPlot = FALSE, nCores = 1)
```

## Arguments

- db:

  `FIA.Database` or `Remote.FIA.Database` object produced from
  [`readFIA`](readFIA.md) or [`getFIA`](getFIA.md). If a
  `Remote.FIA.Database`, data will be read in and processed
  state-by-state to conserve RAM (see details for an example).

- grpBy:

  variables from PLOT, PLOTGEOM, or COND tables to group estimates by
  (NOT quoted). Multiple grouping variables should be combined with
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

- landType:

  character ("forest" or "timber"); Type of land which estimates will be
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
  compute estimates using mulitple wieghting schemes, and use `plotFIA`
  with `grp` set to `lambda` to produce moving average ribbon plots. See
  [Stanke et al 2020](https://research.fs.usda.gov/treesearch/59521) for
  examples.

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

- nCores:

  numeric; number of cores to use for parallel implementation. Check
  available cores using `detectCores`. Default = 1, serial processing.

## Details

**Estimation Details**

Estimation of forest variables follows the procedures documented in
Bechtold and Patterson (2005) and [Stanke et al
2020](https://research.fs.usda.gov/treesearch/59521).

Specifically, the percent land area occupied by forest in each stand
structural stage are computed using a sample-based ratio-of-means
estimator of total area in structural stage / total land area within the
domain of interest. Stand structural stage is classified based on the
relative basal area of canopy stems in various size classes (defined
below). Only stems which are identified on-site as dominant,
subdominant, or intermdediate crown-classes are used to classify stand
structural stage.

**Diameter Classes**

- *Pole*: 12.7 - 25.9 cm

- *Mature*: 26 - 45.9 cm

- *Large*: 46+ cm

**Structural Stage Classification**

- *Pole Stage*: \> 67% BA in pole and mature classes, with more BA in
  pole than mature.

- *Mature Stage*: \> 67% BA in pole and mature classes, with more BA in
  mature than pole OR \> 67% BA in mature and large classes, with more
  BA in mature.

- *Late-Successional Stage*: \> 67% BA in mature and large classes, with
  more in large

- *Mosiac*: Any plot not meeting above criteria.

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
values are returned for each plot (structural stage of dominant stand
type; `PLOT_STATUS_CD = 1` when forest exists at the plot location). All
variables with names ending in `SE`, represent the estimate of sampling
error (%) of the variable. When `variance = TRUE`, variables ending in
`VAR` denote the variance of the variable and `N` is the total sample
size (i.e., including non-zero plots).

- **STAGE**: Stand structural stage.

- **PERC**: % land area in each structural stage.

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

Frelich, L. E., and Lorimer, C. G. (1991). Natural Disturbance Regimes
in Hemlock-Hardwood Forests of the Upper Great Lakes Region. Ecological
Monographs, 61(2), 145-164. doi:10.2307/1943005

Goodell, L., and Faber-Langendoen, D. (2007). Development of stand
structural stage indices to characterize forest condition in Upstate New
York. Forest Ecology and Management, 249(3), 158-170.
doi:10.1016/j.foreco.2007.04.052

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
## Load data from rFIA package
data(fiaRI)
data(countiesRI)

## Most recents subset
fiaRI_mr <- clipFIA(fiaRI)

## Calculate structural stage distribution of all forestland
standStruct(fiaRI_mr)
#> # A tibble: 4 × 6
#>    YEAR STAGE  COVER_PCT COVER_PCT_SE nPlots_AREA     N
#>   <dbl> <chr>      <dbl>        <dbl>       <int> <int>
#> 1  2018 LATE      18.8          19.1          127   199
#> 2  2018 MATURE    58.8           7.61         127   199
#> 3  2018 MOSAIC     0.912        64.0          127   199
#> 4  2018 POLE      21.5          16.6          127   199

# \donttest{
## Same as above at plot-level (classify stands)
standStruct(fiaRI_mr,
            byPlot = TRUE)
#> # A tibble: 136 × 6
#>     YEAR pltID       PLT_CN STAGE  PROP_STAGE PROP_FOREST
#>    <int> <chr>        <dbl> <chr>       <dbl>       <dbl>
#>  1  2013 1_44_1_228 1.45e13 POLE        0.667       0.667
#>  2  2013 1_44_3_144 1.45e13 MATURE      0.170       0.170
#>  3  2013 1_44_7_126 2.47e14 MATURE      0.5         0.5  
#>  4  2013 1_44_7_169 1.45e13 MATURE      1           1    
#>  5  2013 1_44_7_177 2.47e14 POLE        0.25        0.25 
#>  6  2013 1_44_7_229 1.45e13 MATURE      1           1    
#>  7  2013 1_44_7_245 1.45e13 MATURE      0.25        0.25 
#>  8  2013 1_44_7_306 1.45e13 MATURE      0.217       0.217
#>  9  2013 1_44_7_341 2.47e14 MATURE      1           1    
#> 10  2013 1_44_7_61  1.45e13 POLE        1           1    
#> # ℹ 126 more rows

## Calculate structural stage distribution of all forestland by owner group, over time
standStruct(fiaRI_mr,
            grpBy = OWNGRPCD)
#> # A tibble: 8 × 7
#>    YEAR OWNGRPCD STAGE  COVER_PCT COVER_PCT_SE nPlots_AREA     N
#>   <dbl>    <int> <chr>      <dbl>        <dbl>       <int> <int>
#> 1  2018       30 LATE      17.4          35.9           40   199
#> 2  2018       30 MATURE    58.8          13.6           40   199
#> 3  2018       30 MOSAIC     0.729       102.            40    32
#> 4  2018       30 POLE      23.0          28.6           40   199
#> 5  2018       40 LATE      19.4          22.5           90   167
#> 6  2018       40 MATURE    58.8           9.06          90   199
#> 7  2018       40 MOSAIC     0.993        77.8           90   167
#> 8  2018       40 POLE      20.8          20.6           90   167

## Calculate structural stage distribution of all forestland on xeric sites, over time
standStruct(fiaRI_mr,
            areaDomain = PHYSCLCD %in% c(11:19))
#> # A tibble: 2 × 6
#>    YEAR STAGE  COVER_PCT COVER_PCT_SE nPlots_AREA     N
#>   <dbl> <chr>      <dbl>        <dbl>       <int> <int>
#> 1  2018 MOSAIC         0          NaN         127   199
#> 2  2018 POLE         100            0         127    32

## Calculate structural stage distribution of all forestland, over time
standStruct(fiaRI)
#> # A tibble: 24 × 6
#>     YEAR STAGE  COVER_PCT COVER_PCT_SE nPlots_AREA     N
#>    <dbl> <chr>      <dbl>        <dbl>       <int> <int>
#>  1  2013 LATE       13.5         23.6          123   197
#>  2  2013 MATURE     62.1          7.00         123   197
#>  3  2013 MOSAIC      1.48        66.0          123   197
#>  4  2013 POLE       22.9         16.6          123   197
#>  5  2014 LATE       13.5         23.5          123   196
#>  6  2014 MATURE     62.6          7.05         123   196
#>  7  2014 MOSAIC      1.20        77.6          123   196
#>  8  2014 POLE       22.7         16.7          123   196
#>  9  2015 LATE       14.1         22.6          124   194
#> 10  2015 MATURE     60.7          7.30         124   194
#> # ℹ 14 more rows

# }
```
