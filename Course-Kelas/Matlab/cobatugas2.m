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
ya = y+0.3*randn(length(x),1); 
disp(size(y))


%%
figure
plot(x,ya,".r", "markersize", 20);
hold on;
plot(x,y,'-b', 'linewidth', 2);
title('Plot Regresi');
xlabel('x');
ylabel('y');

error = (ya-y).^2;
fprintf("Least Square Error: %s",sum(error))

dim = [.2 .1 .2 .1];
str1 = ("Least Square Error: ");
str2 = sum(error);
annotation('textbox',dim,'String',str1+str2,'FitBoxToText','on');

legend('data', 'regresi' ,'Location', 'northeast');
