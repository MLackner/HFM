/*
 * _coder_heatflux3n_api.c
 *
 * Code generation for function '_coder_heatflux3n_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "heatflux3n.h"
#include "_coder_heatflux3n_api.h"
#include "heatflux3n_emxutil.h"

/* Variable Definitions */
static emlrtRTEInfo d_emlrtRTEI = { 1, 1, "_coder_heatflux3n_api", "" };

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static real_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *d, const
  char_T *identifier))[6];
static real_T (*d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[6];
static real_T e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *dt, const
  char_T *identifier);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *K, const
  char_T *identifier, emxArray_real_T *y);
static const mxArray *emlrt_marshallOut(const emxArray_real_T *u);
static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static real_T (*h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[6];
static real_T i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  g_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static real_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *d, const
  char_T *identifier))[6]
{
  real_T (*y)[6];
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  y = d_emlrt_marshallIn(sp, emlrtAlias(d), &thisId);
  emlrtDestroyArray(&d);
  return y;
}
  static real_T (*d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
  const emlrtMsgIdentifier *parentId))[6]
{
  real_T (*y)[6];
  y = h_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *dt, const
  char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  y = f_emlrt_marshallIn(sp, emlrtAlias(dt), &thisId);
  emlrtDestroyArray(&dt);
  return y;
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *K, const
  char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  b_emlrt_marshallIn(sp, emlrtAlias(K), &thisId, y);
  emlrtDestroyArray(&K);
}

static const mxArray *emlrt_marshallOut(const emxArray_real_T *u)
{
  const mxArray *y;
  static const int32_T iv4[3] = { 0, 0, 0 };

  const mxArray *m1;
  y = NULL;
  m1 = emlrtCreateNumericArray(3, iv4, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m1, (void *)u->data);
  emlrtSetDimensions((mxArray *)m1, u->size, 3);
  emlrtAssign(&y, m1);
  return y;
}

static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = i_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  int32_T iv5[4];
  boolean_T bv0[4];
  int32_T i;
  static const int8_T iv6[4] = { -1, -1, -1, 6 };

  static const boolean_T bv1[4] = { true, true, true, false };

  int32_T iv7[4];
  for (i = 0; i < 4; i++) {
    iv5[i] = iv6[i];
    bv0[i] = bv1[i];
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 4U, iv5, bv0, iv7);
  ret->size[0] = iv7[0];
  ret->size[1] = iv7[1];
  ret->size[2] = iv7[2];
  ret->size[3] = iv7[3];
  ret->allocatedSize = ret->size[0] * ret->size[1] * ret->size[2] * ret->size[3];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static real_T (*h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[6]
{
  real_T (*ret)[6];
  int32_T iv8[2];
  int32_T i1;
  for (i1 = 0; i1 < 2; i1++) {
    iv8[i1] = 1 + 5 * i1;
  }

  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 2U, iv8);
  ret = (real_T (*)[6])mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}
  static real_T i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId)
{
  real_T ret;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, 0);
  ret = *(real_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

void heatflux3n_api(const mxArray * const prhs[5], const mxArray *plhs[1])
{
  emxArray_real_T *K;
  emxArray_real_T *dT;
  emxArray_real_T *HF;
  real_T (*d)[6];
  real_T dt;
  real_T (*A)[6];
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_real_T(&st, &K, 4, &d_emlrtRTEI, true);
  emxInit_real_T(&st, &dT, 4, &d_emlrtRTEI, true);
  b_emxInit_real_T(&st, &HF, 3, &d_emlrtRTEI, true);

  /* Marshall function inputs */
  emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "K", K);
  d = c_emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "d");
  emlrt_marshallIn(&st, emlrtAlias(prhs[2]), "dT", dT);
  dt = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[3]), "dt");
  A = c_emlrt_marshallIn(&st, emlrtAlias(prhs[4]), "A");

  /* Invoke the target function */
  heatflux3n(&st, K, *d, dT, dt, *A, HF);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(HF);
  HF->canFreeData = false;
  emxFree_real_T(&HF);
  dT->canFreeData = false;
  emxFree_real_T(&dT);
  K->canFreeData = false;
  emxFree_real_T(&K);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_heatflux3n_api.c) */
