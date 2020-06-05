setwd("~/Dropbox/conferences/envr2018/exercise-1a")
##Load shared libraries
source("rIDist.R")

# For Linux/macOS
dyn.load("cIDist.so")
# For Windows
# dyn.load("cIDist.dll")
source("cIDist.R")

# For Linux/macOS
dyn.load("cIDistOMP.so")
# For Windows
# dyn.load("cIDistOMP.dll")
source("cIDistOMP.R")

##Make data
n.1 <- 5000
coords.1 <- cbind(1:n.1, 1:n.1)

n.2 <- 5000
coords.2 <- cbind(1:n.2, 1:n.2)

##Calculate Euclidean distance matrices and print timing
r.D <- r.iDist(coords.1, coords.2)
print(r.D$sys.time)

c.D <- c.iDist(coords.1, coords.2)
print(c.D$sys.time)

c.omp.D <- c.iDist.omp(coords.1, coords.2, n.omp.threads=4)
print(c.omp.D$sys.time)
