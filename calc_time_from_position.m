function[timestamp]=calc_time_from_position(offset,coord,station_data);

    v=1500;
    
    x=coord(1,1);
    y=coord(2,1);
    z=coord(3,1);
    
    b=station_data(1,1);
    cx=station_data(2,1);
    cy=station_data(3,1);
    depth=station_data(4,1);
    
%     ra=sqrt(x^2+y^2+(z-depth)^2);
%     rb=sqrt((x-b)^2+y^2+(z-depth)^2);
%     rc=sqrt((x-cx)^2+(y-cy)^2+(z-depth)^2);
    
%     timestamp(1,1)=offset+fix(ra/v);
%     timestamp(1,2)=(ra/v-fix(ra/v))*1000;
%     timestamp(2,1)=offset+fix(rb/v);
%     timestamp(2,2)=(rb/v-fix(rb/v))*1000;
%     timestamp(3,1)=offset+fix(rc/v);
%     timestamp(3,2)=(rc/v-fix(rc/v))*1000;
    ra=sqrt(x^2+y^2);
    rb=sqrt((x-b)^2+y^2);
    rc=sqrt((x-cx)^2+(y-cy)^2);
    timestamp(1,1)=offset;
    timestamp(1,2)=(ra/v)*1000;
    timestamp(2,1)=offset;
    timestamp(2,2)=(rb/v)*1000;
    timestamp(3,1)=offset;
    timestamp(3,2)=(rc/v)*1000;
%     fileID = fopen('TBR_11_TAG_ID_40_Detections.txt','a');
%     fprintf(fileID,'1521558154	0	40	%2.2f	47	 %3.5f\n',z,timestamp(1,2));
%     fclose(fileID);
%     fileID = fopen('TBR_22_TAG_ID_40_Detections.txt','a');
%     fprintf(fileID,'1521558154	0	40	%2.2f	47	 %3.5f\n',z,timestamp(2,2));
%     fclose(fileID);
%     fileID = fopen('TBR_33_TAG_ID_40_Detections.txt','a');
%     fprintf(fileID,'1521558154	0	40	%2.2f	47	 %3.5f\n',z,timestamp(3,2));
%     fclose(fileID);
end