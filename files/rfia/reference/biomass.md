# Estimate tree biomass and carbon stocks from the FIADB

Produces estimates of tree biomass and carbon on a per acre basis from
FIA data, along with population estimates for each variable. Estimates
can be produced for regions defined within the FIA Database (e.g.
counties), at the plot level, or within user-defined areal units.
Options to group estimates by species, size class, and other variables
defined in the FIADB. If multiple reporting years (EVALIDs) are included
in the data, estimates will be output as a time series. If multiple
states are represented by the data, estimates will be output for the
full region (all area combined), unless specified otherwise (e.g.
`grpBy = STATECD`).

## Usage

``` r
biomass(db, grpBy = NULL, polys = NULL, returnSpatial = FALSE,
        bySpecies = FALSE, bySizeClass = FALSE, byComponent = FALSE,
        landType = "forest", treeType = "live", method = "TI",
        lambda = 0.5, treeDomain = NULL, areaDomain = NULL,
        totals = FALSE, variance = FALSE, byPlot = FALSE,
        treeList = FALSE, component = "AG",
        bioMethod = "NSVB", nCores = 1)
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

- byComponent:

  logical; if TRUE, returns estimates grouped by the following biomass
  components: stem, stem bark, branches, foliage, stump, stump bark,
  merchantable bole, merchantable bole bark, sawlog, sawlog bark, and
  belowground roots.

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
  use with [`customPSE()`](customPSE.md).

- component:

  character, combination of: "TOTAL" (sum of all components), "AG"
  (aboveground components excluding foliage), "STEM" (total stem of
  timber species from ground line to the tree tip), "STEM_BARK",
  "BRANCH", (branch/limbs of timber species), "FOLIAGE" (foliage for
  live trees at least 1.0 inches dbh/drc), "STUMP", "STUMP_BARK", "BOLE"
  (merchantable bole), "BOLE_BARK", "SAWLOG", "SAWLOG_BARK", "ROOT"
  (beloground portion of tree including coarse roots with a root
  diameter at elast 0.1 inch); biomass component to use in estimation.
  Note that "TOTAL" includes foliage for biomass estimates but does not
  include foliage for carbon estimates. See Details below for more
  detailed descriptions of the components.

- bioMethod:

  character; tree-level biomass estimation procedures to use. As of
  `rFIA v1.1.0`, the only biomass estimation procedure supported is the
  National Scale Volume and Biomass ("NSVB") models. See Estimation
  Details for references.

- nCores:

  numeric; number of cores to use for parallel implementation. Check
  available cores using `detectCores()`. Default = 1, serial processing.

## Details

**Estimation Details**

Estimation of forest variables follows the procedures documented in
Bechtold and Patterson (2005) and [Stanke et al
2020](https://research.fs.usda.gov/treesearch/59521). Specifically, tree
biomass and carbon per acre are computed using a sample-based
ratio-of-means estimator of total biomass / total land area within the
domain of interest.

A sum of aboveground biomass components, excluding foliage, is estimated
by default (`component = 'AG'`). However, users may specify unique
combinations of biomass components if they wish to do so. For example,
to estimate aboveground biomass, including foliage, specify
`component = c('AG', 'FOLIAGE')` in the call to `biomass`. To estimate
all biomass components simultaneously (i.e., grouped by copmonent),
specify `byComponent = TRUE`. All biomass components are computed using
the National Scale Volume and Biomass (NSVB) approach adopted by FIA in
September 2023. See [Westfall et al.
2024](https://research.fs.usda.gov/treesearch/66998) for more detailed
information on NSVB procedures. The following biomass components can be
estimated using `biomass()` (note the components are not mutually
exclusive):

- *TOTAL*: total biomass, which is equivalent to the sum of the
  following components: "ROOT", "STEM", "STEM_BARK", "BRANCH", and
  "FOLIAGE". *NOTE*: total carbon estimates do not include estimates of
  carbon in foliage.

- *AG*: aboveground biomass/carbon, not including foliage. This is
  equivalent to the sum of the following components: "STEM",
  "STEM_BARK", and "BRANCH".

- *STEM*: oven-dry biomass/carbon of wood in the total stem of timber
  species (trees where diameter is measured at breast height) with dbh
  at least 1.0 inches, from ground line to the tree tip. Calculated for
  live and standing dead trees.

- *STEM_BARK*: oven-dry biomass/carbon of bark in the total stem of
  timber species with dbh at least 1.0 inches, from ground line to the
  tree tip. Calculated for live and standing dead trees.

- *BRANCH*: oven-dry biomass/carbon of wood and bark in the
  branches/limbs of timber species with at least 1.0 inches. This only
  includes branches; it does not include any portion of the total stem.
  Calculated for live and standing dead trees. For live trees, this
  value is reduced for broken tops. For standing dead trees, this value
  is reduced for broken tops as well as decay.

- *FOLIAGE*: oven-dry biomass of foliage for live trees with dbh/drc at
  least 1.0 inches. *NOTE*: foliar carbon is not calculated and is
  instead set to 0.

- *STUMP*: oven-dry biomass/carbon of wood in the stump of timber
  species with dbh at least 5.0 inches. The stump is that portion of the
  tree from the ground line to the bottom of the merchantable bole
  (i.e., below 1 foot). Calculated for live and standing dead trees.

- *STUMP_BARK*:oven-dry biomass/carbon of bark in the stump of timber
  species with dbh at least 5.0 inches. The stump is that portion of the
  tree from the ground line to the bottom of the merchantable bole
  (i.e., below 1 foot). Calculated for live and standing dead trees.

- *BOLE*: oven-dry biomass/carbon of wood in the merchantable bole of
  timber species with dbh at least 5.0 inches, from a 1-foot stump to a
  minimum 4-inch top diameter. Calculated for live and standing dead
  trees.

- *BOLE_BARK*: oven-dry biomass/carbon of bark in the merchantable bole
  of timber species with dbh at least 5.0 inches, from a 1-foot stump to
  a minimum 4-inch top diameter. Calculated for live and standing dead
  trees.

- *SAWLOG*: the oven-dry biomass/carbon of wood in the sawlog portion of
  timber species of sawtimber size from a 1-foot stump to a minimum top
  diameter or to where the central stem breaks into limbs, all of which
  are less than the minimum top diamter. Minimum dbh is 9.0 inches for
  softwoods and 11.0 inches for hardwoods. The minimum top diameter is
  7.0 inches for softwoods and 9.0 inches for hardwoods.

- *SAWLOG_BARK*: the oven-dry biomass/carbon of bark in the sawlog
  portion of timber species of sawtimber size from a 1-foot stump to a
  minimum top diameter or to where the central stem breaks into limbs,
  all of which are less than the minimum top diamter. Minimum dbh is 9.0
  inches for softwoods and 11.0 inches for hardwoods. The minimum top
  diameter is 7.0 inches for softwoods and 9.0 inches for hardwoods.

- *ROOT*: oven-dry biomass of the below ground portion of a tree,
  including coarse roots with a root diameter of at least 0.1 inches.
  This is a modeled estimate, calculated for live and standing dead
  trees with dbh/drc at least 1.0 inches. This component, unlike all
  other compoments, is estimated using the Component Ratio Method (CRM).

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
values are returned for each plot (`PLOT_STATUS_CD = 1` when forest
exists at the plot location). All variables with names ending in `SE`,
represent the estimate of sampling error (%) of the variable. When
`variance = TRUE`, variables ending in `VAR` denote the variance of the
variable and `N` is the total sample size (i.e., including non-zero
plots).

- **YEAR**: reporting year associated with estimates

- **BIO_ACRE**: estimate of mean tree biomass per acre (short tons/acre)

- **CARB_ACRE**: estimate of mean tree carbon per acre (short tons/acre)

- **nPlots_TREE**: number of non-zero plots used to compute biomass and
  carbon estimates

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

Westfall, James A., Coulston, John W., Gray, Andrew N., Shaw, John D.,
Radtke, Philip J., Walker, David M., Weiskittel, Aaron R., MacFarlane,
David W., Affleck, David L.R., Zhao, Dehai, Temesgen, Hailemariam,
Poudel, Krishna P., Frank, Jereme M., Prisley, Stephen P., Wang,
Yingfang, Sánchez Meador, Andrew J., Auty, David, Domke, Grant M. 2024.
A national-scale tree volume, biomass, and carbon modeling system for
the United States. Gen. Tech. Rep. WO-104. Washington, DC: U.S.
Department of Agriculture, Forest Service. 37 p.
<https://research.fs.usda.gov/treesearch/66998>.

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


# Most recent estimates of aboveground biomass (excluding foliage)
# for growing-stock trees on timber land
biomass(db = fiaRI_mr,
        landType = 'timber',
        treeType = 'gs')
#> # A tibble: 1 × 8
#>    YEAR BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE nPlots_TREE nPlots_AREA
#>   <dbl>    <dbl>     <dbl>       <dbl>        <dbl>       <int>       <int>
#> 1  2018     61.6      29.8        5.37         5.40         120         127
#> # ℹ 1 more variable: N <int>

# Same as above but include foliage
biomass(db = fiaRI_mr,
        landType = 'timber',
        treeType = 'gs',
        component = c('AG', 'FOLIAGE'))
#> # A tibble: 1 × 8
#>    YEAR BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE nPlots_TREE nPlots_AREA
#>   <dbl>    <dbl>     <dbl>       <dbl>        <dbl>       <int>       <int>
#> 1  2018     63.1      29.8        5.32         5.40         120         127
#> # ℹ 1 more variable: N <int>
# \donttest{

# Same as above, but at the plot-level
biomass(db = fiaRI_mr,
        landType = 'timber',
        treeType = 'gs',
        component = c('AG', 'FOLIAGE'),
        byPlot = TRUE)
#> # A tibble: 127 × 6
#>     YEAR pltID       PLT_CN BIO_ACRE CARB_ACRE PROP_FOREST
#>    <int> <chr>        <dbl>    <dbl>     <dbl>       <dbl>
#>  1  2013 1_44_1_228 1.45e13    22.4      10.4        0.667
#>  2  2013 1_44_3_144 1.45e13     7.13      3.33       0.170
#>  3  2013 1_44_7_126 2.47e14     3.11      1.38       0.5  
#>  4  2013 1_44_7_169 1.45e13    94.2      46.5        1    
#>  5  2013 1_44_7_177 2.47e14     3.92      1.76       0.25 
#>  6  2013 1_44_7_229 1.45e13    70.0      33.6        1    
#>  7  2013 1_44_7_245 1.45e13     8.15      3.85       0.25 
#>  8  2013 1_44_7_306 1.45e13    38.2      17.7        0.217
#>  9  2013 1_44_7_341 2.47e14    72.2      34.6        1    
#> 10  2013 1_44_7_61  1.45e13    41.0      19.0        1    
#> # ℹ 117 more rows

# Belowground (i.e., coarse roots) and stump biomass only
biomass(db = fiaRI_mr,
        component = c('ROOT', 'STUMP'))
#> # A tibble: 1 × 8
#>    YEAR BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE nPlots_TREE nPlots_AREA
#>   <dbl>    <dbl>     <dbl>       <dbl>        <dbl>       <int>       <int>
#> 1  2018     16.3      7.90        3.92         3.96         126         127
#> # ℹ 1 more variable: N <int>

# Estimate all biomass components simultaneosly
biomass(db = fiaRI_mr,
        byComponent = TRUE)
#> # A tibble: 11 × 9
#>     YEAR COMPONENT   BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE nPlots_TREE
#>    <dbl> <chr>          <dbl>     <dbl>       <dbl>        <dbl>       <int>
#>  1  2018 BOLE          43.1      20.9          4.27         4.31         126
#>  2  2018 BOLE_BARK      6.79      3.28         3.86         3.89         126
#>  3  2018 BRANCH        19.0       9.19         4.42         4.43         126
#>  4  2018 FOLIAGE        2.09      0            3.05       NaN            126
#>  5  2018 ROOT          14.0       6.78         4.10         4.15         126
#>  6  2018 SAWLOG        24.5      11.9          7.46         7.53         126
#>  7  2018 SAWLOG_BARK    3.75      1.82         7.17         7.23         126
#>  8  2018 STEM          48.9      23.6          3.90         3.94         126
#>  9  2018 STEM_BARK      7.78      3.76         3.49         3.51         126
#> 10  2018 STUMP          2.33      1.13         3.13         3.13         126
#> 11  2018 STUMP_BARK     0.375     0.181        2.92         2.90         126
#> # ℹ 2 more variables: nPlots_AREA <int>, N <int>

# Estimates for live white pine ( > 12" DBH) on forested mesic sites (all available inventories)
biomass(fiaRI_mr,
        treeType = 'live',
        treeDomain = SPCD == 129 & DIA > 12, # Species code for white pine
        areaDomain = PHYSCLCD %in% 21:29) # Mesic Physiographic classes
#> # A tibble: 1 × 8
#>    YEAR BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE nPlots_TREE nPlots_AREA
#>   <dbl>    <dbl>     <dbl>       <dbl>        <dbl>       <int>       <int>
#> 1  2018     9.32      4.72        21.3         21.3          29         127
#> # ℹ 1 more variable: N <int>

# Most recent estimates grouped by stand age on forest land
# Make a categorical variable which represents stand age (grouped by 10 yr intervals)
fiaRI_mr$COND$STAND_AGE <- makeClasses(fiaRI_mr$COND$STDAGE, interval = 10)
biomass(db = fiaRI_mr,
        grpBy = STAND_AGE)
#> # A tibble: 11 × 9
#>     YEAR STAND_AGE BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE nPlots_TREE
#>    <dbl> <chr>        <dbl>     <dbl>       <dbl>        <dbl>       <int>
#>  1  2018 [0,10)       0.208     0.101 35.9         35.9                  1
#>  2  2018 [20,30)     11.1       5.23   0            0.00000238           1
#>  3  2018 [30,40)     37.1      17.7   34.1         33.8                  5
#>  4  2018 [40,50)     41.2      20.0   16.2         16.3                  7
#>  5  2018 [50,60)     66.7      32.1   13.3         13.4                 12
#>  6  2018 [60,70)     82.6      39.9    7.39         7.39                23
#>  7  2018 [70,80)     73.2      35.4    5.48         5.59                43
#>  8  2018 [80,90)     84.5      40.9    8.33         8.36                27
#>  9  2018 [90,100)    86.3      41.6   10.0          9.96                12
#> 10  2018 [100,110)  104.       51.2   15.4         15.2                  3
#> 11  2018 [110,120]  119.       58.1    0.00000201   0                    1
#> # ℹ 2 more variables: nPlots_AREA <int>, N <int>

# Estimates for snags greater than 20 in DBH on forestland for all
#  available inventories (time-series)
biomass(db = fiaRI,
        landType = 'forest',
        treeType = 'dead',
        treeDomain = DIA > 20)
#> # A tibble: 6 × 8
#>    YEAR BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE nPlots_TREE nPlots_AREA
#>   <dbl>    <dbl>     <dbl>       <dbl>        <dbl>       <int>       <int>
#> 1  2013   0.0566    0.0277        55.5         55.1           4         123
#> 2  2014   0.0578    0.0283        54.7         54.3           4         123
#> 3  2015   0.0566    0.0277        55.3         54.9           4         124
#> 4  2016   0.0508    0.0248        60.6         60.2           3         125
#> 5  2017   0.231     0.110         74.6         74.2           4         125
#> 6  2018   0.326     0.155         60.2         59.9           5         127
#> # ℹ 1 more variable: N <int>

# Most recent estimates for live stems on forest land by species
biomass(db = fiaRI_mr,
        landType = 'forest',
        treeType = 'live',
        bySpecies = TRUE)
#> # A tibble: 45 × 11
#>     YEAR  SPCD COMMON_NAME        SCIENTIFIC_NAME BIO_ACRE CARB_ACRE BIO_ACRE_SE
#>    <dbl> <dbl> <chr>              <chr>              <dbl>     <dbl>       <dbl>
#>  1  2018    12 balsam fir         Abies balsamea   0.00902   0.00456      114.  
#>  2  2018    43 Atlantic white-ce… Chamaecyparis …  0.0433    0.0206        56.7 
#>  3  2018    68 eastern redcedar   Juniperus virg…  0.0419    0.0218        69.0 
#>  4  2018   126 pitch pine         Pinus rigida     1.67      0.794         49.8 
#>  5  2018   129 eastern white pine Pinus strobus   10.3       5.23          18.9 
#>  6  2018   130 Scotch pine        Pinus sylvestr…  0.00342   0.00161       91.9 
#>  7  2018   261 eastern hemlock    Tsuga canadens…  1.00      0.481         39.4 
#>  8  2018   313 boxelder           Acer negundo     0.0222    0.0108        92.6 
#>  9  2018   316 red maple          Acer rubrum     16.9       8.23           9.78
#> 10  2018   317 silver maple       Acer saccharin…  0.164     0.0782        92.6 
#> # ℹ 35 more rows
#> # ℹ 4 more variables: CARB_ACRE_SE <dbl>, nPlots_TREE <int>, nPlots_AREA <int>,
#> #   N <int>

# Same as above, but implemented in parallel (much quicker)
# parallel::detectCores(logical = FALSE) # 4 cores available, we will take 2
# biomass(db = fiaRI_mr,
#         landType = 'forest',
#         treeType = 'live',
#         bySpecies = TRUE,
#         nCores = 2)


# Most recent estimates for all stems on forest land grouped by user-defined areal units
ctSF <- biomass(fiaRI_mr,
                polys = countiesRI,
                returnSpatial = TRUE)
plot(ctSF) # Plot multiple variables simultaneously
#> Warning: plotting the first 9 out of 10 attributes; use max.plot = 10 to plot all

plotFIA(ctSF, BIO_ACRE) # Plot of aboveground biomass per acre

# }
```
