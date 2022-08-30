%Pemodelan Inversi Non-Linier dengan pendekatan linier
%Leonardo Budhi Satrio Utomo
%12318011

clc
clear
close all

x = 600;
z = 600;
R = 300;
rho = 8000;
G = 6.674*10^-11;

xp = (0:50:2000);
nsta = length(xp);

for i=1:nsta
    g(i) = G*(4/3*pi*R.^3*z*rho)/(((xp(i)-x).^2+z.^2).^(3/2))*10.^5;
    gn(i) = g(i)+2.*randn;
end

figure
plot(xp,gn,".r", "markersize", 15);
hold on;
plot(xp,g,'-b', 'linewidth', 2);
title('Plot Nilai Gravitasi');
xlabel('x');
ylabel('grav(mgal)');

file_dat = fopen('data_UAS.txt','w');
for i = 1:nsta
    fprintf(file_dat,'%12.3f %12.3f \n',xp(i),gn(i));
end
fclose(file_dat);






