function [x,y,z]=iA_pos_algo(depth,timestamp_matrix,station_data)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %depth=1x1 matrix, m units                          %          
        %timestamp=3x2 matrix,                              %          
        %   (1,1)->sec_a & (1,2)->msec_a;(2,1)->sec_b &     %
        %   (2,2)->msec_b;(3,1)->sec_c & (3,2)->msec_c      %
        %station_b_coord->1x1 matrix, parameter b           %
        %station_c_coord->2x1 matrix,cx and c (m units!!!)  %
        %x,y and z @ output are in cm                       %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    format long 
    %extract values from input matrixes in algorithm/paper naming convetion
        %timestamps
    sec_a=timestamp_matrix(1,1);
    msec_a=timestamp_matrix(1,2);
    sec_b=timestamp_matrix(2,1);
    msec_b=timestamp_matrix(2,2);
    sec_c=timestamp_matrix(3,1);
    msec_c=timestamp_matrix(3,2);
        %coordinates of stations
    b=station_data(1,1);
    cx=station_data(2,1);
    cy=station_data(3,1);
    depth_hydrophone=station_data(4,1);
    c=sqrt(cx^2+cy^2);
        %z_m
    z_m=depth;
        %sound speed
    v=1500;
    %caculate R_ab and R_ac
    T_a=sec_a+(msec_a/1000);
    T_b=sec_b+(msec_b/1000);
    T_c=sec_c+(msec_c/1000);
    R_ab=v*(T_a-T_b);
    R_ac=v*(T_a-T_c);
%     if R_ab ==0
%         if R_ac ==0
%             x=100*b/2;
%             z=100*depth;
%             disp('Both R_ab abd R_ac are zero');
%             %solve for y
%             y_projection=sqrt(((msec_c/1000)*v)^2-(depth_hydrophone-depth)^2);    %changed from T_c
%             y=100*(cy-y_projection);
%             y=100*12.46;
%             if  ~(isreal(x)) || ~(isreal(y)) 
%                 x=abs(x);
%                 y=abs(y);
%                 %disp('Y is imaginary');
%             end
%             if  (abs(y)>100*cy) 
%                 y=cy/2;
%                 disp('Setting y to cy/2');
%             end
%             return 
%         else
%             x=100*b/2;
%             z=100*depth;
%             %solve for y
%             term=(R_ac^2-c^2+2*cx*b/2);
%             %calculate x
%             a=(2*cy^2)-(4*R_ac^2*(b/2)^2);          %y^2
%             b=(4*cy*term);                          %y
%             c=term^2-(4*R_ac^2*((b/2)^2+depth^2));  %const.
%             p=[a b c];
%             y_mat=roots(p);
%             y_projection=sqrt(((msec_c/1000)*v)^2-(depth_hydrophone-depth)^2);    %changed from T_c
%             y=100*(cy-y_projection);
%             y=100*12.46;
%             disp('R_ab is zero');
%             if  ~(isreal(x)) || ~(isreal(y)) 
%                 x=abs(x);
%                 y=abs(y);
%                 %disp('Y is imaginary');
%             end
%             if  (abs(y)>100*cy) 
%                 y=cy/2;
%                 disp('Setting y to cy/2');
%             end
%             return
%         end
%     end
disp('New iteration')
    if R_ab ==0
       if R_ac ==0
            x=100*(b/2);
            z=100*depth;
            y=100*(-((cx*b)/(cy*2))+(c^2/(2*cy)));
            disp('Both R_ab abd R_ac are zero');
            return 
       else
            x_mat(1,1)=b/2;     %equal rooots
            x_mat(2,1)=b/2;     %equal roots
            z_m=depth;
            %solve for y
            term=(R_ac^2-c^2+(2*cx*(b/2)));
            %make quadratric equation
            a=(4*cy^2)-(4*R_ac^2);                  %y^2
            b=(4*cy*term);                          %y
            c=term^2-(4*R_ac^2*((b/2)^2+depth^2));  %const.
            p=[a b c];
            y_mat=roots(p);
            disp('R_ab is zero');
       end
    else
        %caclutae g, h, d, e and f
        b_rab=b/R_ab;
        b_rab_1=1-b_rab^2;
        g=((R_ac*b_rab)-cx)/cy;
        h=(c^2-R_ac^2+(R_ac*R_ab*b_rab_1))/(2*cy);
        d=-1*(b_rab_1+g^2);
        e=(b*b_rab_1)-(2*g*h);
        f=((R_ab^2/4)*(b_rab_1^2))-h^2;
        %calculate x
        p=[d e f-z_m^2];
        x_mat=roots(p);
        %calculayte y
        y_mat=g*x_mat+h;
    end
    %check equs 1 and 2 are satisfied with x,y and z values
    for loop_var=1:3
        
        x_extrctd=x_mat(loop_var,1);
        y_extrctd=y_mat(loop_var,1);
        
        R_ab_calc=sqrt(x_extrctd^2+y_extrctd^2+z_m^2)-sqrt((x_extrctd-b)^2+y_extrctd^2+z_m^2);
        R_ac_calc=sqrt(x_extrctd^2+y_extrctd^2+z_m^2)-sqrt((x_extrctd-cx)^2+(y_extrctd-cy)^2+z_m^2);
        abs(R_ab_calc-R_ab);
        abs(R_ac_calc-R_ac);
        if(abs(R_ab_calc-R_ab) < 2 && abs(R_ac_calc-R_ac) < 2)
            x=x_extrctd;
            y=y_extrctd;
            break;
        end
        if (loop_var >= 2)
            disp('No roots found');
            sec_a;
            sec_b;
            sec_c;
            x=0;
            y=0;
            break;
        end
    end 
    %convert x,y,z into cm
    x=x*100;
    y=y*100;
    z=z_m*100;
            %checks
    if  ~(isreal(x)) || ~(isreal(y)) 
        x=abs(x);
        y=abs(y);
        %disp('Y is imaginary');
    end

end
