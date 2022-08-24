function posupt = pos_update_detection(u, laser_dist,zupt)
% given the data u (acceleration, angular veloc), calculate where we
% should update position using zero-vel
% method, determin the angular x 

% currently use angular x to detect zero vector

% threshold = -1000 * pi/180;
% angular_x = u(4,:);
% % zupt = zeros(1, length(angular_x));

% zupt = angular_x < threshold;


% threshold = -1000;
% posupt = nan(3, length(laser_dist));

% at all position where zupt detects zero vector, set pos(3) to 0
posupt = nan(3, length(laser_dist));
for k = 1 : length(zupt)
    if zupt(k) == 1
        posupt(3,zupt) = 0;
        posupt(1,zupt) = 0;
        posupt(2,zupt) = laser_dist(zupt);
    end
end