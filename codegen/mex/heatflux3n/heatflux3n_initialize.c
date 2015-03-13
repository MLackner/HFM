/*
 * heatflux3n_initialize.c
 *
 * Code generation for function 'heatflux3n_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "heatflux3n.h"
#include "heatflux3n_initialize.h"
#include "heatflux3n_data.h"

/* Function Definitions */
void heatflux3n_initialize(emlrtContext *aContext)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, aContext, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (heatflux3n_initialize.c) */
