function time_sampling = calculate_samplingrate(laser_dist, laser_vel);
% given the laser distance, laser velocity
% calculate the sampling rate
laser_vel_avg = consec_average(laser_vel);
time_sampling = diff(laser_dist) ./ laser_vel_avg;
