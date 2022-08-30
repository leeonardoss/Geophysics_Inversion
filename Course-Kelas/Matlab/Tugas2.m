%Tugas 2 - Pemodelan Kedepan Linier dengan Perkalian Matriks
%Leonardo Budhi Satrio Utomo
%12318011

clc
clear
close all

M = [1; 1.5; -2; -2.5; 0; 0.3]; %parameter model

x=(-2:0.1:1.5); %area of interest
G = [(x').^5 (x').^4 (x').^3 (x').^2 x' ones(length(x),1)];

y = G*M;
ya = y+0.3*randn(1,length(x)); 
disp(size(ya))
%%
% p = polyfit(x,ya,5);
% a = p(1);
% b = p(2);
% c = p(3);
% d = p(4);
% e = p(5);
% f = p(6);
% xcal = (-2:0.1:1.5);
% ycal = a*xcal.^5+b*xcal.^4+c*xcal.^3+d*xcal.^2+e*xcal+f;

% xplot = (-2:0.01:1.5);
% yplot = a*xplot.^5+b*xplot.^4+c*xplot.^3+d*xplot.^2+e*xplot+f;

%%
figure
plot(x,ya,".r", "markersize", 15);
hold on;
plot(xplot,yplot,'-b', 'linewidth', 2);
title('Plot Regresi');
xlabel('x');
ylabel('y');

error = (ya-ycal).^2;
fprintf("Least Square Error: %s",sum(error))

dim = [.2 .1 .2 .1];
str1 = ("Least Square Error: ");
str2 = sum(error);
annotation('textbox',dim,'String',str1+str2,'FitBoxToText','on');

legend('data', 'regresi' ,'Location', 'northeast');
