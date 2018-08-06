function y=iA_pos_cacluations_top(tag_id,tbr_a,tbr_b,tbr_c,n_samples)
        %just change this path and modify others (if any) required paths...
    addpath('C:\Users\waseemh\OneDrive - NTNU\iA PhD\iA_TDoA_experiments\Matlab_algo\simulation_files');
    formatSpec ='TBR_%d_TAG_ID_%d_Detections.txt';
    str = sprintf(formatSpec,tbr_a,tag_id);
    fid_a = fopen(str);
    formatSpec ='TBR_%d_TAG_ID_%d_Detections.txt';
    str = sprintf(formatSpec,tbr_b,tag_id);
    fid_b = fopen(str);
    formatSpec ='TBR_%d_TAG_ID_%d_Detections.txt';
    str = sprintf(formatSpec,tbr_c,tag_id);
    fid_c = fopen(str);
            %specs
        %station data
    b=43.301;
    cx=21.6498;
    cy=37.4988;
    depth=25;
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
        %outputs
    coord_matrix=zeros(N_samples,3);      %N rows 3 columns
        %general purpose variables
    size_string=31;
    SingleTag=ones(10,1);
    
     %           timestamp_matrix=[2x3 matrix with stamp and millisec; stat_a,stat_b,stat_c]
     %       [x_cal,y_cal,z_cal]=iA_pos_algo(coord(3,1),timestamp,station_data);
        %flow
         %go to end of line of each file -> move back N samples -> etxract
         %depth and time stamps -> apply algo and save results in coord
         %matrix -> plot 3d coords, no sorting since coord matrix is
         %chronological
%         %goto end of file
%     while ~feof(fid_a)
%         tline_a = fgetl(fid_a);   
%     end
%         while ~feof(fid_b)
%         tline_b = fgetl(fid_b);   
%     end
%     while ~feof(fid_c)
%         tline_c = fgetl(fid_c);   
%     end 
%     %disp(tline)
%         % move N samples back
%     fseek(fid_a,-1*N_samples*size_string,'cof');
%     tline_a = fgetl(fid_a);         %required to get rid of first single integer...
%     fseek(fid_b,-1*N_samples*size_string,'cof');
%     tline_b = fgetl(fid_b);         
%     fseek(fid_c,-1*N_samples*size_string,'cof');
%     tline_c = fgetl(fid_c);         
        % get each sample and apply positioning algorithm
    for loop_var=1:N_samples-1
            %for tbr_a
        tline_a = fgetl(fid_a);
        SingleTag =sscanf(tline_a,'%f');
        timestamp_a(1,1)=0;%SingleTag(1,1);        %get second timestamp
        timestamp_a(1,2)=SingleTag(6,1);        %get millisecond
        z_a=SingleTag(4,1);                     %get data
            %for tbr_b
        tline_b = fgetl(fid_b);
        SingleTag =sscanf(tline_b,'%f');
        timestamp_b(1,1)=0;%SingleTag(1,1);        
        timestamp_b(1,2)=SingleTag(6,1);        
        z_b=SingleTag(4,1);                    
            %for tbr_c
        tline_c = fgetl(fid_c);
        SingleTag =sscanf(tline_c,'%f');
        timestamp_c(1,1)=0;%SingleTag(1,1);        
        timestamp_c(1,2)=SingleTag(6,1);        
        z_c=SingleTag(4,1);                    
            %average depth
        z_avg=(z_a+z_b+z_c)/3;
            %make timestamp matrix
        timestamp_matrix=[timestamp_a;timestamp_b;timestamp_c];    %veritcal concatenate
            %apply position algo (check 1 or 3 whichever is wokring)
           [x_cal,y_cal,z_cal]=iA_pos_algo(z_avg,timestamp_matrix,station_data);
        coord_matrix(loop_var,:)=[x_cal,y_cal,z_cal];
    end
    hold on
    for loop_var=1:N_samples   
        %plot(coord_matrix(loop_var,1),coord_matrix(loop_var,2),'*');
        plot3(coord_matrix(loop_var,1),coord_matrix(loop_var,2),coord_matrix(loop_var,3),'*');
    end
    grid on;
    xlabel('x-distance');
    ylabel('y-distance');
    zlabel('z-depth');
    fclose(fid_a);
    fclose(fid_b);
    fclose(fid_c);
    coord_matrix;
end
