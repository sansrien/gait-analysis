vid = VideoReader('vid_out_colab.avi') %change to name of video, should be in same folder

all_keypoints= readtable('switched_colab_fixed.csv'); % change to name of csv file

% specify keypoint of interest
keypoint=[all_keypoints.l_ankle_x all_keypoints.l_ankle_y];

%We will de-normalize openpose measurements to match image coordinated
keypoint=[keypoint(:,1)*vid.Width keypoint(:,2)*vid.Height];

%circle stuff
r = 5; % r is the radius of the plotting circle
j=0:.01:2*pi; %to make the plotting circle

% loop through all frames
for n =1:vid.numFrames 
    videoFrame = read(vid,n);
    img = videoFrame(:,:,1);

    % plot on image
    imagesc(img);
    axis off
    colormap(gray);
    hold on;
    plot(r*sin(j)+keypoint(n,1),r*cos(j)+keypoint(n,2),'.g');
    plot(keypoint(1:n,1),keypoint(1:n,2),'g-'); % traces path
    hold off
    pause(0.1)
end    