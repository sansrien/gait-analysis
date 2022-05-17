function gaitanalysis
dataTable = readtable('p1s1_processed_switched.csv');

events_extraction(dataTable);

calculate_spatial();

calculate_temporal();
