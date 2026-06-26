# Find EVALIDs used in the FIADB

Lookup Evaluation IDs (EVALIDs) associated with reporting years and
evaluation types used in the Forest Inventory and Analysis Database. NOT
required to run other rFIA functions. Only use if you are interested in
subsetting an `FIA.Database` object for a specific reporting year or
evaluation type using [`clipFIA`](clipFIA.md).

## Usage

``` r
findEVALID(db, mostRecent = FALSE, state = NULL, year = NULL, type = NULL)
```

## Arguments

- db:

  FIA Database object produced from [`readFIA()`](readFIA.md).

- mostRecent:

  logical; if TRUE, returns EVALIDs associated with most recent
  inventory.

- state:

  character vector containing full names of states of interest (e.g.
  `c('Michigan', 'Minnesota', 'Wisconsin')`)

- year:

  numeric vector containing years of interest (e.g.
  `c(2015, 2016, 2017)`)

- type:

  character ('ALL', 'CURR', 'VOL', 'GROW', 'MORT', 'REMV', 'CHANGE',
  'DWM', 'REGEN'). See Reference Population Evaluation Type Description
  Table (REF_POP_EVAL_TYP_DESCR) in FIADB P2 User Guide (link in
  references) for descriptions of evaluation types.

## Details

EVALIDs in the FIA Database are used to reference data points associated
with particular inventory years and evaluation types within a state
(e.g. 2017 Current Volume in Michigan). They are often extraordinarily
confusing for those not familiar for the FIA Database. With this in
mind, rFIA has been designed to eliminate users dependence on
identifying and specifying appropriate EVALIDs to produce desired
estimates, and we therefore do not recommend users attempt to identify
EVALIDs independently.

Any `state` or `year` specified must be present in `db` to return
associated EVALIDS.

## Value

A numeric vector containing the EVALIDs associated with states, years,
or evaluation types specified.

## References

FIA Database User Guide:
<https://research.fs.usda.gov/understory/forest-inventory-and-analysis-database-user-guide-nfi>

## Author

Hunter Stanke and Andrew Finley

## See also

[`clipFIA`](clipFIA.md)

## Examples

``` r
## Lookup all EVALIDs in an FIA.Database object
findEVALID(fiaRI)
#>  [1] 441601 441603 441607 441608 441700 441701 441703 441707 441708 441801
#> [11] 441803 441807 441812 441808 441810 441809 441800 441300 441301 441303
#> [21] 441400 441401 441403 441408 441507 441500 441501 441503 441508 441600

## Find the most recent EVALIDs
findEVALID(fiaRI, mostRecent = FALSE)
#>  [1] 441601 441603 441607 441608 441700 441701 441703 441707 441708 441801
#> [11] 441803 441807 441812 441808 441810 441809 441800 441300 441301 441303
#> [21] 441400 441401 441403 441408 441507 441500 441501 441503 441508 441600
```
