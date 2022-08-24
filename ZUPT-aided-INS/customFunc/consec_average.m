function v_average = consec_average(v)
% given a vector v calculate the consecutive average
% i.e.  v_average(1) = (v(1) + v(2))/2
v_average = zeros(1,length(v)-1);
for index = 1 : length(v)-1
    v_average(index) = (v(index) + v(index+1))/2;
end
