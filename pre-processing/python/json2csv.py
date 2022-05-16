import json
import os

import csv
#foldername= str(input("Foldername where the json files are located")) #change to folder name 
#dir_location="examples/output/" + foldername #change to frames directory
num=str(input())
dir_location="p"+num+"s5";#"p2s1" #change this line
frame_count= len(os.listdir(dir_location))

joints={
    2:"neck",
    9:"spine_hip",
    10:"r_hip",
    11:"r_knee",
    12:"r_ankle",
    25:"r_heel",
    23:"r_bigtoe",
    24:"r_smalltoe",
    13:"l_hip",
    14:"l_knee",
    15:"l_ankle",
    22:"l_heel",
    20:"l_bigtoe",
    21:"l_smalltoe"
}

csvFileName = dir_location+".csv" #change
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


