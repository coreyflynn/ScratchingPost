"""
automatically builds sphinx .rst files for generation of documentations for the cjf package

Created on Jan 25, 2012
@author: Corey Flynn
"""
import os

def get_source_files():
    """
    walks the cjf directory and finds all source files with .py extensions that are not
    under .svn directories
    """
    walk_result = os.walk('/xchip/cogs/cflynn/sandboxCodeWorking/python/cjf')
    file_list = []
    root_list = []
    for res in walk_result:
        root = res[0]
        if root not in root_list:
            root_list.append(root)
        if 'cjf' in root and '.svn' not in root:
            print 'scanning ' + root
            for file_name in res[2]:
                if 'py' in file_name and '.pyc' not in file_name and '__init__' not in file_name:
                    file_list.append(os.path.join(root,file_name))
    return (root_list,file_list)

def make_source_rst(input_path,output_dir):
    """
    write an rst file to output_dir containing a title and an automodule call for the source
    file
    """
    base = os.path.basename(input_path)
    with open(os.path.join(output_dir,base.replace('.py','') + '.rst'),'w') as f:
        f.write(base.replace('.py','') + '\n')
        f.write('='*len(base) + '\n\n')
        f.write('.. automodule:: ' + input_path.replace('/xchip/cogs/cflynn/sandboxCodeWorking/python/','').replace('.py','').replace('/','.')
                 + '\n\t' + ':members:')
def make_dir_rst(root_list,output_dir):
    """
    create TOC pages for the root hierarchy formed in root_list  
    """
    for root in root_list:
        base = os.path.basename(root)
        if not base.startswith('.'):
            with open(os.path.join(output_dir,base.replace('.py','') + '.rst'),'w') as f:
                f.write(base + '\n')
                f.write('='*len(base) + '\n\n')
                f.write('.. toctree::\n\t:maxdepth: 2\n\n')
                contents = os.listdir(root)
                for c in contents:
                    if '.svn' not in c and '.pyc' not in c and '__init__' not in c:
                        f.write('\t' + c.replace('.py','') + '\n')

if __name__ == '__main__':
    (roots,source_files) = get_source_files()
    for sf in source_files:
        make_source_rst(sf, '/xchip/cogs/cflynn/sandboxCodeWorking/python/sphinx')
    make_dir_rst(roots, '/xchip/cogs/cflynn/sandboxCodeWorking/python/sphinx')