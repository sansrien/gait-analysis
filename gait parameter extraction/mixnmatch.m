%% Read input file from pre-processing
rgb_dataTable = readtable('p1s1_processed_switched.csv');
rgb_dataTable.Properties.VariableNames;

%% Create time vector
rgb_timeVector = rgb_dataTable.elapsed_time_s_;

%% Get column of left and right heel points
% Get columns of needed variables
LeftHX = rgb_dataTable.l_heel_x;
LeftHY = rgb_dataTable.l_heel_y;

RightHX = rgb_dataTable.r_heel_x;
RightHY = rgb_dataTable.r_heel_y;

% Create vector for left and right heel
dataLeftH = [rgb_timeVector LeftHX LeftHY];
dataRightH = [rgb_timeVector RightHX RightHY];


%% Filling gaps or zero values
% Filling 0 values with NaN
for i =1:length(dataLeftH)
    if dataLeftH(i,3) == 0
        dataLeftH(i,3) = NaN;
    end
    
    if dataLeftH(i,2) == 0
        dataLeftH(i,2) = NaN;
    end
end

for i =1:length(dataRightH)
    if dataRightH(i,3) == 0
        dataRightH(i,3) = NaN;
    end
    
    if dataRightH(i,2) == 0
        dataRightH(i,2) = NaN;
    end
end

% Filling NaNs (gaps) via fillgaps() or autoregressive modelling
dataLeftH(:,3) = fillgaps(dataLeftH(:,3));
dataLeftH(:,2) = fillgaps(dataLeftH(:,2));
dataRightH(:,3) = fillgaps(dataRightH(:,3));
dataRightH(:,2) = fillgaps(dataRightH(:,2));


%% Properties trial
rgb_leftH.time = dataLeftH(:,1);
rgb_leftH.yLoc = dataLeftH(:,3);
rgb_leftH.xLoc = dataLeftH(:,2);
rgb_rightH.time = dataRightH(:,1);
rgb_rightH.yLoc = dataRightH(:,3);
rgb_rightH.xLoc = dataRightH(:,2);

rgb_fs = (length(rgb_timeVector))/(rgb_timeVector(length(rgb_timeVector)));
rgb_fc = 20;    %initially 10 from RRL but increased to 20 to detect the end heelstrikes
rgb_Wn = rgb_fc/rgb_fs;
[mB, mA] = butter(4,rgb_Wn,'low');
rgb_leftH.yLoc = filtfilt(mB,mA,rgb_leftH.yLoc);
rgb_rightH.yLoc = filtfilt(mB,mA,rgb_rightH.yLoc);
    
[rgb_pksL, rgb_locsL] = findpeaks(rgb_leftH.yLoc);
[rgb_pksR, rgb_locsR] = findpeaks(rgb_rightH.yLoc);

rgb_meanL = mean(rgb_pksL);
rgb_threshL = 0.4*rgb_meanL;
[rgb_pksL, rgb_locsL] = findpeaks(rgb_leftH.yLoc, 'MinPeakHeight', rgb_threshL, 'MinPeakDistance', rgb_fs);

rgb_meanR = mean(rgb_pksR);
rgb_threshR = 0.4*rgb_meanR;
[rgb_pksR, rgb_locsR] = findpeaks(rgb_rightH.yLoc, 'MinPeakHeight', rgb_threshR, 'MinPeakDistance', rgb_fs);
 
if rgb_leftH.time(rgb_locsL(1)) > rgb_rightH.time(rgb_locsR(1)) && rgb_pksR(1) ~= 0 %left first
    firstyholder = rgb_pksR(1);
    firstxholder = rgb_rightH.xLoc(rgb_locsR(1));
    rgb_pksR(1) = [];
    rgb_locsR(1) = [];
elseif rgb_leftH.time(rgb_locsL(1)) < rgb_rightH.time(rgb_locsR(1)) && rgb_pksL(1) ~= 0    %right first
    firstyholder = rgb_pksL(1);
    firstxholder = rgb_leftH.xLoc(rgb_locsL(1));
    rgb_pksL(1) = [];
    rgb_locsL(1) = [];
else
    ;
end

%% Mocap reading

mocap_data = readtable('p7s1_mocap.csv');
mocap_data.Properties.VariableNames;

mocap_time = mocap_data.elapsed_time;
mocap_fs = (length(mocap_time))/(mocap_time(length(mocap_time)));

mocap_lheex = mocap_data.LHEE_y;
mocap_lheey = mocap_data.LHEE_z;
mocap_rheex = mocap_data.RHEE_y;
mocap_rheey = mocap_data.RHEE_z;

% Create vector for left and right heel
LeftH = [timeVector lheex lheey];
RightH = [timeVector rheex rheey];

lhee.time = LeftH(:,1);
rhee.time = RightH(:,1);

mocap_fc = 5;    %initially 10 from RRL but increased to 20 to detect the end heelstrikes
mocap_Wn = mocap_fc/sampFreq;
[mB, mA] = butter(4,mocap_Wn,'low');
lheey = filtfilt(mB,mA,lheey);
rheey = filtfilt(mB,mA,rheey);

[mocap_pksL mocap_locsL] = findpeaks(-lheey);
[mocap_pksR mocap_locsR] = findpeaks(-rheey);

mocap_meanL = mean(mocap_pksL);
mocap_threshL = 0.40*mocap_meanL; 
[mocap_pksL, mocap_locsL] = findpeaks(-lheey, 'MinPeakDistance', sampFreq);
mocap_meanR = mean(mocap_pksR);
mocap_threshR = 0.40*mocap_meanR;
[mocap_pksR, mocap_locsR] = findpeaks(-rheey, 'MinPeakDistance', sampFreq);

if lhee.time(mocap_locsL(1)) > rhee.time(mocap_locsR(1)) && mocap_pksR(1) ~= 0 %left first
    mc_firstyholder = mocap_pksR(1);
    mc_firstxholder = rheex(mocap_locsR(1));
    mocap_pksR(1) = [];
    mocap_locsR(1) = [];
elseif lhee.time(mocap_locsL(1)) < rhee.time(mocap_locsR(1)) && mocap_pksL(1) ~= 0    %right first
    mc_firstyholder = mocap_pksL(1);
    mc_firstxholder = lheex(mocap_locsL(1));
    mocap_pksL(1) = [];
    mocap_locsL(1) = [];
else
    ;
end

%% plot
subplot 211
plot(rgb_leftH.time, rgb_leftH.yLoc, rgb_leftH.time(rgb_locsL), rgb_pksL, 'or')
hold on
plot(rgb_leftH.time, -lheey, rgb_leftH.time(mocap_locsL), mocap_pksL, 'or')
title('Filtered Left Leg Heel Location')
legend('RGB', '', 'Mocap', '')
hold off

subplot 212
plot(rgb_rightH.time, rgb_rightH.yLoc, rgb_rightH.time(rgb_locsR), rgb_pksR, 'or')
hold on
plot(rgb_rightH.time, -rheey, rgb_rightH.time(mocap_locsR), mocap_pksR, 'or')
title('Filtered Right Leg Heel Location')
legend('RGB', '', 'Mocap', '')
hold off

