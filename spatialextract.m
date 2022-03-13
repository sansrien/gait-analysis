%% Read input file from pre-processing
dataTable = readtable('keypoints1.csv');
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

% Create a table for display purposes
tableLeftH = array2table(dataLeftH);
tableLeftH.Properties.VariableNames(1:3) = {'Elapsed Time' 'Distance (x-coord)' 'Heel Location (y-coord)'};
tableRightH = array2table(dataRightH);
tableRightH.Properties.VariableNames(1:3) = {'Elapsed Time' 'Distance (x-coord)' 'Heel Location (y-coord)'};

% Properties trial
leftH.time = dataLeftH(:,1);
leftH.xLoc = dataLeftH(:,2);
leftH.yLoc = dataLeftH(:,3);
rightH.time = dataRightH(:,1);
rightH.xLoc = dataRightH(:,2);
rightH.yLoc = dataRightH(:,3);

%%
allHS = []; %combined left and right heel strikes
[pksLy, locsLy] = findpeaks(leftH.yLoc);
for i = 1:length(pksLy)
    pksLx = leftH.xLoc(locsLy);
end

[pksRy, locsRy] = findpeaks(rightH.yLoc);
for i = 1:length(pksRy)
    pksRx = rightH.xLoc(locsRy);
end

allHS.xlhs = pksLx;allHS.ylhs = pksLy;
allHS.xrhs = pksRx;allHS.yrhs = pksRy;

xleftgaitcycle = [];
yleftgaitcycle = [];
for i = 1:length(allHS.xlhs)
    if i ~= length(allHS.xlhs)
         xleftgaitcycle(i,1) = allHS.xlhs(i);
         yleftgaitcycle(i,1) = allHS.ylhs(i);
         xleftgaitcycle(i,2) = allHS.xlhs(i+1);
         yleftgaitcycle(i,2) = allHS.ylhs(i+1);
    end
end

xrightgaitcycle = [];
yrightgaitcycle = [];
for i = 1:length(allHS.xrhs)
    if i ~= length(allHS.xrhs)
         xrightgaitcycle(i,1) = allHS.xrhs(i);
         yrightgaitcycle(i,1) = allHS.yrhs(i);
         xrightgaitcycle(i,2) = allHS.xrhs(i+1);
         yrightgaitcycle(i,2) = allHS.yrhs(i+1);
    end
end

%% trial computation for spatial parameter

leftstridelength = [];
for i = 1:(length(allHS.ylhs)-1)
    leftstridelength(i) = sqrt(((xleftgaitcycle(i,2)-xleftgaitcycle(i,1))^2)+(yleftgaitcycle(i,2)-yleftgaitcycle(i,1))^2);
end

rightstridelength = [];
for i = 1:(length(allHS.yrhs)-1)
    rightstridelength(i) = sqrt(((xrightgaitcycle(i,2)-xrightgaitcycle(i,1))^2)+(yrightgaitcycle(i,2)-yrightgaitcycle(i,1))^2);
end

leftstridelength
rightstridelength
 
