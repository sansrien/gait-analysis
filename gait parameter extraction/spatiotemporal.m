%% Read input file from pre-processing
dataTable = readtable('keypointssample_json.csv');
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


%% Create function to get gait cycles
% get peaks to get local minima and store in a vector
    % coordinate system: upper left = origin
    % y-coord: higher number, lower height
    % x-coord: higher number, farther distance from origin
[pks, locs] = findpeaks(dataLeftH(:,3));


% create Mx2 matrix where M is the number of gait cycles while the columns 
% indicate the two heel strike points for each gait cycle
gaitCycles = zeros(length(pks)-1, 2);
for i = 1:length(pks)
    if i ~= length(pks)
        gaitCycles(i,1) = pks(i);
        gaitCycles(i,2) = pks(i+1);
    end
end

% create a variable for number of gait cycles
numGaitCycle = length(gaitCycles);



    



