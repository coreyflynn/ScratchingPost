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

#include "mclmcrrt.h"

#ifdef __cplusplus
extern "C" {
#endif
const unsigned char __MCC_correlation_report_tool_session_key[] = {
    '2', 'F', 'F', 'F', '9', '7', 'C', 'D', '6', '0', '2', '4', 'F', '2', '6',
    'C', '7', '9', '8', '8', '2', 'B', '5', '3', 'A', '0', '4', '9', '3', 'F',
    'F', 'F', 'B', 'C', 'F', '6', '8', 'C', '4', '8', '9', '6', 'C', '8', '1',
    '1', '8', '6', '1', 'B', '6', 'D', '0', '9', '9', '4', '8', '0', 'C', 'A',
    'B', '0', '9', 'A', '9', 'D', 'B', '3', '4', 'D', '1', '7', '3', '6', 'F',
    '4', 'B', 'C', '9', '2', 'B', 'D', 'D', '4', '6', 'F', 'C', '4', '4', '4',
    '4', '9', '5', '2', '7', '9', 'E', 'B', '0', '9', '4', '0', '1', '3', '8',
    '7', '5', '2', '5', 'A', '1', 'C', '1', 'C', '2', '2', '1', '1', '8', '0',
    '0', 'F', '0', 'B', '8', 'F', '8', '0', '4', '9', 'C', 'F', '5', '5', 'D',
    '2', 'A', 'E', '6', '0', '8', 'F', '7', 'D', '1', '9', '5', '0', '2', 'F',
    'E', 'E', 'D', 'A', 'E', 'A', '6', '1', 'B', '0', 'B', '3', '6', 'B', '7',
    '3', '2', '6', '9', '2', '2', '3', 'E', '5', '0', '4', '2', '7', 'C', 'B',
    '5', 'A', 'B', '3', '8', '1', 'F', '5', '3', '1', '3', 'E', 'C', '0', 'F',
    '0', '7', '4', '1', 'E', 'F', '7', '5', 'A', 'A', 'E', '5', '3', '2', '0',
    '5', 'A', 'F', 'C', '3', '0', '5', '2', '6', '3', '4', '3', 'D', 'D', '2',
    '6', 'B', 'A', '7', '7', '0', 'C', '1', '3', '6', '0', '2', '6', 'A', 'A',
    'E', 'E', '6', '6', '3', 'E', 'D', 'F', '3', '8', 'E', 'E', '3', '5', '4',
    '0', '\0'};

const unsigned char __MCC_correlation_report_tool_public_key[] = {
    '3', '0', '8', '1', '9', 'D', '3', '0', '0', 'D', '0', '6', '0', '9', '2',
    'A', '8', '6', '4', '8', '8', '6', 'F', '7', '0', 'D', '0', '1', '0', '1',
    '0', '1', '0', '5', '0', '0', '0', '3', '8', '1', '8', 'B', '0', '0', '3',
    '0', '8', '1', '8', '7', '0', '2', '8', '1', '8', '1', '0', '0', 'C', '4',
    '9', 'C', 'A', 'C', '3', '4', 'E', 'D', '1', '3', 'A', '5', '2', '0', '6',
    '5', '8', 'F', '6', 'F', '8', 'E', '0', '1', '3', '8', 'C', '4', '3', '1',
    '5', 'B', '4', '3', '1', '5', '2', '7', '7', 'E', 'D', '3', 'F', '7', 'D',
    'A', 'E', '5', '3', '0', '9', '9', 'D', 'B', '0', '8', 'E', 'E', '5', '8',
    '9', 'F', '8', '0', '4', 'D', '4', 'B', '9', '8', '1', '3', '2', '6', 'A',
    '5', '2', 'C', 'C', 'E', '4', '3', '8', '2', 'E', '9', 'F', '2', 'B', '4',
    'D', '0', '8', '5', 'E', 'B', '9', '5', '0', 'C', '7', 'A', 'B', '1', '2',
    'E', 'D', 'E', '2', 'D', '4', '1', '2', '9', '7', '8', '2', '0', 'E', '6',
    '3', '7', '7', 'A', '5', 'F', 'E', 'B', '5', '6', '8', '9', 'D', '4', 'E',
    '6', '0', '3', '2', 'F', '6', '0', 'C', '4', '3', '0', '7', '4', 'A', '0',
    '4', 'C', '2', '6', 'A', 'B', '7', '2', 'F', '5', '4', 'B', '5', '1', 'B',
    'B', '4', '6', '0', '5', '7', '8', '7', '8', '5', 'B', '1', '9', '9', '0',
    '1', '4', '3', '1', '4', 'A', '6', '5', 'F', '0', '9', '0', 'B', '6', '1',
    'F', 'C', '2', '0', '1', '6', '9', '4', '5', '3', 'B', '5', '8', 'F', 'C',
    '8', 'B', 'A', '4', '3', 'E', '6', '7', '7', '6', 'E', 'B', '7', 'E', 'C',
    'D', '3', '1', '7', '8', 'B', '5', '6', 'A', 'B', '0', 'F', 'A', '0', '6',
    'D', 'D', '6', '4', '9', '6', '7', 'C', 'B', '1', '4', '9', 'E', '5', '0',
    '2', '0', '1', '1', '1', '\0'};

static const char * MCC_correlation_report_tool_matlabpath_data[] = 
  { "correlation_/", "$TOOLBOXDEPLOYDIR/", "xchip/cogs/tools/bmtk/util/",
    "xchip/cogs/tools/bmtk/plot/", "xchip/cogs/tools/bmtk/io/",
    "xchip/cogs/tools/bmtk/deprecated/", "xchip/cogs/tools/bmtk/math/",
    "xchip/cogs/tools/bmtk/core/", "xchip/cogs/tools/bmtk/resources/",
    "xchip/cogs/tools/bmtk/resources/.svn/",
    "xchip/cogs/tools/bmtk/resources/.svn/prop-base/",
    "xchip/cogs/tools/bmtk/resources/.svn/text-base/",
    "home/unix/cflynn/matlab/", "$TOOLBOXMATLABDIR/general/",
    "$TOOLBOXMATLABDIR/ops/", "$TOOLBOXMATLABDIR/lang/",
    "$TOOLBOXMATLABDIR/elmat/", "$TOOLBOXMATLABDIR/randfun/",
    "$TOOLBOXMATLABDIR/elfun/", "$TOOLBOXMATLABDIR/specfun/",
    "$TOOLBOXMATLABDIR/matfun/", "$TOOLBOXMATLABDIR/datafun/",
    "$TOOLBOXMATLABDIR/polyfun/", "$TOOLBOXMATLABDIR/funfun/",
    "$TOOLBOXMATLABDIR/sparfun/", "$TOOLBOXMATLABDIR/scribe/",
    "$TOOLBOXMATLABDIR/graph2d/", "$TOOLBOXMATLABDIR/graph3d/",
    "$TOOLBOXMATLABDIR/specgraph/", "$TOOLBOXMATLABDIR/graphics/",
    "$TOOLBOXMATLABDIR/uitools/", "$TOOLBOXMATLABDIR/strfun/",
    "$TOOLBOXMATLABDIR/imagesci/", "$TOOLBOXMATLABDIR/iofun/",
    "$TOOLBOXMATLABDIR/audiovideo/", "$TOOLBOXMATLABDIR/timefun/",
    "$TOOLBOXMATLABDIR/datatypes/", "$TOOLBOXMATLABDIR/verctrl/",
    "$TOOLBOXMATLABDIR/codetools/", "$TOOLBOXMATLABDIR/helptools/",
    "$TOOLBOXMATLABDIR/demos/", "$TOOLBOXMATLABDIR/timeseries/",
    "$TOOLBOXMATLABDIR/hds/", "$TOOLBOXMATLABDIR/guide/",
    "$TOOLBOXMATLABDIR/plottools/", "toolbox/local/",
    "$TOOLBOXMATLABDIR/datamanager/", "toolbox/compiler/", "toolbox/stats/" };

static const char * MCC_correlation_report_tool_classpath_data[] = 
  { "" };

static const char * MCC_correlation_report_tool_libpath_data[] = 
  { "" };

static const char * MCC_correlation_report_tool_app_opts_data[] = 
  { "" };

static const char * MCC_correlation_report_tool_run_opts_data[] = 
  { "" };

static const char * MCC_correlation_report_tool_warning_state_data[] = 
  { "off:MATLAB:dispatcher:nameConflict" };


mclComponentData __MCC_correlation_report_tool_component_data = { 

  /* Public key data */
  __MCC_correlation_report_tool_public_key,

  /* Component name */
  "correlation_report_tool",

  /* Component Root */
  "",

  /* Application key data */
  __MCC_correlation_report_tool_session_key,

  /* Component's MATLAB Path */
  MCC_correlation_report_tool_matlabpath_data,

  /* Number of directories in the MATLAB Path */
  49,

  /* Component's Java class path */
  MCC_correlation_report_tool_classpath_data,
  /* Number of directories in the Java class path */
  0,

  /* Component's load library path (for extra shared libraries) */
  MCC_correlation_report_tool_libpath_data,
  /* Number of directories in the load library path */
  0,

  /* MCR instance-specific runtime options */
  MCC_correlation_report_tool_app_opts_data,
  /* Number of MCR instance-specific runtime options */
  0,

  /* MCR global runtime options */
  MCC_correlation_report_tool_run_opts_data,
  /* Number of MCR global runtime options */
  0,
  
  /* Component preferences directory */
  "correlation__213D70616C21C6C0DD99D2C82A233D45",

  /* MCR warning status data */
  MCC_correlation_report_tool_warning_state_data,
  /* Number of MCR warning status modifiers */
  1,

  /* Path to component - evaluated at runtime */
  NULL

};

#ifdef __cplusplus
}
#endif


