from ast import Dict
from asyncore import write
from importlib.resources import read_binary
import json
import os

def readEnumsIfExists(path):
    if fileExists(path) :    
        return readEnums(path)
    else:
        print("file does not exist: " + path)
        return []

def readItemsIfExists(path):
    if fileExists(path) :    
        return readItems(path)
    else:
        print("file does not exist: " + path)
        return []

def fileExists(path):
    return os.path.exists(path)

def readEnums(path):
    print("Started Reading Enum JSON file")
    with open(path, "r") as read_file:
        print("Starting to convert json decoding")
        enums = json.load(read_file)

    print("Decoded JSON Data From File")
    thislist = []
    for key in enums:
        if (key in thislist):
            print('key is already in')
        else:
            thislist.append(key)
    print("Done reading json file")
    return thislist

def readItems(path):
    print("Started Reading Items JSON file")
    with open(path, "r") as read_file:
        print("Starting to convert json decoding")
        enums = json.load(read_file)

    print("Decoded JSON Data From File")
    thislist = {}
    for key in enums:
        if (key["Name"] in thislist.keys()):
            print('key is already in')
        else:
            thislist[key["Name"]] = key
    print("Done reading json file")
    return thislist

def readObject(path):
    print("Started Reading Object JSON file")
    with open(path, "r") as read_file:
        return json.load(read_file)

def storeEnums(path, enums):
    json_str = json.dumps(enums)
    with open(path,"w") as write_file:
        write_file.write(json_str)

def storeItems(path, dicItems):
    json_str = json.dumps(list(dicItems.values()))
    with open(path,"w") as write_file:
        write_file.write(json_str)

def storeObject(path, item):
    json_str = json.dumps(item)
    with open(path,"w") as write_file:
        write_file.write(json_str)   