'''
set operation methods
Created on May 31, 2012
@author: Corey Flynn
'''

def order_preserved_unique_list(input_list):
    '''
    returns a list composed of the unique members of input_list in the order of the first 
    appearance of the members in input_list
    '''
    output_list = []
    for item in input_list:
        if item not in output_list:
            output_list.append(item)
    return output_list

def unique_list(input_list):
    '''
    returns a list composed of the unique members of input_list.  The order is not 
    guaranteed to be preserved
    '''
    return list(set(input_list))

def intersection_list(list_one,list_two):
    '''
    returns a list of the intersection of list_one with list_two
    '''
    set_one = set(list_one)
    set_two = set(list_two)
    intersect = set_one.intersection(set_two)
    return list(intersect)
        