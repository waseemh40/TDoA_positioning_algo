function iA_simultae_error

    close all
    resolution=0.5;
    lower_limit_x=-5;
    upper_limit_x=47;
    lower_limit_y=-15;
    upper_limit_y=40;
        %to check a specific range for error
%     lower_limit_x=2;
%     upper_limit_x=45;
%     lower_limit_y=-10;
%     upper_limit_y=35;

    samples_x=fix((upper_limit_x-lower_limit_x)/resolution);
    samples_y=fix((upper_limit_y-lower_limit_y)/resolution);
    samples_sqr=samples_x*samples_y;
    z=5;
            %station data% 
    b=43.301;
    cx=21.6498;
    cy=37.4988;
    depth=25;
    station_data=[b,cx,cy,depth]';
    offset=0;
        %coodinate matrix data
    calc_coord_matrix_index=1;
    input_coord_matrix_index=1;
    outlier_samples=0;
    coord_calc=zeros(2,1,samples_sqr);
    coord_input=zeros(2,1,samples_sqr);
    x_p=zeros(1,100);
    y_p=zeros(1,100);
        %error analysis
    error_matrix_x=zeros(1,samples_sqr);
    error_matrix_y=zeros(1,samples_sqr);
    y_input_row=zeros(1,samples_y);
    y_calc_row=zeros(1,samples_y);
    x=lower_limit_x;
    hold on
    for outer_loop_var=1:samples_x
        y=lower_limit_y;
        for inner_loop_var=1:samples_y
            coord=[x,y,z]';
            timestamp=calc_time_from_position(offset,coord,station_data);
            [x_cal,y_cal,z_cal]=iA_pos_algo(coord(3,1),timestamp,station_data);
            x_scaled=x*100;
            y_scaled=y*100;
  
            if x_cal<5000 && x_cal> -1000 &&  y_cal<5000 && y_cal> -2000 
                coord_calc(:,1,calc_coord_matrix_index)=[x_cal,y_cal]';
                error_matrix_y(1,calc_coord_matrix_index)=y_scaled-y_cal;
                error_matrix_x(1,calc_coord_matrix_index)=x_scaled-x_cal;
                calc_coord_matrix_index=calc_coord_matrix_index+1;
            else
                outlier_samples=outlier_samples+1;
            end     
            coord_input(:,1,input_coord_matrix_index)=[x_scaled,y_scaled]';
            input_coord_matrix_index=input_coord_matrix_index+1;
%                 %error analysis
%             y_input_row(1,inner_loop_var)=y_scaled;
%             y_calc_row(1,inner_loop_var)=y_cal;
%                 %checks
%             if  ~(isreal(y_cal)) || ~(isreal(x_cal)) 
%                 x_cal=abs(x_cal);
%                 y_cal=abs(y_cal);
%                 disp('Y is imaginary');
%                 x_scaled
%                 y_scaled
%                 x_cal
%                 y_cal
%             end
            y=y+resolution;
        end
%         plot(y_calc_row,'r');
%         hold on
%         plot(y_input_row,'g');
%         figure
        outer_loop_var
        x=resolution+x;
    end
    for outer_loop_var=1:calc_coord_matrix_index-1
        x_p(1,outer_loop_var)=    coord_calc(1,1,outer_loop_var);
        y_p(1,outer_loop_var)=    coord_calc(2,1,outer_loop_var);
    end
    plot(x_p(1,:),y_p(1,:),'ro');
    for outer_loop_var=1:samples_sqr
        x_p(1,outer_loop_var)=    coord_input(1,1,outer_loop_var);
        y_p(1,outer_loop_var)=    coord_input(2,1,outer_loop_var);
    end
    hold on
    plot(x_p(1,:),y_p(1,:),'g*');
    xlabel('x-distance(cm)');
    ylabel('y-distance(cm)');
        %cage
    circle((2500-335.01),(2500-1250.11),2500);
        %hydrophones
        sz=140; 
    scatter(0,0,sz,'kd')
    scatter(4330.1,0,sz,'kd')
    scatter(2164.98,3749.88,sz,'kd')
    outlier_samples
        %original frame
    x_frame=lower_limit_y*ones(1,samples_x*50);
    y_frame=lower_limit_y*100:0.1:upper_limit_y*100;
    %plot(x_frame,'k*');
        %error analysis
    figure
    hold on
    plot(error_matrix_x(1,:),error_matrix_y(1,:),'r');
   % plot(error_matrix_y(1,:),'b');
    

end

function h = circle(x,y,r)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit,'k');
end
