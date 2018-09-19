function y=iA_pos_cacluations_top(tag_id,tbr_a,tbr_b,tbr_c,n_samples)
    close all
        %just change this path and modify others (if any) required paths...
    addpath('C:\Users\waseemh\OneDrive - NTNU\iA PhD\iA_TDoA_experiments\Matlab_algo\simulation_files');

    formatSpec ='TBR_%d_TAG_ID_%d_Detections.txt';
    str = sprintf(formatSpec,tbr_b,tag_id);
    fid_b = fopen(str);
    formatSpec ='TBR_%d_TAG_ID_%d_Detections.txt';
    str = sprintf(formatSpec,tbr_c,tag_id);
    fid_c = fopen(str);
            %specs
        %ref pos
    ref_pos=[2149 1246 -300]; %(21.49,12.46,-3.00)
        %station data
    b=41.58;                %b=43.301;
    cx=21.19;                %cx=21.6498;
    cy=37.21;               %cy=37.4988;
    depth=3;                %depth=25;
    station_data=[b,cx,cy,depth]';
        %samples and extracted variables
    timestamp_a=zeros(1,2);
    timestamp_b=zeros(1,2);
    timestamp_c=zeros(1,2);
    timestamp_matrix=zeros(3,2);
    z_a=0;
    z_b=0;
    z_c=0;
    z_avg=0;
    N_samples=n_samples;
    used_timestamps=0;
    zero_calcs=0;
        %outputs
    coord_matrix=zeros(N_samples,3);      %N rows 3 columns        
        % get each sample and apply positioning algorithm
    formatSpec ='TBR_%d_TAG_ID_%d_Detections.txt';
    str = sprintf(formatSpec,tbr_a,tag_id);
    file_id_read=fopen(str,'r');
    tline_a = fgetl(file_id_read);
    size_string=size(tline_a);
    fseek(file_id_read,-1*(n_samples+1)*size_string(1,2),'eof');
    tline_a = fgetl(file_id_read);
    for loop_var=1:N_samples-1
        tline_a = fgetl(file_id_read);
        tline_a;
        if (tline_a~=-1)
            SingleTag =sscanf(tline_a,'%ld%c%d%c%d%c%d%c%d%c%d');
            timestamp_ref=SingleTag(1,1);
            timestamp_a(1,1)=SingleTag(1,1);        %get second timestamp
            timestamp_a(1,2)=SingleTag(12,1);       %get millisecond
            z_a=SingleTag(7,1);                     %get depth
            tbr_sn=tbr_b;
            [timestamp_ret,millsec_ret,depth_ret]=find_timestamp_in_file(timestamp_ref,tbr_sn,tag_id);
            timestamp_b(1,1)=timestamp_ret;
            timestamp_b(1,2)=millsec_ret;
            z_b=depth_ret;
            tbr_sn=tbr_c;
            [timestamp_ret,millsec_ret,depth_ret]=find_timestamp_in_file(timestamp_ref,tbr_sn,tag_id);
            timestamp_c(1,1)=timestamp_ret;
            timestamp_c(1,2)=millsec_ret;
            z_c=depth_ret;                  
                %average depth
            z_avg=(z_a+z_b+z_c)/3;
            if((timestamp_a(1,1)==-1) || ((timestamp_b(1,1)==-1)))
                ;
            else
            used_timestamps=used_timestamps+1;
               %make timestamp matrix
            timestamp_matrix=[timestamp_a;timestamp_b;timestamp_c];    %veritcal concatenate
                %apply position algo (check 1 or 3 whichever is wokring)
            [x_cal,y_cal,z_cal]=iA_pos_algo(z_avg,timestamp_matrix,station_data);
                %debug code
            if (x_cal==0)|| (y_cal==0)
                zero_calcs=zero_calcs+1;
            end
                %%%%%%%%%%%%%%
            coord_matrix(used_timestamps,:)=[x_cal,y_cal,z_cal]; 
            end
        end
    end
    used_timestamps
    zero_calcs
    hold on
    for loop_var=1:N_samples   
        %plot(coord_matrix(loop_var,1),coord_matrix(loop_var,2),'*');
        plot3(coord_matrix(loop_var,1),coord_matrix(loop_var,2),-1*coord_matrix(loop_var,3),'*');
    end
    grid on;
    xlabel('x(cm)');
    ylabel('y(cm)');
    zlabel('depth(cm)');
    zlim([-500 0])
    fclose(file_id_read);
    hold on
    plot3(0,0,-100*depth,'ok');
    text(0,0,-100*depth,'Receiver_A','Color','blac','FontSize',14);
    plot3(b*100,0,-100*depth,'ok');
    text(b*100,0,-100*depth,'Receiver_B','Color','blac','FontSize',14);
    plot3(cx*100,cy*100,-100*depth,'ok');
    text(cx*100,cy*100,-100*depth,'Receiver_C','Color','blac','FontSize',14);
    grid on
    ax = gca;
    c = ax.FontSize;
    ax.FontSize = 12;
    ax.FontWeight= 'bold';
            %cage
    circle((2500-335.01),(2500-1250.11),2500);
        %error related
    coord_matrix=sortrows(coord_matrix,[-1 -2 -3])
    for loop_var=1:used_timestamps-zero_calcs
        error_matrix(loop_var,:)=coord_matrix(loop_var,:)-ref_pos;
    end
    figure
    plot(error_matrix(:,1),'*');
    hold on
    plot(error_matrix(:,2),'o');
    legend('x-error','y-error');
    ylabel('Error(cm)','FontSize',12,'FontWeight','bold','Color','k')
    xlabel('Samples','FontSize',12,'FontWeight','bold','Color','k')
    grid on
    ax = gca;
    c = ax.FontSize;
    ax.FontSize = 12;
    ax.FontWeight= 'bold';
   % ax.Color = 'blue';

end
function [timestamp_ret,millsec_ret,depth_ret]=find_timestamp_in_file(timestamp_ref,tbr_sn,tag_id)
    
    timestamp_ret=-1;
    millsec_ret=-1;
    depth_ret=-1;
    formatSpec ='TBR_%d_TAG_ID_%d_Detections.txt';
    str = sprintf(formatSpec,tbr_sn,tag_id);
    fid = fopen(str,'r');
    while ~feof(fid)
        tline_a = fgetl(fid);   
        SingleTag =sscanf(tline_a,'%ld%c%d%c%d%c%d%c%d%c%f');
        timestamp=SingleTag(1,1);
        if(abs(timestamp-timestamp_ref)<2)
            timestamp_ret=timestamp;
            millsec_ret= SingleTag(12,1);    %milli_sec
            depth_ret= SingleTag(7,1);
            fclose(fid);
            return;
        end
    end
    fclose(fid);
end

function h = circle(x,y,r)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit,'k');
end