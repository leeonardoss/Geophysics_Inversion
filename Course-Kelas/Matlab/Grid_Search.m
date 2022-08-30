%Pemodelan Inversi Non-Linier dengan pendekatan Grid Search
%Leonardo Budhi Satrio Utomo
%12318011

clc
close all
clear
% %forward modelling data sintetik
% x0 = 65; %posisi x untuk event gempa
% y0 = 27; %posisi y untuk event gempa
% x = [20 50 40 10];
% y = [10 25 50 40];
% nsta = length(x);
% vp = 7.2;
% 
% for i=1:nsta
%     tobs(i) = ((sqrt((x(i)-x0).^2+(y(i)-y0).^2))/vp)+0.5*randn();
% end

x0 = 65; %posisi x untuk event gempa
y0 = 27; %posisi y untuk event gempa
z0 = 15; %posisi z untuk event gempa

fileID = fopen('gelombang_gempa.txt','r');
data = fscanf(fileID,'%d %d %d %f', [4 inf]);
data=data';


x = data(:,1);
y = data(:,2);
z = data(:,3);
%z0 = data(1,4);
tobs = data(:,4);
vp = 7.2;

mx = (0:1:100);
my = (0:1:100);
%mz = (0:2.5:50);
min_e=inf; %nilai minimum erms
for i=1:length(mx)
    for j=1:length(my)
        %for k=1:length(mz)
            for a=1:length(x)
                tcal(a) = ((sqrt((x(a)-mx(i)).^2+(y(a)-my(j)).^2))/vp);
                
            end
            misfit = (tobs-tcal').^2;
            erms(i,j) = sqrt(mean(misfit));
            if erms(i,j)<min_e
                min_e=erms(i,j);
                loc_x = i;
                loc_y = j;
            end
        %end
    end
end

sprintf('lokasi episenter gempa(x,y): %d,%d',loc_x,loc_y)
sprintf('erms min: %3.4f',min(erms,[],'all'))

figure
contourf(mx, my, erms',50); %Plot permukaan dengan plot kontur di bawahnya
hold on
title('Nilai Persebaran Misfit Metode Grid Search')
ax = gca;
ax.XTick = 0:10:100;
ax.YTick = 0:10:100;
grid on
grid minor
plot(x0,y0,'pr','MarkerSize',15)
plot(loc_x,loc_y,'hy','MarkerSize',15)
plot(x,y,'vk','MarkerSize',10)
xlabel('x')
ylabel('y')
zlabel('erms')
grid on
legend('Erms','Titik sampel','Lokasi Eposenter Asli','Lokasi Episenter Inversi','Stasiun')
colorbar %color bar sebagai legenda dari warna
