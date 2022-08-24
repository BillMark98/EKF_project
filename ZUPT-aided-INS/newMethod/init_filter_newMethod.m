function [P, Q, R, R_zeroVec, H, H_zeroVec] = init_filter_newMethod(simdata,method)

%> @param[out]   P     Initial state covariance matrix.
%> @param[out]   Q     Process noise covariance matrix.
%> @param[out]   R     Measurement noise covariance matrix.
%> @param[out]   H     Measurement observation matrix.
%> @param[out]   H_zeroVec  The observation matrix for the zero vector
%>

    %  Initial state covariance matrix
    P=zeros(9);
    
    % Process noise covariance matrix
    Q=zeros(6);
    
    if method == 1
        % Observation matrix
        H=zeros(2,9);
        H(1,2) = 1;
        H(2,4) = 1;

        % Observation matrix for zero vector
        H_zeroVec=zeros(3,9);
        % General values for the observation matrix H
        H_zeroVec(1:3,4:6)=eye(3);

        R=diag([simdata.sigma_dist_y,simdata.sigma_vel_y].^2);
        R_zeroVec=diag(simdata.sigma_vel.^2);

    end

    if method == 2
        % Observation matrix
        H=zeros(6,9);
        % H(1:3,1:3) = eye(3);
        % H(1:3,1:3) = eye(3);
        H(1:6,1:6) = eye(6);
        % Observation matrix for zero vector
        H_zeroVec=zeros(4,9);
        % General values for the observation matrix H
        H_zeroVec(1:4,3:6)=eye(4);

        R=diag([simdata.sigma_dist_x, simdata.sigma_dist_y, simdata.sigma_dist_z, simdata.sigma_vel_x,simdata.sigma_vel_y, simdata.sigma_vel_z].^2);
        R_zeroVec=diag([simdata.sigma_dist_z, simdata.sigma_vel.^2]);

    end

    if method == 3 || 4
        H=zeros(2,9);
        H(1,2) = 1;
        H(2,4) = 1;

        % Observation matrix for zero vector
        H_zeroVec=zeros(3,9);
        % General values for the observation matrix H
        H_zeroVec(1:3,4:6)=eye(3);

        R=diag([simdata.sigma_dist_y,simdata.sigma_vel_y].^2);
        R_zeroVec=diag(simdata.sigma_vel.^2);
    end

    % % Check which errors that are included in the state space model and
    % % allocate P,Q, and H matrices with the right size.
    
    % if (strcmp(simdata.scalefactors,'on') && strcmp(simdata.biases,'on')) % Both scale and bias errors included
        
        
        
    %     %  Initial state covariance matrix
    %     P=zeros(9+6+6);
    %     P(10:12,10:12)=diag(simdata.sigma_initial_acc_bias.^2);
    %     P(13:15,13:15)=diag(simdata.sigma_initial_gyro_bias.^2);
    %     P(16:18,16:18)=diag(simdata.sigma_initial_acc_scale.^2);
    %     P(19:21,19:21)=diag(simdata.sigma_initial_gyro_scale.^2);
        
        
        
    %     Q=zeros(12);
    %     Q(7:9,7:9)=diag(simdata.acc_bias_driving_noise.^2);
    %     Q(10:12,10:12)=diag(simdata.gyro_bias_driving_noise.^2);
        
        
    %     H=zeros(3,9+6+6);
        
    % elseif strcmp(simdata.scalefactors,'on') && strcmp(simdata.biases,'off') % Scale errors included
        
        
        
    %     %  Initial state covariance matrix
    %     P=zeros(9+6);
    %     P(10:12,10:12)=diag(simdata.sigma_initial_acc_scale.^2);
    %     P(13:15,13:15)=diag(simdata.sigma_initial_gyro_scale.^2);
        
    %     % Process noise covariance matrix
    %     Q=zeros(6);
        
    %     % Observation matrix
    %     H=zeros(3,9+6);
        
    % elseif strcmp(simdata.scalefactors,'off') && strcmp(simdata.biases,'on') % Bias errors included
        
        
        
    %     %  Initial state covariance matrix
    %     P=zeros(9+6);
    %     P(10:12,10:12)=diag(simdata.sigma_initial_acc_bias.^2);
    %     P(13:15,13:15)=diag(simdata.sigma_initial_gyro_bias.^2);
        
    %     % Process noise covariance matrix
    %     Q=zeros(12);
    %     Q(7:9,7:9)=diag(simdata.acc_bias_driving_noise.^2);
    %     Q(10:12,10:12)=diag(simdata.gyro_bias_driving_noise.^2);
        
    %     % Observation matrix
    %     H=zeros(3,9+6);
        
    % else % Only the standard errors included
        
    %     %  Initial state covariance matrix
    %     P=zeros(9);
        
    %     % Process noise covariance matrix
    %     Q=zeros(6);
        
    %     % Observation matrix
    %     H=zeros(3,9);
    % end
    
    

    % H matrix for different method


    
    % General values for the initial covariance matrix P
    P(1:3,1:3)=diag(simdata.sigma_initial_pos.^2);
    P(4:6,4:6)=diag(simdata.sigma_initial_vel.^2);
    P(7:9,7:9)=diag(simdata.sigma_initial_att.^2);
    
    % General values for the process noise covariance matrix Q
    Q(1:3,1:3)=diag(simdata.sigma_acc.^2);
    Q(4:6,4:6)=diag(simdata.sigma_gyro.^2);

    end
    