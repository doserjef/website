# dat comes from simTOcc
preprocess_data <- function(dat, numKnots = 7) {
  # Site x Replicate
  y <- dat$y
  # Occurrence Covariates
  X <- dat$X
  # Detection Covariates
  X.p <- dat$X.p
  # Coordinates
  coords <- dat$coords

  ## create a spline basis for each covariate
  m <- 1:numKnots
  psiBound <- c(floor(min(X[, , 2])), ceiling(max(X[, , 2])))
  pBound <- c(floor(min(X.p[, , , 2])), ceiling(max(X.p[, , , 2])))

  X.sp <- as.data.frame(bs(X[, , 2], knots = psiBound[1] + m * psiBound[2] / (numKnots + 1)))
  X.p.sp <- bs(X.p[, , , 2], knots = pBound[1] + m * pBound[2] / (numKnots + 1))

  detectCovFormatted <- vector("list", numKnots + 3)
  for (j in 1:(numKnots + 3)) {
    detectCovFormatted[[j]] <- X.p.sp[, j]
  }

  names(X.sp) <- paste("z", 1:(numKnots + 3), sep = "")
  names(detectCovFormatted) <- paste("p", 1:(numKnots + 3), sep = "")


  formattedData <- list(
    y = y, occ.covs = X.sp,
    det.covs = detectCovFormatted
  )

  return(list(formattedData = formattedData, X.sp = X.sp, X.p.sp = X.p.sp))
}

# lists of data, bases, and estimates respectively for occurrence
plot_occur <- function(dat_reps, basis_reps, estimates_reps) {
  dat <- dat_reps[[1]]
  zData <- dat$X[, , 2]
  psiData <- dat$psi[, 1]
  idx <- order(zData)
  thin <- 1:length(zData)
  basisPsiSV <- basis_reps[[1]]

  ## covariates come from standard normal so between -3 and 3
  plot((zData[idx])[thin], (psiData[idx])[thin], ylim = c(0, 1), type = "l", lwd = .5, xlim = c(-3, 3), xlab = "x", ylab = "", cex.axis = 2, cex.lab = 2) ## truth
  for (i in 2:length(estimates_reps)) {
    dat <- dat_reps[[i]]
    zData <- dat$X[, , 2]
    psiData <- dat$psi[, 1]
    idx <- order(zData)
    thin <- 1:length(zData)
    basisPsiSV <- basis_reps[[i]]
    idx <- order(zData)
    lines((zData[idx])[thin], (psiData[idx])[thin], lwd = .5)
  }

  for (i in 1:length(dat_reps)) {
    dat <- dat_reps[[i]]
    zData <- dat$X[, , 2]
    psiData <- dat$psi[, 1]
    idx <- order(zData)
    thin <- 1:length(zData)
    basisPsiSV <- basis_reps[[i]]
    ## predicted var
    fitted.val <- exp(estimates_reps[[i]][[1]] +
      estimates_reps[[i]][[2]] * basisPsiSV[, 1] +
      estimates_reps[[i]][[3]] * basisPsiSV[, 2] +
      estimates_reps[[i]][[4]] * basisPsiSV[, 3] +
      estimates_reps[[i]][[5]] * basisPsiSV[, 4] +
      estimates_reps[[i]][[6]] * basisPsiSV[, 5] +
      estimates_reps[[i]][[7]] * basisPsiSV[, 6]
      + estimates_reps[[i]][[8]] * basisPsiSV[, 7]
      + estimates_reps[[i]][[9]] * basisPsiSV[, 8]
      + estimates_reps[[i]][[10]] * basisPsiSV[, 9]
      + estimates_reps[[i]][[11]] * basisPsiSV[, 10]) / (1 + exp(estimates_reps[[i]][[1]] +
      estimates_reps[[i]][[2]] * basisPsiSV[, 1] +
      estimates_reps[[i]][[3]] * basisPsiSV[, 2] +
      estimates_reps[[i]][[4]] * basisPsiSV[, 3] +
      estimates_reps[[i]][[5]] * basisPsiSV[, 4] +
      estimates_reps[[i]][[6]] * basisPsiSV[, 5] +
      estimates_reps[[i]][[7]] * basisPsiSV[, 6]
      + estimates_reps[[i]][[8]] * basisPsiSV[, 7]
      + estimates_reps[[i]][[9]] * basisPsiSV[, 8]
      + estimates_reps[[i]][[10]] * basisPsiSV[, 9]
      + estimates_reps[[i]][[11]] * basisPsiSV[, 10]))

    lines((zData[idx]), (fitted.val[idx]), col = "red", cex = .5)
  }


  dat <- dat_reps[[1]]
  zData <- dat$X[, , 2]
  psiData <- dat$psi[, 1]
  idx <- order(zData)
  thin <- 1:length(zData)
  basisPsiSV <- basis_reps[[1]]
  lines(sort(zData[thin]), sort(psiData[thin]))

  mtext(
    text = expression(paste(psi, "(x)")),
    side = 2,
    line = 2.5, cex = 2
  )
}



# lists of data, bases, and estimates respectively for detection
plot_detect <- function(dat_reps, basis_reps, estimates_reps) {
  dat <- dat_reps[[1]]
  mData <- dat$X.p[, , , 2]
  pData <- dat$p[, , 1]
  idx <- order(mData)
  thin <- 1:length(mData)
  basisPSV <- basis_reps[[1]]

  plot((mData[idx])[thin], (pData[idx])[thin], ylim = c(0, 1), type = "l", lwd = .5, xlim = c(-3, 3), xlab = "z", ylab = "", cex.axis = 2, cex.lab = 2) ## truth

  for (i in 2:length(dat_reps)) {
    dat <- dat_reps[[i]]
    mData <- dat$X.p[, , , 2]
    pData <- dat$p[, , 1]
    idx <- order(mData)
    thin <- 1:length(mData)
    idx <- order(mData)
    lines((mData[idx])[thin], (pData[idx])[thin], lwd = .5)
  }
  ##

  ## predicted value
  for (i in 1:length(dat_reps)) {
    basisPSV <- basis_reps[[i]]
    dat <- dat_reps[[i]]
    mData <- dat$X.p[, , , 2]
    pData <- dat$p[, , 1]
    fitted.val <- exp(estimates_reps[[i]][[1]] +
      estimates_reps[[i]][[2]] * basisPSV[, 1] +
      estimates_reps[[i]][[3]] * basisPSV[, 2] +
      estimates_reps[[i]][[4]] * basisPSV[, 3] +
      estimates_reps[[i]][[5]] * basisPSV[, 4] +
      estimates_reps[[i]][[6]] * basisPSV[, 5] +
      estimates_reps[[i]][[7]] * basisPSV[, 6]
      + estimates_reps[[i]][[8]] * basisPSV[, 7]
      + estimates_reps[[i]][[9]] * basisPSV[, 8]
      + estimates_reps[[i]][[10]] * basisPSV[, 9]
      + estimates_reps[[i]][[11]] * basisPSV[, 10]) / (1 + exp(estimates_reps[[i]][[1]] +
      estimates_reps[[i]][[2]] * basisPSV[, 1] +
      estimates_reps[[i]][[3]] * basisPSV[, 2] +
      estimates_reps[[i]][[4]] * basisPSV[, 3] +
      estimates_reps[[i]][[5]] * basisPSV[, 4] +
      estimates_reps[[i]][[6]] * basisPSV[, 5] +
      estimates_reps[[i]][[7]] * basisPSV[, 6]
      + estimates_reps[[i]][[8]] * basisPSV[, 7]
      + estimates_reps[[i]][[9]] * basisPSV[, 8]
      + estimates_reps[[i]][[10]] * basisPSV[, 9]
      + estimates_reps[[i]][[11]] * basisPSV[, 10]))


    idx <- order(mData)
    lines((mData[idx])[thin], (fitted.val[idx])[thin], col = "red", cex = .5)
  }

  dat <- dat_reps[[1]]
  mData <- dat$X.p[, , , 2]
  pData <- dat$p[, , 1]
  idx <- order(mData)
  thin <- 1:length(mData)
  basisPSV <- basis_reps[[i]]
  lines((mData[idx])[thin], (pData[idx])[thin])


  mtext(
    text = expression(paste(p, "(z)")),
    side = 2,
    line = 2.5, cex = 2
  )
}
