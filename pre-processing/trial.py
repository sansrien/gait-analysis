import cv2 as cv
import numpy as np

def video_frames(vid_path):
    vidcap = cv2.VideoCapture('big_buck_bunny_720p_5mb.mp4')
    success,image = vidcap.read()
    count = 0
    while success:
        cv2.imwrite("frame%d.jpg" % count, image)     # save frame as JPEG file      
        success,image = vidcap.read()
        print('Read a new frame: ', success)
        count += 1
  


def histogram_equalization(img_dir):
    img = cv.imread(img_dir)
    cv.imshow('raw image',img)
     # convert from RGB color-space to YCrCb
    ycrcb_img = cv.cvtColor(img, cv.COLOR_BGR2YCrCb)

    # equalize the histogram of the Y channel
    ycrcb_img[:, :, 0] = cv.equalizeHist(ycrcb_img[:, :, 0])

    # convert back to RGB color-space from YCrCb
    output = cv.cvtColor(ycrcb_img, cv.COLOR_YCrCb2BGR)

    # ycrcb_img = cv.cvtColor(img, cv.COLOR_BGR2YCrCb)

    # ycrcb_img[:, :, 0] = cv.equalizeHist(ycrcb_img[:, :, 0])

    # output= cv.cvtColor(ycrcb_img, cv.COLOR_YCrCb2BGR)
    cv.imshow('equalized image',output)
    cv.waitKey(0)

#histogram_equalization("gait_sample.png")

# cv.imshow('res.png', equ) #new image



# equ=cv.equalizeHist(img)

# res= np.hstack((img,equ)) #horizontally stakcing image

# cv.imshow('res.png', res) #new image
# cv.waitKey(0)
# src = cv.cvtColor(img, cv.COLOR_BGR2GRAY)

# while(True):
#     cv.imshow('source image', img)

