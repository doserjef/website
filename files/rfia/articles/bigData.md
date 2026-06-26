# Tips for working with big data

## Larger-than-RAM methods

The sheer size of the FIA Database can present a serious challenge for
many users interested in performing regional studies (requiring a large
subset of the database). Recent updates to `rFIA` are intended to reduce
these barriers.

Namely, we’ve implemented “larger-than-RAM” methods for all `rFIA`
estimator functions. In short, behind the scenes we read the necessary
tables for individual states into RAM one at a time and summarize to the
estimation unit level (always sub-state and mutually exclusive
populations, hence additive properties apply). We save the estimation
unit level results for each state in RAM, and combine them into the
final output once we’ve iterated over all states. This may sound
complicated, but *fortunately these “larger-than-RAM” methods use the
exact same syntax as normal “in-memory” operations.*

To get started, we simply have to set up a `Remote.FIA.Database` in
place of our regular in-memory `FIA.Database` by setting
`inMemory=FALSE` in our call to [`readFIA()`](../reference/readFIA.md):

``` r
library(rFIA)
# Download data for two small states
getFIA(c('RI', 'CT'), dir = 'path/to/save/', load = FALSE)

# Now set up a Remote.FIA.Database with readFIA by setting inMemory = FALSE
# Instead of reading in the data now, readFIA will simply save a pointer
# and allow the estimator functions to read/process the data state-by-state
fia <- readFIA('path/to/save/', inMemory = FALSE)
class(fia)
```

    ## [1] "Remote.FIA.Database"

Once set up, our `Remote.FIA.Database` will work exactly the same as we
are used to. That is, we can use the same syntax we have been using for
normal, in-memory operations. For example, to estimate biomass using our
`Remote.FIA.Database`:

``` r
# Estimate biomass with Remote.FIA.Database
biomass(db = fia)
```

    ## # A tibble: 20 × 8
    ##     YEAR BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE nPlots_TREE nPlots_AREA
    ##    <dbl>    <dbl>     <dbl>       <dbl>        <dbl>       <int>       <int>
    ##  1  2005     70.6      34.0        3.19         3.19         219         223
    ##  2  2006     71.1      34.2        2.65         2.66         325         331
    ##  3  2007     71.0      34.2        2.26         2.26         436         442
    ##  4  2008     71.8      34.6        2.21         2.22         425         430
    ##  5  2009     73.6      35.4        2.24         2.24         419         425
    ##  6  2010     75.1      36.1        2.21         2.21         422         426
    ##  7  2011     76.1      36.6        2.18         2.18         435         441
    ##  8  2012     77.1      37.1        2.15         2.15         441         446
    ##  9  2013     77.3      37.2        2.12         2.11         438         443
    ## 10  2014     77.8      37.4        2.12         2.12         439         444
    ## 11  2015     78.3      37.7        2.10         2.10         442         448
    ## 12  2016     79.2      38.1        2.10         2.10         440         445
    ## 13  2017     79.4      38.2        2.11         2.11         438         443
    ## 14  2018     79.6      38.3        2.15         2.15         434         440
    ## 15  2019     80.4      38.7        2.26         2.26         430         436
    ## 16  2020     81.4      39.1        2.26         2.26         428         436
    ## 17  2021     81.3      39.1        2.36         2.36         426         435
    ## 18  2022     82.3      39.6        2.23         2.23         428         436
    ## 19  2023     79.1      38.1        2.40         2.40         409         436
    ## 20  2024     50.9      24.6        7.99         8.00          90         132
    ## # ℹ 1 more variable: N <int>

``` r
# All the extra goodies work the same:
# By species
biomass(fia, bySpecies = TRUE)
```

    ## # A tibble: 1,276 × 11
    ##     YEAR  SPCD COMMON_NAME        SCIENTIFIC_NAME BIO_ACRE CARB_ACRE BIO_ACRE_SE
    ##    <dbl> <int> <chr>              <chr>              <dbl>     <dbl>       <dbl>
    ##  1  2005    10 fir spp.           Abies spp.      0.000761  0.000366       100. 
    ##  2  2005    43 Atlantic white-ce… Chamaecyparis … 0.00398   0.00189         99.9
    ##  3  2005    68 eastern redcedar   Juniperus virg… 0.517     0.269           29.4
    ##  4  2005    91 Norway spruce      Picea abies     0.00445   0.00213        100. 
    ##  5  2005    97 red spruce         Picea rubens    0.0155    0.00745        100. 
    ##  6  2005   125 red pine           Pinus resinosa  0.0300    0.0160         100. 
    ##  7  2005   126 pitch pine         Pinus rigida    0.417     0.199           58.4
    ##  8  2005   129 eastern white pine Pinus strobus   3.78      1.92            20.3
    ##  9  2005   261 eastern hemlock    Tsuga canadens… 2.58      1.24            22.9
    ## 10  2005   315 striped maple      Acer pensylvan… 0.00956   0.00457         77.1
    ## # ℹ 1,266 more rows
    ## # ℹ 4 more variables: CARB_ACRE_SE <dbl>, nPlots_TREE <int>, nPlots_AREA <int>,
    ## #   N <int>

``` r
# Alternative estimators (linear moving average)
biomass(fia, method = 'LMA')
```

    ## # A tibble: 20 × 8
    ##     YEAR BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE nPlots_TREE nPlots_AREA
    ##    <dbl>    <dbl>     <dbl>       <dbl>        <dbl>       <int>       <int>
    ##  1  2005     70.8      34.1        2.97         2.97         219         223
    ##  2  2006     71.5      34.4        2.52         2.51         320         326
    ##  3  2007     72.3      34.8        2.20         2.20         435         441
    ##  4  2008     73.6      35.4        2.38         2.37         412         417
    ##  5  2009     74.3      35.7        2.45         2.44         417         423
    ##  6  2010     76.2      36.6        2.29         2.28         421         425
    ##  7  2011     76.0      36.6        2.45         2.44         435         441
    ##  8  2012     77.6      37.4        2.52         2.52         441         446
    ##  9  2013     77.2      37.1        2.49         2.49         438         443
    ## 10  2014     78.6      37.8        2.50         2.49         439         444
    ## 11  2015     79.0      37.9        2.33         2.32         442         448
    ## 12  2016     80.9      38.9        2.38         2.36         440         445
    ## 13  2017     80.7      38.8        2.51         2.54         438         443
    ## 14  2018     79.9      38.4        2.57         2.59         434         440
    ## 15  2019     81.8      39.4        2.89         2.91         430         436
    ## 16  2020     81.9      39.4        2.86         2.86         428         436
    ## 17  2021     82.5      39.7        2.93         2.92         426         435
    ## 18  2022     82.8      39.8        2.56         2.55         428         436
    ## 19  2023     78.2      37.6        2.68         2.66         409         436
    ## 20  2024     42.6      20.6        6.41         6.41          90         132
    ## # ℹ 1 more variable: N <int>

``` r
# Grouping variables
biomass(fia, grpBy = c(STDORGCD, SITECLCD))
```

    ## # A tibble: 151 × 10
    ##     YEAR STDORGCD SITECLCD BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE
    ##    <dbl>    <int>    <int>    <dbl>     <dbl>       <dbl>        <dbl>
    ##  1  2005        0        3    105.      51.3        12.4         11.9 
    ##  2  2005        0        4     86.5     41.6         7.52         7.53
    ##  3  2005        0        5     72.9     35.1         3.45         3.45
    ##  4  2005        0        6     55.5     26.7         7.37         7.36
    ##  5  2005        0        7     45.6     22.1         9.93        10.3 
    ##  6  2005        1        3     84.7     42.1         0            0   
    ##  7  2005        1        6     10.2      4.94        6.25         6.06
    ##  8  2006        0        3    103.      50.5        11.4         11.0 
    ##  9  2006        0        4     80.9     39.0         6.96         6.89
    ## 10  2006        0        5     75.3     36.2         2.89         2.93
    ## # ℹ 141 more rows
    ## # ℹ 3 more variables: nPlots_TREE <int>, nPlots_AREA <int>, N <int>

In addition, you can still specify spatial-temporal subsets on
`Remote.FIA.Database` objects using
[`clipFIA()`](../reference/clipFIA.md):

``` r
# A most recent subset with the Remote.FIA.Database
fiaMR <- clipFIA(fia)

# Biomass in most recent inventory
biomass(fiaMR)
```

    ## # A tibble: 1 × 8
    ##    YEAR BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE nPlots_TREE nPlots_AREA
    ##   <dbl>    <dbl>     <dbl>       <dbl>        <dbl>       <int>       <int>
    ## 1  2024     76.7      36.9        2.51         2.51         391         438
    ## # ℹ 1 more variable: N <int>

In practice, `rFIA's` new larger-than-RAM methods make it possible for
nearly anyone to work with very large subsets of FIA Database. In our
testing, we have run [`tpa()`](../reference/tpa.md),
[`biomass()`](../reference/biomass.md), [`dwm()`](../reference/dwm.md),
and [`carbon()`](../reference/carbon.md) for the entire continental US
on a machine with just 16 GB of RAM (where the FIA data total ~ 50GB).

The only challenge that the `Remote.FIA.Database` presents is that it
becomes difficult for users to modify variables in FIA tables (e.g.,
make tree size classes). However, it is possible to read in, modify, and
save tables of interest prior to setting up a `Remote.FIA.Database`. For
example, we can extend our example above to produce estimates of live
tree biomass grouped by stand age classes, where stand age classes can
be computed with [`makeClasses()`](../reference/makeClasses.md).

``` r
# Rather than read all tables into memory, just read those of interest
# In this case, we just need the COND table
modTables <- readFIA(dir = 'path/to/save/', tables = 'COND', 
                     states = c('RI', 'CT'), inMemory = TRUE)

# Now we can modify the COND table in any way we like
# Here we just add a variable that we will want to group by later
modTables$COND$STANDAGEGROUP <- makeClasses(modTables$COND$STDAGE, interval = 50)

# Now we can save our changes to the modified tables on disk with writeFIA
# This will overwrite the COND tables previously stored in our target directory
# And allow us to use our new variables in a subsequent 'Remote.FIA.Database'
writeFIA(modTables, dir = 'path/to/save/', byState = TRUE)


# Now set up the Remote database again
fia <- readFIA('path/to/save/', inMemory = FALSE)

# And produce estimates grouped by our new variable
biomass(fia, grpBy = STANDAGEGROUP)
```

    ## # A tibble: 82 × 9
    ##     YEAR STANDAGEGROUP BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE nPlots_TREE
    ##    <dbl> <chr>            <dbl>     <dbl>       <dbl>        <dbl>       <int>
    ##  1  2005 [-49,1)          12.4       5.88       80.2         80.1            3
    ##  2  2005 [1,51)           33.6      16.2        14.2         14.2           35
    ##  3  2005 [101,151)        83.2      39.9         7.39         7.33          18
    ##  4  2005 [51,101)         74.7      35.9         3.19         3.20         178
    ##  5  2006 [-49,1)          12.9       6.11       67.9         67.8            3
    ##  6  2006 [1,51)           35.7      17.2        10.5         10.5           57
    ##  7  2006 [101,151)        79.9      38.3         6.64         6.58          23
    ##  8  2006 [51,101)         76.4      36.8         2.65         2.66         261
    ##  9  2007 [-49,1)           6.19      2.93       91.0         90.9            3
    ## 10  2007 [1,51)           35.5      17.1         9.45         9.43          74
    ## # ℹ 72 more rows
    ## # ℹ 2 more variables: nPlots_AREA <int>, N <int>

## Simple, easy parallelization

All `rFIA` estimator functions (as well as
[`readFIA()`](../reference/readFIA.md) and
[`getFIA()`](../reference/getFIA.md)) can be implemented in parallel,
using the `nCores` argument. By default, processing is implemented
serially with `nCores = 1`, although users may find substantial
increases in efficiency by increasing `nCores`.

Parallelization is implemented with the parallel package. Parallel
implementation is achieved using a snow type cluster on any Windows OS,
and with multicore forking on any Unix OS (Linux, Mac). Implementing
parallel processing may substantially decrease free memory during
processing, particularly on Windows OS. Thus, users should be cautious
when running in parallel, and consider implementing serial processing
for this task if computational resources are limited (`nCores = 1`).

``` r
# Check the number of cores available on your machine 
# Requires the parallel package
parallel::detectCores()
```

    ## [1] 16

``` r
# On our machine, we have a fun 16 cores to play with. 
# To speed processing, we will split the workload 
# across 3 of these cores using nCores = 3
tpaRI_par <- tpa(fiaRI, nCores = 3)
```
