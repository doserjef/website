# Download FIA Data and Load into R

Downloads FIA Data from the FIA Datamart, loads the data into R
environment, and optionally saves all downloaded tables as .csv files to
local directory. Requires an internet connection to access and download
tables from the FIA Datamart. **R stops downloads after 60 seconds by
default. To prevent this (allow download for 1 hour), run
`options(timeout=3600)`.**

## Usage

``` r
getFIA(states, dir = NULL, common = TRUE, tables = NULL,
       load = TRUE, nCores = 1)
```

## Arguments

- states:

  character; state/ US territory abbreviations (e.g. 'AL', 'MI', etc.)
  indicating which state subsets to download. Choose to download
  multiple states by passing character vector of state abbreviations
  (e.g. `states = c('RI', 'CT', 'MA')`). If multiple states specified,
  tables will be saved as individual state subsets (for future use with
  [`readFIA()`](readFIA.md), although loaded in R as a merged, regional
  database.

- dir:

  character (optional); directory where FIA tables will be saved after
  download. If NULL, tables will not be saved on disk and only loaded
  into R environment.

- common:

  logical; if TRUE, only import most commonly used tables, including all
  required for `rFIA` functions (see Details for list of tables).

- tables:

  character vector (optional); names of specific tables to be downloaded
  for each state specified (e.g. 'PLOT', 'TREE', 'COND',
  'TREE_GRM_COMPONENT').

- load:

  logical; should downloaded data be loaded into R immediately? If all
  data is too large to fit in memory, use `load = FALSE` and load the
  data as a `"Remote.FIA.Database"` with [`readFIA()`](readFIA.md).

- nCores:

  numeric; number of cores to use for parallel implementation. Check
  available cores using `detectCores`. Default = 1, serial processing.

## Details

If `common = TRUE`, the following tables will be loaded: COND,
COND_DWM_CALC, INVASIVE_SUBPLOT_SPP, PLOT, POP_ESTN_UNIT, POP_EVAL,
POP_EVAL_GRP, POP_EVAL_TYP, POP_PLOT_STRATUM_ASSGN, POP_STRATUM,
SUBPLOT, TREE, TREE_GRM_COMPONENT, TREE_GRM_MIDPT, TREE_GRM_BEGIN,
SUBP_COND_CHNG_MTRX, SEEDLING, SURVEY, SUBP_COND, P2VEG_SUBP_STRUCTURE.
These tables currently support all functionality with `rFIA`, and it is
recommended that only these tables be imported to conserve RAM and
reduce processing time.

If you wish to merge multiple state downloads of FIA data (e.g. Michigan
and Indiana state downloads), simply specify multiple state
abbreviations to the `states` argument. Upon import, corresponding
tables (e.g. MI_PLOT and IN_PLOT) will be merged, and analysis can be
completed for the entire region or within spatial units which transcend
state boundaries (e.g. Ecoregion subsections).

If you choose to save downloaded tables to a local directory after
download (simply specify `dir`), these tables can be easily reloaded
into R using [`readFIA()`](readFIA.md) (do not need to redownload
files).

Easy, efficient parallelization is implemented with the `parallel`
package. Users must only specify the `nCores` argument with a value
greater than 1 in order to implement parallel processing on their
machines. Parallel implementation is achieved using a snow type cluster
on any Windows OS, and with multicore forking on any Unix OS (Linux,
Mac). Implementing parallel processing may substantially decrease
decrease free memory during processing, particularly on Windows OS.
Thus, users should be cautious when running in parallel, and consider
implementing serial processing for this task if computational resources
are limited (`nCores = 1`).

## Value

List object containing FIA Datatables. List elements represent
individual FIA Datatables stored as `data.frame` objects.

If multiple subsets of the FIA database are downloaded (e.g.
`states = c('MI', 'IN')`), corresponding tables will be merged (e.g.
PLOT table returned contains plots in both Michigan and Indiana).

## References

FIA DataMart: <https://apps.fs.usda.gov/fia/datamart/datamart.html>

FIA Website Questions:
<https://research.fs.usda.gov/programs/fia#data-and-tools> Direct email:
SM.FS.fia@usda.gov E.g., Problems accessing the state CSV files.

FIA Database User Guide:
<https://research.fs.usda.gov/understory/forest-inventory-and-analysis-database-user-guide-nfi>

## Author

Hunter Stanke and Andrew Finley

## See also

[`readFIA`](readFIA.md)

## Examples

``` r
# \donttest{
# Allow downloads that take up to 1 hour (defaults to 60 seconds)
options(timeout=3600)

# Download the common tables for Rhode Island, load into R, and save to local directory
# Replace tempDir() with the path to your directory (where data will be saved)
db <- getFIA(states = 'RI', dir = tempdir())
#> Saving to /tmp/RtmpR4rCGu/. NOTE: modifying FIA tables in Excel may corrupt csv files.
# }
```
