%Tugas 3 - Pemodelan Kedepan Inversi Linear Bola Homogen Gravitasi
%Leonardo Budhi Satrio Utomo
%12318011

%ALWAN ABDURRAHMAN/12318021
%PEMODELAN GRAVITASI BOLA HOMOGEN PADA RUANG 3D

clear; 
clc;
close all

R = [250 450 600 850]; %m
Zc = [100 300 500 650]; %m
Xc = [150 350 500 700]; %m
Yc = [200 350 500 800]; %m
rho = [3000; 4000; 5000; 2000]; %kg/m^3
G = 6.6710*10.^(-11); %Konstanta Gravitasi

[Xi,Yi] = meshgrid(0:10:1000, 0:10:1000); %m
g1 = (G.*(4/3*pi*R(1).^3.*Zc(1))./(((Xi-Xc(1)).^2+(Yi-Yc(1)).^2+(Zc(1)).^2).^(3./2))).*10.^5; %satuan mGal
g2 = (G.*(4/3*pi*R(2).^3.*Zc(2))./(((Xi-Xc(2)).^2+(Yi-Yc(2)).^2+(Zc(2)).^2).^(3./2))).*10.^5; %satuan mGal
g3 = (G.*(4/3*pi*R(1).^3.*Zc(3))./(((Xi-Xc(3)).^2+(Yi-Yc(3)).^2+(Zc(3)).^2).^(3./2))).*10.^5; %satuan mGal
g4 = (G.*(4/3*pi*R(1).^3.*Zc(4))./(((Xi-Xc(4)).^2+(Yi-Yc(4)).^2+(Zc(4)).^2).^(3./2))).*10.^5; %satuan mGal

Ga = [g1' g2' g3' g4'];
d = Ga*rho;

contour3(Xi,Yi,d) %Plot dalam 3D
title('PEMODELAN GRAVITASI BOLA HOMOGEN PADA RUANG 3D')
xlabel('m')
ylabel('m')
zlabel('mGal')
