clc
clear all
close all

a = 4;
b = 3;
xi = (0:0.1:1);
y = a+b*xi;
ya = y+rand(1,length(xi));

title('Plot Regresi');
plot(xi,ya,'om');
xlabel('x');
ylabel('y');
hold on;

p = polyfit(xi,ya,1);
a = p(2);
b = p(1);
ycal = a+b*xi;
plot(xi,ycal,'-');
legend('data', 'regresi' ,'Location', 'southeast');


