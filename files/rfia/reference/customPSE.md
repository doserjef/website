# Post-stratified estimator for custom variables in FIA Data

Produces estimates of population totals, ratios, and associated
variances for custom variables using FIA's post-stratified inventories.
Accepts tree- and condition-level summaries from rFIA estimator
functions as input, with potential modifications to associated variables
(e.g., custom allometrics can be applied to estimate tree
biomass/carbon). See our website for example use cases.

## Usage

``` r
customPSE(db, x, xVars, xGrpBy = NULL, xTransform = NULL, y = NULL,
          yVars = NULL, yGrpBy = NULL, yTransform = NULL, method = "TI",
          lambda = 0.5, totals = TRUE, variance = TRUE)
```

## Arguments

- db:

  `FIA.Database` or `Remote.FIA.Database` object produced from
  [`readFIA()`](readFIA.md) or [`getFIA()`](getFIA.md). If a
  `Remote.FIA.Database`, data will be read in and processed
  state-by-state to conserve RAM (see details for an example).

- x:

  data.frame; tree- or condition-list containing numerator variable(s).
  See details for more info on producing acceptable tree- and
  condition-lists using `rFIA` estimator functions.

- xVars:

  name of variable(s) in `x` to be treated as numerator variables,
  unquoted. Multiple variables should be combined with
  [`c()`](https://rdrr.io/r/base/c.html), e.g., `xVars = c(TPA, BAA)`.

- xGrpBy:

  names of variables in `x` to be treated as grouping variables for the
  numerator, unquoted. Multiple variables should be combined with
  [`c()`](https://rdrr.io/r/base/c.html), e.g.,
  `xVars = c(SPCD, OWNGRPCD)`.

- xTransform:

  function to be applied to plot-level summaries of numerator variables,
  e.g., `sqrt` or `function(x){log(x + 0.001)}`.

- y:

  data.frame; tree- or condition-list containing denominator variable.
  See details for more info on producing acceptable tree- and
  condition-lists using `rFIA` estimator functions.

- yVars:

  name of variable in `y` to be treated as denominator variables,
  unquoted. Maximum one denominator variable allowed at this time.

- yGrpBy:

  names of variables in `y` to be treated as grouping variables for the
  numerator, unquoted. Multiple variables should be combined with
  [`c()`](https://rdrr.io/r/base/c.html), e.g.,
  `xVars = c(SPCD, OWNGRPCD)`.

- yTransform:

  function to be applied to plot-level summaries of denominator
  variable, e.g., `sqrt` or `function(x){log(x + 0.001)}`.

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

- totals:

  logical; if TRUE, return total population estimates (e.g. total area)
  along with ratio estimates (e.g. mean trees per acre).

- variance:

  logical; if TRUE, return estimated variance (`VAR`) and sample size
  (`N`). If FALSE, return 'sampling error' (`SE`) as returned by
  EVALIDator. Note: sampling error cannot be used to construct
  confidence intervals.

## Details

**Workflow and intended use cases**

`customPSE` is intended to be used in combination with standard rFIA
estimator functions, like [`tpa()`](tpa.md), [`area()`](area.md), and
[`volume()`](volume.md), among others. Standard rFIA estimator functions
generate tree- and or condition-lists for standard variables of interest
(see `treeList` and `condList` arguments in estimator functions). Users
may make modifications to these standard variables, for example a
variable representing tree crown area may be added to a tree-list
produced by [`tpa()`](tpa.md) (via some suite of allometrics). Users may
then hand their modified tree-list to `customPSE` to estimate the total
and proportion of forested land area in their domain of interest that is
covered by tree crowns.

`customPSE` may be used to estimate population totals for multiple
variables simultaneously (total number of trees in a region), and given
a denominator variable, the associated population ratios (trees per
forested acre, where forested land area is the denominator). Estimation
follows the procedures documented in Bechtold and Patterson (2005) and
[Stanke et al 2020](https://research.fs.usda.gov/treesearch/59521).

Three general forms of ratio estimates may be produced: tree-tree,
tree-area, and area-area ratios. For example, if tree height is
specified as the numerator variable (adjusted for sampling area by
multiplying by TPA), and TPA is specified as the denominator variable, a
tree-tree ratio will be produced that represents the height of the
average tree within a region of interest. Similarly, if stand age is
specified as the numerator (adjusted for sampling area by proportionate
area of the forested condition on the plot, i.e., `PROP_FOREST`), and
the proportion area of the plot that is forested is specified as the
denominator, an area-area ratio will be produced that represents average
stand age within the region of interest. Tree-area ratios are more
familiar, such as trees per acre, tree biomass per acre, etc, where a
tree variable is specified as the numerator, and proportion of plot area
occupied by forestland is the denominator. See our website for detailed
examples of each of these ratio estimates.

**Input requirements**

Estimation of tree variables require the following columns be present in
`x` and/or `y`: PLT_CN, EVAL_TYP, SUBP, TREE, and TREE_BASIS. Similarly,
estimation of area variables require the following columns be present in
`x` and/or `y`: PLT_CN, EVAL_TYP, CONDID, and AREA_BASIS. Each of these
required variables will be returned in tree- and condition-lists
generated by standard rFIA estimator functions.

IMPORTANT: Only one of TREE_BASIS or AREA_BASIS may be present `x` or
`y`, as the presence of these columns are used to determine if variables
to be estimated are tree variables or area variables. Some standard rFIA
estimator functions will produce tree-lists with both TREE_BASIS and
AREA_BASIS listed in output, as the tree-list will contain tree
variables (e.g., TPA, BAA) as well as area variables (e.g., PROP_FOREST,
proportion of plot represented by the forested condition where each tree
is growing)). To produce a tree-area ratio with such an output,
AREA_BASIS must be removed from the data.frame specified in `x`, and
TREE_BASIS must be removed from that specified in `y`.

## Value

- **YEAR**: reporting year associated with estimates

- **\*\_RATIO**: population ratio estimate, where \* will be replaced
  with the name of each numerator variable

- **\*\_TOTAL**: population total estimate, where \* will be replaced
  with the name of each numerator/ denominator variable

- **\*\_RATIO_VAR**: estimated variance of the population ratio

- **\*\_TOTAL_VAR**: estimated variance of the population total

- **nPlots_x**: number of non-zero plots used to compute numerator
  estimates

- **nPlots_y**: number of non-zero plots used to compute denominator
  estimates

- **N**: total number of plots (including zeros) associated with each
  inventory

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
# See our website for a more thorough suite of examples
data(fiaRI)

# Get tree-list from tpa
tree.list <- tpa(fiaRI,
                 treeList = TRUE)

# Estimate trees per acre and basal area per acre
customPSE(db = fiaRI,
          # Numerator variables
          x = dplyr::select(tree.list, -c(AREA_BASIS)),
          xVars = c(TPA, BAA),
          # Denominator variables
          y = dplyr::select(tree.list, -c(TREE_BASIS)),
          yVars = PROP_FOREST)
#> # A tibble: 6 × 14
#>    YEAR TPA_RATIO BAA_RATIO  TPA_TOTAL BAA_TOTAL PROP_FOREST_TOTAL TPA_RATIO_VAR
#>   <dbl>     <dbl>     <dbl>      <dbl>     <dbl>             <dbl>         <dbl>
#> 1  2013      467.      119. 171481307. 43626598.           367372.          960.
#> 2  2014      466.      120. 171464450. 44107127.           367884.          983.
#> 3  2015      444.      121. 164362240. 44586819.           369844.          808.
#> 4  2016      450.      123. 164787783. 45021353.           366364.          844.
#> 5  2017      441.      123. 162503315. 45388036.           368373.          863.
#> 6  2018      427.      122. 156585656. 44810915.           366959.          801.
#> # ℹ 7 more variables: BAA_RATIO_VAR <dbl>, TPA_TOTAL_VAR <dbl>,
#> #   BAA_TOTAL_VAR <dbl>, PROP_FOREST_TOTAL_VAR <dbl>, nPlots_x <int>,
#> #   nPlots_y <int>, N <int>

# Same as above, but rename variables for a clean output
# customPSE(db = fiaRI,
#           x = dplyr::select(tree.list, -c(AREA_BASIS)),
#           # Variables can be renamed using c()
#           xVars = c(NUM = TPA,
#                     BA = BAA),
#           y = dplyr::select(tree.list, -c(TREE_BASIS)),
#           # Variables can be renamed using c()
#           yVars = c(FOREST_AREA = PROP_FOREST))
# 
# # Ensure the above matches expected output
# tpa(fiaRI,
#     totals = TRUE,
#     variance = TRUE)
```
