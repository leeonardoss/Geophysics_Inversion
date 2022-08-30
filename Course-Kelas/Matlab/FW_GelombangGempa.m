%Pemodelan Kedepan Waktu Tempuh Gelombang
%Leonardo Budhi Satrio Utomo
%12318011

clc
close all
clear

%forward modelling data sintetik
x0 = 600; %posisi x untuk event gempa
y0 = 27; %posisi y untuk event gempa
z0 = 15; %posisi z untuk event gempa
x = [25 90 65 10];
y = [10 35 60 70];
z = 0;
nsta = length(x);
vp = 7.2;

for i=1:nsta
    tobs(i) = ((sqrt((x(i)-x0).^2+(y(i)-y0).^2+(z-z0).^2))/vp)+0.5*randn();
end

file_dat = fopen('gelombang_gempa3d.txt','w');
for i = 1:nsta
    fprintf(file_dat,'%3d %3d %3d %3d %12.4f \n',x(i),y(i),z,z0,tobs(i));
end
fclose(file_dat);


