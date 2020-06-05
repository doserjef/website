c.iDist <- function(coords.1, coords.2){
    
    # Section 1: Error Handling
    if(!is.matrix(coords.1))
        coords.1 <- as.matrix(coords.1)
    
    if(missing(coords.2))
        coords.2 <- coords.1
    
    if(!is.matrix(coords.2))
        coords.2 <- as.matrix(coords.2)
    
    if(ncol(coords.1) != ncol(coords.2))
        stop("error: ncol(coords.1) != ncol(coords.2)")
    
    # Section 2: Setup
    p <- ncol(coords.1)
    n1 <- nrow(coords.1)
    n2 <- nrow(coords.2)
    
    D <- matrix(0, n1, n2)
    
    storage.mode(coords.1) <- "double"
    storage.mode(coords.2) <- "double"
    storage.mode(D) <- "double"
    storage.mode(n1) <- "integer"
    storage.mode(n2) <- "integer"
    storage.mode(p) <- "integer"
    
    start.time <- proc.time()
    
    # Section 3: Execute and Output
    .Call("cIDist", coords.1, n1, coords.2, n2, p, D)
    
    list("D"=D, sys.time=proc.time()-start.time)
}


