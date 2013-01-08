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

#include "mclmcrrt.h"

#ifdef __cplusplus
extern "C" {
#endif
const unsigned char __MCC_inferred_correlation_tool_session_key[] = {
    '5', '3', '5', '4', '0', '3', '3', '5', 'B', '4', '1', 'A', '6', '1', '1',
    '6', '1', '1', 'F', '7', 'C', '2', '2', '0', '7', 'E', 'E', 'E', '3', '5',
    '7', '1', 'B', '0', 'C', '6', '1', 'A', '8', '9', 'F', '2', '2', '9', 'B',
    '2', '9', 'D', 'E', '2', '9', '3', '9', '4', '0', 'C', '8', 'F', 'E', '3',
    '5', '4', '6', 'C', '0', '7', 'D', 'D', '4', 'E', '5', 'C', 'A', 'B', 'A',
    '5', '8', '3', 'F', 'E', 'F', 'B', '3', '9', '8', '1', 'B', 'B', '6', '9',
    '2', '6', 'C', '0', 'B', '4', 'F', '4', 'C', '3', 'F', 'E', '9', '1', 'F',
    '2', 'F', '6', '7', '7', '4', '9', 'A', 'A', '0', '5', 'A', '1', 'C', 'B',
    'A', 'D', '1', 'E', '4', 'E', 'E', 'C', 'C', '4', 'B', 'B', '4', 'D', '3',
    'F', '9', '2', '1', 'E', 'A', '0', '1', '6', '2', '3', '7', 'D', '5', '2',
    'D', '2', '3', '5', '8', 'A', '0', 'E', 'B', 'B', '6', '3', '3', 'B', 'C',
    '0', '2', '7', 'D', 'E', '5', '7', 'E', '3', 'A', '8', '2', '0', 'D', 'C',
    '8', '4', '7', '1', '5', 'F', 'B', '9', 'F', '0', '1', '7', 'B', '2', '5',
    '2', '7', '7', '2', '3', '1', '2', '3', '8', '6', '9', '5', '8', '9', '1',
    'A', '9', '1', 'D', 'C', 'D', '4', '9', '0', 'A', 'F', 'B', 'D', 'D', 'C',
    '5', 'B', 'F', 'B', '0', 'E', 'B', '0', '0', '2', '9', '6', '7', '9', '8',
    'C', '2', '6', '8', '6', '5', '6', '5', 'B', '4', '6', 'E', '2', '8', '7',
    '7', '\0'};

const unsigned char __MCC_inferred_correlation_tool_public_key[] = {
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

static const char * MCC_inferred_correlation_tool_matlabpath_data[] = 
  { "inferred_cor/", "$TOOLBOXDEPLOYDIR/", "xchip/cogs/tools/bmtk/util/",
    "xchip/cogs/tools/bmtk/plot/", "xchip/cogs/tools/bmtk/l1000/",
    "xchip/cogs/tools/bmtk/io/", "xchip/cogs/tools/bmtk/deprecated/",
    "xchip/cogs/tools/bmtk/math/", "xchip/cogs/tools/bmtk/core/",
    "xchip/cogs/tools/bmtk/resources/", "xchip/cogs/tools/bmtk/resources/.svn/",
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

static const char * MCC_inferred_correlation_tool_classpath_data[] = 
  { "" };

static const char * MCC_inferred_correlation_tool_libpath_data[] = 
  { "" };

static const char * MCC_inferred_correlation_tool_app_opts_data[] = 
  { "" };

static const char * MCC_inferred_correlation_tool_run_opts_data[] = 
  { "" };

static const char * MCC_inferred_correlation_tool_warning_state_data[] = 
  { "off:MATLAB:dispatcher:nameConflict" };


mclComponentData __MCC_inferred_correlation_tool_component_data = { 

  /* Public key data */
  __MCC_inferred_correlation_tool_public_key,

  /* Component name */
  "inferred_correlation_tool",

  /* Component Root */
  "",

  /* Application key data */
  __MCC_inferred_correlation_tool_session_key,

  /* Component's MATLAB Path */
  MCC_inferred_correlation_tool_matlabpath_data,

  /* Number of directories in the MATLAB Path */
  50,

  /* Component's Java class path */
  MCC_inferred_correlation_tool_classpath_data,
  /* Number of directories in the Java class path */
  0,

  /* Component's load library path (for extra shared libraries) */
  MCC_inferred_correlation_tool_libpath_data,
  /* Number of directories in the load library path */
  0,

  /* MCR instance-specific runtime options */
  MCC_inferred_correlation_tool_app_opts_data,
  /* Number of MCR instance-specific runtime options */
  0,

  /* MCR global runtime options */
  MCC_inferred_correlation_tool_run_opts_data,
  /* Number of MCR global runtime options */
  0,
  
  /* Component preferences directory */
  "inferred_cor_F1E2A02D32272EF8396C88D8979ED61A",

  /* MCR warning status data */
  MCC_inferred_correlation_tool_warning_state_data,
  /* Number of MCR warning status modifiers */
  1,

  /* Path to component - evaluated at runtime */
  NULL

};

#ifdef __cplusplus
}
#endif


