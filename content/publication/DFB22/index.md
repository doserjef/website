---
abstract: "Determining spatial distributions of species and communities are key objectives of ecology and conservation. Joint species distribution models use multi-species detection-nondetection data to estimate species and community distributions. The analysis of such data is complicated by residual correlations between species, imperfect detection, and spatial autocorrelation. While methods exist to accommodate each of these complexities, there are few examples in the literature that address and explore all three complexities simultaneously. Here we developed a spatial factor multi-species occupancy model to explicitly account for species correlations, imperfect detection, and spatial autocorrelation. The proposed model uses a spatial factor dimension reduction approach and Nearest Neighbor Gaussian Processes to ensure computational efficiency for data sets with both a large number of species (e.g., > 100) and spatial locations (e.g., 100,000). We compare the proposed model performance to five candidate models, each addressing a subset of the three complexities. We implemented the proposed and competing models in the `spOccupancy` software, designed to facilitate application via an accessible, well-documented, and open-source R package. Using simulations, we found ignoring the three complexities when present leads to inferior model predictive performance, and the impacts of failing to account for one or more complexities will depend on the objectives of a given study. Using a case study on 98 bird species across the continental US, the spatial factor multi-species occupancy model had the highest predictive performance among the candidate models. Further, our model successfully distinguished between two biogeographical species groups within the 98 species, indicating the potential of our framework as a model-based ordination technique. Our proposed framework, together with its implementation in `spOccupancy`, serves as a user-friendly tool to understand spatial variation in species distributions and biodiversity metrics while addressing common complexities in multi-species detection-nondetection data."
authors:
- Jeffrey W. Doser
- Andrew O. Finley
- Sudipto Banerjee
date: "2022-11-25T00:00:00Z"
doi: ""
featured: false
publication: ""
publication_short: ""
publication_types:
- "3"
publishDate: "2021-09-06T00:00:00Z"
slides: ''
summary: ""
title: "Joint species distribution models with imperfect detection for high-dimensional spatial data"
url_code: 'https://github.com/doserjef/Doser_et_al_2022'
url_dataset: 'https://github.com/doserjef/Doser_et_al_2022'
url_pdf: 'https://arxiv.org/pdf/2204.02707.pdf'
url_poster: ''
url_project: 'https://cran.r-project.org/web/packages/spOccupancy/index.html'
url_slides: ''
url_source: 'https://github.com/doserjef/spOccupancy'
url_video: ''
---


