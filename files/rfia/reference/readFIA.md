# Load FIA database into R environment from local directory

Loads FIA Datatables into R from .csv files stored in a local directory
(common, easy), or from a database connection (uncommon, difficult). If
you have not previously downloaded FIA Data from the FIA Datamart, use
[`getFIA()`](getFIA.md) to download data for your region of interest and
load it into R.

## Usage

``` r
readFIA(dir = NULL, con = NULL, schema = NULL, common = TRUE, tables = NULL,
        states = NULL, inMemory = TRUE, nCores = 1, ...)
```

## Arguments

- dir:

  directory where .csv files of FIA tables are stored.

- con:

  database connection (e.g., produced with
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).
  Only required when reading tables from a database connection. Most
  users will want to specify `dir` instead, reading FIA tables from .csv
  files.)

- schema:

  SQL Schema that contains FIA tables. Only required when reading tables
  from a database connection, which most users should avoid.

- common:

  logical; if TRUE, only import most commonly used tables, including all
  required for `rFIA` functions (see Details for list of tables).

- tables:

  character vector; names of specific tables to be imported (e.g.
  'PLOT', 'TREE', 'COND', 'TREE_GRM_COMPONENT').

- states:

  character; state/ US territory abbreviations (e.g. 'AL', 'MI', etc.)
  indicating which state subsets to read. Data for each state must be in
  `dir`. Choose to read multiple states by passing character vector of
  state abbreviations (e.g. `states = c('RI', 'CT', 'MA')`). If
  `states = NULL`, data for all states within `dir` will be read in and
  merged into a regional database.

- inMemory:

  logical; should data be stored in-memory? If FALSE, data will be read
  in state-by-state when an estimator function is called (e.g.,
  [`tpa()`](tpa.md)). This conserves RAM and allows the user to to
  produce estimates using very large databases that does not all fit in
  memory at once.

- nCores:

  numeric; number of cores to use for parallel implementation. Check
  available cores using `detectCores()`. Default = 1, serial processing.

- ...:

  other arguments to pass to
  [`data.table::fread()`](https://rdatatable.gitlab.io/data.table/reference/fread.html).

## Details

Download subsets of the FIA Database using [`getFIA()`](getFIA.md)
(recommended), or manually from the FIA Datamart:
<https://apps.fs.usda.gov/fia/datamart/datamart.html>. Once downloaded,
unzip the directory (if downloaded manually), and read into R using
`readFIA()`.

If `common = TRUE`, the following tables will be imported: COND,
COND_DWM_CALC, INVASIVE_SUBPLOT_SPP, PLOT, POP_ESTN_UNIT, POP_EVAL,
POP_EVAL_GRP, POP_EVAL_TYP, POP_PLOT_STRATUM_ASSGN, POP_STRATUM,
SUBPLOT, TREE, TREE_GRM_COMPONENT, TREE_GRM_MIDPT, TREE_GRM_BEGIN,
SUBP_COND_CHNG_MTRX, SEEDLING, SURVEY, SUBP_COND, P2VEG_SUBP_STRUCTURE.
These tables currently support all functionality with `rFIA`, and it is
recommended that only these tables be imported to conserve RAM and
reduce processing time.

If you wish to merge multiple state downloads of FIA data (e.g. North
Carolina and Virginia state downloads), simply place both sets of
datatables in the same directory (done for you when using
[`getFIA()`](getFIA.md)) and import with `readFIA`. Upon import,
corresponding tables (e.g. NC_PLOT and VA_PLOT) will be merged, and
analysis can be completed for the entire region or within spatial units
which transcend state boundaries (e.g. Ecoregion subsections).

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

List object containing FIA tables. List elements represent individual
FIA tables stored as `data.frame` objects. Names of list elements
reflect names of files from which they were read into R environment
(File names should not be changed after download from FIA Datamart).

If multiple subsets of the FIA database are held in the same directory
(e.g. North Carolina and Virginia state downloads), corresponding tables
will be merged (e.g. PLOT table returned contains plots in both North
Carolina and Virginia).

## References

FIA DataMart: <https://apps.fs.usda.gov/fia/datamart/datamart.html>

FIA Database User Guide:
<https://research.fs.usda.gov/understory/forest-inventory-and-analysis-database-user-guide-nfi>

## Author

Hunter Stanke and Andrew Finley

## Note

To download subsets of the FIA Database manually, go online to the FIA
Datamart (<https://apps.fs.usda.gov/fia/datamart/datamart.html>) and
choose to download .csv files. Here you can choose to download subsets
of the full database for individual states, or select to download
individual tables. For use with the `rFIA` package, we recommend
downloading of subsets of the full database representing individual
states of interest. Files must be unzipped in order to be imported.

Alternatively, use [`getFIA()`](getFIA.md) to automate the download,
reading, and saving process for you (recommended).

## See also

[`clipFIA`](clipFIA.md), [`getFIA`](getFIA.md)

## Examples

``` r
# \donttest{
# The following examples shows how you
# can take an existing in-memory FIA.Database,
# save it, and read it back in!


# First download the common tables for Rhode Island,
# load into R, but don't save it anywhere yet
db <- getFIA(states = 'RI')



# Now we write it all out
# Replace tempdir() with the path to your
# directory (where data will be saved)
writeFIA(db, dir = tempdir())
#> Saving to /tmp/RtmpR4rCGu/. NOTE: modifying FIA tables in Excel may corrupt csv files.
# }
```
