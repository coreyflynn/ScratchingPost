#! /usr/bin/env python
'''
provides custom DOM utilities 
Created on Feb 9, 2012
@author: Corey Flynn, Broad Institute
'''
import os

import mechanize
from BeautifulSoup import BeautifulSoup

def extract_svg_from_html(input_html,out_dir):
    '''
    reads input_html and finds all svg elements in the file.  These elements are then
    written to individual svg files in out_dir
    '''
    #use mechanize to emulate a browser and read the input_html text after all scripts have 
    #finished
    br = mechanize.Browser()
    site = br.open(input_html)
    html_text = site.read()
    
    #parse input_html text with BeautifulSoup and find all svg elements
    soup = BeautifulSoup(html_text)
    svgs = soup.findAll('svg')
    svg_counter = 0
    for svg in svgs:
        write_to_standard_svg(str(svg), os.path.join(out_dir,str(svg_counter)))
        svg_counter += 1
    

def write_to_standard_svg(svg_string,out_name):
    '''
    writes svg_string to out_name.svg, wrapping svg_string in a standard svg header
    '''
    with open(out_name + '.svg', 'w') as f:
        f.write('<?xml version="1.0" encoding="utf-8"?>\n')
        f.write('<!-- Generator: cjf.cmap.util.dom SVG Version: 6.00 Build 0)  -->\n')
        f.write('<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n')
        f.write(svg_string)
    
    print('wrote file to ' +  out_name + '.svg')
    
    

if __name__ == '__main__':
    pass