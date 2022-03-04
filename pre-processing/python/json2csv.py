import json
import os

import csv
foldername= str(input("Foldername where the json files are located")) #change to folder name 
#dir_location="examples/output/" + foldername #change to frames directory
dir_location="1" #change this line
frame_count= len(os.listdir(dir_location))

joints={
    8:"spine-hip",
    9:"r-hip",
    10:"r-knee",
    11:"r-ankle",
    24:"r-heel",
    22:"r-bigtoe",
    23:"r-smalltoe",
    12:"l-hip",
    13:"l-knee",
    14:"l-ankle",
    21:"l-heel",
    19:"l-bigtoe",
    20:"l-smalltoe"
}

csvFileName = "keypoints"+foldername+".csv"
with open(csvFileName,'w', encoding='UTF8',newline='') as f: # this will OVERWRITE the existing file
    writer = csv.writer(f)
    #csv headers
    header=['frame','elapsed_time(s)']

    for joint in joints.values():
        header.append(joint+'_x')
        header.append(joint+'_y')
        header.append(joint+'_c')

    writer.writerow(header)

    #going over all frames
    frame_ctr=0
    frame_time=0
    time_increment = 1/25
    for filename in os.listdir(dir_location):
        f = open(dir_location + '/' + filename)
        data = json.load(f)['people'][0]["pose_keypoints_2d"] #loaded as dictitionary -> gets the array of keypoints only
        #create list for row
        frame_time= 0 if not frame_ctr else frame_time + time_increment
        row= [frame_ctr,frame_time]
        for key in joints.keys():
            index=(key-1)*3
            row.append(data[index])
            row.append(data[index+1])
            row.append(data[index+2])
        writer.writerow(row)	
        frame_ctr=frame_ctr+1


