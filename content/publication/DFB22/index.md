---
abstract: "Determining the spatial distributions of species and communities is a key task in ecology and conservation efforts. Joint species distribution models are a fundamental tool in community ecology that use multi-species detection–nondetection data to estimate species distributions and biodiversity metrics. The analysis of such data is complicated by residual correlations between species, imperfect detection, and spatial autocorrelation. While many methods exist to accommodate each of these complexities, there are few examples in the literature that address and explore all three complexities simultaneously. Here we developed a spatial factor multi-species occupancy model to explicitly account for species correlations, imperfect detection, and spatial autocorrelation. The proposed model uses a spatial factor dimension reduction approach and Nearest Neighbor Gaussian Processes to ensure computational efficiency for data sets with both a large number of species (e.g., >100) and spatial locations (e.g., 100,000). We compared the proposed model performance to five alternative models, each addressing a subset of the three complexities. We implemented the proposed and alternative models in the spOccupancy software, designed to facilitate application via an accessible, well documented, and open-source R package. Using simulations, we found that ignoring the three complexities when present leads to inferior model predictive performance, and the impacts of failing to account for one or more complexities will depend on the objectives of a given study. Using a case study on 98 bird species across the continental US, the spatial factor multi-species occupancy model had the highest predictive performance among the alternative models. Our proposed framework, together with its implementation in spOccupancy, serves as a user-friendly tool to understand spatial variation in species distributions and biodiversity while addressing common complexities in multi-species detection–nondetection data."
authors:
- Jeffrey W. Doser
- Andrew O. Finley
- Sudipto Banerjee
date: "2023-07-16T00:00:00Z"
doi: ""
featured: false
publication: "In: Ecology (2023) https://esajournals.onlinelibrary.wiley.com/doi/10.1002/ecy.4137"
publication_short: ""
publication_types:
- "2"
publishDate: "2023-07-16T00:00:00Z"
slides: ''
summary: ""
title: "Joint species distribution models with imperfect detection for high-dimensional spatial data"
url_code: 'https://github.com/doserjef/Doser_et_al_2023_Ecology'
url_dataset: 'https://github.com/doserjef/Doser_et_al_2023_Ecology'
url_pdf: 'https://esajournals.onlinelibrary.wiley.com/doi/epdf/10.1002/ecy.4137'
url_poster: ''
url_project: 'https://cran.r-project.org/web/packages/spOccupancy/index.html'
url_slides: ''
url_source: 'https://github.com/doserjef/spOccupancy'
url_video: ''
---


