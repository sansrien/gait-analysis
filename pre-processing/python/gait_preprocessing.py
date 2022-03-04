import cv2 as cv
import numpy as np
from low_level_processing import *
from run_openpose import *
from kalman_filter import *


#get video file directory
vid_dir = input() 

#apply low level processing
vid_processed = low_level_processing(vid_dir)

#run OpenPose on processed video & convert the json output to csv
keypoints = run_openpose(vid_processed)

#Apply Kalman Filter to the keypoints
keypoits_kf = kalman_filter(keypoints)




