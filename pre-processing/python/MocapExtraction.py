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
    1:"CLAV",
    2:"LASI",
    3:"RASI",
    4:"LKNE",
    5:"LANK",
    6:"LHEE",
    7:"LTOE",
    8:"RKNE",
    9:"RANK",
    10:"RHEE",
    11:"RTOE",
    12:"spine-hip"
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
                        row.append((float(row[5])+ float(row[8]))/2)
                        #spine-hip_y
                        row.append((float(row[6])+ float(row[9]))/2)
                        #spine-hip_z
                        row.append((float(row[7])+ float(row[10]))/2)
                        writer.writerow(row)
                        total_written +=1
                        next_frame+=4
                frame_ctr +=1

            row_ctr += 1


    