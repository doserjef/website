# Intersect FIA data with spatial polygons

Performs spatial intersection between FIA data and user-supplied spatial
polygons (sp or sf). Polygon attributes appended to PLOT table, and
hence can be used as grouping variables in subsequent calls to rFIA
estimator functions. Alternative to the `polys` argument in rFIA
estimator functions.

## Usage

``` r
intersectFIA(db, polys, nCores = 1)
```

## Arguments

- db:

  `FIA.Database` or `Remote.FIA.Database` object produced from
  [`readFIA()`](readFIA.md) or [`getFIA()`](getFIA.md). If a
  `Remote.FIA.Database`, data will be read in and processed
  state-by-state to conserve RAM (see details for an example).

- polys:

  `sp` or `sf` Polygon/MultiPolgyon object; Areal units to bin data for
  estimation. Separate estimates will be produced for region encompassed
  by each areal unit. FIA plot locations will be reprojected to match
  projection of `polys` object.

- nCores:

  numeric; number of cores to use for parallel implementation. Check
  available cores using `detectCores`. Default = 1, serial processing.

## Details

All polygon attributes will be joined onto the PLOT table.

Primarily useful if you intend to make multiple calls to rFIA estimator
functions, e.g., you need to call both `tpa` and `biomass` and group by
spatial polygons in both cases. If using the `polys` argument in each
function call, spatial intersection will occur mulitple times, and hence
be slower than performing the intersection a single time upfront.

## Value

FIA.Database or Remote.FIA.Database, depending on specification of `db`.

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

## See also

[`clipFIA`](clipFIA.md)

## Examples

``` r
data(fiaRI)
data(countiesRI)

# Perform spatial intersection
db <- intersectFIA(fiaRI,
                   countiesRI)

# Group estimates by variable defined
# in `countiesRI`
tpa(db,
    grpBy = COUNTY)
#> # A tibble: 30 × 9
#>     YEAR COUNTY       TPA   BAA TPA_SE BAA_SE nPlots_TREE nPlots_AREA     N
#>    <dbl> <chr>      <dbl> <dbl>  <dbl>  <dbl>       <int>       <int> <int>
#>  1  2013 bristol     307.  118.  32.5    7.93           3           3   197
#>  2  2013 kent        535.  132.  16.8    6.40          14          14   197
#>  3  2013 newport     325.  122.   7.76   6.01           5           5   197
#>  4  2013 providence  518.  126.  10.6    3.98          53          54   197
#>  5  2013 washington  410.  110.  10.9    6.88          38          40   197
#>  6  2014 bristol     308.  119.  31.5    7.81           3           3   196
#>  7  2014 kent        534.  135.  16.4    6.77          14          14   196
#>  8  2014 newport     311.  118.   9.13   7.08           6           6   196
#>  9  2014 providence  528.  128.  11.0    3.92          52          52   196
#> 10  2014 washington  406.  111.  10.6    6.66          39          41   196
#> # ℹ 20 more rows
```
