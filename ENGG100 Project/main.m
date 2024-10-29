%Getting the inputs from the user
mass=input('Enter mass of the ball (kg): ');
distance_from_building_user=input('Enter distance from the building (m): ');
height_of_building=input('Enter height of the building (m): ');
while 1
   if distance_from_building_user<=0 || height_of_building<=0
       disp('Values for height of the building and the distance from the building must be greater then 0')
       distance_from_building_user=input('Enter distance from the building (m): ');
       height_of_building=input('Enter height of the building (m): ');
   else
       break
   end
end

%Establishing the given information
ring_distance=6;
g=9.81; 
ring_height=3;
range=distance_from_building_user+ring_distance;

%Finding the angle from the user end
min_angle_1=atan(height_of_building/distance_from_building_user);
disp("The minimum angle from user to building is: "+ rad2deg(min_angle_1));

%Finding the angle from the hoop end
min_angle_2=atan((height_of_building-ring_height)/ring_distance);
disp("The minimum angle from building to hoop is: "+rad2deg(min_angle_2));

%Checking which angle is greater and make that as the minimum angle
if min_angle_1>min_angle_2
   min_angle=min_angle_1;
else
   min_angle=min_angle_2;
end

%Calculating values
i=0;
for angle=min_angle:(pi/180):deg2rad(89)
   velocity=sqrt((range^2*g)/(2*((cos(angle))^2)*((range*tan(angle))-ring_height)));
   time_to_building=distance_from_building_user/(velocity*cos(angle));
   height_proj_building=velocity*sin(angle)*time_to_building-0.5*g*time_to_building^2;
   time_of_flight=range/(velocity*cos(angle));
   height_reach_ring = (velocity*sin(angle)*time_of_flight) - (0.5*g*time_of_flight^2);
   max_height_of_projectile = (velocity^2*(sin(angle))^2)/(2*g);
   if (height_proj_building >= height_of_building)
       i=i+1;
       allangles.angle(i+1)=rad2deg(angle);
       allangles.velocity(i+1)=velocity;
       allangles.time(i+1)=time_of_flight;
       allangles.maxheight(i+1)=max_height_of_projectile;
   else
       continue
   end
end

%Plotting the graph
try
   single_angle = allangles.angle(2);
   single_velocity = allangles.velocity(2);
   single_time = allangles.time(2);
   single_height = allangles.maxheight(2);
   disp(['The angle taken is: ',num2str(single_angle)]);
   disp(['The initial velocity is: ',num2str(single_velocity)]);
   disp(['The time taken for the ball to reach the hoop is: ',num2str(single_time)]);
   disp(['In the complete projectile, the maximum height travelled by the ball is: ',num2str(single_height)]);
   [x,y] = graphing(single_velocity,deg2rad(single_angle),single_time);
   plot(x,y,[distance_from_building_user distance_from_building_user],[0 height_of_building],'LineWidth',2);

%Calculations for certain time
   user_spec_time=input('Do you want to enter specific time? (yes/no) ','s');
   while 1
       if strcmp(user_spec_time,'yes')
           specific_time = input("Enter the time between 0 to "+single_time+": ");
           while specific_time<0 || specific_time>single_time
               disp('Wrong Input. Error!');
               specific_time = input("Enter the time between 0 to "+single_time+": ");
           end
           [x_dist_st, y_dist_st, vel_at_time_st] = calc_at_specific_time(single_velocity, deg2rad(single_angle), specific_time);
           disp(['At the specified time, the horizontal distance travelled is: ',num2str(x_dist_st)]);
           disp(['At the specified time, the vertical distance travelled is: ',num2str(y_dist_st)]);
           disp(['At the specified time, the velocity: ',num2str(vel_at_time_st)]);
           specific_time_graph = input("Graph? (yes/no) ","s");
           while 1
               if strcmp(specific_time_graph,'yes')
                   [x,y] = graphing(single_velocity,deg2rad(single_angle),specific_time);
                   plot(x,y,[distance_from_building_user distance_from_building_user],[0 height_of_building],'LineWidth',2);
                   break
               elseif strcmp(specific_time_graph,'no')
                   disp('THE END!!!');
                   break
               else
                   disp('Wrong Input. Error!')
                   specific_time_graph = input("Graph? (yes/no) ","s");
               end
           end
           break
       elseif strcmp(user_spec_time,'no')
           disp('THE END!!!');
           break
       else
           user_spec_time=input('Do you want to enter specific time?','s');
       end
   end
catch
   disp("Sorry, values are to extreme!")
end
