function events_extraction()
clearvars -except gait_events;
data_extracted = [];
%% Read input file from pre-processing
dataTable = readtable('p1s1_processed_switched.csv');
dataTable.Properties.VariableNames; %to display variable names from file

%% Create time vector
timeVector = dataTable.elapsed_time_s_;

%% Get column of left and right heel points
% Get columns of needed variables
LeftHX = dataTable.l_heel_x;
LeftHY = dataTable.l_heel_y;

RightHX = dataTable.r_heel_x;
RightHY = dataTable.r_heel_y;

% Create vector for left and right heel
dataLeftH = [timeVector LeftHX LeftHY];
dataRightH = [timeVector RightHX RightHY];


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


% Create a table for display purposes
tableLeftH = array2table(dataLeftH);
tableLeftH.Properties.VariableNames(1:3) = {'Elapsed Time' 'Distance (x-coord)' 'Heel Location (y-coord)'};
tableRightH = array2table(dataRightH);
tableRightH.Properties.VariableNames(1:3) = {'Elapsed Time' 'Distance (x-coord)' 'Heel Location (y-coord)'};


%% Properties trial
leftH.time = dataLeftH(:,1);
leftH.yLoc = dataLeftH(:,3);
leftH.xLoc = dataLeftH(:,2);
rightH.time = dataRightH(:,1);
rightH.yLoc = dataRightH(:,3);
rightH.xLoc = dataRightH(:,2);

subplot 221
plot(leftH.time, leftH.yLoc)
title('Left Leg Heel Location')

subplot 223
plot(rightH.time, rightH.yLoc)
title('Right Leg Heel Location')

fs = (length(timeVector))/(timeVector(length(timeVector)));
fc = 20;    %initially 10 from RRL but increased to 20 to detect the end heelstrikes
Wn = fc/fs;
[B, A] = butter(4,Wn,'low');
leftH.yLoc = filtfilt(B,A,leftH.yLoc);
rightH.yLoc = filtfilt(B,A,rightH.yLoc);

%% Create function to get gait cycles
% get peaks to get local minima and store in a vector
    % coordinate system: upper left = origin
    % y-coord: higher number, lower height
    % x-coord: higher number, farther distance from origin
    
[pksL, locsL] = findpeaks(leftH.yLoc);
[pksR, locsR] = findpeaks(rightH.yLoc);

% meanL = mean(pksL);
% threshL = 0.4*meanL;
% [pksL, locsL] = findpeaks(leftH.yLoc, 'MinPeakHeight', threshL, 'MinPeakDistance', fs);
% 
% meanR = mean(pksR);
% threshR = 0.4*meanR;
% %[pksR, locsR] = findpeaks(rightH.yLoc, 'MinPeakHeight', threshR, 'MinPeakDistance', fs);
% [pksR, locsR] = findpeaks(rightH.yLoc(locsL(1):end), 'MinPeakDistance', fs, 'NPeaks', 5);
% locsR = locsR + (locsL(1)-1);
% 
% ofst = locsR(end)+(round(fs)-1);                                                
% [pksR(end+1),locsR(end+1)] = max(rightH.yLoc(ofst:end)); 
% locsR(end) = locsR(end) + ofst;

meanL = mean(pksL);
threshL = 0.4*meanL;
[pksL, locsL] = findpeaks(leftH.yLoc, 'MinPeakHeight', threshL, 'MinPeakDistance', fs);

meanR = mean(pksR);
threshR = 0.4*meanR;
%[pksR, locsR] = findpeaks(rightH.yLoc, 'MinPeakHeight', threshR, 'MinPeakDistance', fs, 'NPeaks', 4);
[pksR, locsR] = findpeaks(rightH.yLoc, 'MinPeakHeight', threshR, 'MinPeakDistance', fs);
 
if leftH.time(locsL(1)) > rightH.time(locsR(1)) && pksR(1) ~= 0
    pksR(1) = [];
    locsR(1) = [];
else    
    pksL(1) = [];
    locsL(1) = [];
end

% test plots for heel locations
% subplot 224
% plot(rightH.time, rightH.yLoc)
% hold on
% scatter(rightH.time(locsR), pksR, 'or')
% hold off
% title('Filtered Right Leg Heel Location')
% 
% subplot 222
% plot(leftH.time, leftH.yLoc)
% hold on
% scatter(leftH.time(locsL), pksL, 'or')
% hold off
% title('Filtered Left Leg Heel Location')

subplot 224
plot(rightH.time, rightH.yLoc, rightH.time(locsR), pksR, 'or')
% xlabel('x-coordinates')
% ylabel('time')
title('Filtered Right Leg Heel Location')

subplot 222
plot(leftH.time, leftH.yLoc, leftH.time(locsL), pksL, 'or')
% xlabel('x-coordinates')
% ylabel('time')
title('Filtered Left Leg Heel Location')


% create Mx2 matrix where M is the number of gait cycles while the columns 
% indicate the two heel strike points for each gait cycle
gaitCyclesL = cell(length(pksL)-1, 2);
for i = 1:length(pksL)
    if i ~= length(pksL)
        gaitCyclesL{i,1} = [leftH.xLoc(locsL(i)) pksL(i)];
        gaitCyclesL{i,2} = [leftH.xLoc(locsL(i+1)) pksL(i+1)];
    end
end

gaitCyclesR = cell(length(pksR)-1, 2);
for i = 1:length(pksR)
    if i ~= length(pksR)
        gaitCyclesR{i,1} = [rightH.xLoc(locsR(i)) pksR(i)];
        gaitCyclesR{i,2} = [rightH.xLoc(locsR(i+1)) pksR(i+1)];
    end
end

numgaitL = length(gaitCyclesL)
numgaitR = length(gaitCyclesR)


data_extracted.time = timeVector;
data_extracted.left = gaitCyclesL;
data_extracted.right = gaitCyclesR;

save('gait_events.mat','data_extracted')

clearvars -except gait_events

% Create a table for display purposes
% tableLHS = array2table(gaitCyclesL);
% tableLHS.Properties.VariableNames(1:2) = {'Initial Heel Strike (x,y)' 'Final Heel Strike (x,y)'};
% tableRHS = array2table(gaitCyclesR);
% tableRHS.Properties.VariableNames(1:2) = {'Initial Heel Strike (x,y)' 'Final Heel Strike (x,y)'};
% 
% 
%gait_events = join(tableLHS,tableRHS);
% create a variable for number of gait cycles
numGaitCycleL = length(gaitCyclesL);
numGaitCycleR = length(gaitCyclesR);




 



