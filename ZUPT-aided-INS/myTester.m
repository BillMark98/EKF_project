
%% clear all
clear


%% use the tester

%load old data

% Loads the algorithm settings and the IMU data
addpath(genpath(pwd))
disp('Loads the algorithm settings and the IMU data')
method = 2;
simdata = mysettings_newMethod(method);

% Load data. Measurements contained in variable u.   
% load square2
% load groth_200_left_standard_plain
load groth_200_left_standard_unique_dist
load groth_200_yMethod1_unique_dist
load groth_200_dist_unique
tester(groth_200_dist_unique, u,y, simdata, method);


%% left right method

% use the tester

%load old data

% Loads the algorithm settings and the IMU data
addpath(genpath(pwd))
disp('Loads the algorithm settings and the IMU data')
method = 3; % or use method 4
simdata = mysettings_newMethod(method);

% Load data. Measurements contained in variable u.   
% load square2
% load groth_200_left_standard_plain
load groth_200_left_standard_unique_dist
u1 = u;
load groth_200_right_standard_unique_dist
u2 = u;
u = [u1;u2];

load groth_200_yMethod1_unique_dist
load groth_200_dist_unique
tester(groth_200_dist_unique, u,y, simdata, method);

%% another data set

% most ideal case
method = 2;
simdata = mysettings_newMethod(method);

% Load data. Measurements contained in variable u.   
% load square2
% load groth_200_left_standard_plain
load henrik_200_left_standard_unique_dist
load henrik_200_yMethod1_unique_dist
load henrik_200_dist_unique
tester(henrik_200_dist_unique, u,y, simdata, method);


%% left right method

% use the tester

%load old data

% Loads the algorithm settings and the IMU data
addpath(genpath(pwd))
disp('Loads the algorithm settings and the IMU data')
method = 4; % or use method 4
simdata = mysettings_newMethod(method);

% Load data. Measurements contained in variable u.   
% load square2
% load groth_200_left_standard_plain
load henrik_200_left_standard_unique_dist
u1 = u;
load henrik_200_right_standard_unique_dist
u2 = u;
u = [u1;u2];

load henrik_200_yMethod1_unique_dist
load henrik_200_dist_unique
tester(henrik_200_dist_unique, u,y, simdata, method);


