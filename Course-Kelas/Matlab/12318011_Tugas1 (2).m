%Tugas 1 - Pemodelan Nilai Persebaran Gravitasi Bola Homogen dalam Ruang 3D
%Leonardo Budhi Satrio Utomo
%12318011

clear all; 
clc;
close all;

R = 175; %m
z = 100; %m
x = 350; %m
rho = 2830; %kg/m^3
G = 6.6740*10.^(-11); %Konstanta Gravitasi
zi = 15*rand(1,101); %zi sebagai variabel penghimpun data ketinggian titik ukur
y = 600; %m

[xi,yi] = meshgrid(0:10:1000, 0:10:1000); %m
Gz = (G*(4/3*pi*R.^3*rho*z)./(((xi-x).^2+(yi-y).^2+(zi-z).^2).^(3./2)))*10.^5; %mGal

disp(size(xi))
disp(size(Gz))

contour3(xi,yi,Gz,150);%Plot dengan kontur dalam 3D
title('PEMODELAN PERSEBARAN NILAI GRAVITASI BOLA HOMOGEN PADA RUANG 3D DI PERMUKAAN')
xlabel('m')
ylabel('m')
zlabel('mGal')

colorbar %color bar sebagai legenda dari warna gradasi model
