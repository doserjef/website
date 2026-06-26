# Estimate vegation cover by canopy layer from FIADB

Produces estimates of vegetation cover by canopy layer and species
growth form from the Forest Inventory and Analysis Database. Estimates
can be produced for regions defined within the FIA Database (e.g.
counties), at the plot level, or within user-defined areal units. If
multiple reporting years (EVALIDs) are included in the data, estimates
will be output as a time series. If multiple states are represented by
the data, estimates will be output for the full region (all area
combined), unless specified otherwise (e.g. `grpBy = STATECD`). Easy
options to implement parallel processing.

## Usage

``` r
vegStruct(db, grpBy = NULL, polys = NULL,
          returnSpatial = FALSE, landType = "forest",
          method = "TI", lambda = 0.5,
          areaDomain = NULL, totals = FALSE,
          variance = FALSE, byPlot = FALSE,
          nCores = 1)
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
  estimation. Separate estimates will be produced for regions
  encompassed by each areal unit. FIA plot locations will be reprojected
  to match projection of `polys` object.

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
  compute estimates using mulitple weighting schemes, and use `plotFIA`
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
ratio-of-means estimator of total coverage area / total land area within
the domain of interest. Percent coverage estimates are returned
separately by canopy layer and growth habit (the general appearance of
the plant, including size, shape, growth form, and orientation). Canopy
layers

**Canopy layers**

- 0 - 2.0 feet

- 2.1 - 6.0 feet

- 6.1 - 16.0 feet

- Greater than 16 feet

- Aerial: Canopy cover for all layers

**Growth habit**

- *Forbs*: herbaceous, broad-leaved plants; includes non-woody-vines and
  ferns (does not include mosses and cryptobiotic crusts).

- *Graminoids*: grasses and grass-like plants (includes rushes and
  sedges).

- *Non-tally tree*: tree species not on a particular FIA work unit's
  tree tally list that are woody plants with a single well-defined,
  dominant main stem, not supported by other vegetation or structures
  (not vines), and which are, or expected to become, greater than 13
  feet in height. Seedlings, saplings, and mature plants are included.

- *Shrubs/vines*: woody, multiple-stemmed plants of any size, subshrubs
  (low-growing shrubs under 1.5 feet tall at maturity), and woody vines.
  Most cacti are included in this category.

- *Tally tree*: all core tree species and any core optional tree species
  selected by a particular FIA work unit. Only tree species on the FIA
  Master Tree Species List (or those listed as hybrid, variety, or
  subspecies) are included. Any plant of that species is included,
  regardless of its shape and regardless of whether it was tallied on
  the subplot or microplot during the tree tally. Seedlings, saplings,
  and mature plants are included.

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

- **LAYER**: canopy layer

- **GROWTH_HABIT**: species growth habit

- **COVER_PCT**: estimate of percent areal coverage of the growth habit
  within the canopy layer

- **COVER_AREA_TOTAL**: estimate of areal coverage of the growth habit
  within the canopy layer (acres)

- **AREA_TOTAL**: estimate of total land area (acres)

- **nPlots_VEG**: number of non-zero plots used to compute areal
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
# Load data from the rFIA package
data(fiaRI)
data(countiesRI)

# Most recents subset
fiaRI_mr <- clipFIA(fiaRI)

# \donttest{
# Estimates across RI for the most recent inventory year
vegStruct(db = fiaRI_mr)
#> # A tibble: 25 × 8
#>     YEAR LAYER  GROWTH_HABIT COVER_PCT COVER_PCT_SE nPlots_VEG nPlots_AREA     N
#>    <dbl> <chr>  <chr>            <dbl>        <dbl>      <int>       <int> <int>
#>  1  2018 0 to … Forbs          27.3            43.6          6           6   199
#>  2  2018 0 to … Graminoids      7.61           47.3          6           6   199
#>  3  2018 0 to … Non-tally t…    0.432          43.1          6           6   199
#>  4  2018 0 to … Shrubs/vines   21.3            18.1          6           6   199
#>  5  2018 0 to … Tally tree      7.01           26.8          6           6   199
#>  6  2018 2.1 t… Forbs           4.28           53.1          6           6   199
#>  7  2018 2.1 t… Graminoids      0.0454         80.6          6           6   199
#>  8  2018 2.1 t… Non-tally t…    1.13           49.4          6           6   199
#>  9  2018 2.1 t… Shrubs/vines   12.1            25.6          6           6   199
#> 10  2018 2.1 t… Tally tree     10.4            32.2          6           6   199
#> # ℹ 15 more rows


# Return estimates at the plot-level
vegStruct(db = fiaRI,
          byPlot = TRUE)
#> # A tibble: 150 × 7
#>     PLT_CN  YEAR pltID      LAYER           GROWTH_HABIT  PROP_COVER PROP_FOREST
#>      <dbl> <int> <chr>      <chr>           <chr>              <dbl>       <dbl>
#>  1 1.45e13  2013 1_44_7_169 0 to 2.0 feet   Forbs             0.138            1
#>  2 1.45e13  2013 1_44_7_169 0 to 2.0 feet   Graminoids        0.115            1
#>  3 1.45e13  2013 1_44_7_169 0 to 2.0 feet   Non-tally tr…     0.005            1
#>  4 1.45e13  2013 1_44_7_169 0 to 2.0 feet   Shrubs/vines      0.227            1
#>  5 1.45e13  2013 1_44_7_169 0 to 2.0 feet   Tally tree        0.11             1
#>  6 1.45e13  2013 1_44_7_169 2.1 to 6.0 feet Forbs             0.0025           1
#>  7 1.45e13  2013 1_44_7_169 2.1 to 6.0 feet Graminoids        0                1
#>  8 1.45e13  2013 1_44_7_169 2.1 to 6.0 feet Non-tally tr…     0.01             1
#>  9 1.45e13  2013 1_44_7_169 2.1 to 6.0 feet Shrubs/vines      0.03             1
#> 10 1.45e13  2013 1_44_7_169 2.1 to 6.0 feet Tally tree        0.045            1
#> # ℹ 140 more rows
  # }
```
