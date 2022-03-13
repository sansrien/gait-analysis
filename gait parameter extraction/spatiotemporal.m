clear all;

%% Read input file from pre-processing
dataTable = readtable('switched_keypoints.csv');
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

%% Create function to get gait cycles
% Get the frame rate
sampFreq = (length(timeVector))/(timeVector(length(timeVector)));

% get peaks to get local minima and store in a vector
    % coordinate system: upper left = origin
    % y-coord: higher number, lower height
    % x-coord: higher number, farther distance from origin
[pksL, locsL] = findpeaks(leftH.yLoc);
[pksR, locsR] = findpeaks(rightH.yLoc);

% use findpeaks() with height and distance thresholds
meanL = mean(pksL);
threshL = 0.40*meanL; % > 40% threshold from https://www.frontiersin.org/articles/10.3389/fneur.2017.00457/full#F3
[pksL, locsL] = findpeaks(leftH.yLoc, 'MinPeakHeight', threshL, 'MinPeakDistance', sampFreq);

meanR = mean(pksR);
threshR = 0.40*meanR; % > 40% threshold from https://www.frontiersin.org/articles/10.3389/fneur.2017.00457/full#F3
[pksR, locsR] = findpeaks(rightH.yLoc, 'MinPeakHeight', threshR, 'MinPeakDistance', sampFreq);



% test plots for heel locations
subplot(2,1,1)
plot(leftH.time, leftH.yLoc)
hold on
scatter(leftH.time(locsL), pksL, '*')
hold off
ylabel('Heel Location (y-coord)')
xlabel('Time (seconds)')
legend('Heel Data Point', 'Heel Strikes')
title('Left Leg Heel Location')

subplot(2,1,2)
plot(rightH.time, rightH.yLoc)
hold on
scatter(rightH.time(locsR), pksR, '*')
hold off
ylabel('Heel Location (y-coord)')
xlabel('Time (seconds)')
legend('Heel Data Point', 'Heel Strikes')
title('Right Leg Heel Location')




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


% Create a table for display purposes
tableLHS = array2table(gaitCyclesL);
tableLHS.Properties.VariableNames(1:2) = {'Initial Heel Strike (x,y)' 'Final Heel Strike (x,y)'};
tableRHS = array2table(gaitCyclesR);
tableRHS.Properties.VariableNames(1:2) = {'Initial Heel Strike (x,y)' 'Final Heel Strike (x,y)'};


% create a variable for number of gait cycles
numGaitCycleL = length(gaitCyclesL);
numGaitCycleR = length(gaitCyclesR);


%% Calculation of Temporal Parameters
% Get time associated with all heel strikes

% leftHeelTime = zeros(length(pksL)-1, 2);
% for i = 1:length(gaitCyclesL)
%     for j = 1:2
%         curr = gaitCyclesL{i,j}(2);
%         currTimeIdx = find(leftH.yLoc == curr);
%         if leftH.time(currTimeIdx) > 1
%             leftHeelTime(i,j) = leftH.time(currTimeIdx);
%         end
%     end
% end

% rightHeelTime = zeros(length(pksR)-1, 2);
% for i = 1:length(gaitCyclesR)
%     for j = 1:2
%         curr = gaitCyclesR{i,j}(2);
%         currTimeIdx = find(rightH.yLoc == curr);
%         rightHeelTime(i,j) = rightH.time(currTimeIdx); 
%     end
% end
% 
% 
% % Stride Time
% leftStrideTime = [];
% for i = 1:length(leftHeelTime(:,1))
%     leftStrideTime(i) = leftHeelTime(i,2) - leftHeelTime(i,1);
% end
% 
% leftStrideTime = leftStrideTime.';
% avgStepTimeL = mean(leftStrideTime);
% 
% rightStrideTime = [];
% for i = 1:length(rightHeelTime(:,1))
%     rightStrideTime(i) = rightHeelTime(i,2) - rightHeelTime(i,1);
% end
% 
% rightStrideTime = rightStrideTime.';
% avgStepTimeR = mean(rightStrideTime);

% % Step Time //not correct pa ata?
% % leftStepTime = [];
% % for i = 1:length(rightHeelTime(:,1))
% %     leftStepTime(i) = leftHeelTime(i,2) - rightHeelTime(i,1);
% % end
% % 
% % leftStepTime = leftStepTime.';
% % avgStepTime = mean(leftStepTime);
% 
% % Cadence
% cadence = (60/avgStepTimeL) + (60/avgStepTimeR);






%% try lang kineme
% create Mx2 matrix where M is the number of gait cycles while the columns 
% indicate the two heel strike points for each gait cycle
%gaitCycles2 = zeros(length(pks)-1, 2);
% for i = 1:length(pks)
%     if i ~= length(pks)
%         test.time(i) = leftH.time(locs(i));
%         test.xLoc(i) = leftH.xLoc(locs(i));
%         test.yLoc(i) = leftH.yLoc(locs(i));
%     end
% end
% 
% % create a variable for number of gait cycles
% numGaitCycle2 = length(test);



    



