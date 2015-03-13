/*
 * heatflux3n.h
 *
 * Code generation for function 'heatflux3n'
 *
 */

#ifndef __HEATFLUX3N_H__
#define __HEATFLUX3N_H__

/* Include files */
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "blas.h"
#include "rtwtypes.h"
#include "heatflux3n_types.h"

/* Function Declarations */
extern void heatflux3n(const emlrtStack *sp, const emxArray_real_T *K, const
  real_T d[6], const emxArray_real_T *dT, real_T dt, const real_T A[6],
  emxArray_real_T *HF);

#endif

/* End of code generation (heatflux3n.h) */
