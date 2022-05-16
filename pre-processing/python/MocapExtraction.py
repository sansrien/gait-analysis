import json
import os
import csv

dir_location=input("Enter location of CSV file:")
filename=input("Enter file name of MOCAP csv file:")
rgb_frame_count=int(input("Enter total frames of RGB video file:")) # 1-indexing
start_frame=int(input("Enter start frame:"))*4 # 1-indexing

print(start_frame)
#joints dictionary
joints={
    1:"LFHD",
    2:"RFHD",
    3:"LBHD",
    4:"RBHD",
    5:"C7",
    6:"T10",
    7:"CLAV",
    8:"STRN",
    9:"RBAK",
    10:"LSHO",
    11:"LUPA",
    12:"LELB",
    13:"LFRM",
    14:"LWRA",
    15:"LWRB",
    16:"LFIN",
    17:"RSHO",
    18:"RUPA",
    19:"RELB",
    20:"RFRM",
    21:"RWRA",
    22:"RWRB",
    23:"RFIN",
    24:"LASI",
    25:"RASI",
    26:"LPSI",
    27:"RPSI",
    28:"LTHI",
    29:"LKNE",
    30:"LTIB",
    31:"LANK",
    32:"LHEE",
    33:"LTOE",
    34:"RTHI",
    35:"RKNE",
    36:"RTIB",
    37:"RANK",
    38:"RHEE",
    39:"RTOE",
    40:"spine-hip",
    41:"middle-neck"
}

csvFileName = "mocap_"+ filename+".csv" #change

with open(csvFileName,'w', encoding='UTF8',newline='') as f:
    writer = csv.writer(f)

    header=['frame','elapsed_time(s)']

    for joint in joints.values():
        header.append(joint+'_x')
        header.append(joint+'_y')
        header.append(joint+'_z')

    writer.writerow(header)

    # f = dir_location + '/' + filename +".csv"
    f = dir_location + '/' + filename +".csv"
    frame_ctr=1;
    with open(f) as mocap_file:
        csv_reader = csv.reader(mocap_file, delimiter=',')
        row_ctr=0;
        frame_ctr=start_frame;
        next_frame=start_frame;
        total_written=0;
        for row in csv_reader:
            #ignore first 3 headers & start at start frame
            if (row_ctr>=2+start_frame):
                #match frame count of original RGB vid
                if(total_written < rgb_frame_count):
                    #sampling fs=4
                    if(frame_ctr==next_frame):
                        row.insert(0, frame_ctr)
                        #spine-hip registration
                        #spine-hip_x
                        row.append((float(row[71])+ float(row[74]))/2)
                        #spine-hip_y
                        row.append((float(row[72])+ float(row[75]))/2)
                        #spine-hip_z
                        row.append((float(row[73])+ float(row[76]))/2)

                        #middle-neck_x
                        row.append((float(row[14])+ float(row[20]))/2)
                        #middle-neck_y
                        row.append((float(row[15])+ float(row[21]))/2)
                        #middle-neck_z
                        row.append((float(row[16])+ float(row[22]))/2)
                        writer.writerow(row)
                        total_written +=1
                        next_frame+=4
                frame_ctr +=1

            row_ctr += 1


    