#! /usr/bin/env python
'''
methods for the creation and manipulation of sqlite databases using sqlite3
Created on Mar 7, 2012
@author: Corey Flynn, Broad Institute
'''
import os
import sqlite3

def create_db(db_path):
    '''
    create an empty sqlite database at the location specified in db_path.
    '''
    #ensure .sqlite extenstion
    db_path = ensure_sqlite(db_path)
    
    #build the empty database
    conn = sqlite3.connect(db_path)
    conn.commit()
    
def add_table(db_path,table_name,table_list):
    '''
    create a new table in the database at db_path.  The name of the table is given in
    table_name and the fields are specified by the entries in table_list.  Table_list 
    entries must be of the form ('name','sql_data_type')
    '''
    #ensure .sqlite extenstion
    db_path = ensure_sqlite(db_path)
    
    #translate table_name and table_list into a valid SQL command
    command_list = []
    for item in table_list:
        command_list.append(item[0])
        command_list.append(item[1])
    
    command_string = 'create table ' + table_name + '('
    for i in range(len(table_list)):
        command_string += '%s %s'
        if not i == len(table_list)-1:
            command_string += ', '
    command_string += ')'
    command_string = command_string % tuple(command_list)
    
    #connect to the db and create the table
    conn = sqlite3.connect(db_path)
    c = conn.cursor()
    c.execute(command_string)
    conn.commit()
    c.close()
    
def add_row_to_table(db_path,table_name,row_data):
    '''
    adds the list of data given by row_data to table_name in db_path. The data in row_data
    is assumed to be of the right format for the given table
    '''
    #ensure .sqlite extenstion
    db_path = ensure_sqlite(db_path)
    
    #translate table_name and table_list into a valid SQL command
    command_string = "insert into %s values (" % (table_name,)
    for i in range(len(row_data)):
        command_string += "%s"
        if not i == len(row_data)-1:
            command_string += ", "
    command_string += ")"
    for i,item in enumerate(row_data):
        if isinstance(item,str):
            row_data[i] = '"' + item + '"'
        
    command_string = command_string % tuple(row_data)
          
    #connect to the db and add row_data to the table
    conn = sqlite3.connect(db_path)
    c = conn.cursor()
    c.execute(command_string)
    conn.commit()
    c.close()
    
    
def ensure_sqlite(db_path):
    '''
    ensures that the given db_path ends in .sqlite in order to standardize database naming
    '''
    #check for .sqlite file extension and force it if it is not there
    db_name,db_extension = os.path.splitext(db_path) 
    if not db_extension == '.sqlite':
        db_extension = '.sqlite'
    db_path = db_name + db_extension
    return db_path

def run_query(db_path,query):
    '''
    returns a list of all of the objects returned from the given query into the database
    '''
    #ensure .sqlite extenstion
    db_path = ensure_sqlite(db_path)
    
    conn = sqlite3.connect(db_path)
    c = conn.cursor()
    c.execute(query)
    result = []
    for row in c:
        result.append(row)
    return result
    
    
if __name__ == '__main__':
    pass