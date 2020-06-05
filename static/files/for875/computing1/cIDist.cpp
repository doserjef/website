// Section 1
#include <R.h>
#include <Rmath.h>
#include <Rinternals.h>

extern "C" {

  // Section 2
  SEXP cIDist(SEXP coords1_r, SEXP n1_r, SEXP coords2_r, SEXP n2_r, SEXP p_r, SEXP D_r){
    
    // Section 3
    double *coords1 = REAL(coords1_r);
    int n1 = INTEGER(n1_r)[0];
    
    double *coords2 = REAL(coords2_r);
    int n2 = INTEGER(n2_r)[0];
    
    int p = INTEGER(p_r)[0];
    
    double *D = REAL(D_r);
    
    int i, j, k;
    double dist = 0.0;
    
    // Section 4
    for(i = 0; i < n1; i++){
      for(j = 0; j < n2; j++){
	      dist = 0.0;
	      for(k = 0; k < p; k++){
	        dist += pow(coords1[k*n1+i]-coords2[k*n2+j],2);
	      }
	      D[n1*j+i] = sqrt(dist);
      }
    }

    // Section 5
    return(R_NilValue);
  }  
}
