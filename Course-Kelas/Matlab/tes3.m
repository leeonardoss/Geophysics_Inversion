clear all; clc;
close all

R = 250; %m
Zc = 300; %m
Xc = 500; %m
p = 3000; %kg/m^3
G = 6.6710.^(-11); %Konstanta Gravitasi
Zi = 0 %Dapat menambahkan Zi dengan asumsi Zi = elevasi untuk menambah kompleksitas
Yc = 500; %m

[Xi,Yi] = meshgrid(0:10:1000, 0:10:1000); %m
Gz = (G*(4/3*pi*R.^3*p*Zc)./(((Xi-Xc).^2+(Yi-Yc).^2+(Zi-Zc).^2).^(3./2)))*10.^5; %satuan mGal

figure
surfc(Xi, Yi, Gz) %Plot permukaan dengan plot kontur di bawahnya
title('PEMODELAN GRAVITASI BOLA HOMOGEN PADA RUANG 3D')
xlabel('m')
ylabel('m')
zlabel('mGal')
grid on
colorbar %color bar sebagai legenda dari warna