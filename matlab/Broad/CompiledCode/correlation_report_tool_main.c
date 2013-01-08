/*
 * MATLAB Compiler: 4.13 (R2010a)
 * Date: Thu Jan 19 12:11:06 2012
 * Arguments: "-B" "macro_default" "-d"
 * "/xchip/cogs/cflynn/sandboxCodeWorking/matlab/CompiledCode" "-m" "-W" "main"
 * "-T" "link:exe"
 * "/xchip/cogs/cflynn/sandboxCodeWorking/matlab/correlation_report_tool.m"
 * "-I" "/xchip/cogs/tools/bmtk" "-I" "/xchip/cogs/tools/bmtk/util" "-I"
 * "/xchip/cogs/tools/bmtk/reports" "-I" "/xchip/cogs/tools/bmtk/plot" "-I"
 * "/xchip/cogs/tools/bmtk/unit_tests" "-I"
 * "/xchip/cogs/tools/bmtk/unit_tests/gctx" "-I"
 * "/xchip/cogs/tools/bmtk/unit_tests/formats" "-I"
 * "/xchip/cogs/tools/bmtk/l1000" "-I" "/xchip/cogs/tools/bmtk/io" "-I"
 * "/xchip/cogs/tools/bmtk/mksqlite" "-I"
 * "/xchip/cogs/tools/bmtk/mksqlite/docu" "-I"
 * "/xchip/cogs/tools/bmtk/deprecated" "-I" "/xchip/cogs/tools/bmtk/math" "-I"
 * "/xchip/cogs/tools/bmtk/core" "-I" "/xchip/cogs/tools/bmtk/alg" "-I"
 * "/xchip/cogs/tools/bmtk/alg/gsea" "-I" "/xchip/cogs/tools/bmtk/alg/clust"
 * "-I" "/xchip/cogs/tools/bmtk/alg/svdd" "-I"
 * "/xchip/cogs/tools/bmtk/alg/svdd/main" "-I"
 * "/xchip/cogs/tools/bmtk/alg/svdd/subroutines" "-I"
 * "/xchip/cogs/tools/bmtk/alg/classify" "-I"
 * "/xchip/cogs/tools/bmtk/alg/marker_selection" "-I"
 * "/xchip/cogs/tools/bmtk/alg/cmap" "-I" "/xchip/cogs/tools/bmtk/resources"
 * "-a" "/xchip/cogs/tools/bmtk/resources" 
 */
#include <stdio.h>
#include "mclmcrrt.h"
#ifdef __cplusplus
extern "C" {
#endif

extern mclComponentData __MCC_correlation_report_tool_component_data;

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

#ifndef LIB_correlation_report_tool_C_API
#define LIB_correlation_report_tool_C_API /* No special import/export declaration */
#endif

LIB_correlation_report_tool_C_API 
bool MW_CALL_CONV correlation_report_toolInitializeWithHandlers(
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
                                                     *)(correlation_report_toolInitializeWithHandlers), 
                                    234923);
        if (ctfStream) {
            bResult = mclInitializeComponentInstanceEmbedded(   &_mcr_inst,
                                                                
                                                     &__MCC_correlation_report_tool_component_data,
                                                                true, 
                                                                NoObjectType, 
                                                                ExeTarget,
                                                                error_handler, 
                                                                print_handler,
                                                                ctfStream, 
                                                                234923);
            mclDestroyStream(ctfStream);
        } else {
            bResult = 0;
        }
    }  
    if (!bResult)
    return false;
  return true;
}

LIB_correlation_report_tool_C_API 
bool MW_CALL_CONV correlation_report_toolInitialize(void)
{
  return correlation_report_toolInitializeWithHandlers(mclDefaultErrorHandler, 
                                                       mclDefaultPrintHandler);
}
LIB_correlation_report_tool_C_API 
void MW_CALL_CONV correlation_report_toolTerminate(void)
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
  __MCC_correlation_report_tool_component_data.path_to_component = path_to_component; 
  if (!correlation_report_toolInitialize()) {
    return -1;
  }
  argc = mclSetCmdLineUserData(mclGetID(_mcr_inst), argc, argv);
  _retval = mclMain(_mcr_inst, argc, argv, "correlation_report_tool", 0);
  if (_retval == 0 /* no error */) mclWaitForFiguresToDie(NULL);
  correlation_report_toolTerminate();
  mclTerminateApplication();
  return _retval;
}

int main(int argc, const char **argv)
{
  if (!mclInitializeApplication(
    __MCC_correlation_report_tool_component_data.runtime_options, 
    __MCC_correlation_report_tool_component_data.runtime_option_count))
    return 0;

  return mclRunMain(run_main, argc, argv);
}
