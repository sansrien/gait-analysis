function vid_out = low_level(raw_video)
    videoFileReader = VideoReader("data\raw_vids\"+raw_video + ".avi");
    vid_out = VideoWriter(raw_video+'_processed2.avi');
    open(vid_out);
    sigma = 0.2;
    alpha = 0.7;
    while hasFrame(videoFileReader)
        videoFrame = readFrame(videoFileReader);
        videoFrame = locallapfilt(videoFrame, sigma, alpha);
        videoFrame_done = imlocalbrighten(videoFrame,'AlphaBlend',true);
        %writeVideo(vid_out, videoFrame);
        writeVideo(vid_out, videoFrame_done);
%         writeVideo(vid_out, B);
    end
    close(vid_out);
end
   