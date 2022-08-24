function zupt = zero_velocity_detector_by_pattern(u, simdata);

% currently use angular x to detect zero vector

if 0
threshold = -1000 * pi/180;
angular_x = u(4,:);
% zupt = zeros(1, length(angular_x));

zupt = angular_x < threshold;

elseif 0

    left_acce_z = u(3,:);
    threshold = 50;
    zupt = left_acce_z > threshold;

else
    left_acce_z = u(3,:);
    threshold = 50;
    zupt = abs(left_acce_z) > threshold;

end