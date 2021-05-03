function position = integrate_IMU(a,del_t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

v = zeros(length(a),1);
p = zeros(length(a),1);

v(1) = a(1) * del_t;
p(1) = 0.5 * a(1) * del_t;

for i = 2:length(a)
    v(i) = v(i-1) + (a(i) * del_t);
    p(i) = p(i-1) + (v(i-1) * del_t) + (0.5 * a(i) * (del_t^2));
    
end



position = p;

end

