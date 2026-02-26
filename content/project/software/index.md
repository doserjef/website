---
date: "2026-02-25T00:00:00Z"
external_link: ""
image:
  caption:
  focal_point: smart
slides:
summary: "Effective forest and wildlife management requires user-friendly software that makes state-of-the-art statistical tools and data products accessible to natural resource managers, foresters, wildlife professionals, and conservation practitioners. A key pillar of the lab's research is developing computationally-efficient and accessible software to inform natural resource management and conservation."
title: "Natural resources software development"
url_code: ""
url_pdf: ""
url_slides: ""
url_video: ""
---

Effective forest and wildlife management requires user-friendly software that makes state-of-the-art statistical tools accessible to natural resource managers, foresters, wildlife professionals, and conservation practitioners. A key pillar of the lab's research is developing computationally-efficient and accessible software to inform natural resource management and conservation.

I am the lead author and maintainer of the [spOccupancy R package](https://www.jeffdoser.com/files/spoccupancy-web/), which fits spatially explicit single-species, multi-species, and integrated Bayesian occupancy models ([Doser et al. 2022 MEE](https://www.jeffdoser.com/publication/dfkz21/)), with an emphasis on making these complex statistical models accessible to ecologists, managers, and conservation practitioners that may lack extensive training in spatial statistics. With collaborators across the world, I am actively using spOccupancy to inform effective conservation and management approaches for birds, mammals, trees, bats, crickets, invasive aquatic plants, and cartilaginous fish. For example, with collaborators at the University of Arkansas, we used spOccupancy within a scenario planning framework to understand the effects of multiple woodland restoration outcomes on bird communities in Arkansas, USA ([Roberts et al. 2024 Restoration Ecology](https://www.jeffdoser.com/publication/rdbfmmrssw23/)). 

I am also the lead author and maintainer of the R package [spAbundance](https://www.jeffdoser.com/files/spabundance-web/) that provides user-friendly approaches to efficiently fit spatially explicit single-species (i.e., univariate) and multi-species (i.e., multivariate) abundance-based generalized linear models, N-mixture models, and distance sampling models ([Doser et al. 2024 MEE](https://www.jeffdoser.com/publication/dfkz23/)). spAbundance allows for robust modeling of multi-species abundance patterns, providing crucial insight into the patterns that determine population dynamics and ecological communities. While the package name is geared towards abundance estimation, the package implements a suite of univariate and multivariate spatial GLMMs that can be used for modeling response variables besides abundance. In particular, much of the recent package development has focused on improving the spatial GLMM capabilities for performing small area estimation with forest inventory data ([Doser et al. 2025 Forest Ecology and Management](https://www.sciencedirect.com/science/article/pii/S0378112725006206?via%3Dihub)). We used `spAbundance` to explore trends in butterfly communities across the midwestern US ([Leuenberger et al. 2025](https://www.pnas.org/doi/abs/10.1073/pnas.2501340122)), pollinator communities in Maryland, US ([Quinlan et al. 2025](https://www.sciencedirect.com/science/article/pii/S0048969724059394)), and American chestnut restoration across the eastern US (Fertakos et al. In review). 

In 2024, I took over as the lead developer and maintainer of the [rFIA R package](https://doserlab.com/files/rfia/), which increases the accessibility and use of the USFS Forest Inventory and Analysis (FIA) Database by providing a user-friendly, open-source platform to easily query and analyze FIA data. Future projects in the SEFS Lab include building in model-based estimators into rFIA for estimating forest carbon at user-defined spatial scales. 

I contributed to the the R package [ForestFit](https://cran.r-project.org/web/packages/ForestFit/index.html), which is designed to streamline estimation of common probability distributions used to model tree diameter distributions, including two and three parameter Weibull distributions, Johnson's SB distribution, Birnbaum-Saunders distribution, and finite mixture distributions in both a frequentist and Bayesian approach. The package includes additional functionality for estimating parameters of common tree height-diameter models.  

