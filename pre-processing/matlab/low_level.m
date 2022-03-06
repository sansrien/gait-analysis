function vid_out = low_level(raw_video)
    videoFileReader = VideoReader(raw_video);
    vid_out = VideoWriter('vid_out.avi');
    open(vid_out);
    while hasFrame(videoFileReader)
        videoFrame = readFrame(videoFileReader);
        videoFrame_done = imlocalbrighten(videoFrame,'AlphaBlend',true);
        writeVideo(vid_out, videoFrame_done);
        
    end
    close(vid_out);
end
   