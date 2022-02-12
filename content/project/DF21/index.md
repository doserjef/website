---
date: "2021-11-28T00:00:00Z"
external_link: ""
image:
  focal_point: Smart
slides:
summary: ""
title: "Joint species distribution models with imperfect detection for high-dimensional spatial data"
url_code: "https://github.com/doserjef/spOccupancy"
url_pdf: ""
url_slides: ""
url_video: ""
---

I am currently developing a joint species distribution model with imperfect detection that incorporates residual species correlations as well as spatial autocorrelation. I am leveraging a spatial factor model framework to allow for computationally efficient modeling of large communities, as well as Nearest Neighbor Gaussian Processes for computational efficiency for large spatial data sets. I am applying this framework to a community of approximately 100 bird species across the continental US. I am implementing the framework in the `spOccupancy` R package. The [development version](https://github.com/doserjef/spOccupancy) of the package currently has implementations of the modeling framework, which will be included in the CRAN version sometime in spring 2022. 
