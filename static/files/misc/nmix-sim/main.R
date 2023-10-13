# main.R: script to run a VERY small simulation study to look at the performance
#         of the "marginal" vs. "conditional" posterior predictive checks. 
# Author: Jeffrey W. Doser
rm(list = ls())
library(spAbundance)

# Simulation parameters ---------------------------------------------------
# Number of simulations
n.sims <- 20
# Object to hold Bayesian p-values from marginal fitted values
marginal.bps <- rep(NA, n.sims)
# Object to hold Bayesian p-values from conditional fitted values
conditional.bps <- rep(NA, n.sims)

# Run the simulations -----------------------------------------------------
for (i in 1:n.sims) {
  print(paste0("Currently on simulation ", i, " out of ", n.sims))
  # Simulate the data -----------------------------------------------------
  J.x <- 15
  J.y <- 15
  # Number of spatial locations
  J <- J.x * J.y
  # At most 3 replicates per site
  n.rep <- sample(3, J, replace = TRUE)
  # n.rep <- rep(3, J)
  # Intercept and two spatially-varying covariates on abundance
  beta <- runif(3, -1, 1)
  p.abund <- length(beta)
  # Intercept and two observation-level varying covariates on detection
  alpha <- runif(3, -1, 1)
  p.det <- length(alpha)
  # No random effects
  mu.RE <- list()
  p.RE <- list()
  phi <- runif(1, 3 / 1, 3 / 0.3)
  sigma.sq <- runif(1, 1, 1.5) 
  sp <- TRUE 
  cov.model <- 'exponential'
  family <- 'Poisson'
  dat <- simNMix(J.x = J.x, J.y = J.y, n.rep = n.rep, beta = beta, alpha = alpha,
  	         mu.RE = mu.RE, p.RE = p.RE, sp = sp, 
                 phi = phi, sigma.sq = sigma.sq, cov.model = cov.model, family = family)
  
  y <- dat$y
  X <- dat$X
  X.re <- dat$X.re
  X.p <- dat$X.p
  X.p.re <- dat$X.p.re
  coords <- as.matrix(dat$coords)
  
  abund.covs <- X
  colnames(abund.covs) <- c('int', 'abund.cov.1', 'abund.cov.2')
  
  det.covs <- list(det.cov.1 = X.p[, , 2], 
  		   det.cov.2 = X.p[, , 3]) 
  
  data.list <- list(y = y, 
  		    abund.covs = abund.covs,
  		    det.covs = det.covs)
  
  # Priors
  prior.list <- list(beta.normal = list(0, 10),
  		   alpha.normal = list(0, 2.72)) 
  # Starting values
  inits.list <- list(alpha = 0,
  		   beta = 0,
  		   N = apply(y, 1, max, na.rm = TRUE))
  # Tuning values 
  tuning.list <- list(beta = 0.1, alpha = 0.1)
  
  n.batch <- 400
  batch.length <- 50 
  n.burn <- 10000
  n.thin <- 10
  n.chains <- 3
  
  out <- NMix(abund.formula = ~ abund.cov.1 + abund.cov.2,
  	      det.formula = ~ det.cov.1 + det.cov.2, 
  	      data = data.list, 
  	      n.batch = n.batch, 
  	      batch.length = batch.length, 
  	      tuning = tuning.list,
  	      inits = inits.list, 
  	      priors = prior.list, 
  	      family = 'Poisson',
  	      accept.rate = 0.43, 
  	      n.omp.threads = 1, 
  	      verbose = FALSE, 
  	      n.report = 100,
  	      n.burn = n.burn,
  	      n.thin = n.thin,
  	      n.chains = n.chains) 
  ppc.c.out <- ppcAbund(out, fit.stat = 'freeman-tukey', group = 1, type = 'conditional')
  ppc.m.out <- ppcAbund(out, fit.stat = 'freeman-tukey', group = 1, type = 'marginal')
  conditional.bps[i] <- mean(ppc.c.out$fit.y.rep > ppc.c.out$fit.y)
  marginal.bps[i] <- mean(ppc.m.out$fit.y.rep > ppc.m.out$fit.y)
}

save(conditional.bps, marginal.bps, file = 'results/nmix-sim-results.rda')
