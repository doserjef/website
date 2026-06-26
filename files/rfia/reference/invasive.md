# Estimate invasive species coverage from FIADB

Produces estimates of areal coverage of invasive species from the Forest
Inventory and Analysis Database. Estimates can be produced for regions
defined within the FIA Database (e.g. counties), at the plot level, or
within user-defined areal units. All estimates are returned by species
although can be grouped by other variables defined in the FIADB. If
multiple reporting years (EVALIDs) are included in the data, estimates
will be output as a time series. If multiple states are represented by
the data, estimates will be output for the full region (all area
combined), unless specified otherwise (e.g. `grpBy = STATECD`).

## Usage

``` r
invasive(db, grpBy = NULL, polys = NULL, returnSpatial = FALSE, landType = "forest",
         method = 'TI', lambda = 0.5, areaDomain = NULL, totals = FALSE,
         variance = FALSE, byPlot = FALSE, nCores = 1)
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

Specifically, percent areal coverage is computed using a sample-based
ratio-of-means estimator of total invasive coverage area / total land
area within the domain of interest. Estimates of areal coverage of
individual invasive species should NOT be summed to produce estimates of
areal coverage by ALL invasive species, as areal coverage by species is
not mutually exclusive (multiple species may occur in the same area).
Current FIA data collection protocols do not allow for the unbiased
estimation of areal coverage by all invasive species.

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
values are returned for each plot (proportion of plot in domain of
interest; `PLOT_STATUS_CD = 1` when forest exists at the plot location).
All variables with names ending in `SE`, represent the estimate of
sampling error (%) of the variable. When `variance = TRUE`, variables
ending in `VAR` denote the variance of the variable and `N` is the total
sample size (i.e., including non-zero plots).

- **YEAR**: reporting year associated with estimates

- **SYMBOL**: unique species ID from NRCS Plant Reference Guide

- **SCIENTIFIC_NAME**: scientific name of the species

- **COMMON_NAME**: common name of the species

- **COVER_PCT**: estimate of percent areal coverage of the species

- **COVER_AREA**: estimate of areal coverage of the species (acres)

- **AREA**: estimate of total land area (acres)

- **nPlots_INV**: number of non-zero plots used to compute invasive
  coverage estimates

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

# \donttest{
## Most recent estimates on forest land
invasive(db = fiaRI_mr,
         landType = 'forest')
#> # A tibble: 6 × 9
#>    YEAR SYMBOL SCIENTIFIC_NAME     COMMON_NAME COVER_PCT COVER_PCT_SE nPlots_INV
#>   <dbl> <chr>  <chr>               <chr>           <dbl>        <dbl>      <int>
#> 1  2018 BETH   Berberis thunbergii Japanese b…    0.0561         73.5          2
#> 2  2018 CEOR7  Celastrus orbicula… Oriental b…    0.767          85.7          3
#> 3  2018 FRAL4  Frangula alnus      glossy buc…    0.135          91.1          1
#> 4  2018 POCU6  Polygonum cuspidat… Japanese k…    0.103         105.           1
#> 5  2018 RHCA3  Rhamnus cathartica  common buc…    0.0248        105.           1
#> 6  2018 ROMU   Rosa multiflora     multiflora…    0.341          66.5          3
#> # ℹ 2 more variables: nPlots_AREA <int>, N <int>

## Most recent estimates on forest land
invasive(db = fiaRI_mr,
         landType = 'forest',
         byPlot = TRUE)
#> # A tibble: 11 × 8
#>     PLT_CN  YEAR pltID      SYMBOL SCIENTIFIC_NAME    COMMON_NAME PROP_INV_COVER
#>      <dbl> <int> <chr>      <chr>  <chr>              <chr>                <dbl>
#>  1 1.45e13  2013 1_44_7_169 CEOR7  Celastrus orbicul… Oriental b…        0.01   
#>  2 1.45e13  2013 1_44_7_169 FRAL4  Frangula alnus     glossy buc…        0.01   
#>  3 1.45e13  2013 1_44_7_169 ROMU   Rosa multiflora    multiflora…        0.01   
#>  4 1.68e14  2014 1_44_7_254 CEOR7  Celastrus orbicul… Oriental b…        0.0615 
#>  5 1.68e14  2014 1_44_7_254 POCU6  Polygonum cuspida… Japanese k…        0.03   
#>  6 1.68e14  2014 1_44_7_254 RHCA3  Rhamnus cathartica common buc…        0.00723
#>  7 1.68e14  2015 1_44_7_113 BETH   Berberis thunberg… Japanese b…        0.01   
#>  8 1.68e14  2015 1_44_7_113 ROMU   Rosa multiflora    multiflora…        0.01   
#>  9 3.74e14  2017 1_44_5_102 BETH   Berberis thunberg… Japanese b…        0.00423
#> 10 3.74e14  2017 1_44_5_102 CEOR7  Celastrus orbicul… Oriental b…        0.0338 
#> 11 3.74e14  2017 1_44_5_102 ROMU   Rosa multiflora    multiflora…        0.0480 
#> # ℹ 1 more variable: PROP_FOREST <dbl>

## Same as above, but implemented in parallel (much quicker)
# parallel::detectCores(logical = FALSE) # 4 cores available, we will take 2
# invasive(db = fiaRI_mr,
#          landType = 'forest',
#          nCores = 2)

## Most recent estimates grouped by stand age on forest land
# Make a categorical variable which represents stand age (grouped by 10 yr intervals)
fiaRI_mr$COND$STAND_AGE <- makeClasses(fiaRI_mr$COND$STDAGE, interval = 10)
invasive(db = fiaRI_mr,
         grpBy = STAND_AGE)
#> # A tibble: 10 × 10
#>     YEAR STAND_AGE SYMBOL SCIENTIFIC_NAME     COMMON_NAME COVER_PCT COVER_PCT_SE
#>    <dbl> <chr>     <chr>  <chr>               <chr>           <dbl>        <dbl>
#>  1  2018 [70,80)   CEOR7  Celastrus orbicula… Oriental b…    1.27           90.5
#>  2  2018 [70,80)   FRAL4  Frangula alnus      glossy buc…    0.253          82.1
#>  3  2018 [70,80)   POCU6  Polygonum cuspidat… Japanese k…    0.192          99.1
#>  4  2018 [70,80)   RHCA3  Rhamnus cathartica  common buc…    0.0464         99.1
#>  5  2018 [70,80)   ROMU   Rosa multiflora     multiflora…    0.0843         82.1
#>  6  2018 [80,90)   BETH   Berberis thunbergii Japanese b…    0.106           0  
#>  7  2018 [80,90)   CEOR7  Celastrus orbicula… Oriental b…    0.845           0  
#>  8  2018 [80,90)   ROMU   Rosa multiflora     multiflora…    2.40            0  
#>  9  2018 [90,100)  BETH   Berberis thunbergii Japanese b…    0.125          71.8
#> 10  2018 [90,100)  ROMU   Rosa multiflora     multiflora…    0.125          71.8
#> # ℹ 3 more variables: nPlots_INV <int>, nPlots_AREA <int>, N <int>

## Estimates on forested mesic sites (all available inventories)
invasive(fiaRI,
         areaDomain = PHYSCLCD %in% 21:29) # Mesic Physiographic classes
#> # A tibble: 37 × 9
#>     YEAR SYMBOL SCIENTIFIC_NAME    COMMON_NAME COVER_PCT COVER_PCT_SE nPlots_INV
#>    <dbl> <chr>  <chr>              <chr>           <dbl>        <dbl>      <int>
#>  1  2013 BETH   Berberis thunberg… Japanese b…    0.0117         89.6          1
#>  2  2013 CEOR7  Celastrus orbicul… Oriental b…    0.156          67.7          5
#>  3  2013 ELUM   Elaeagnus umbella… autumn oli…    0.0247        114.           1
#>  4  2013 FRAL4  Frangula alnus     glossy buc…    2.23           96.6          4
#>  5  2013 RHCA3  Rhamnus cathartica common buc…    0.0117         89.6          1
#>  6  2013 ROMU   Rosa multiflora    multiflora…    0.166          60.8          4
#>  7  2013 ROPS   Robinia pseudoaca… black locu…    0.173         114.           1
#>  8  2014 BETH   Berberis thunberg… Japanese b…    0.0116         90.6          1
#>  9  2014 CEOR7  Celastrus orbicul… Oriental b…    0.393          73.7          4
#> 10  2014 FRAL4  Frangula alnus     glossy buc…    2.46           93.5          3
#> # ℹ 27 more rows
#> # ℹ 2 more variables: nPlots_AREA <int>, N <int>
# }
```
