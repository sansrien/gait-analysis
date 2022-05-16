import json
import os
import csv

def convert_to_csv(dir_location, filename, start_frame, total_frame):
    start_frame=start_frame*4 
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
    csvFileName = "mocap_csv/"+ filename+"_mocap.csv" #change

    with open(csvFileName,'w', encoding='UTF8',newline='') as f:
        writer = csv.writer(f)

        header=['frame','elapsed_time']

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
                    if(total_written < total_frame):
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
#convert_to_csv(dir_location, filename, total_frame, start_frame):
convert_to_csv("mocap","p1s1", 195, 135)
convert_to_csv("mocap","p2s1", 130 ,155 )
convert_to_csv("mocap","p3s1", 340,145 )
convert_to_csv("mocap","p4s1", 130, 120)
convert_to_csv("mocap","p5s1", 195, 155 )
#convert_to_csv("mocap","p6s1", 110,90 )
convert_to_csv("mocap","p7s1", 90,120 )
convert_to_csv("mocap","p8s1", 260, 140)
convert_to_csv("mocap","p9s1", 145, 145)
convert_to_csv("mocap","p10s1", 160, 135)
convert_to_csv("mocap","p11s1", 145, 115)
convert_to_csv("mocap","p12s1", 200, 130)
convert_to_csv("mocap","p13s1", 10, 125)
convert_to_csv("mocap","p14s1", 5, 125)
convert_to_csv("mocap","p15s1", 80, 105)
#convert_to_csv("mocap","p16s1", 105, 115)
convert_to_csv("mocap","p17s1", 200, 125)
#convert_to_csv("mocap","p18s1", 160, 120)
convert_to_csv("mocap","p19s1", 110, 105)
convert_to_csv("mocap","p20s1", 140, 160)
convert_to_csv("mocap","p21s1", 150, 135)
convert_to_csv("mocap","p22s1", 140, 125)
#convert_to_csv("mocap","p23s1", 100, 100)
convert_to_csv("mocap","p24s1", 145, 135)
convert_to_csv("mocap","p25s1", 105, 110)
#convert_to_csv("mocap","p26s1", 100, 105 )
convert_to_csv("mocap","p26s5", 155, 100)
convert_to_csv("mocap","p27s1", 160, 145)
convert_to_csv("mocap","p27s5", 130, 145)
convert_to_csv("mocap","p28s1", 155, 145)
convert_to_csv("mocap","p28s5", 170, 180)
convert_to_csv("mocap","p29s1", 200, 140)
convert_to_csv("mocap","p29s5", 180, 115)
convert_to_csv("mocap","p30s1", 145, 115)
convert_to_csv("mocap","p30s5", 130, 115)
convert_to_csv("mocap","p31s1", 125, 115)
#convert_to_csv("mocap","p31s5", 130, 125)
convert_to_csv("mocap","p30s1", 190, 160)

