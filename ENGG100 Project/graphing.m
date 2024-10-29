function [x,y] = graphing(velocity, angle, timeofflight)
    t=0:0.001:timeofflight;
    x = velocity*cos(angle)*t;
    y = velocity*sin(angle)*t - 0.5*9.81*t.^2;
end
