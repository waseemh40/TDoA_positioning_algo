function h = circle(x,y,r)
close all
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit,'k');
sz=140; 
scatter(3.3501,12.5011,sz,'kd')
scatter(3.3501+43.3013,12.5011,sz,'kd')
scatter(25,50,sz,'kd')
    %AC
sqrt((25-3.3501)^2+(50-12.5011)^2)
    %BC
sqrt((25-(3.3501+43.3013))^2+(50-12.5011)^2)
    %AB
sqrt(43.3013^2)
grid on
grid minor

set(gca,'xtick',[0:5:100])

set(gca,'ytick',[0:5:100])

end