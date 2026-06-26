# Estimating individual-tree and population growth rates

We can use FIA data to estimate how forest structure has changed over
time (i.e., has density increased or declined) or to estimate the
average rate at which individual trees grow. Here we show how we can use
the [`vitalRates()`](../reference/vitalRates.md) function in `rFIA` to
do just that.

For this specific example, we’ll focus on estimating average annual
change in individual tree basal area and cumulative tree basal area per
acre, by site productivity class (SITECLCD) and species across the
states of Washington and Oregon.

So first, we’ll need to download some data (you can skip this step if
you already have FIA data for WA and OR). Here we use
[`getFIA()`](../reference/getFIA.md) to download and save the state
subsets to our computer:

``` r
library(rFIA)
library(dplyr)

# Download some FIA data from the DataMart ------------------------------------
getFIA(states = c('OR', 'WA'),
       dir = 'path/to/save/FIA/data',
       load = FALSE) # Download, but don't load yet
```

Next we’ll read our data into R with
[`readFIA()`](../reference/readFIA.md) and take a most recent subset
across the two states with [`clipFIA()`](../reference/clipFIA.md). Note
that we are setting `inMemory = FALSE` to set up the database in a
remote fashion as opposed to reading the entire data set into RAM. You
would need to set `inMemory = TRUE` if you desire to modify columns in
the database or do any other sort of manipualation to the underlying
data.

``` r
db <- readFIA(dir = fiaPath,
              states = c('OR', 'WA'), # If you keep all your data together
              nCores = 1, # Can set to >1 if you have multiple cores.
              inMemory = FALSE) # Set to TRUE if your computer has enough RAM

# Take the most recent subset -------------------------------------------------
db <- clipFIA(db, mostRecent = TRUE)
```

Now that we have our data loaded, we can start estimating tree growth
rates! First, we’ll estimate *net* growth rates, i.e., we will include
trees that have recruited or died in our estimates of tree growth. Note
that net growth can be negative if mortality exceeds recruitment and
growth on live trees. This type of growth estimate is most useful if
we’re interested in characterizing population-level change. For example,
if we’d like to know how the average rate at which cumulative basal area
per acre has changed in our population of interest, we’d shoot for net
growth. Here’s how we do it with `rFIA`, where net growth is indicated
by the argument `treeType = 'all'`:

``` r
# Net annual change
net <- vitalRates(db,
                  treeType = 'all', # "all" indicates net growth
                  grpBy = SITECLCD, # Grouping by site productivity class
                  bySpecies = TRUE, # also grouping by species
                  variance = TRUE)
net
```

    ## # A tibble: 305 × 26
    ##     YEAR SITECLCD  SPCD COMMON_NAME SCIENTIFIC_NAME DIA_GROW BA_GROW NETVOL_GROW
    ##    <dbl>    <int> <dbl> <chr>       <chr>              <dbl>   <dbl>       <dbl>
    ##  1  2021        1    11 Pacific si… Abies amabilis    0.0609 0.00850      0.462 
    ##  2  2021        1    17 grand fir   Abies grandis    -0.142  0.00197      0.673 
    ##  3  2021        1    22 noble fir   Abies procera     0.194  0.0226       0.986 
    ##  4  2021        1    42 Alaska yel… Chamaecyparis …   0.337  0.0439       0.772 
    ##  5  2021        1    73 western la… Larix occident…   0.511  0.0222       0.377 
    ##  6  2021        1    93 Engelmann … Picea engelman…   0.551  0.0164       0.0867
    ##  7  2021        1    98 Sitka spru… Picea sitchens…   0.156  0.0203       1.01  
    ##  8  2021        1   108 lodgepole … Pinus contorta    0.316  0.0124       0.200 
    ##  9  2021        1   119 western wh… Pinus monticola   0.581  0.0182       0.167 
    ## 10  2021        1   122 ponderosa … Pinus ponderosa   0.09   0.0237       1.40  
    ## # ℹ 295 more rows
    ## # ℹ 18 more variables: SAWVOL_GROW <dbl>, BIO_GROW <dbl>, BA_GROW_AC <dbl>,
    ## #   NETVOL_GROW_AC <dbl>, SAWVOL_GROW_AC <dbl>, BIO_GROW_AC <dbl>,
    ## #   DIA_GROW_VAR <dbl>, BA_GROW_VAR <dbl>, NETVOL_GROW_VAR <dbl>,
    ## #   SAWVOL_GROW_VAR <dbl>, BIO_GROW_VAR <dbl>, BA_GROW_AC_VAR <dbl>,
    ## #   NETVOL_GROW_AC_VAR <dbl>, SAWVOL_GROW_AC_VAR <dbl>, BIO_GROW_AC_VAR <dbl>,
    ## #   nPlots_TREE <int>, nPlots_AREA <int>, N <int>

If we are instead interested in characterizing the average annual growth
rate of individual trees, we’d most likely want to exclude stems that
died or recruited into the population between plot measurements. To do
this with rFIA, simply set `treeType = 'live'`:

``` r
# Annual growth on live trees that remained live
live <- vitalRates(db,
                   treeType = 'live', # "live" excludes mortality and recruitment
                   grpBy = SITECLCD, # Grouping by site productivity class
                   bySpecies = TRUE, # also grouping by species
                   variance = TRUE)
```

By default, [`vitalRates()`](../reference/vitalRates.md) will estimate
average annual DBH, basal area, biomass, and net volume growth rates for
*individual stems*, along with average annual basal area, biomass, and
net volume growth *per acre*. Here we’ll focus in on basal area, so
let’s simplify and pretty up our tables a bit:

``` r
# Net annual change
net <- net %>%
  # Dropping unnecessary columns
  select(SITECLCD, COMMON_NAME, SCIENTIFIC_NAME, SPCD,
         BA_GROW, BA_GROW_AC, BA_GROW_VAR, BA_GROW_AC_VAR, nPlots_TREE, N) %>%
  # Dropping rows with no live trees (growth was NA)
  filter(!is.na(BA_GROW)) %>%
  # Making SITECLCD more informative
  mutate(site = case_when(SITECLCD == 1 ~ "225+ cubic feet/acre/year",
                          SITECLCD == 2 ~ "165-224 cubic feet/acre/year",
                          SITECLCD == 3 ~ "120-164 cubic feet/acre/year",
                          SITECLCD == 4 ~ "85-119 cubic feet/acre/year",
                          SITECLCD == 5 ~ "50-84 cubic feet/acre/year",
                          SITECLCD == 6 ~ "20-49 cubic feet/acre/year",
                          SITECLCD == 7 ~ "0-19 cubic feet/acre/year")) %>%
  # Arrange it nicely
  select(COMMON_NAME, SCIENTIFIC_NAME, SITECLCD, site, everything()) %>%
  arrange(COMMON_NAME, SCIENTIFIC_NAME, SITECLCD, site)

# Annual growth on live trees that remained live
live <- live %>%
  # Dropping unnecessary columns
  select(SITECLCD, COMMON_NAME, SCIENTIFIC_NAME, SPCD,
         BA_GROW, BA_GROW_AC, BA_GROW_VAR, BA_GROW_AC_VAR, nPlots_TREE, N) %>%
  # Dropping rows with no live trees (growth was NA)
  filter(!is.na(BA_GROW)) %>%
  # Making SITECLCD more informative
  mutate(siteProd = case_when(SITECLCD == 1 ~ "225+ cubic feet/acre/year",
                              SITECLCD == 2 ~ "165-224 cubic feet/acre/year",
                              SITECLCD == 3 ~ "120-164 cubic feet/acre/year",
                              SITECLCD == 4 ~ "85-119 cubic feet/acre/year",
                              SITECLCD == 5 ~ "50-84 cubic feet/acre/year",
                              SITECLCD == 6 ~ "20-49 cubic feet/acre/year",
                              SITECLCD == 7 ~ "0-19 cubic feet/acre/year")) %>%
  # Arrange it nicely
  select(COMMON_NAME, SCIENTIFIC_NAME, SITECLCD, siteProd, everything()) %>%
  arrange(COMMON_NAME, SCIENTIFIC_NAME, SITECLCD, siteProd)
```

Here `BA_GROW` gives us annual basal area growth per tree in square
feet/year, and `BA_GROW_AC` gives us average basal area growth per acre
in square feet/acre/year. But maybe we’d prefer units to be square
centimeters instead - just remember to multiply the variance by the
square of the conversion factor!

``` r
# Net annual change
net <- net %>%
  # Convert to square centimeters instead of square feet
  mutate(BA_GROW = BA_GROW * 929.03,
         BA_GROW_AC = BA_GROW_AC * 929.03,
         BA_GROW_VAR = BA_GROW_VAR * (929.03^2),
         BA_GROW_AC_VAR = BA_GROW_AC_VAR * (929.03^2))
net
```

    ## # A tibble: 305 × 11
    ##    COMMON_NAME          SCIENTIFIC_NAME  SITECLCD site   SPCD BA_GROW BA_GROW_AC
    ##    <chr>                <chr>               <int> <chr> <dbl>   <dbl>      <dbl>
    ##  1 Alaska yellow-cedar  Chamaecyparis n…        1 225+…    42  40.8       1.26  
    ##  2 Alaska yellow-cedar  Chamaecyparis n…        2 165-…    42  11.2       0.632 
    ##  3 Alaska yellow-cedar  Chamaecyparis n…        3 120-…    42   2.62      0.524 
    ##  4 Alaska yellow-cedar  Chamaecyparis n…        4 85-1…    42   4.57      3.05  
    ##  5 Alaska yellow-cedar  Chamaecyparis n…        5 50-8…    42   3.24      3.02  
    ##  6 Alaska yellow-cedar  Chamaecyparis n…        6 20-4…    42   1.45      1.30  
    ##  7 Alaska yellow-cedar  Chamaecyparis n…        7 0-19…    42   0.236     0.198 
    ##  8 Brewer spruce        Picea breweriana        6 20-4…    92   3.75      0.0298
    ##  9 California black oak Quercus kellogg…        2 165-…   818   0.797     0.0231
    ## 10 California black oak Quercus kellogg…        3 120-…   818  -1.14     -0.117 
    ## # ℹ 295 more rows
    ## # ℹ 4 more variables: BA_GROW_VAR <dbl>, BA_GROW_AC_VAR <dbl>,
    ## #   nPlots_TREE <int>, N <int>

``` r
# Annual growth on live trees that remained live
live <- live %>%
  # Convert to square centimeters instead of square feet
  mutate(BA_GROW = BA_GROW * 929.03,
         BA_GROW_AC = BA_GROW_AC * 929.03,
         BA_GROW_VAR = BA_GROW_VAR * (929.03^2),
         BA_GROW_AC_VAR = BA_GROW_AC_VAR * (929.03^2))
live
```

    ## # A tibble: 289 × 11
    ##    COMMON_NAME        SCIENTIFIC_NAME SITECLCD siteProd  SPCD BA_GROW BA_GROW_AC
    ##    <chr>              <chr>              <int> <chr>    <dbl>   <dbl>      <dbl>
    ##  1 Alaska yellow-ced… Chamaecyparis …        1 225+ cu…    42   40.8      1.26  
    ##  2 Alaska yellow-ced… Chamaecyparis …        2 165-224…    42   12.8      0.483 
    ##  3 Alaska yellow-ced… Chamaecyparis …        3 120-164…    42   10.2      1.41  
    ##  4 Alaska yellow-ced… Chamaecyparis …        4 85-119 …    42    6.95     3.89  
    ##  5 Alaska yellow-ced… Chamaecyparis …        5 50-84 c…    42    4.68     3.63  
    ##  6 Alaska yellow-ced… Chamaecyparis …        6 20-49 c…    42    4.20     3.33  
    ##  7 Alaska yellow-ced… Chamaecyparis …        7 0-19 cu…    42    6.36     4.48  
    ##  8 Brewer spruce      Picea breweria…        6 20-49 c…    92    3.75     0.0298
    ##  9 California black … Quercus kellog…        2 165-224…   818   11.1      0.131 
    ## 10 California black … Quercus kellog…        3 120-164…   818    4.09     0.206 
    ## # ℹ 279 more rows
    ## # ℹ 4 more variables: BA_GROW_VAR <dbl>, BA_GROW_AC_VAR <dbl>,
    ## #   nPlots_TREE <int>, N <int>
