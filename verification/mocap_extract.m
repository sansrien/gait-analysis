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
