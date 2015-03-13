/*
 * heatflux3n_terminate.c
 *
 * Code generation for function 'heatflux3n_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "heatflux3n.h"
#include "heatflux3n_terminate.h"

/* Function Definitions */
void heatflux3n_atexit(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void heatflux3n_terminate(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (heatflux3n_terminate.c) */
