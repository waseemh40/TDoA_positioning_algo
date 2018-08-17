function temporary_script
    close all
%         %temp_vars
%     %SingleTag=ones(60,1);
%     tline_a=1;
%     file_id_read=fopen('Position_Experiment_v3.txt','r');
%     while (tline_a>0)
%             %get data from file
%         tline_a = fgetl(file_id_read);
%         SingleTag =sscanf(tline_a,'%ld%c%d%c%d%c%d%c%d%c%d%');
%         timestamp=SingleTag(1,1);        %get second timestamp
%         ms=SingleTag(3,1);               %get millisecond
%         tag_id=SingleTag(5,1);           %get ID
%         tbr_sn=SingleTag(11,1);          %get SNR
%             %add to file
%         formatSpec ='TBR_%d_TAG_ID_%d_Detections.txt';
%         str = sprintf(formatSpec,tbr_sn,tag_id);
%         fid_id_write = fopen(str,'a');
%         z=3;
%         fprintf(fid_id_write,'%ld	0	%d	%2.2f	47	%3.5f\n',timestamp,tag_id,z,ms);
%         fclose(fid_id_write);
%         %pause(2);
%     end
%         fclose(file_id_read);
%         %fprintf(fileID,'1521558154	0	40	%2.2f	47	 %3.5f\n',z,timestamp(1,2));
%         %fclose(fileID);
    file_id_read=fopen('TBR_43_TAG_ID_10_Detections.txt','r');
    tline_a = fgetl(file_id_read);
    size_string=size(tline_a);
    fseek(file_id_read,-1*(1+1)*size_string(1,2),'eof');
    tline_a = fgetl(file_id_read);
        %this part goes into a loop
    tline_a = fgetl(file_id_read);
    tline_a
    SingleTag =sscanf(tline_a,'%ld%c%d%c%d%c%d%c%d%c%d');
    timestamp_ref=SingleTag(1,1);
    tbr_sn=44;
    tag_id=10;
    [timestamp_ret,millsec_ret]=find_timestamp_in_file(timestamp_ref,tbr_sn,tag_id)
    tbr_sn=46;
    tag_id=10;
    [timestamp_ret,millsec_ret]=find_timestamp_in_file(timestamp_ref,tbr_sn,tag_id)
end

function [timestamp_ret,millsec_ret]=find_timestamp_in_file(timestamp_ref,tbr_sn,tag_id)
    
    timestamp_ret=-1;
    millsec_ret=-1;
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
            return;
        end
    end
end