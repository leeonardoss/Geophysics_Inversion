%Tugas 4 - Pemodelan Inversi Linier dengan standar deviasi data konstan
%Leonardo Budhi Satrio Utomo
%12318011

clc
clear
close all

M = [1; 1.5; -2; -2.5; 0; 0.3]; %parameter model

x=(-2:0.1:1.5); %area of interest
G = [(x').^5 (x').^4 (x').^3 (x').^2 x' ones(length(x),1)];
n = length(x);

y = G*M;
ya = y+0.5*randn(length(x),1); 
disp(size(y))

%matriks sigma d
std = 0.5;
var = std^2;


%%
M = inv(G'*G)*G'*ya;
yinv = G*M;
disp(yinv)

I = eye(n);
cd = var*I;
error_data = diag(cd);
%A = inv(G'*G)*G';
cm = (std.^2)*inv(G'*G);
display(cm)
cm_diag = diag(cm);
m_std = sqrt(cm_diag);

%Perhitungan inversi berbobot
w = inv(cd');
m_cal = inv(G'*w*G) * (G'*w*ya);
m_cal_stdpos = m_cal + m_std;
m_cal_stdneg = m_cal - m_std;
y_cal = G*m_cal;
y_cal_stdpos = G*m_cal_stdpos;
y_cal_stdneg = G*m_cal_stdneg;
%%
figure
errorbar(x,ya,error_data,'.');
hold on;
%plot(x,ya,".k", "markersize", 20);
%hold on;
%plot(x,y,'-r', 'linewidth', 2);
plot(x,yinv,'-b', 'linewidth', 2);
hold on
%plot(x,y_cal,'-k', 'linewidth', 2);
%hold on
plot(x,y_cal_stdpos,'--r')
hold on
plot(x,y_cal_stdneg,'--r')
title('Plot Regresi');
xlabel('x');
ylabel('y');

error = sqrt(sum(yinv-y)/n);
fprintf("Error rms: %s",error)

dim = [.2 .1 .2 .1];
str1 = ("Erms: ");
str2 = error;
annotation('textbox',dim,'String',str1+str2,'FitBoxToText','on');

legend('noise','data awal', 'regresi' ,'Location', 'northeast');