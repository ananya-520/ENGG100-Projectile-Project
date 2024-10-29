classdef GUI_PROJECT < matlab.apps.AppBase
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        TrajectoryofProjectileLabel  matlab.ui.control.Label
        ProjectileatParticularTimeLabel  matlab.ui.control.Label
        MovetheslidertoseethepositionandveloctiyoftheprojectilsLabel  matlab.ui.control.Label
        UITable2                     matlab.ui.control.Table
        Slider                       matlab.ui.control.Slider
        SliderLabel                  matlab.ui.control.Label
        UITable                      matlab.ui.control.Table
        SelectAnglesListBox          matlab.ui.control.ListBox
        SelectAnglesListBoxLabel     matlab.ui.control.Label
        EnterheightofthebuildingmEditField  matlab.ui.control.NumericEditField
        EnterheightofthebuildingmEditFieldLabel  matlab.ui.control.Label
        EnterdistancefrombuildingtotheusermEditField  matlab.ui.control.NumericEditField
        EnterdistancefrombuildingtotheusermEditFieldLabel  matlab.ui.control.Label
        CalculateButton              matlab.ui.control.Button
        Heightofbasketis3mLabel      matlab.ui.control.Label
        Distancefrombaskettothebuildingis6mLabel  matlab.ui.control.Label
        UIAxes2_2                    matlab.ui.control.UIAxes
        UIAxes2                      matlab.ui.control.UIAxes
    end
    % Callbacks that handle component events
    methods (Access = private)
        % Button pushed function: CalculateButton
        function CalculateButtonPushed(app, event)
            distance_from_building_user= app.EnterdistancefrombuildingtotheusermEditField.Value;
            height_of_building=app.EnterheightofthebuildingmEditField.Value;
            ring_distance=6;
            g=9.81;
            ring_height=3;
            range=distance_from_building_user+ring_distance;
            min_angle_1=atan(height_of_building/distance_from_building_user);
           
            min_angle_2=atan((height_of_building-ring_height)/ring_distance);
            if min_angle_1>min_angle_2
                min_angle=min_angle_1;
            else
                min_angle=min_angle_2;
               
            end
            cla(app.UIAxes2);
            i=0;
            for angle=deg2rad(ceil((rad2deg(min_angle)))):(pi/180):deg2rad(89)
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
                    app.SelectAnglesListBox.Items(i+1)={num2str(rad2deg(angle))};
                else
                    continue
                end
            end          
        end
        % Clicked callback: SelectAnglesListBox
        function SelectAnglesListBoxClicked(app, event)
            distance_from_building_user= app.EnterdistancefrombuildingtotheusermEditField.Value;
            height_of_building=app.EnterheightofthebuildingmEditField.Value;
            ring_distance=6;
            g=9.81;
            ring_height=3;
            range=distance_from_building_user+ring_distance;
         
            min_angle_1=atan(height_of_building/distance_from_building_user);
            min_angle_2=atan((height_of_building-ring_height)/ring_distance);
            if min_angle_1>min_angle_2
                min_angle=min_angle_1;
            else
                min_angle=min_angle_2;
            end
           
            allangles = app.SelectAnglesListBox.Items;
            main_angle = deg2rad(str2double(allangles(event.InteractionInformation.Item)));
            single_velocity=sqrt((range^2*g)/(2*((cos(main_angle))^2)*((range*tan(main_angle))-ring_height)));
            single_time=range/(single_velocity*cos(main_angle));
            single_height=(single_velocity^2*(sin(main_angle))^2)/(2*g);
     
            values(1,1)=rad2deg(main_angle);
            values(1,2)=single_velocity;
            values(1,3)=single_time;
            values(1,4)=single_height;
          
           
            app.UITable.Data=values;
           
           
            [x,y] = graphing(single_velocity,main_angle,single_time);
            hold(app.UIAxes2, 'on')
            for nf = 0:(length(x))/30:length(x)
           
                    plot(app.UIAxes2, x(1:nf),y(1:nf),[distance_from_building_user distance_from_building_user],[0 height_of_building], "LineWidth", 2);
                    pause(0.001);
                   
             end
        end
        % Value changing function: Slider
        function SliderValueChanging(app, event)
            changingValue = event.Value;
            time_for_slider=app.UITable.Data(1,3);
            app.Slider.Limits=[0 time_for_slider];
           
        end
        % Value changed function: Slider
        function SliderValueChanged(app, event)
            distance_from_building_user= app.EnterdistancefrombuildingtotheusermEditField.Value;
            height_of_building=app.EnterheightofthebuildingmEditField.Value;
            ring_distance=6;
            g=9.81;
            ring_height=3;
            range=distance_from_building_user+ring_distance;               
            specific_time = app.Slider.Value;
            range_time_specific=app.UITable.Data(1,2);
            time_specific_=app.UITable.Data(1,1);
            [x_dist_st, y_dist_st, vel_at_time_st] = calc_at_specific_time(range_time_specific, deg2rad(time_specific_), specific_time);
            values_for_2nd_table(1,1)=specific_time;
            values_for_2nd_table(1,2)=x_dist_st;
            values_for_2nd_table(1,3)=y_dist_st;
            values_for_2nd_table(1,4)=vel_at_time_st;
            app.UITable2.Data=values_for_2nd_table;
           
            [x_for_specific_time the_rock]=graphing(range_time_specific,deg2rad(time_specific_),specific_time);
            plot(app.UIAxes2_2,x_for_specific_time,the_rock,[distance_from_building_user distance_from_building_user],[0 height_of_building],'LineWidth',2);
           
        end
    end
    % Component initialization
    methods (Access = private)
        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100.333333333333 100.333333333333 1090 741];
            app.UIFigure.Name = 'MATLAB App';
            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Flight of Projectile')
            xlabel(app.UIAxes2, 'X (m)')
            ylabel(app.UIAxes2, 'Y (m)')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [591 372 440 290];
            % Create UIAxes2_2
            app.UIAxes2_2 = uiaxes(app.UIFigure);
            title(app.UIAxes2_2, 'Trajectory')
            xlabel(app.UIAxes2_2, 'X (m)')
            ylabel(app.UIAxes2_2, 'Y (m)')
            zlabel(app.UIAxes2_2, 'Z')
            app.UIAxes2_2.Position = [591 68 442 290];
            % Create Distancefrombaskettothebuildingis6mLabel
            app.Distancefrombaskettothebuildingis6mLabel = uilabel(app.UIFigure);
            app.Distancefrombaskettothebuildingis6mLabel.Position = [49 535 236 22];
            app.Distancefrombaskettothebuildingis6mLabel.Text = 'Distance from basket to the building is: 6 m';
            % Create Heightofbasketis3mLabel
            app.Heightofbasketis3mLabel = uilabel(app.UIFigure);
            app.Heightofbasketis3mLabel.Position = [49 510 130 22];
            app.Heightofbasketis3mLabel.Text = 'Height of basket is: 3 m';
            % Create CalculateButton
            app.CalculateButton = uibutton(app.UIFigure, 'push');
            app.CalculateButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateButtonPushed, true);
            app.CalculateButton.Position = [292 500 100 22];
            app.CalculateButton.Text = 'Calculate';
            % Create EnterdistancefrombuildingtotheusermEditFieldLabel
            app.EnterdistancefrombuildingtotheusermEditFieldLabel = uilabel(app.UIFigure);
            app.EnterdistancefrombuildingtotheusermEditFieldLabel.HorizontalAlignment = 'right';
            app.EnterdistancefrombuildingtotheusermEditFieldLabel.Position = [42 590 237 22];
            app.EnterdistancefrombuildingtotheusermEditFieldLabel.Text = 'Enter distance from building to the user (m)';
            % Create EnterdistancefrombuildingtotheusermEditField
            app.EnterdistancefrombuildingtotheusermEditField = uieditfield(app.UIFigure, 'numeric');
            app.EnterdistancefrombuildingtotheusermEditField.HorizontalAlignment = 'left';
            app.EnterdistancefrombuildingtotheusermEditField.Position = [295 592 100 20];
            % Create EnterheightofthebuildingmEditFieldLabel
            app.EnterheightofthebuildingmEditFieldLabel = uilabel(app.UIFigure);
            app.EnterheightofthebuildingmEditFieldLabel.HorizontalAlignment = 'right';
            app.EnterheightofthebuildingmEditFieldLabel.Position = [44 560 172 22];
            app.EnterheightofthebuildingmEditFieldLabel.Text = 'Enter height of the building  (m)';
            % Create EnterheightofthebuildingmEditField
            app.EnterheightofthebuildingmEditField = uieditfield(app.UIFigure, 'numeric');
            app.EnterheightofthebuildingmEditField.HorizontalAlignment = 'left';
            app.EnterheightofthebuildingmEditField.Position = [293 562 100 20];
            % Create SelectAnglesListBoxLabel
            app.SelectAnglesListBoxLabel = uilabel(app.UIFigure);
            app.SelectAnglesListBoxLabel.HorizontalAlignment = 'right';
            app.SelectAnglesListBoxLabel.Position = [64 480 75 22];
            app.SelectAnglesListBoxLabel.Text = 'SelectAngles';
            % Create SelectAnglesListBox
            app.SelectAnglesListBox = uilistbox(app.UIFigure);
            app.SelectAnglesListBox.Items = {'0'};
            app.SelectAnglesListBox.ClickedFcn = createCallbackFcn(app, @SelectAnglesListBoxClicked, true);
            app.SelectAnglesListBox.Position = [54 400 100 74];
            app.SelectAnglesListBox.Value = {};
            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'ANGLE (°)'; 'VELOCITY (m/s)'; 'TIME (s)'; 'MAX. HEIGHT (m)'};
            app.UITable.RowName = {};
            app.UITable.Position = [177 402 385 72];
            % Create SliderLabel
            app.SliderLabel = uilabel(app.UIFigure);
            app.SliderLabel.HorizontalAlignment = 'right';
            app.SliderLabel.Position = [30 212 36 22];
            app.SliderLabel.Text = 'Slider';
            % Create Slider
            app.Slider = uislider(app.UIFigure);
            app.Slider.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider.ValueChangingFcn = createCallbackFcn(app, @SliderValueChanging, true);
            app.Slider.Position = [87 221 427 3];
            % Create UITable2
            app.UITable2 = uitable(app.UIFigure);
            app.UITable2.ColumnName = {'TIME (s) '; 'RANGE (m)'; 'HEIGHT (m)'; 'VELOCITY (m/s)'};
            app.UITable2.RowName = {};
            app.UITable2.Position = [36 83 488 61];
            % Create MovetheslidertoseethepositionandveloctiyoftheprojectilsLabel
            app.MovetheslidertoseethepositionandveloctiyoftheprojectilsLabel = uilabel(app.UIFigure);
            app.MovetheslidertoseethepositionandveloctiyoftheprojectilsLabel.Position = [35 248 452 22];
            app.MovetheslidertoseethepositionandveloctiyoftheprojectilsLabel.Text = 'Move the slider to see the position and veloctiy of the projectile at a particular time.';
            % Create ProjectileatParticularTimeLabel
            app.ProjectileatParticularTimeLabel = uilabel(app.UIFigure);
            app.ProjectileatParticularTimeLabel.FontName = 'Times New Roman';
            app.ProjectileatParticularTimeLabel.FontSize = 24;
            app.ProjectileatParticularTimeLabel.FontWeight = 'bold';
            app.ProjectileatParticularTimeLabel.Position = [35 268 325 53];
            app.ProjectileatParticularTimeLabel.Text = 'Projectile at Particular Time';
            % Create TrajectoryofProjectileLabel
            app.TrajectoryofProjectileLabel = uilabel(app.UIFigure);
            app.TrajectoryofProjectileLabel.FontName = 'Times New Roman';
            app.TrajectoryofProjectileLabel.FontSize = 36;
            app.TrajectoryofProjectileLabel.FontWeight = 'bold';
            app.TrajectoryofProjectileLabel.Position = [49 635 369 53];
            app.TrajectoryofProjectileLabel.Text = 'Trajectory of Projectile';
            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end
    % App creation and deletion
    methods (Access = public)
        % Construct app
        function app = GUI_PROJECT
            % Create UIFigure and components
            createComponents(app)
            % Register the app with App Designer
            registerApp(app, app.UIFigure)
            if nargout == 0
                clear app
            end
        end
        % Code that executes before app deletion
        function delete(app)
            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
 