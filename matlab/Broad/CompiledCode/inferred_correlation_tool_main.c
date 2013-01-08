/*
 * MATLAB Compiler: 4.13 (R2010a)
 * Date: Thu Oct 20 15:50:34 2011
 * Arguments: "-B" "macro_default" "-d"
 * "/xchip/cogs/cflynn/sandboxCodeWorking/matlab/CompiledCode" "-m" "-W" "main"
 * "-T" "link:exe"
 * "/xchip/cogs/cflynn/sandboxCodeWorking/matlab/inferred_correlation_tool.m"
 * "-I" "/xchip/cogs/tools/bmtk" "-I" "/xchip/cogs/tools/bmtk/util" "-I"
 * "/xchip/cogs/tools/bmtk/reports" "-I" "/xchip/cogs/tools/bmtk/plot" "-I"
 * "/xchip/cogs/tools/bmtk/l1000" "-I" "/xchip/cogs/tools/bmtk/io" "-I"
 * "/xchip/cogs/tools/bmtk/deprecated" "-I" "/xchip/cogs/tools/bmtk/math" "-I"
 * "/xchip/cogs/tools/bmtk/core" "-I" "/xchip/cogs/tools/bmtk/alg" "-I"
 * "/xchip/cogs/tools/bmtk/alg/gsea" "-I" "/xchip/cogs/tools/bmtk/alg/clust"
 * "-I" "/xchip/cogs/tools/bmtk/alg/svdd" "-I"
 * "/xchip/cogs/tools/bmtk/alg/svdd/main" "-I"
 * "/xchip/cogs/tools/bmtk/alg/svdd/subroutines" "-I"
 * "/xchip/cogs/tools/bmtk/alg/classify" "-I"
 * "/xchip/cogs/tools/bmtk/alg/marker_selection" "-I"
 * "/xchip/cogs/tools/bmtk/alg/cmap" "-I" "/xchip/cogs/tools/bmtk/alg/l1k" "-I"
 * "/xchip/cogs/tools/bmtk/resources" "-a" "/xchip/cogs/tools/bmtk/resources" 
 */
#include <stdio.h>
#include "mclmcrrt.h"
#ifdef __cplusplus
extern "C" {
#endif

extern mclComponentData __MCC_inferred_correlation_tool_component_data;

#ifdef __cplusplus
}
#endif

static HMCRINSTANCE _mcr_inst = NULL;

#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultPrintHandler(const char *s)
{
  return mclWrite(1 /* stdout */, s, sizeof(char)*strlen(s));
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultErrorHandler(const char *s)
{
  int written = 0;
  size_t len = 0;
  len = strlen(s);
  written = mclWrite(2 /* stderr */, s, sizeof(char)*len);
  if (len > 0 && s[ len-1 ] != '\n')
    written += mclWrite(2 /* stderr */, "\n", sizeof(char));
  return written;
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

#ifndef LIB_inferred_correlation_tool_C_API
#define LIB_inferred_correlation_tool_C_API /* No special import/export declaration */
#endif

LIB_inferred_correlation_tool_C_API 
bool MW_CALL_CONV inferred_correlation_toolInitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler)
{
    int bResult = 0;
  if (_mcr_inst != NULL)
    return true;
  if (!mclmcrInitialize())
    return false;
    {
        mclCtfStream ctfStream = 
            mclGetEmbeddedCtfStream((void 
                                                     *)(inferred_correlation_toolInitializeWithHandlers), 
                                    215000);
        if (ctfStream) {
            bResult = mclInitializeComponentInstanceEmbedded(   &_mcr_inst,
                                                                
                                                     &__MCC_inferred_correlation_tool_component_data,
                                                                true, 
                                                                NoObjectType, 
                                                                ExeTarget,
                                                                error_handler, 
                                                                print_handler,
                                                                ctfStream, 
                                                                215000);
            mclDestroyStream(ctfStream);
        } else {
            bResult = 0;
        }
    }  
    if (!bResult)
    return false;
  return true;
}

LIB_inferred_correlation_tool_C_API 
bool MW_CALL_CONV inferred_correlation_toolInitialize(void)
{
  return inferred_correlation_toolInitializeWithHandlers(mclDefaultErrorHandler, 
                                                         mclDefaultPrintHandler);
}
LIB_inferred_correlation_tool_C_API 
void MW_CALL_CONV inferred_correlation_toolTerminate(void)
{
  if (_mcr_inst != NULL)
    mclTerminateInstance(&_mcr_inst);
}

int run_main(int argc, const char **argv)
{
  int _retval;
  /* Generate and populate the path_to_component. */
  char path_to_component[(PATH_MAX*2)+1];
  separatePathName(argv[0], path_to_component, (PATH_MAX*2)+1);
  __MCC_inferred_correlation_tool_component_data.path_to_component = path_to_component; 
  if (!inferred_correlation_toolInitialize()) {
    return -1;
  }
  argc = mclSetCmdLineUserData(mclGetID(_mcr_inst), argc, argv);
  _retval = mclMain(_mcr_inst, argc, argv, "inferred_correlation_tool", 0);
  if (_retval == 0 /* no error */) mclWaitForFiguresToDie(NULL);
  inferred_correlation_toolTerminate();
  mclTerminateApplication();
  return _retval;
}

int main(int argc, const char **argv)
{
  if (!mclInitializeApplication(
    __MCC_inferred_correlation_tool_component_data.runtime_options, 
    __MCC_inferred_correlation_tool_component_data.runtime_option_count))
    return 0;

  return mclRunMain(run_main, argc, argv);
}
