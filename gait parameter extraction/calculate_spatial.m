function calculate_spatial()
clearvars -except gait_events;

file = sprintf('%s%s','gait_events.mat');
cd = pwd;
load(fullfile(cd,file),'data_extracted')

gaitCyclesL = data_extracted.left;
gaitCyclesR = data_extracted.right;

% create a variable for number of gait cycles
 numGaitCycleL = length(gaitCyclesL);
 numGaitCycleR = length(gaitCyclesR);
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

%spatial_parameters = table(leftstridelength,rightstridelength,leftsteplength,rightsteplength);
spatial_parameters.leftstridelength = leftstridelength;
spatial_parameters.rightstridelength = rightstridelength;
spatial_parameters.leftsteplength = leftsteplength;
spatial_parameters.rightsteplength = rightsteplength;

save('gait_events.mat','data_extracted','spatial_parameters')

clearvars -except gait_events
