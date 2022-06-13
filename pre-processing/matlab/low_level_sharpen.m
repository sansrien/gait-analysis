function vid_out = low_level_sharpen(raw_video)
    videoFileReader = VideoReader("data\raw_vids\"+raw_video + ".avi");
    vid_out = VideoWriter("data\raw_vids\processed\"+raw_video+'_processed_sharpen.avi');
    open(vid_out);
    while hasFrame(videoFileReader)
        videoFrame = readFrame(videoFileReader);
        RGB = imsharpen(videoFrame);
        frame_out =RGB;
        %
%         frame_out = imlocalbrighten(frame_out,'AlphaBlend',true);
        %
        %writeVideo(vid_out, videoFrame);
        writeVideo(vid_out, frame_out);
        %writeVideo(vid_out, B);
    end
    close(vid_out);
end
   
