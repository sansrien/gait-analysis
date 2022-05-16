data_Mocap = readtable('mocap_p1s1_noheaders.csv');
data_Mocap.Properties.VariableNames;

timeVector = data_Mocap.elapsed_time_s;
sampFreq = (length(timeVector))/(timeVector(length(timeVector)));

lheex = data_Mocap.LHEE_y;
lheey = data_Mocap.LHEE_z;
rheex = data_Mocap.RHEE_y;
rheey = data_Mocap.RHEE_z;

[pksL locsL] = findpeaks(-lheey);
[pksR locsR] = findpeaks(-rheey);

meanL = mean(pksL);
threshL = 0.40*meanL; 
[pksL, locsL] = findpeaks(-lheey, 'MinPeakDistance', sampFreq);

meanR = mean(pksR);
threshR = 0.40*meanR;
[pksR, locsR] = findpeaks(-rheey, 'MinPeakDistance', sampFreq);

% ignore first heel strike
pksL(1) = []; locsL(1) = [];
pksR(1) = []; locsR(1) = [];


subplot 211
plot(timeVector, -lheey)
hold on
scatter(timeVector(locsL), pksL, '*')
hold off
title('Left Leg Heel Location (MoCap)')
xlabel('Time (seconds)')
ylabel('Inverted Heel Location (y-coord)')

subplot 212
plot(timeVector, -rheey)
hold on
scatter(timeVector(locsR), pksR, '*')
hold off
title('Right Leg Heel Location (MoCap)')
xlabel('Time (seconds)')
ylabel('Inverted Heel Location (y-coord)')


% create Mx2 matrix where M is the number of gait cycles while the columns 
% indicate the two heel strike points for each gait cycle
gaitCyclesL = cell(length(pksL)-1, 2);
for i = 1:length(pksL)
    if i ~= length(pksL)
        gaitCyclesL{i,1} = [lheex(locsL(i)) -pksL(i)];
        gaitCyclesL{i,2} = [lheex(locsL(i+1)) -pksL(i+1)];
    end
end

gaitCyclesR = cell(length(pksR)-1, 2);
for i = 1:length(pksR)
    if i ~= length(pksR)
        gaitCyclesR{i,1} = [rheex(locsR(i)) -pksR(i)];
        gaitCyclesR{i,2} = [rheex(locsR(i+1)) -pksR(i+1)];
    end
end

comb = [timeVector lheey lheex];
tableOrig = array2table(comb);
tableOrig.Properties.VariableNames(1:3) = {'Time' 'Left Heel Y' 'Left Heel X'};


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

leftHeelTime = zeros(length(locsL)-1, 2);
for i = 1:length(locsL)
    if i ~= length(locsL)
        leftHeelTime(i,1) = timeVector(locsL(i));
        leftHeelTime(i,2) = timeVector(locsL(i+1));
    end
end

rightHeelTime = zeros(length(locsR)-1, 2);
for i = 1:length(locsR)
    if i ~= length(locsR)
        rightHeelTime(i,1) = timeVector(locsR(i));
        rightHeelTime(i,2) = timeVector(locsR(i+1));
    end
end

%% Stride Time - OK
leftStrideTime = [];
for i = 1:length(leftHeelTime(:,1))
    leftStrideTime(i) = leftHeelTime(i,2) - leftHeelTime(i,1);
end

leftStrideTime = leftStrideTime.';
avgStrideTimeL = mean(leftStrideTime);

rightStrideTime = [];
for i = 1:length(rightHeelTime(:,1))
    rightStrideTime(i) = rightHeelTime(i,2) - rightHeelTime(i,1);
end

rightStrideTime = rightStrideTime.';
avgStrideTimeR = mean(rightStrideTime);


%% Step Time //for right first heel strikes
leftStepTime = [];
for i = 1:length(rightHeelTime(:,1))
    leftStepTime(i) = abs(leftHeelTime(i,2) - rightHeelTime(i,1));
end

leftStepTime = leftStepTime.';
avgStepTimeL = mean(leftStepTime);


rightStepTime = [];
for i = 1:length(leftHeelTime(:,1))
    rightStepTime(i) = abs(rightHeelTime(i,1) - leftHeelTime(i,1));
end

rightStepTime = rightStepTime.';
avgStepTimeR = mean(rightStepTime);

%% Cadence
cadence = (60/avgStrideTimeL) + (60/avgStrideTimeR);


% Create a table for display purposes
tempParams = [leftStrideTime rightStrideTime leftStepTime rightStepTime];
tableTempParams = array2table(tempParams);
tableTempParams.Properties.VariableNames(1:4) = {'Left Stride Time' 'Right Stride Time', 'Left Step Time', 'Right Step Time'};
avgTempParams = [avgStrideTimeL avgStrideTimeR avgStepTimeL avgStepTimeR cadence];
tableAvgTempParams = array2table(avgTempParams);
tableAvgTempParams.Properties.VariableNames(1:5) = {'Left Stride Time' 'Right Stride Time', 'Left Step Time', 'Right Step Time', 'Cadence'};

%% Calculation of Spatial Parameters

leftstridelength = [];
for i = 1:(numGaitCycleL)
    leftstridelength(i) = sqrt(((gaitCyclesL{i,2}(1,1)-gaitCyclesL{i,1}(1,1))^2)+((gaitCyclesL{i,2}(1,2)-gaitCyclesL{i,1}(1,2))^2));
end

rightstridelength = [];
for i = 1:(numGaitCycleR)
    rightstridelength(i) = sqrt(((gaitCyclesR{i,2}(1,1)-gaitCyclesR{i,1}(1,1))^2)+((gaitCyclesR{i,2}(1,2)-gaitCyclesR{i,1}(1,2))^2));
end


leftsteplength = [];
for i = 1:(numGaitCycleL)
    vectora = [gaitCyclesL{i,2}(1,1)-gaitCyclesR{1,1}(1,1) gaitCyclesL{i,2}(1,2)-gaitCyclesR{i,1}(1,2)];
    vectorb = [gaitCyclesL{i,2}(1,1)-gaitCyclesL{1,1}(1,1) gaitCyclesL{i,2}(1,2)-gaitCyclesL{i,1}(1,2)];
    projection = dot(vectora,vectorb);
    temp = sqrt(((gaitCyclesL{i,2}(1,1)-gaitCyclesL{i,1}(1,1))^2)+((gaitCyclesL{i,2}(1,2)-gaitCyclesL{i,1}(1,2))^2));
    leftsteplength(i) = projection/temp;
end

rightsteplength = [];
for i = 1:(numGaitCycleL)
    vectora = [gaitCyclesR{i,2}(1,1)-gaitCyclesL{1,1}(1,1) gaitCyclesR{i,2}(1,2)-gaitCyclesL{i,1}(1,2)];
    vectorb = [gaitCyclesR{i,2}(1,1)-gaitCyclesR{1,1}(1,1) gaitCyclesR{i,2}(1,2)-gaitCyclesR{i,1}(1,2)];
    projection = dot(vectora,vectorb);
    temp = sqrt(((gaitCyclesR{i,2}(1,1)-gaitCyclesR{i,1}(1,1))^2)+((gaitCyclesR{i,2}(1,2)-gaitCyclesR{i,1}(1,2))^2));
    rightsteplength(i) = projection/temp;
end

avgStrideLengthL = mean(leftstridelength);
avgStrideLengthR = mean(rightstridelength);
avgStepLengthL = mean(leftsteplength);
avgStepLengthR = mean(rightsteplength);

%% Gait Speed
avgStepLengthL = mean(leftsteplength);
avgStepLengthR = mean(rightsteplength);

leftGaitSpeed = avgStepLengthL/avgStepTimeL;
rightGaitSpeed = avgStepLengthR/avgStepTimeR;

% Create a table for display purposes
tempParams2 = [leftstridelength rightstridelength leftsteplength rightsteplength];
tableTempParams2 = array2table(tempParams2);
tableTempParams2.Properties.VariableNames(1:4) = {'Left Stride Length' 'Right Stride Length', 'Left Step Length', 'Right Step Length'};
avgTempParams2 = [avgStrideLengthL avgStrideLengthR avgStepLengthL avgStepLengthR leftGaitSpeed rightGaitSpeed];
tableAvgTempParams2 = array2table(avgTempParams2);
tableAvgTempParams2.Properties.VariableNames(1:6) = {'Left Stride Length' 'Right Stride Length', 'Left Step Length', 'Right Step Length', 'Left Gait Speed', 'Right Gait Speed'};

tableAvgTempParams
tableAvgTempParams2