# Write FIA tables to local directory

Write `FIA.Database` object to local directory as a series of .csv files
representing each table. Most useful for writing merged states and
temporal/spatial subsets of the database. Once written as .csv, files
can be reloaded into R with [`readFIA()`](readFIA.md).

## Usage

``` r
writeFIA(db, dir, byState = FALSE, nCores = 1, ...)
```

## Arguments

- db:

  `FIA.Database` object produced from [`readFIA()`](readFIA.md) or
  [`getFIA()`](getFIA.md).

- dir:

  directory where FIA Datatables will be stored.

- nCores:

  numeric; number of cores to use for parallel implementation. Check
  available cores using `detectCores`. Default = 1, serial processing.

- byState:

  logical; should tables be written out by state? Must be TRUE if
  planning to load data as an out-of-memory database in the future (see
  [`readFIA()`](readFIA.md)).

- ...:

  other arguments to pass to
  [`data.table::fwrite()`](https://rdatatable.gitlab.io/data.table/reference/fwrite.html).

## Details

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

## Author

Hunter Stanke and Andrew Finley

## See also

[`readFIA`](readFIA.md), [`getFIA`](getFIA.md)

## Value

No return value, called to export `FIA.Database` object to a local
directory.

## Examples

``` r
# Write the 'fiaRI' object to a temporary directory
# Replace temp_dir with the path to your directory (where data will be saved)
temp_dir = tempdir()
writeFIA(fiaRI, dir = temp_dir)
#> Saving to /tmp/RtmpR4rCGu/. NOTE: modifying FIA tables in Excel may corrupt csv files.
```
