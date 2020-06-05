r.iDist <- function(coords.1, coords.2){
    
    n.1 <- nrow(coords.1)
    n.2 <- nrow(coords.2)
    p <- ncol(coords.1)
    
    D <- matrix(0, n.1, n.2)
    
    dist <- 0

    start.time <- proc.time()
    
    for(i in 1:n.1){
        for(j in 1:n.2){
            dist <- 0
            for(k in 1:p){
                dist <- dist + (coords.1[i,k] - coords.2[j,k])^2
            }
            D[i,j] <- sqrt(dist)
        }
    }
    
    return(list("D"=D, sys.time=proc.time()-start.time))
}
