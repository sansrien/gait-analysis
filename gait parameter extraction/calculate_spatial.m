function calculate_spatial()
clearvars -except gait_events;

file = sprintf('%s%s','gait_events.mat');
cd = pwd;
load(fullfile(cd,file),'data_extracted')

gaitCyclesL = data_extracted.left;
gaitCyclesR = data_extracted.right;

firstyholder = data_extracted.extrapks;
firstxholder = data_extracted.extralocs;

scale = 6.959;


% create a variable for number of gait cycles
 numGaitCycleL = length(gaitCyclesL);
 numGaitCycleR = length(gaitCyclesR);

%% Calculation of Spatial Parameters

%% stride length
leftstridelength = [];
for i = 1:(numGaitCycleL)
    vector_m = scale*(gaitCyclesL{i,2}(1,1)-gaitCyclesL{i,1}(1,1));
    vector_n = scale*(gaitCyclesL{i,2}(1,2)-gaitCyclesL{i,1}(1,2));
    vector_temp = [vector_m vector_n];
    leftstridelength(i) = norm(vector_temp);
end

leftstride_ave = mean(leftstridelength);

rightstridelength = [];
for i = 1:(numGaitCycleR)
    vector_x = scale*(gaitCyclesR{i,2}(1,1)-gaitCyclesR{i,1}(1,1));
    vector_y = scale*(gaitCyclesR{i,2}(1,2)-gaitCyclesR{i,1}(1,2));
    vector_temp = [vector_x vector_y];
    rightstridelength(i) = norm(vector_temp);
end

rightstride_ave = mean(rightstridelength);

%% step length
leftsteplength = []; rightsteplength = [];
if gaitCyclesL{1,1}(1,1) >= gaitCyclesR{1,1}(1,1) %left step first
    for i = 1:(numGaitCycleL)
        vectora = [scale*(gaitCyclesL{i,2}(1,1)-gaitCyclesR{i,1}(1,1)) scale*(gaitCyclesL{i,2}(1,2)-gaitCyclesR{i,1}(1,2))];
        vectorb = [scale*(gaitCyclesL{i,2}(1,1)-gaitCyclesL{i,1}(1,1)) scale*(gaitCyclesL{i,2}(1,2)-gaitCyclesL{i,1}(1,2))];
        projection = dot(vectora,vectorb);
        temp = norm(vectorb);
        leftsteplength(i) = projection/temp;
    end
    
    for i = 1:(numGaitCycleR)
        if i == 1
            vectora = [scale*(gaitCyclesR{i,1}(1,1)-gaitCyclesL{i,1}(1,1)) scale*(gaitCyclesR{i,1}(1,2)-gaitCyclesL{i,1}(1,2))];
            vectorb = [scale*(gaitCyclesR{i,1}(1,1)-firstxholder) scale*(gaitCyclesR{i,2}(1,2)-firstyholder)];
        else
            vectora = [scale*(gaitCyclesR{i,1}(1,1)-gaitCyclesL{i,1}(1,1)) scale*(gaitCyclesR{i,1}(1,2)-gaitCyclesL{i,1}(1,2))];
            vectorb = [scale*(gaitCyclesR{i,1}(1,1)-gaitCyclesR{i-1,1}(1,1)) scale*(gaitCyclesR{i,1}(1,2)-gaitCyclesR{i-1,1}(1,2))];
%             vectora = [scale*(gaitCyclesR{i,2}(1,1)-gaitCyclesL{i,2}(1,1)) scale*(gaitCyclesR{i,2}(1,2)-gaitCyclesL{i,2}(1,2))];
%             vectorb = [scale*(gaitCyclesR{i,2}(1,1)-gaitCyclesR{i,1}(1,1)) scale*(gaitCyclesR{i,2}(1,2)-gaitCyclesR{i,1}(1,2))];
        end
        projection = dot(vectora,vectorb);
        temp = norm(vectorb);
        rightsteplength(i) = projection/temp
    end

else
    for i = 1:(numGaitCycleL)   %right step first
        if i == 1
            vectora = [scale*(gaitCyclesL{i,1}(1,1)-gaitCyclesR{i,1}(1,1)) scale*(gaitCyclesL{i,1}(1,2)-gaitCyclesR{i,1}(1,2))];
            vectorb = [scale*(gaitCyclesL{i,1}(1,1)-firstxholder) scale*(gaitCyclesL{i,2}(1,2)-firstyholder)];
        else
            vectora = [scale*(gaitCyclesL{i,1}(1,1)-gaitCyclesR{i,1}(1,1)) scale*(gaitCyclesL{i,1}(1,2)-gaitCyclesR{i,1}(1,2))];
            vectorb = [scale*(gaitCyclesL{i,1}(1,1)-gaitCyclesL{i-1,1}(1,1)) scale*(gaitCyclesL{i,1}(1,2)-gaitCyclesL{i-1,1}(1,2))];
%             vectora = [scale*(gaitCyclesL{i,2}(1,1)-gaitCyclesR{i,2}(1,1)) scale*(gaitCyclesL{i,2}(1,2)-gaitCyclesR{i,2}(1,2))];
%             vectorb = [scale*(gaitCyclesL{i,2}(1,1)-gaitCyclesL{i,1}(1,1)) scale*(gaitCyclesL{i,2}(1,2)-gaitCyclesL{i,1}(1,2))];
        end
        projection = dot(vectora,vectorb);
        temp = norm(vectorb);
        leftsteplength(i) = projection/temp;
    end

    for i = 1:(numGaitCycleR)
        vectora = [scale*(gaitCyclesR{i,2}(1,1)-gaitCyclesL{i,1}(1,1)) scale*(gaitCyclesR{i,2}(1,2)-gaitCyclesL{i,1}(1,2))];
        vectorb = [scale*(gaitCyclesR{i,2}(1,1)-gaitCyclesR{i,1}(1,1)) scale*(gaitCyclesR{i,2}(1,2)-gaitCyclesR{i,1}(1,2))];
        projection = dot(vectora,vectorb);
        temp = norm(vectorb);
        rightsteplength(i) = projection/temp;
    end
end  

leftstep_ave = mean(leftsteplength);
rightstep_ave = mean(rightsteplength);

spatial_average = table(leftstride_ave,rightstride_ave,leftstep_ave,rightstep_ave)
spatial_parameters.leftstridelength = leftstridelength;
spatial_parameters.rightstridelength = rightstridelength;
spatial_parameters.leftstrideaverage = leftstride_ave;
spatial_parameters.rightstrideaverage = rightstride_ave;
spatial_parameters.leftsteplength = leftsteplength;
spatial_parameters.rightsteplength = rightsteplength;
spatial_parameters.leftstepaverage = leftstep_ave;
spatial_parameters.rightstepaverage = rightstep_ave;

save('gait_events.mat','data_extracted','spatial_parameters')

clearvars -except gait_events
end

