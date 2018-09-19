function iA_simultae_error_paper
    
    % Idea is from one of the old papers
    %(A method for estimating the ‘‘position accuracy’’ of acoustic fish tags)
    % i.e. x3 plots for z=1m, z= 5m and z=10m
    % for each plot, x changes from 0 (or 0.5) to b
    % whereas y changes 3 times and z remains fixed
    % y combinations used are 0, cy/2 and cy
    % station data used is for equilateral triangle NOT Jo's data!!!
    
    close all
    resolution=0.5;
    y_step=10;
    lower_limit_x=1;
    upper_limit_x=40;
    lower_limit_y=0;
    upper_limit_y=40;
        %to check a specific range for error
%     lower_limit_x=2;
%     upper_limit_x=45;
%     lower_limit_y=-10;
%     upper_limit_y=35;

    samples_x=fix((upper_limit_x-lower_limit_x)/resolution)
    samples_y=fix((upper_limit_y-lower_limit_y)/y_step)
    samples_sqr=samples_x*samples_y;
            %station data% 
    b=43.301;
    cx=21.6498;
    cy=37.4988;
    depth=10;
    station_data=[b,cx,cy,depth]';
    offset=0;
        %coodinate matrix data
    y_set=[-7; 15; cy];
   % y_set=[5; 15; 15];
    calc_coord_matrix_index=1;
    input_coord_matrix_index=1;
    outlier_samples=0;
    coord_calc=zeros(2,1,samples_sqr);
    coord_input=zeros(2,1,samples_sqr);
    x_p=zeros(1,100);
    y_p=zeros(1,100);
        %error analysis
    error_matrix_x=zeros(samples_x,3);
    error_matrix_y=zeros(1,samples_sqr);
    y_input_row=zeros(1,samples_y);
    y_calc_row=zeros(1,samples_y);
    zero_count=0;
    hold on
    z=10;
    for outer_loop_var=1:3
        y=y_set(outer_loop_var,1);
        x=lower_limit_x;
        for inner_loop_var=1:samples_x
            coord=[x,y,z]';
            timestamp=calc_time_from_position(offset,coord,station_data);
            [x_cal,y_cal,z_cal]=iA_pos_algo(coord(3,1),ceil(timestamp),station_data);
            x_scaled=x*100;
            y_scaled=y*100;
  
            if x_cal==0 || y_cal==0
                zero_count=zero_count+1;
            elseif x_cal<5000 && x_cal> -1000 &&  y_cal<5000 && y_cal> -2000 
                coord_calc(:,1,calc_coord_matrix_index)=[x_cal,y_cal]';
                error_matrix_y(1,calc_coord_matrix_index)=y_scaled-y_cal;
                error_matrix_x(inner_loop_var,outer_loop_var)=x_scaled-x_cal;
                calc_coord_matrix_index=calc_coord_matrix_index+1;
            else
                outlier_samples=outlier_samples+1;
            end     
            coord_input(:,1,input_coord_matrix_index)=[x_scaled,y_scaled]';
            input_coord_matrix_index=input_coord_matrix_index+1;
            x=resolution+x;
        end
    end
            %average error for 3 values of y
    M1 = mean(error_matrix_x');
        calc_coord_matrix_index=1;
    input_coord_matrix_index=1;
    outlier_samples=0;
        z=5;
    for outer_loop_var=1:3
        y=y_set(outer_loop_var,1);
        x=lower_limit_x;
        for inner_loop_var=1:samples_x
            coord=[x,y,z]';
            timestamp=calc_time_from_position(offset,coord,station_data);
            [x_cal,y_cal,z_cal]=iA_pos_algo(coord(3,1),ceil(timestamp),station_data);
            x_scaled=x*100;
            y_scaled=y*100;
  
            if x_cal==0 || y_cal==0
                zero_count=zero_count+1;
            elseif x_cal<5000 && x_cal> -1000 &&  y_cal<5000 && y_cal> -2000 
                coord_calc(:,1,calc_coord_matrix_index)=[x_cal,y_cal]';
                error_matrix_y(1,calc_coord_matrix_index)=y_scaled-y_cal;
                error_matrix_x(inner_loop_var,outer_loop_var)=x_scaled-x_cal;
                calc_coord_matrix_index=calc_coord_matrix_index+1;
            else
                outlier_samples=outlier_samples+1;
            end     
            coord_input(:,1,input_coord_matrix_index)=[x_scaled,y_scaled]';
            input_coord_matrix_index=input_coord_matrix_index+1;
            x=resolution+x;
        end
    end
            %average error for 3 values of y
    M2 = mean(error_matrix_x');
    calc_coord_matrix_index=1;
    input_coord_matrix_index=1;
    outlier_samples=0;
    z=1;
    for outer_loop_var=1:3
        y=y_set(outer_loop_var,1);
        x=lower_limit_x;
        for inner_loop_var=1:samples_x
            coord=[x,y,z]';
            timestamp=calc_time_from_position(offset,coord,station_data);
            [x_cal,y_cal,z_cal]=iA_pos_algo(coord(3,1),ceil(timestamp),station_data);
            x_scaled=x*100;
            y_scaled=y*100;
  
            if x_cal==0 || y_cal==0
                zero_count=zero_count+1;
            elseif x_cal<5000 && x_cal> -1000 &&  y_cal<5000 && y_cal> -2000 
                coord_calc(:,1,calc_coord_matrix_index)=[x_cal,y_cal]';
                error_matrix_y(1,calc_coord_matrix_index)=y_scaled-y_cal;
                error_matrix_x(inner_loop_var,outer_loop_var)=x_scaled-x_cal;
                calc_coord_matrix_index=calc_coord_matrix_index+1;
            else
                outlier_samples=outlier_samples+1;
            end     
            coord_input(:,1,input_coord_matrix_index)=[x_scaled,y_scaled]';
            input_coord_matrix_index=input_coord_matrix_index+1;
            x=resolution+x;
        end
    end
            %average error for 3 values of y
    M3 = mean(error_matrix_x');
    
    calc_coord_matrix_index
    zero_count
    lim=size(M1);
    x=1:(lim(1,2));
    x=x.*0.5;
    hold on
    plot(x,M1,'k');
    plot(x,M2,'r');
    plot(x,M3,'g');
    grid on
    ax = gca;
    c = ax.FontSize;
    ax.FontSize = 12;
    ax.FontWeight= 'bold';
    plot(x_p(1,:),y_p(1,:),'g*');
    xlabel('x-distance(m)');
    ylabel('Mean error(cm)');
    legend('z=10','z=5','z=1');
    for outer_loop_var=1:calc_coord_matrix_index-1
        x_p(1,outer_loop_var)=    coord_calc(1,1,outer_loop_var);
        y_p(1,outer_loop_var)=    coord_calc(2,1,outer_loop_var);
    end
        %cage plot
    figure
    plot(x_p(1,:),y_p(1,:),'ro');
    for outer_loop_var=1:samples_sqr
        x_p(1,outer_loop_var)=    coord_input(1,1,outer_loop_var);
        y_p(1,outer_loop_var)=    coord_input(2,1,outer_loop_var);
    end
    hold on
    grid on
    ax = gca;
    c = ax.FontSize;
    ax.FontSize = 12;
    ax.FontWeight= 'bold';
    plot(x_p(1,:),y_p(1,:),'g*');
    xlabel('x-distance(cm)');
    ylabel('y-distance(cm)');
    legend('calcualted position','actual position');
        %cage
    circle((2500-335.01),(2500-1250.11),2500);
        %hydrophones
        sz=140; 
    scatter(0,0,sz,'kd','MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5);
            t=text(0,0,'Receiver_A','Color','blac','FontSize',14);
            t.HorizontalAlignment  = 'right';
            t.VerticalAlignment='top'; 
    scatter(4330.1,0,sz,'kd','MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5);
          t=text(b*100,0,'Receiver_B','Color','blac','FontSize',14);
          t.VerticalAlignment='top'; 
    scatter(2164.98,3749.88,sz,'kd','MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5);
          t=text(cx*100,cy*100,'Receiver_C','Color','blac','FontSize',14);
          t.HorizontalAlignment  = 'center';
          t.VerticalAlignment='bottom'; 

    outlier_samples
        %original frame
    x_frame=lower_limit_y*ones(1,samples_x*50);
    y_frame=lower_limit_y*100:0.1:upper_limit_y*100;
    %plot(x_frame,'k*');
    

end

function h = circle(x,y,r)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit,'k');
end
