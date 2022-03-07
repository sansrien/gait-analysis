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

% Create a table for display purposes
tableLeftH = array2table(dataLeftH);
tableLeftH.Properties.VariableNames(1:3) = {'Elapsed Time' 'Distance (x-coord)' 'Heel Location (y-coord)'};
tableRightH = array2table(dataRightH);
tableRightH.Properties.VariableNames(1:3) = {'Elapsed Time' 'Distance (x-coord)' 'Heel Location (y-coord)'};

% Properties trial
leftH.time = dataLeftH(:,1);
leftH.yLoc = dataLeftH(:,2);
leftH.xLoc = dataLeftH(:,3);
rightH.time = dataRightH(:,1);
rightH.yLoc = dataRightH(:,2);
rightH.xLoc = dataRightH(:,3);

%% Create function to get gait cycles
% get peaks to get local minima and store in a vector
    % coordinate system: upper left = origin
    % y-coord: higher number, lower height
    % x-coord: higher number, farther distance from origin
[pksL, locsL] = findpeaks(dataLeftH(:,3));
[pksR, locsR] = findpeaks(dataRightH(:,3));


% create Mx2 matrix where M is the number of gait cycles while the columns 
% indicate the two heel strike points for each gait cycle
gaitCyclesL = zeros(length(pksL)-1, 2);
for i = 1:length(pksL)
    if i ~= length(pksL)
        gaitCyclesL(i,1) = pksL(i);
        gaitCyclesL(i,2) = pksL(i+1);
    end
end

for i = 1:length(pksR)
    if i ~= length(pksR)
        gaitCyclesR(i,1) = pksR(i);
        gaitCyclesR(i,2) = pksR(i+1);
    end
end


% Create a table for display purposes
tableLHS = array2table(gaitCyclesL);
tableLHS.Properties.VariableNames(1:2) = {'Initial Heel Strike (y-coord)' 'Final Heel Strike (y-coord)'};
tableRHS = array2table(gaitCyclesR);
tableRHS.Properties.VariableNames(1:2) = {'Initial Heel Strike (y-coord)' 'Final Heel Strike (y-coord)'};


% create a variable for number of gait cycles
numGaitCycleL = length(gaitCyclesL);
numGaitCycleR = length(gaitCyclesR);

%% Calculation of Temporal Parameters
% Get time associated with all heel strikes
leftHeelTime = zeros(length(pksL)-1, 2);
for i = 1:length(gaitCyclesL)
    for j = 1:2
        curr = gaitCyclesL(i,j);
        currTimeIdx = find(dataLeftH(:,3) == curr);
        leftHeelTime(i,j) = dataLeftH(currTimeIdx, 1); 
    end
end

rightHeelTime = zeros(length(pksR)-1, 2);
for i = 1:length(gaitCyclesR)
    for j = 1:2
        curr = gaitCyclesR(i,j);
        currTimeIdx = find(dataRightH(:,3) == curr);
        rightHeelTime(i,j) = dataRightH(currTimeIdx, 1); 
    end
end

% Stride Time
leftStrideTime = [];
for i = 1:length(leftHeelTime(:,1))
    leftStrideTime(i) = leftHeelTime(i,2) - leftHeelTime(i,1);
end

leftStrideTime = leftStrideTime.';
avgStepTimeL = mean(leftStrideTime);

rightStrideTime = [];
for i = 1:length(rightHeelTime(:,1))
    rightStrideTime(i) = rightHeelTime(i,2) - rightHeelTime(i,1);
end

rightStrideTime = rightStrideTime.';
avgStepTimeR = mean(rightStrideTime);

% Step Time //not correct pa ata?
% leftStepTime = [];
% for i = 1:length(rightHeelTime(:,1))
%     leftStepTime(i) = leftHeelTime(i,2) - rightHeelTime(i,1);
% end
% 
% leftStepTime = leftStepTime.';
% avgStepTime = mean(leftStepTime);

% Cadence
cadence = (60/avgStepTimeL) + (60/avgStepTimeR);






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



    



