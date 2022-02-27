#Leg Correction

#loop
#see difference
#switch if big difference
# check first if bigger difference if switch
#kind of complicated if in double stance
# looking at knee may also help

# for each frames
#     right ankle

#next attempt"
#switch all suceeding points

import json
import os
import csv
import matplotlib.pyplot as plt

def switch(keypoints, frame):
    print('switching')
    joints_r= [ 
    "r-hip_x", "r-hip_y", "r-hip_c",
    "r-knee_x", "r-knee_y", "r-knee_c",
    "r-ankle_x", "r-ankle_y", "r-ankle_c",
    "r-heel_x", "r-heel_y", "r-heel_c",
    "r-bigtoe_x", "r-bigtoe_y", "r-bigtoe_c",
    "r-smalltoe_x", "r-smalltoe_y", "r-smalltoe_c"]
    joints_l= [ 
    "l-hip_x", "l-hip_y", "l-hip_c",
    "l-knee_x", "l-knee_y", "l-knee_c",
    "l-ankle_x", "l-ankle_y", "l-ankle_c",
    "l-heel_x", "l-heel_y", "l-heel_c",
    "l-bigtoe_x", "l-bigtoe_y", "l-bigtoe_c",
    "l-smalltoe_x", "l-smalltoe_y", "l-smalltoe_c"]

    # #create temp
    # temp_r={}
    # for joint in joints_r:
    #     temp_r[joint]=keypoints[joint][frame]

    #switch
    for n in range(len(joints_r)):
        temp_r = keypoints[joints_r[n]][frame]
        keypoints[joints_r[n]][frame] = keypoints[joints_l[n]][frame]
        keypoints[joints_l[n]][frame] = temp_r

    return keypoints


foldername="trial1" #change to folder name 
dir_location="C:/Users/Clarisse Alago/Documents/School/Active/EEE 196/OP/openpose/output_json_folder/trial1" #change to frames directory
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

#initialize dict.
keypoints ={}
for joint in joints.values():
        keypoints[joint+'_x']=[]
        keypoints[joint+'_y']=[]
        keypoints[joint+'_c']=[]

frame_ctr=0;
for filename in os.listdir(dir_location):
        f = open(foldername + '/' + filename)
        data = json.load(f)['people'][0]["pose_keypoints_2d"] #loaded as dictitionary -> gets the array of keypoints only
        #create list for row
        for key in joints.keys():
            index=(key-1)*3
            keypoints[joints[key]+'_x'].append(data[index])
            keypoints[joints[key]+'_y'].append(data[index + 1])
            keypoints[joints[key]+'_c'].append(data[index + 2])
        
        

        #leg correction function
        #list is 0 indexing
        if frame_ctr >= 1:
            delta_r = abs(keypoints["r-ankle_x"][frame_ctr-1] - keypoints["r-ankle_x"][frame_ctr])
            delta_l = abs(keypoints["r-ankle_x"][frame_ctr-1] - keypoints["l-ankle_x"][frame_ctr])
            if delta_r > (1*delta_l):
                print('switch')
                keypoints=switch(keypoints,frame_ctr)
            else:
                print('ok')

        frame_ctr=frame_ctr+1
            


#to csv file 
with open('keypoints_correctx.csv','w', encoding='UTF8',newline='') as f: # this will OVERWRITE the existing file
    writer = csv.writer(f)
    #csv headers
    header=['frame']

    for joint in joints.values():
        header.append(joint+'_x')
        header.append(joint+'_y')
        header.append(joint+'_c')
        
    writer.writerow(header)

    #going over all frames
    for i in range(frame_ctr):
        row=[i]
        for key in joints.keys():
            joint= joints[key]
            row.append(keypoints[joint+'_x'][i])
            row.append(keypoints[joint+'_y'][i])
            row.append(keypoints[joint+'_c'][i])
        writer.writerow(row)





plt.plot(keypoints['r-ankle_x'], label="right")
plt.plot(keypoints['l-ankle_x'], label="left")
plt.title('Correction - ankle_x')
plt.show()


