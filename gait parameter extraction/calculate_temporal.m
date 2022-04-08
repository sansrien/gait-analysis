function calculate_temporal()
clearvars -except gait_events;

file = sprintf('%s%s','gait_events.mat');
cd = pwd;
load(fullfile(cd,file),'data_extracted');

timeVector = data_extracted.time;
locsL = data_extracted.locsL;
locsR = data_extracted.locsR;


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


%% Step Time //not correct pa ata?
leftStepTime = [];
for i = 1:length(rightHeelTime(:,1))
    leftStepTime(i) = leftHeelTime(i,2) - rightHeelTime(i,1);
end

leftStepTime = leftStepTime.';
avgStepTimeL = mean(leftStepTime);


rightStepTime = [];
for i = 1:length(leftHeelTime(:,1))
    rightStepTime(i) = rightHeelTime(i,2) - leftHeelTime(i,1);
end

rightStepTime = rightStepTime.';
avgStepTimeR = mean(rightStepTime);

%% Cadence
cadence = (60/avgStepTimeL) + (60/avgStepTimeR);


% Create a table for display purposes
tempParams = [leftStrideTime rightStrideTime leftStepTime rightStepTime];
tableTempParams = array2table(tempParams);
tableTempParams.Properties.VariableNames(1:4) = {'Left Stride Time' 'Right Stride Time', 'Left Step Time', 'Right Step Time'};
avgTempParams = [avgStrideTimeL avgStrideTimeR avgStepTimeL avgStepTimeR cadence];
tableAvgTempParams = array2table(avgTempParams);
tableAvgTempParams.Properties.VariableNames(1:5) = {'Left Stride Time' 'Right Stride Time', 'Left Step Time', 'Right Step Time', 'Cadence'};


%% Storing into variables for return
temporal_parameters.leftStrideTime = leftStrideTime;
temporal_parameters.rightStrideTime = rightStrideTime;
temporal_parameters.leftStepTime = leftStepTime;
temporal_parameters.rightStepTime = rightStepTime;
temporal_parameters.cadence = cadence;

save('gait_events.mat','data_extracted','temporal_parameters', 'locsL', 'locsR')

clearvars -except gait_events