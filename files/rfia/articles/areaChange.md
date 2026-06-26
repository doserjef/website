# Estimating temporal changes in land area

The increasing availability of remeasured FIA plots offers the unique
opportunity to move from asking questions about the *status* of forest
resources, to questions of how resources have *changed* over time. For
example, we could use the [`area()`](../reference/area.md) function in
rFIA to determine the relative land area occupied by various forest
types in a landscape or region of interest, i.e., it’s current
composition. But how has the composition of that landscape changed in
recent decades? What are the primary drivers of such change? And how
does this shape our thinking of what the landscape will look like in the
future?

rFIA v0.3.1 gave rise to the
[`areaChange()`](../reference/areaChange.md) function, which allows us
to address such questions using FIA data alone.

By default, [`areaChange()`](../reference/areaChange.md) will estimate
*net* annual change in forest land area within a region over time. As
always, you can check out our complete documentation with by clicking on
[`areaChange()`](../reference/areaChange.md) (or opening up the same
information in R via [`?areaChange`](../reference/areaChange.md)):

``` r
library(rFIA)

# Download the FIA data for Rhode Island 
ri <- getFIA('RI')

# Estimate change in forestland area
areaChange(ri)
```

    ## # A tibble: 17 × 9
    ##     YEAR PERC_CHNG AREA_CHNG PREV_AREA PERC_CHNG_SE AREA_CHNG_SE PREV_AREA_SE
    ##    <dbl>     <dbl>     <dbl>     <dbl>        <dbl>        <dbl>        <dbl>
    ##  1  2008   -0.612     -2383.   389114.         84.8         84.0        10.4 
    ##  2  2009   -0.424     -1411.   332902.         93.7         92.5         6.17
    ##  3  2010   -0.590     -2108.   357309.         62.4         61.4         4.82
    ##  4  2011   -0.131      -466.   356992.        302.         302.          4.52
    ##  5  2012    0.104       377.   363420.        369.         369.          3.89
    ##  6  2013    0.224       833.   371634.        176.         175.          3.57
    ##  7  2014    0.329      1213.   368937.        114.         114.          3.74
    ##  8  2015    0.383      1404.   366790.         91.3         90.4         3.78
    ##  9  2016    0.0473      173.   366439.        703.         702.          3.91
    ## 10  2017    0.0909      331.   363600.        414.         413.          3.86
    ## 11  2018   -0.0656     -238.   363831.        533.         535.          3.85
    ## 12  2019   -0.567     -2099.   370239.         57.8         58.6         3.45
    ## 13  2020   -0.689     -2542.   368700.         51.5         52.1         3.76
    ## 14  2021   -0.751     -2744.   365531.         49.4         49.9         3.76
    ## 15  2022   -0.484     -1831.   378440.         68.1         69.1         3.79
    ## 16  2023   -0.153      -574.   375522.        203.         204.          3.71
    ## 17  2024   -0.111      -426.   385391.        245.         245.          3.54
    ## # ℹ 2 more variables: nPlots_AREA <int>, N <int>

Here `AREA_CHNG` is the estimated annual change in forest land area in
acres, and `PERC_CHNG` is the estimated annual change as a percentage of
previous total forestland. Importantly, the values estimated above are
*net* changes (`chngType="NET"`). In other words, these changes epresent
the combined effects of reversion (non-forest becoming forest) and
diversion (forest becoming non-forest).

Often, however, examining the *components of change* can yield valuable
insight into the drivers of net changes in forest resources. As such,
[`areaChange()`](../reference/areaChange.md) allows us to explicitly
estimate change components when `chngType = "component"`. In our simple
example, this means estimating the annual rates of reversion and
diversion in our region:

``` r
# Estimate change in forestland area by component
areaChange(ri, chngType = 'component')
```

    ## # A tibble: 51 × 11
    ##     YEAR STATUS1 STATUS2 PERC_CHNG AREA_CHNG PREV_AREA PERC_CHNG_SE AREA_CHNG_SE
    ##    <dbl> <chr>   <chr>       <dbl>     <dbl>     <dbl>        <dbl>        <dbl>
    ##  1  2008 Forest  Forest        0          0    375257.       NaN           NaN  
    ##  2  2008 Forest  Non-fo…      19.2     2654.    13857.         5.21         73.9
    ##  3  2008 Non-fo… Forest       21.4      272.     1268.         1.11        106. 
    ##  4  2009 Forest  Forest        0          0    321493.       NaN           NaN  
    ##  5  2009 Forest  Non-fo…      20.0     2281.    11409.         3.66         53.3
    ##  6  2009 Non-fo… Forest       20.7      869.     4207.         1.23         49.7
    ##  7  2010 Forest  Forest        0          0    340459.       NaN           NaN  
    ##  8  2010 Forest  Non-fo…      19.7     3313.    16850.         3.32         35.8
    ##  9  2010 Non-fo… Forest       21.1     1205.     5699.         1.89         40.1
    ## 10  2011 Forest  Forest        0          0    343518.       NaN           NaN  
    ## # ℹ 41 more rows
    ## # ℹ 3 more variables: PREV_AREA_SE <dbl>, nPlots_AREA <int>, N <int>

Here `STATUS1` and `STATUS2` represent the land classification at first
and second measurements, respectively. For the 2010 inventory, we
estimate that 3,313 acres of forestland were diverted to a non-forest
land use annually, and 1,205 acres of non-forest were reverted back to
the forest land base. Here our losses (3,313 acres) exceed our gains
(1,205 acres), and their difference is equal to the net change
(`AREA_CHNG`) we estimated previously when `chngType = 'NET'` (-2,108
acres).

We can extend this example by examining patterns of change across some
variable of interest, let’s say ownership classes:

``` r
# Grab only the most recent survey
ri_mr <- clipFIA(ri)
# Estimate NET change in forestland area by ownership group
areaChange(ri_mr, grpBy = OWNGRPCD, chngType = 'net')
```

    ## # A tibble: 2 × 10
    ##    YEAR OWNGRPCD PERC_CHNG AREA_CHNG PREV_AREA PERC_CHNG_SE AREA_CHNG_SE
    ##   <dbl>    <int>     <dbl>     <dbl>     <dbl>        <dbl>        <dbl>
    ## 1  2024       30   -0.353     -455.    128868.         139.         141.
    ## 2  2024       40    0.0113      29.1   256523.        3531.        3529.
    ## # ℹ 3 more variables: PREV_AREA_SE <dbl>, nPlots_AREA <int>, N <int>

``` r
# Estimate component change in forestland area by ownership group
areaChange(ri_mr, grpBy = OWNGRPCD, chngType = 'component')
```

    ## # A tibble: 8 × 13
    ##    YEAR OWNGRPCD1 OWNGRPCD2 STATUS1    STATUS2    PERC_CHNG AREA_CHNG PREV_AREA
    ##   <dbl>     <int>     <int> <chr>      <chr>          <dbl>     <dbl>     <dbl>
    ## 1  2024        30        30 Forest     Forest           0          0    122431.
    ## 2  2024        30        40 Forest     Forest          14.7      327.     2231.
    ## 3  2024        30        NA Forest     Non-forest      14.7      620.     4206.
    ## 4  2024        40        30 Forest     Forest          13.6      320.     2346.
    ## 5  2024        40        40 Forest     Forest           0          0    243418.
    ## 6  2024        40        NA Forest     Non-forest      14.4     1554.    10760.
    ## 7  2024        NA        30 Non-forest Forest          14.1      172.     1223.
    ## 8  2024        NA        40 Non-forest Forest          14.7     1575.    10698.
    ## # ℹ 5 more variables: PERC_CHNG_SE <dbl>, AREA_CHNG_SE <dbl>,
    ## #   PREV_AREA_SE <dbl>, nPlots_AREA <int>, N <int>

Note that when, `grpBy` is specified, change components are estimated
for all shifts in forest land area across the classified attributes
represented by the variables (first and second measurements again
denoted by the suffix 1 and 2). In our case this means `OWNGRPCD1`
indicates ownership at initial measurement and `OWNGRPCD2` is ownership
at final measurement. Unfortunately, ownership group is unavailable for
non-forest conditions and hence initial ownership is listed as `NA` for
all non-forest to forest conversions (and forest to non-forest
conversions).

Finally, what if we were interested in understanding change in forest
land that meets some specific criteria? We can easily accomplish this
using the `treeDomain` argument. For example, below we calculate net
change for forest land that contains live (`STATUSCD == 1`) eastern
hemlock (`SPCD == 261`).

``` r
areaChange(ri, treeDomain = STATUSCD == 1 & SPCD == 261) 
```

    ## # A tibble: 17 × 9
    ##     YEAR PERC_CHNG AREA_CHNG PREV_AREA PERC_CHNG_SE AREA_CHNG_SE PREV_AREA_SE
    ##    <dbl>     <dbl>     <dbl>     <dbl>        <dbl>        <dbl>        <dbl>
    ##  1  2008     0            0     33214.        NaN          NaN           69.4
    ##  2  2009     0            0     16605.        NaN          NaN           71.5
    ##  3  2010     0            0     21452.        NaN          NaN           53.1
    ##  4  2011     0            0     23980.        NaN          NaN           45.4
    ##  5  2012     4.36       818.    18780.        102.          89.4         46.5
    ##  6  2013     4.03       921.    22840.         96.0         84.8         40.6
    ##  7  2014     4.03       921.    22840.         96.4         85.1         40.8
    ##  8  2015     4.03       885.    21944.         98.6         87.1         41.8
    ##  9  2016     3.23       820.    25435.         98.1         88.5         37.6
    ## 10  2017     2.41       565.    23469.        138.         126.          38.7
    ## 11  2018     2.41       565.    23469.        138.         126.          38.7
    ## 12  2019    -0.678     -189.    27889.         84.7         91.7         36.2
    ## 13  2020    -0.679     -195.    28808.         84.3         91.3         36.0
    ## 14  2021    -0.689     -214.    31109.         81.7         88.5         35.0
    ## 15  2022    -3.23      -980.    30341.         60.0         70.6         34.9
    ## 16  2023    -2.21      -650.    29363.        106.         118.          35.2
    ## 17  2024    -1.58      -464.    29367.        155.         164.          34.5
    ## # ℹ 2 more variables: nPlots_AREA <int>, N <int>

In this case, the `AREA_CHNG` column corresponds to the net change (in
acres) of forest land that contains at least one live eastern hemlock
tree, while the `PREV_AREA` column indicates the previous area (in
acres) of forest land with at least one hemlock tree. Notice that the
`PERC_CHNG` columns is simply calculated as
`AREA_CHNG / PREV_AREA * 100`.
