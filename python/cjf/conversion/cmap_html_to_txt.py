#! /usr/bin/env python
"""
Utility to convert a raw html dump of a cmap search result table into a tab delimited table.
INPUTS:
(1) input_html: the html file to be parsed
(2) output_txt: the txt file to be written
"""

import urllib2
import BeautifulSoup


def stringify(soup_list):
    """ turn tag list into a list of strings"""
    string_list = []
    for item in soup_list:
        try:
            string_list.append(str(item.contents[0]))
        except IndexError:
            string_list.append("null")
    
    return string_list


if __name__ == '__main__':
    import sys
    
    input_html = sys.argv[1]
    output_txt = sys.argv[2]
    
    print( "parsing " + input_html)
    cmap_html = urllib2.urlopen("file://" + input_html)
    soup = BeautifulSoup.BeautifulSoup(cmap_html)
    
    #grab the data from the data table and store the entries in lists for each column in the table
    print "splitting columns"
    
    ranks = stringify(soup.findAll("td", {"class" : "c1"} ))
    print "."
    #batches = stringify(soup.findAll("td", {"class" : "c2"} ))
    print ".."
    names = stringify(soup.findAll("td", {"class" : "c3"} ))
    print "..."
    doses = stringify(soup.findAll("td", {"class" : "c5"} ))
    print "...."
    cells = stringify(soup.findAll("td", {"class" : "c6"} ))
    print "....."
    scores = stringify(soup.findAll("td", {"class" : "c7"} ))
    print "......"
    #ups = stringify(soup.findAll("td", {"class" : "c8"} ))
    print "......."
    #downs = stringify(soup.findAll("td", {"class" : "c9"} ))
    print "........"
    ATCs = soup.findAll("td", {"class" : "c10"} )
    ATCs_names = []
    for ATC in ATCs:
        code = str(ATC.next.string)
        if code == "\n":
            ATCs_names.append("null\n")
        else:
            ATCs_names.append(code + "\n")
    print "........."
    #ids = stringify(soup.findAll("td", {"class" : "c11"} ))
    
    #open a new file and write the entries to that file
    print("writing data to " + output_txt)
    out = open(output_txt,"w")
    for ii in range(len(ranks)):
        out.write(ranks[ii] +"\t" + names[ii] +"\t"
                  + doses[ii] +"\t" + cells[ii] +"\t" + scores[ii] +"\t"
                  + ATCs_names[ii])
        
    out.close()