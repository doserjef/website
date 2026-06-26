# Estimating tree biomass and merchantable volume

## Introduction

Prior to `rFIA` v0.3.1, the [`biomass()`](../reference/biomass.md)
function provided estimates of volume, biomass, and carbon stocks of
standing trees. This is what is described in the introductory `rFIA`
manuscript ([Stanke et
al. 2020](https://research.fs.usda.gov/treesearch/59521).

`rFIA` v0.3.1 introduced breaking changes to the
[`biomass()`](../reference/biomass.md) function and how `rFIA` handles
volume, carbon, and biomass estimation. Specifically, the
[`biomass()`](../reference/biomass.md) function was overhauled to focus
solely on estimation of tree biomass and carbon, providing enhanced
flexibility in the estimation of *biomass components* (e.g., bole,
limbs, coarse roots, etc.). In addition, v0.3.1 gave rise to the
[`volume()`](../reference/volume.md) function, which supersedes and
expands upon the previous merchantable volume estimators implemented in
[`biomass()`](../reference/biomass.md).

As of `rFIA` v1.1.0, the [`biomass()`](../reference/biomass.md),
[`volume()`](../reference/volume.md), and
[`carbon()`](../reference/carbon.md) functions now all leverage FIA’s
new National Scale Volume and Biomass Estimators (NSVB), which provides
a more consistent and accurate accounting of structural components of
trees. As with previous versions of
[`biomass()`](../reference/biomass.md), estimates can be returned by
tree component using the `byComponent` method, although we note the
specific components available have changged given underlying changes in
FIADB and the NSVB approach. The NSVB represents a substantial
advancement in national scale volume and biomass equations, and
importantly estimates of carbon now leverage species-specific carbon
fractions instead of the previous generic assumption that tree carbon
was equal to 50% of tree biomass. Below we provide some basic examples
of [`biomass()`](../reference/biomass.md) and
[`volume()`](../reference/volume.md).

## Estimating tree biomass components

Let’s see how the [`biomass()`](../reference/biomass.md) function can be
used to estimate tree biomass components! As always, you can check out
our documentation with [`?biomass`](../reference/biomass.md):

``` r
# Load data from the rFIA package
library(rFIA)
data(fiaRI)

# Total live tree aboveground biomass, excluding foliage (default)
biomass(fiaRI)
```

    ## # A tibble: 6 × 8
    ##    YEAR BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE nPlots_TREE nPlots_AREA
    ##   <dbl>    <dbl>     <dbl>       <dbl>        <dbl>       <int>       <int>
    ## 1  2013     71.5      34.6        3.97         4.00         120         123
    ## 2  2014     72.6      35.1        3.99         4.01         121         123
    ## 3  2015     74.0      35.8        3.96         3.98         122         124
    ## 4  2016     75.8      36.6        3.80         3.82         124         125
    ## 5  2017     76.2      36.8        3.86         3.89         124         125
    ## 6  2018     75.7      36.6        3.87         3.90         126         127
    ## # ℹ 1 more variable: N <int>

By default, `biomass` estimates total aboveground live tree biomass for
all reporting years available in the `FIA.Database`
(`treeType = "live"`, `component = "AG"`). Here aboveground tree biomass
is a simple summation of wood biomass in the total stem from ground line
to the tree tip, stem bark biomass, and branch wood and bark. Carbon is
estimated using species carbon fractions.

But what if we’re interested in estimating biomass within different tree
components separately, e.g., we want an individual estimate for bole,
foliage, stump, and others? Simply set the new `byComponent` argument to
`TRUE`:

``` r
biomass(db = clipFIA(fiaRI), byComponent = TRUE)
```

    ## # A tibble: 11 × 9
    ##     YEAR COMPONENT   BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE nPlots_TREE
    ##    <dbl> <chr>          <dbl>     <dbl>       <dbl>        <dbl>       <int>
    ##  1  2018 BOLE          43.1      20.9          4.27         4.31         126
    ##  2  2018 BOLE_BARK      6.79      3.28         3.86         3.89         126
    ##  3  2018 BRANCH        19.0       9.19         4.42         4.43         126
    ##  4  2018 FOLIAGE        2.09      0            3.05       NaN            126
    ##  5  2018 ROOT          14.0       6.78         4.10         4.15         126
    ##  6  2018 SAWLOG        24.5      11.9          7.46         7.53         126
    ##  7  2018 SAWLOG_BARK    3.75      1.82         7.17         7.23         126
    ##  8  2018 STEM          48.9      23.6          3.90         3.94         126
    ##  9  2018 STEM_BARK      7.78      3.76         3.49         3.51         126
    ## 10  2018 STUMP          2.33      1.13         3.13         3.13         126
    ## 11  2018 STUMP_BARK     0.375     0.181        2.92         2.90         126
    ## # ℹ 2 more variables: nPlots_AREA <int>, N <int>

Note that the sum of the provided components is NOT equal to total tree
biomass. In other words, the components are not mutually exclusive
(e.g., `BOLE` biomass is part of `STEM` biomass). Aboveground tree
biomass is equal to the sum of `STEM`, `STEM_BARK`, and `BRANCH`. The
*Estimation Details* section of the help page for
[`biomass()`](../reference/biomass.md) provides all this information and
more.

Awesome, but what if we want to estimate biomass for some combination of
these components, e.g., bole plus stump? The new `component` argument
has our backs. Users can specify any combination of components seen in
the output above. For example, say we want to estimate abovegound
biomass (`"AG"`) plus foliage (`"FOLIAGE"`):

``` r
biomass(db = clipFIA(fiaRI), component = c("AG", "FOLIAGE"))
```

    ## # A tibble: 1 × 8
    ##    YEAR BIO_ACRE CARB_ACRE BIO_ACRE_SE CARB_ACRE_SE nPlots_TREE nPlots_AREA
    ##   <dbl>    <dbl>     <dbl>       <dbl>        <dbl>       <int>       <int>
    ## 1  2018     77.7      36.6        3.82         3.90         126         127
    ## # ℹ 1 more variable: N <int>

## Estimating merchantable tree volume

Previously, [`biomass()`](../reference/biomass.md) included support for
estimation of net merchantable volume and net sawlog volume in units of
cubic feet. Since `rFIA` v0.3.1, the
[`volume()`](../reference/volume.md) function expands on this previous
capacity in two key ways: (1) allowing use of alternative volume
definitions used by the FIA program (i.e., net, sound, and gross
volume), and (2) offering estimates of sawlog volume in units of cubic
feet (CF) and thousand board feet (MBF; International 1/4 inch rule).

By default, [`volume()`](../reference/volume.md) will estimate net
volume of live trees (`volType = "NET"` and `treeType = "live"`):

``` r
volume(db = fiaRI)
```

    ## # A tibble: 6 × 10
    ##    YEAR BOLE_CF_ACRE SAW_CF_ACRE SAW_MBF_ACRE BOLE_CF_ACRE_SE SAW_CF_ACRE_SE
    ##   <dbl>        <dbl>       <dbl>        <dbl>           <dbl>          <dbl>
    ## 1  2013        2305.       1366.         7.02            5.11           8.49
    ## 2  2014        2356.       1402.         7.17            5.10           8.41
    ## 3  2015        2409.       1445.         7.38            5.00           8.32
    ## 4  2016        2475.       1493.         7.58            4.91           8.16
    ## 5  2017        2480.       1497.         7.63            4.97           8.26
    ## 6  2018        2470.       1493.         7.63            4.99           8.26
    ## # ℹ 4 more variables: SAW_MBF_ACRE_SE <dbl>, nPlots_TREE <int>,
    ## #   nPlots_AREA <int>, N <int>

Here, `BOLE_CF_ACRE` gives us merchantable bole volume per acre,
`SAW_CF_ACRE` gives us sawlog volume in cubic feet per acre, and
`SAW_MBF_ACRE` gives us sawlog volume in thousand board feet per acre
(International 1/4 inch rule).

We can change our volume definition using the `volType` argument. Let’s
try gross volume instead:

``` r
volume(db = fiaRI, volType = 'gross')
```

    ## # A tibble: 6 × 10
    ##    YEAR BOLE_CF_ACRE SAW_CF_ACRE SAW_MBF_ACRE BOLE_CF_ACRE_SE SAW_CF_ACRE_SE
    ##   <dbl>        <dbl>       <dbl>        <dbl>           <dbl>          <dbl>
    ## 1  2013        2680.       1551.         7.95            4.97           8.41
    ## 2  2014        2741.       1592.         8.13            4.94           8.33
    ## 3  2015        2804.       1642.         8.38            4.84           8.26
    ## 4  2016        2885.       1695.         8.60            4.72           8.10
    ## 5  2017        2902.       1703.         8.67            4.76           8.19
    ## 6  2018        2888.       1700.         8.69            4.77           8.19
    ## # ℹ 4 more variables: SAW_MBF_ACRE_SE <dbl>, nPlots_TREE <int>,
    ## #   nPlots_AREA <int>, N <int>

So what do these different definitions mean? FIA defines net volume
(`volType="NET"`) as: “The net volume of wood in the central stem of
timber species (trees where diameter is measured at breast height $\geq$
5.0 inches d.b.h., from a 1-foot stump to a minimum 4-inch top diameter,
or to where the central stem breaks into limbs all of which are \<4.0
inches in diameter…. Does not include rotten, missing, and form cull
(volume loss due to rotten, missing, and form cull defect has been
deducted).” In `volum()`, we could also choose from two alternative
definitions: sound volume (`volType = 'SOUND'`) or gross volume
(`volType = 'GROSS'`). Sound volume is identical to net volume except
that sound includes volume from portions of the stem that are be
considered “form cull” under the net volume definition (e.g., sweep). In
contrast, gross volume is identical to the net volume definition except
that gross includes volume from portions of the stem that are rotten,
missing, and considered form cull.
