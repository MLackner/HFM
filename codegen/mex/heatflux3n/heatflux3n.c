/*
 * heatflux3n.c
 *
 * Code generation for function 'heatflux3n'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "heatflux3n.h"
#include "heatflux3n_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "heatflux3n_data.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 13, "heatflux3n",
  "/Users/lackner/Documents/MATLAB/HeatFlowModel/heatflux3n.m" };

static emlrtRSInfo b_emlrtRSI = { 13, "sum",
  "/Applications/MATLAB_R2014b.app/toolbox/eml/lib/matlab/datafun/sum.m" };

static emlrtRSInfo c_emlrtRSI = { 46, "sumprod",
  "/Applications/MATLAB_R2014b.app/toolbox/eml/lib/matlab/datafun/private/sumprod.m"
};

static emlrtRSInfo d_emlrtRSI = { 47, "combine_vector_elements",
  "/Applications/MATLAB_R2014b.app/toolbox/eml/lib/matlab/datafun/private/combine_vector_elements.m"
};

static emlrtRSInfo e_emlrtRSI = { 20, "eml_int_forloop_overflow_check",
  "/Applications/MATLAB_R2014b.app/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m"
};

static emlrtRTEInfo emlrtRTEI = { 1, 15, "heatflux3n",
  "/Users/lackner/Documents/MATLAB/HeatFlowModel/heatflux3n.m" };

static emlrtRTEInfo b_emlrtRTEI = { 30, 1, "combine_vector_elements",
  "/Applications/MATLAB_R2014b.app/toolbox/eml/lib/matlab/datafun/private/combine_vector_elements.m"
};

static emlrtRTEInfo c_emlrtRTEI = { 5, 1, "heatflux3n",
  "/Users/lackner/Documents/MATLAB/HeatFlowModel/heatflux3n.m" };

static emlrtECInfo emlrtECI = { -1, 9, 5, "heatflux3n",
  "/Users/lackner/Documents/MATLAB/HeatFlowModel/heatflux3n.m" };

static emlrtECInfo b_emlrtECI = { 3, 9, 18, "heatflux3n",
  "/Users/lackner/Documents/MATLAB/HeatFlowModel/heatflux3n.m" };

/* Function Definitions */
void heatflux3n(const emlrtStack *sp, const emxArray_real_T *K, const real_T d[6],
                const emxArray_real_T *dT, real_T dt, const real_T A[6],
                emxArray_real_T *HF)
{
  uint32_T sz[4];
  int32_T vstride;
  emxArray_real_T *Q;
  int32_T loop_ub;
  emxArray_real_T *r0;
  emxArray_int32_T *r1;
  emxArray_int32_T *r2;
  emxArray_int32_T *r3;
  emxArray_real_T *r4;
  emxArray_real_T *b_dT;
  int32_T iy;
  int32_T ixstart;
  int32_T j;
  int32_T ix;
  int32_T i0;
  int32_T iv0[3];
  int32_T c_dT[3];
  int32_T iv1[3];
  boolean_T b0;
  real_T s;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);

  /*  Preallocation (Maybe better to pass this variable and define in parent */
  /*  function) */
  for (vstride = 0; vstride < 4; vstride++) {
    sz[vstride] = (uint32_T)dT->size[vstride];
  }

  emxInit_real_T(sp, &Q, 4, &c_emlrtRTEI, true);
  vstride = Q->size[0] * Q->size[1] * Q->size[2] * Q->size[3];
  Q->size[0] = (int32_T)sz[0];
  emxEnsureCapacity(sp, (emxArray__common *)Q, vstride, (int32_T)sizeof(real_T),
                    &emlrtRTEI);
  vstride = Q->size[0] * Q->size[1] * Q->size[2] * Q->size[3];
  Q->size[1] = (int32_T)sz[1];
  emxEnsureCapacity(sp, (emxArray__common *)Q, vstride, (int32_T)sizeof(real_T),
                    &emlrtRTEI);
  vstride = Q->size[0] * Q->size[1] * Q->size[2] * Q->size[3];
  Q->size[2] = (int32_T)sz[2];
  Q->size[3] = 6;
  emxEnsureCapacity(sp, (emxArray__common *)Q, vstride, (int32_T)sizeof(real_T),
                    &emlrtRTEI);
  loop_ub = (int32_T)sz[0] * (int32_T)sz[1] * (int32_T)sz[2] * 6;
  for (vstride = 0; vstride < loop_ub; vstride++) {
    Q->data[vstride] = 0.0;
  }

  b_emxInit_real_T(sp, &r0, 3, &emlrtRTEI, true);
  emxInit_int32_T(sp, &r1, 1, &emlrtRTEI, true);
  emxInit_int32_T(sp, &r2, 1, &emlrtRTEI, true);
  emxInit_int32_T(sp, &r3, 1, &emlrtRTEI, true);
  b_emxInit_real_T(sp, &r4, 3, &emlrtRTEI, true);

  /*  All directions */
  b_emxInit_real_T(sp, &b_dT, 3, &emlrtRTEI, true);
  for (iy = 0; iy < 6; iy++) {
    loop_ub = K->size[0];
    ixstart = K->size[1];
    j = K->size[2];
    vstride = r0->size[0] * r0->size[1] * r0->size[2];
    r0->size[0] = loop_ub;
    r0->size[1] = ixstart;
    r0->size[2] = j;
    emxEnsureCapacity(sp, (emxArray__common *)r0, vstride, (int32_T)sizeof
                      (real_T), &emlrtRTEI);
    for (vstride = 0; vstride < j; vstride++) {
      for (ix = 0; ix < ixstart; ix++) {
        for (i0 = 0; i0 < loop_ub; i0++) {
          r0->data[(i0 + r0->size[0] * ix) + r0->size[0] * r0->size[1] * vstride]
            = -K->data[((i0 + K->size[0] * ix) + K->size[0] * K->size[1] *
                        vstride) + K->size[0] * K->size[1] * K->size[2] * iy];
        }
      }
    }

    for (vstride = 0; vstride < 3; vstride++) {
      iv0[vstride] = r0->size[vstride];
    }

    loop_ub = dT->size[0];
    ixstart = dT->size[1];
    j = dT->size[2];
    vstride = b_dT->size[0] * b_dT->size[1] * b_dT->size[2];
    b_dT->size[0] = loop_ub;
    b_dT->size[1] = ixstart;
    b_dT->size[2] = j;
    emxEnsureCapacity(sp, (emxArray__common *)b_dT, vstride, (int32_T)sizeof
                      (real_T), &emlrtRTEI);
    for (vstride = 0; vstride < j; vstride++) {
      for (ix = 0; ix < ixstart; ix++) {
        for (i0 = 0; i0 < loop_ub; i0++) {
          b_dT->data[(i0 + b_dT->size[0] * ix) + b_dT->size[0] * b_dT->size[1] *
            vstride] = dT->data[((i0 + dT->size[0] * ix) + dT->size[0] *
            dT->size[1] * vstride) + dT->size[0] * dT->size[1] * dT->size[2] *
            iy];
        }
      }
    }

    for (vstride = 0; vstride < 3; vstride++) {
      c_dT[vstride] = b_dT->size[vstride];
    }

    emlrtSizeEqCheckNDR2012b(iv0, c_dT, &b_emlrtECI, sp);
    loop_ub = Q->size[0];
    vstride = r1->size[0];
    r1->size[0] = loop_ub;
    emxEnsureCapacity(sp, (emxArray__common *)r1, vstride, (int32_T)sizeof
                      (int32_T), &emlrtRTEI);
    for (vstride = 0; vstride < loop_ub; vstride++) {
      r1->data[vstride] = vstride;
    }

    loop_ub = Q->size[1];
    vstride = r2->size[0];
    r2->size[0] = loop_ub;
    emxEnsureCapacity(sp, (emxArray__common *)r2, vstride, (int32_T)sizeof
                      (int32_T), &emlrtRTEI);
    for (vstride = 0; vstride < loop_ub; vstride++) {
      r2->data[vstride] = vstride;
    }

    loop_ub = Q->size[2];
    vstride = r3->size[0];
    r3->size[0] = loop_ub;
    emxEnsureCapacity(sp, (emxArray__common *)r3, vstride, (int32_T)sizeof
                      (int32_T), &emlrtRTEI);
    for (vstride = 0; vstride < loop_ub; vstride++) {
      r3->data[vstride] = vstride;
    }

    vstride = r4->size[0] * r4->size[1] * r4->size[2];
    r4->size[0] = r0->size[0];
    r4->size[1] = r0->size[1];
    r4->size[2] = r0->size[2];
    emxEnsureCapacity(sp, (emxArray__common *)r4, vstride, (int32_T)sizeof
                      (real_T), &emlrtRTEI);
    loop_ub = r0->size[2];
    for (vstride = 0; vstride < loop_ub; vstride++) {
      ixstart = r0->size[1];
      for (ix = 0; ix < ixstart; ix++) {
        j = r0->size[0];
        for (i0 = 0; i0 < j; i0++) {
          r4->data[(i0 + r4->size[0] * ix) + r4->size[0] * r4->size[1] * vstride]
            = r0->data[(i0 + r0->size[0] * ix) + r0->size[0] * r0->size[1] *
            vstride] * dT->data[((i0 + dT->size[0] * ix) + dT->size[0] *
            dT->size[1] * vstride) + dT->size[0] * dT->size[1] * dT->size[2] *
            iy] / d[iy] * A[iy] * dt;
        }
      }
    }

    iv1[0] = r1->size[0];
    iv1[1] = r2->size[0];
    iv1[2] = r3->size[0];
    emlrtSubAssignSizeCheckR2012b(iv1, 3, *(int32_T (*)[3])r4->size, 3,
      &emlrtECI, sp);
    loop_ub = r4->size[2];
    for (vstride = 0; vstride < loop_ub; vstride++) {
      ixstart = r4->size[1];
      for (ix = 0; ix < ixstart; ix++) {
        j = r4->size[0];
        for (i0 = 0; i0 < j; i0++) {
          Q->data[((r1->data[i0] + Q->size[0] * r2->data[ix]) + Q->size[0] *
                   Q->size[1] * r3->data[vstride]) + Q->size[0] * Q->size[1] *
            Q->size[2] * iy] = r4->data[(i0 + r4->size[0] * ix) + r4->size[0] *
            r4->size[1] * vstride];
        }
      }
    }

    emlrtBreakCheckFastR2012b(emlrtBreakCheckR2012bFlagVar, sp);
  }

  emxFree_real_T(&b_dT);
  emxFree_real_T(&r4);
  emxFree_int32_T(&r3);
  emxFree_int32_T(&r2);
  emxFree_int32_T(&r1);
  emxFree_real_T(&r0);

  /*  Sum up */
  st.site = &emlrtRSI;
  b_st.site = &b_emlrtRSI;
  c_st.site = &c_emlrtRSI;
  for (vstride = 0; vstride < 4; vstride++) {
    sz[vstride] = (uint32_T)Q->size[vstride];
  }

  vstride = HF->size[0] * HF->size[1] * HF->size[2];
  HF->size[0] = (int32_T)sz[0];
  HF->size[1] = (int32_T)sz[1];
  HF->size[2] = (int32_T)sz[2];
  emxEnsureCapacity(&c_st, (emxArray__common *)HF, vstride, (int32_T)sizeof
                    (real_T), &b_emlrtRTEI);
  if ((Q->size[0] == 0) || (Q->size[1] == 0) || (Q->size[2] == 0)) {
    vstride = HF->size[0] * HF->size[1] * HF->size[2];
    HF->size[0] = (int32_T)sz[0];
    emxEnsureCapacity(&c_st, (emxArray__common *)HF, vstride, (int32_T)sizeof
                      (real_T), &emlrtRTEI);
    vstride = HF->size[0] * HF->size[1] * HF->size[2];
    HF->size[1] = (int32_T)sz[1];
    emxEnsureCapacity(&c_st, (emxArray__common *)HF, vstride, (int32_T)sizeof
                      (real_T), &emlrtRTEI);
    vstride = HF->size[0] * HF->size[1] * HF->size[2];
    HF->size[2] = (int32_T)sz[2];
    emxEnsureCapacity(&c_st, (emxArray__common *)HF, vstride, (int32_T)sizeof
                      (real_T), &emlrtRTEI);
    loop_ub = (int32_T)sz[0] * (int32_T)sz[1] * (int32_T)sz[2];
    for (vstride = 0; vstride < loop_ub; vstride++) {
      HF->data[vstride] = 0.0;
    }
  } else {
    vstride = 1;
    for (loop_ub = 0; loop_ub < 3; loop_ub++) {
      vstride *= Q->size[loop_ub];
    }

    iy = -1;
    ixstart = -1;
    d_st.site = &d_emlrtRSI;
    if (1 > vstride) {
      b0 = false;
    } else {
      b0 = (vstride > 2147483646);
    }

    if (b0) {
      e_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&e_st);
    }

    for (j = 1; j <= vstride; j++) {
      ixstart++;
      ix = ixstart;
      s = Q->data[ixstart];
      for (loop_ub = 0; loop_ub < 5; loop_ub++) {
        ix += vstride;
        s += Q->data[ix];
      }

      iy++;
      HF->data[iy] = s;
    }
  }

  emxFree_real_T(&Q);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (heatflux3n.c) */
