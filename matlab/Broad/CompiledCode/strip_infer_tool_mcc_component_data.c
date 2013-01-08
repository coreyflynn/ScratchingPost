/*
 * MATLAB Compiler: 4.13 (R2010a)
 * Date: Fri Oct 28 16:04:45 2011
 * Arguments: "-B" "macro_default" "-d"
 * "/xchip/cogs/cflynn/sandboxCodeWorking/matlab/CompiledCode" "-m" "-W" "main"
 * "-T" "link:exe"
 * "/xchip/cogs/cflynn/sandboxCodeWorking/matlab/strip_infer_tool.m" "-I"
 * "/xchip/cogs/tools/bmtk" "-I" "/xchip/cogs/tools/bmtk/util" "-I"
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

#include "mclmcrrt.h"

#ifdef __cplusplus
extern "C" {
#endif
const unsigned char __MCC_strip_infer_tool_session_key[] = {
    '1', 'C', '6', '0', '4', 'A', '1', 'D', '5', 'C', 'C', '6', '7', '9', 'A',
    '6', '0', '6', '3', 'C', '4', '5', '2', '4', 'F', 'D', '8', '7', '5', '6',
    'E', 'C', '8', 'D', 'C', '5', 'A', '7', 'B', '7', 'E', '3', '8', 'F', '6',
    '4', 'B', '1', '1', 'F', '6', 'E', '0', '0', 'D', '7', '1', '8', '0', '8',
    '0', '6', '1', '8', '2', '9', '5', '2', '6', 'A', '9', 'F', '3', '9', '2',
    'C', '4', '2', '2', 'F', '2', 'C', '4', 'B', '2', 'E', '4', 'A', 'D', '0',
    '6', '0', '7', '8', '1', '8', '3', 'C', 'C', '0', 'F', '4', '4', 'B', 'A',
    'B', '3', '5', '0', 'D', '7', '7', 'A', '7', 'E', 'A', 'D', 'E', '1', 'D',
    'E', '4', '9', '6', '8', 'A', '7', 'A', '8', '5', '1', '2', 'A', 'A', 'D',
    '8', 'C', '2', 'E', 'C', 'C', 'B', '5', 'D', '3', 'E', '5', '5', '9', '5',
    '7', '2', 'D', 'F', '4', '9', '8', 'B', 'C', 'C', '5', '9', 'C', 'A', 'C',
    '3', '9', '0', '6', '5', '6', '5', '3', '3', 'D', '2', 'E', '2', '4', '3',
    'C', 'A', 'D', '7', '6', 'B', '4', '5', '3', '6', '9', '0', '0', '9', 'C',
    '7', '0', '4', '5', 'F', 'E', '0', '0', 'D', '6', 'F', 'E', '0', '3', 'F',
    'A', '5', 'E', 'F', '3', '0', '8', '3', '9', '2', 'B', '9', '6', '8', '1',
    'D', 'E', '7', '5', '4', '2', 'F', '2', 'B', '1', 'A', 'F', '3', '9', '3',
    '8', '9', '7', 'A', 'D', 'D', '5', 'C', '5', '8', 'D', 'A', 'F', '9', 'B',
    'D', '\0'};

const unsigned char __MCC_strip_infer_tool_public_key[] = {
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

static const char * MCC_strip_infer_tool_matlabpath_data[] = 
  { "strip_infer_/", "$TOOLBOXDEPLOYDIR/", "xchip/cogs/tools/bmtk/util/",
    "xchip/cogs/tools/bmtk/l1000/", "xchip/cogs/tools/bmtk/io/",
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

static const char * MCC_strip_infer_tool_classpath_data[] = 
  { "" };

static const char * MCC_strip_infer_tool_libpath_data[] = 
  { "" };

static const char * MCC_strip_infer_tool_app_opts_data[] = 
  { "" };

static const char * MCC_strip_infer_tool_run_opts_data[] = 
  { "" };

static const char * MCC_strip_infer_tool_warning_state_data[] = 
  { "off:MATLAB:dispatcher:nameConflict" };


mclComponentData __MCC_strip_infer_tool_component_data = { 

  /* Public key data */
  __MCC_strip_infer_tool_public_key,

  /* Component name */
  "strip_infer_tool",

  /* Component Root */
  "",

  /* Application key data */
  __MCC_strip_infer_tool_session_key,

  /* Component's MATLAB Path */
  MCC_strip_infer_tool_matlabpath_data,

  /* Number of directories in the MATLAB Path */
  49,

  /* Component's Java class path */
  MCC_strip_infer_tool_classpath_data,
  /* Number of directories in the Java class path */
  0,

  /* Component's load library path (for extra shared libraries) */
  MCC_strip_infer_tool_libpath_data,
  /* Number of directories in the load library path */
  0,

  /* MCR instance-specific runtime options */
  MCC_strip_infer_tool_app_opts_data,
  /* Number of MCR instance-specific runtime options */
  0,

  /* MCR global runtime options */
  MCC_strip_infer_tool_run_opts_data,
  /* Number of MCR global runtime options */
  0,
  
  /* Component preferences directory */
  "strip_infer__374FB923A733E13E40E1C1898B6329B1",

  /* MCR warning status data */
  MCC_strip_infer_tool_warning_state_data,
  /* Number of MCR warning status modifiers */
  1,

  /* Path to component - evaluated at runtime */
  NULL

};

#ifdef __cplusplus
}
#endif


