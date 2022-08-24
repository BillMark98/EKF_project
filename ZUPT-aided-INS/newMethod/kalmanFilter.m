function [x_h, quat,P,Fout,Gout,cov_h] = kalmanFilter(xin, uin, quat,simdata, k, method, Id, P,Q, R, R_zeroVec,H, H_zeroVec, H_pos,y, zupt,posupt, noZeroVecUpdate);

        u_h=comp_imu_errors(uin,xin,simdata); % Subfunction located further down in the file.
    
        
        % Update the navigation equations.   
        [x_h, quat]=Navigation_equation_newMethod(xin,u_h,quat,simdata,k-1,method); % Subfunction located further down in the file.
    
        % calculate the kalman filter
        K=(P*H')/(H*P*H'+R);
        
        % update the x estimate
        x_h = x_h + K * (y - H * x_h);

        % Update state transition matrix
        [Fout, Gout]=state_matrix_newMethod(quat,u_h,simdata,k-1,method); % Subfunction located further down in the file.
    
        
        % Update the filter state covariance matrix P.
        P=Fout*P*Fout'+Gout*Q*Gout';
        
        % Make sure the filter state covariance matrix is symmetric. 
        P=(P+P')/2;
        
        % Store the diagonal of the state covariance matrix P.
        cov_h=diag(P);
       
         
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %      Zero-velocity update      %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Check if a zero velocity update should be done. If so, do the
        % following
        if ~(noZeroVecUpdate) && (zupt==true)
            
            % Calculate the Kalman filter gain
            K_zeroVec=(P*H_zeroVec')/(H_zeroVec*P*H_zeroVec'+R_zeroVec);
            
            % Calculate the prediction error. Since the detector hypothesis 
            % is that the platform has zero velocity, the prediction error is 
            % equal to zero minus the estimated velocity.    
            if method == 1 || method == 3 || method == 4
                z=-x_h(4:6,1);   
            elseif method == 2
                z = -x_h(3:6,1); % zero z coordinate
            end
            
            % Estimation of the perturbations in the estimated navigation
            % states
            dx=K_zeroVec*z;
            
            
            % Correct the navigation state using the estimated perturbations. 
            % (Subfunction located further down in the file.)
            [x_h, quat]=comp_internal_states(x_h,dx,quat);     % Subfunction located further down in the file.
        
            
            % Update the filter state covariance matrix P.
            P=(Id-K_zeroVec*H_zeroVec)*P;
            
            % Make sure the filter state covariance matrix is symmetric. 
            P=(P+P')/2;
        
            % Store the diagonal of the state covariance matrix P.
            cov_h=diag(P);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %      Position update      %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Check if a zero velocity update should be done. If so, do the
        % following
        if (isstring(posupt) && posupt ~= "NO") && all(~isnan(posupt))
            
            % Calculate the Kalman filter gain
            K=(P*H_pos')/(H_pos*P*H_pos' + R_pos);
            
            % Calculate the prediction error. 
            z = posupt - x_h(1:3,1);   
            
            % Estimation of the perturbations in the estimated navigation
            % states
            dx=K*z;
            
            
            % Correct the navigation state using the estimated perturbations. 
            % (Subfunction located further down in the file.)
            [x_h, quat]=comp_internal_states(x_h,dx,quat);     % Subfunction located further down in the file.
        
            
            % Update the filter state covariance matrix P.
            P=(Id-K*H_pos)*P;
            
            % Make sure the filter state covariance matrix is symmetric. 
            P=(P+P')/2;
        
            % Store the diagonal of the state covariance matrix P.
            cov_h=diag(P);
        end