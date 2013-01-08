"""
Created on Jul 18, 2012

@author: Corey Flynn
"""
if __name__ == '__main__':
    import os
    import platform
    import cmap.ui.dialog as dialog
    import cmap.io.platemap as platemap
    import cmap.io.report as report
    import cmap.util.progress as progress
    import csv
    import sqlite3
    import cmap.util.text as text
    import cmap.util.tool_ops as tool_ops
    from optparse import OptionParser
    
    #imports to force reportlab to work with pyinstaller
    from reportlab.pdfbase import _fontdata_enc_winansi
    from reportlab.pdfbase import _fontdata_enc_macroman
    from reportlab.pdfbase import _fontdata_enc_standard
    from reportlab.pdfbase import _fontdata_enc_symbol
    from reportlab.pdfbase import _fontdata_enc_zapfdingbats
    from reportlab.pdfbase import _fontdata_enc_pdfdoc
    from reportlab.pdfbase import _fontdata_enc_macexpert
    from reportlab.pdfbase import _fontdata_widths_courier
    from reportlab.pdfbase import _fontdata_widths_courierbold
    from reportlab.pdfbase import _fontdata_widths_courieroblique
    from reportlab.pdfbase import _fontdata_widths_courierboldoblique
    from reportlab.pdfbase import _fontdata_widths_helvetica
    from reportlab.pdfbase import _fontdata_widths_helveticabold
    from reportlab.pdfbase import _fontdata_widths_helveticaoblique
    from reportlab.pdfbase import _fontdata_widths_helveticaboldoblique
    from reportlab.pdfbase import _fontdata_widths_timesroman
    from reportlab.pdfbase import _fontdata_widths_timesbold
    from reportlab.pdfbase import _fontdata_widths_timesitalic
    from reportlab.pdfbase import _fontdata_widths_timesbolditalic
    from reportlab.pdfbase import _fontdata_widths_symbol
    from reportlab.pdfbase import _fontdata_widths_zapfdingbats
    
    #parse input arguments
    usage = "usage: %prog [options]"
    parser = OptionParser(usage=usage)
    parser.set_defaults(dir_path=None,out=os.getcwd())
    parser.add_option("-d","--dir_path",dest="dir_path",
                      help="the directory in which to look for .map files")
    parser.add_option("-o","--out",dest="out",
                      help="the directory in which to write output")
    (options, args) = parser.parse_args()
    
    
    #build a progress indicator
    progress_bar = progress.DeterminateProgressBar('Map Checker')
    
    #grab a source folder through UI if needed and get a list map files in the folder
    if options.dir_path:
        dir_path = options.dir_path
    else:
        map_checker_default_out = os.path.expanduser('~/map_checker')
        if not os.path.exists(map_checker_default_out):
            os.mkdir(map_checker_default_out)
        options.out = map_checker_default_out
        dir_path = dialog.open_dir_dialog('Select Map Folder')
    dir_list=os.listdir(dir_path)
    map_files = []
    for fname in dir_list:
        root, ext = os.path.splitext(fname)
        if ext == '.map':
            map_files.append(os.path.join(dir_path,fname))
    num_files = len(map_files)
    print('found %i .map files' %(num_files,))
    
    #check each map file and collect the checker's output
    checker_outputs = []
    demacified = []
    map_files.sort()
    for i, map_file in enumerate(map_files):
        progress_bar.update('checking .map files', i, num_files)
        try:
            checker = platemap.MAP(map_file)
            checker_outputs.append(checker.check(capture_output=True))
        except csv.Error:
            text.demacify(map_file)
            demacified.append(map_file)
            checker = platemap.MAP(map_file)
        except AssertionError, e:
            text.remove_end_tabs(map_file)
            checker_outputs.append(checker.check(capture_output=True))
        except sqlite3.OperationalError, e:
            checker_outputs.append(str(e))
            
    #build a report
    progress_bar.show_message('building report...')
    map_report = report.RPT('Map Checker Report')
    if demacified:
        map_report.header('Demacified files')
        map_report.pre('\n'.join(demacified))
    for i,map_file in enumerate(map_files):
        map_report.header(os.path.basename(map_file))
        map_report.pre(checker_outputs[i])
        
    #write report to file
    escaped_dir_path = text.space_escape(dir_path)
    escaped_out = text.space_escape(options.out)
    #look for map_checker app if on mac
    if platform.system() == 'Darwin':
        if os.path.exists('/Applications/map_checker'):
            tool_ops.append_to_commands("/Applications/map_checker " + ' --dir_path ' + escaped_dir_path
                                        + ' --out ' + escaped_out)
    else:
        tool_ops.append_to_commands("python " + __file__ + ' --dir_path ' + escaped_dir_path
                                    + ' --out ' + escaped_out)
    work_dir = tool_ops.make_working_dir('map_checker',start_path=options.out)
    params = [('dir_path', escaped_dir_path),
              ('out', escaped_out)]
    tool_ops.make_rpt(work_dir, params)
    progress_bar.clear()
    map_report.write(os.path.join(dir_path,work_dir,'map_report.pdf'))
    print('report written to %s' % (os.path.join(dir_path,work_dir,'map_report.pdf'),))