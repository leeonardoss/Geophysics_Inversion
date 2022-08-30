%Tugas 3 - Pemodelan Kedepan Inversi Linear Bola Homogen Gravitasi
%Leonardo Budhi Satrio Utomo
%12318011

clc
clear
close all

x = [100 300 650 950];
y = [200 600 200 800];
z = [150 200 100 200];
R = [100 100 100 100];
rho = [2000 2700 3200 3400];
G = 6.674*10^-11;

x0 = (0:10:1000);
y0 = (0:10:1000);
[xgrid,ygrid] = meshgrid(0:10:1000, 0:10:1000); %m
xi = reshape(xgrid,[length(xgrid)*length(ygrid),1]);
yi = reshape(ygrid,[length(xgrid)*length(ygrid),1]);

g = zeros(length(xi),length(rho));


for i = 1:length(xi)
    for j = 1:length(rho)
        g(i,j) = (G*(4/3).*pi.*R(j).^3.*z(j)/(((xi(i)-x(j)).^2+(yi(i)-y(j)).^2+z(j).^2).^(3/2))).*10.^5;
    end
end
disp(size(g))
disp(size(rho'))
d = g*rho';
% 
disp(size(d))
dnoise = d+0.1*randn(length(d),1);
di = reshape(dnoise,[101,101]);
disp(size(di));
% 

 
%----------------------------------------------------------------------------------------
m = inv(g'*g)*g'*dnoise;
dcal = g*m;
dinv = reshape(dcal,[101,101]);
disp(dinv)

%----------------------------------------------------------------------------------------
tiledlayout(1,2)
nexttile
contour3(xgrid,ygrid,di,500); %Plot dengan kontur dalam 3D
title('PEMODELAN DATA SINTETIK GRAVITASI BOLA HOMOGEN PADA RUANG 3D DI PERMUKAAN')
xlabel('x(m)')
ylabel('y(m)')
zlabel('mGal')
colorbar
hold on
nexttile
contour3(xgrid,ygrid,dinv,500); %Plot dengan kontur dalam 3D
title('PEMODELAN INVERSI NILAI GRAVITASI BOLA HOMOGEN PADA RUANG 3D')
xlabel('x(m)')
ylabel('y(m)')
zlabel('mGal')
colorbar
hold on


 
