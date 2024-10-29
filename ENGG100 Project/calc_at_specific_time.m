function [x_dist, y_dist, vel_at_time] = calc_at_specific_time(velocity, angle, specific_time)
    x_dist = velocity*cos(angle)*specific_time;
    y_velocity_t = velocity*sin(angle)-9.81*specific_time;
    y_dist=velocity*sin(angle)*specific_time-0.5*9.81*specific_time^2;
    vel_at_time=sqrt(y_velocity_t^2+(velocity*cos(angle))^2);
end
