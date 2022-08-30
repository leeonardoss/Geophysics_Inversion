clc
clear all
close all

a = 1;
b = 1.5;
c = -2;
d = -2.5;
e = 0;
f = 0.3;
xi = (-2:0.1:1.5);
y = a.*xi.^5+b.*xi.^4+c.*xi.^3+d.*xi.^2+e.*xi+f;
ya = y+1.5*rand(1,length(xi));

plot(xi,ya,'sk');
title('Plot Regresi');
xlabel('x');
ylabel('y');
hold on;

p = polyfit(xi,ya,5);
a = p(1); %nilai parameter dari pangkat variabel bebas tertinggi
b = p(2);
c = p(3);
d = p(4);
e = p(5);
f = p(6);
ycal = a*xi.^5+b*xi.^4+c*xi.^3+d*xi.^2+e*xi+f;
plot(xi,ycal,'-', 'linewidth', 2);


legend('data', 'regresi' ,'Location', 'southeast');