function vid_out = low_level2_histeq(raw_video)
    videoFileReader = VideoReader("data\raw_vids\"+raw_video + ".avi");
    vid_out = VideoWriter("data\raw_vids\processed\"+raw_video+'_processed_histeq.avi');
    open(vid_out);
    while hasFrame(videoFileReader)
        videoFrame = readFrame(videoFileReader);
        shadow_lab = rgb2lab(videoFrame);
        max_luminosity = 100;
        L = shadow_lab(:,:,1)/max_luminosity;
        
        shadow_histeq = shadow_lab;
        shadow_histeq(:,:,1) = histeq(L)*max_luminosity;
        shadow_histeq = lab2rgb(shadow_histeq,'OutputType','uint8');
        
        frame_out = shadow_histeq;
        
        %
%         frame_out = imlocalbrighten(frame_out,'AlphaBlend',true);
        %
        
        writeVideo(vid_out, frame_out);

    end
    close(vid_out);
end
   