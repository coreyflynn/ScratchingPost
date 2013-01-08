#! /usr/bin/env python
"""
Created on Dec 21, 2011

@author: cflynn
"""
import sys
import json

def txt_to_json(input_file,output_file):
    #open the input and output files
    f_in = open(input_file, 'r')
    f_out = open(output_file, 'w')
    
    level_one_list = get_level_one(f_in)
    level_two_list = get_level_two(f_in, level_one_list)
    #level_two_list = add_instances(f_in, level_two_list, 2)
    level_two_json = json.dumps(level_two_list,sort_keys=True, indent=4)
    f_out.write(level_two_json)
    
    #close the files
    f_in.close()
    f_out.close()
        
def get_level_one(f_in):
    """
    build list of dictionaries of ATC top level codes and their number of occurrences
    """ 
    code_dict = {"null":0}
    f_in.seek(0)
    lines = f_in.readlines()
    for line in lines:
        code = line.split("\t")[5].rstrip("\n")
        if code == "null":
            code_dict["null"] += 1
        else:
            ATC_class = code[0]
            if ATC_class not in code_dict.keys():
                code_dict[ATC_class] = 1
            else:
                code_dict[ATC_class] += 1
    json_list = []
    for key in code_dict.keys():
        json_list.append({"name":key, "val":code_dict[key]})
    
    return json_list

def get_level_two(f_in,level_one_list):
    """
    build list of dictionaries of ATC second level codes and their number of occurrences.
    Add these dictionaries into the correct place in the level_one_dictionary
    """ 
    level_two_list = []
    for category_dict in level_one_list:
        members_dict = {}
        f_in.seek(0)
        lines = f_in.readlines()
        for line in lines:
            split_line = line.split("\t")
            code = split_line[5].rstrip("\n")
            instance_name = split_line[0] + "_" + split_line[1] +"_" + split_line[2] +"_" + split_line[3]
            score = split_line[4]
            if code[0] == category_dict["name"]:
                if code[0:3] not in members_dict.keys():
                    members_dict[code[0:3]] = [1, [{"name":instance_name, "score":score}]]
                else:
                    members_dict[code[0:3]][0] += 1
                    members_dict[code[0:3]][1].append({"name":instance_name, "score":score})
        members_list = []
        for key in members_dict.keys():
            members_list.append({"name":key, "val":members_dict[key][0], "instances":members_dict[key][1]})
            
        new_category_dict = {"name":category_dict["name"], "val":category_dict["val"],
                             "members":members_list}
        level_two_list.append(new_category_dict)
    return level_two_list

def add_instances(f_in,level_list,level):
    """
    add an instances object to the dictionaries in the list.  Each entry in the dictionary
    will have a name and score field
    """
    new_level_list = []
    for category_dict in level_list:
        instances_dict = {}
        f_in.seek(0)
        lines = f_in.readlines()
        for line in lines:
            split_line = line.split("\t")
            code = split_line[5].rstrip("\n")
            if level == 1:                
                if code[0] == category_dict["name"]:
                    instance_name = split_line[0] + "_" + split_line[1] +"_" + split_line[2] +"_" + split_line[3]
                    score = split_line[4]
                    instances_dict[instance_name] = score
            if level == 2:
                print category_dict["name"]
                if code[0:3] == category_dict["name"]:
                    instance_name = split_line[0] + "_" + split_line[1] +"_" + split_line[2] +"_" + split_line[3]
                    score = split_line[4]
                    instances_dict[instance_name] = score
        instances_list = []
        for key,score in instances_dict.items():
            print key + " " + score
            instances_list.append({"name":key, "score":score})
        new_category_dict = {"name":category_dict["name"], "val":category_dict["val"],
                             "members":category_dict["members"], "instances":instances_list}
        new_level_list.append(new_category_dict)
    return new_level_list
      
            
if __name__ == '__main__':
    txt_to_json(sys.argv[1], sys.argv[2])