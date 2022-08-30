%Pemodelan Inversi Non-Linier dengan pendekatan Random Search
%Leonardo Budhi Satrio Utomo
%12318011

clc
close all
clear

x0 = 400; %posisi x untuk bola homogen
z0 = 200; %posisi z untuk bola homogen

fileID = fopen('data1.txt','r');
data = fscanf(fileID,'%f %f', [2 inf]);
data=data';


x = data(:,1);
gobs = data(:,2);
G = 6.674*10^-11;
R = 100;
d=R.*2;
rho = 2994;

xmax = (1:25:1000); %batas ruang model x
zmax = (1:25:1000); %batas ruang model y
n=0.1*length(xmax)*length(zmax);

min_e = inf; %nilai minimum erms
for i = 1:n
    mx(i) = 25*randi(length(xmax)); %xx(randi(50))
    mz(i) = 25*randi(length(zmax)); %yy(randi(50))
    for a=1:length(x)
        gcal(a) = G*(4/3*pi*R.^3*mz(i)*rho)/(((x(a)-mx(i)).^2+(mz(i)).^2).^(3/2)).*10.^5; %dalam mGal
        
    end
    misfit = (gobs-gcal').^2;
    erms(i) = sqrt(mean(misfit));
end

for i=1:length(erms)
    if erms(i)<min_e
        min_e=erms(i);
        loc_x=mx(i);
        loc_z=mz(i);
    end
end

sprintf('lokasi bola homogen(x,z): %d,%d',loc_x,loc_z)
sprintf('erms min: %3.4f',min(erms,[],'all'))

[X,Y] = meshgrid(xmax,zmax);
f = scatteredInterpolant(mx',mz',erms'); %interpolasi nilai erms dari data sampel
Z = f(X,Y);

figure
contourf(X,Y,Z,20) %plot nilai erms dalam kontur
axis tight
hold on
plot3(mx,mz,erms,'.','MarkerSize',15) %plot titik sample
plot(x0,z0,'pr','MarkerSize',15)
plot(loc_x,loc_z,'hy','MarkerSize',15)
plot(x,0,'vk','MarkerSize',10)
set(gca,'ydir','reverse');
title('Nilai Persebaran Misfit Metode Random Search')
xlabel('x')
ylabel('y')
zlabel('Erms')
legend('Erms','Titik sampel','Lokasi Episenter Asli','Lokasi Episenter Inversi','Stasiun')
colorbar %color bar sebagai legenda dari warna



