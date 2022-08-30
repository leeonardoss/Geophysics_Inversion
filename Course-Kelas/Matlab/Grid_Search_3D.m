%Pemodelan Inversi Non-Linier dengan pendekatan Grid Search 3D
%Leonardo Budhi Satrio Utomo
%12318011

clc
close all
clear

x0 = 65; %posisi x untuk event gempa
y0 = 27; %posisi y untuk event gempa
z0 = 15; %posisi z untuk event gempa

fileID = fopen('gelombang_gempa3d.txt','r');
data = fscanf(fileID,'%d %d %d %d %f', [5 inf]);
data=data';


x = data(:,1);
y = data(:,2);
z = data(:,3);
z0 = data(1,4);
tobs = data(:,5);
vp = 7.2;

mx = (0:1:100);
my = (0:1:100);
mz = (0:1:50);
min_e=inf; %nilai minimum erms
for i=1:length(mx)
    for j=1:length(my)
        for k=1:length(mz)
            for a=1:length(x)
                tcal(a) = ((sqrt((x(a)-mx(i)).^2+(y(a)-my(j)).^2+(mz(k)).^2))/vp);
                
            end
            misfit = (tobs-tcal').^2;
            erms(i,j,k) = sqrt(mean(misfit));
            if erms(i,j,k)<min_e
                min_e=erms(i,j,k);
                loc_x = mx(i);
                loc_y = my(j);
                loc_z = mz(k);
            end
        end
    end
end

sprintf('lokasi hiposenter gempa(x,y,z): %d,%d,%d',loc_x,loc_y,loc_z)
sprintf('erms min: %3.4f',min(erms,[],'all'))

%Plot hasil grid search
plot_gs = figure;
scatter3(loc_x,loc_y,loc_z,200,'r','p','filled')
hold on
scatter3(x0,y0,z0,200,'yellow','p','filled')
hold on
scatter3(x,y,z,200,'vk','filled')
hold on
legend('Lokasi Hiposenter Kalkulasi','Lokasi Hiposenter Gempa Asli','Stasiun')
% for i=1:length(mx)
%     contour3(mx, my, erms'); %Plot permukaan dengan plot kontur di bawahnya
%     hold on
% end
xlim([0 100]);
ylim([0 100]);
zlim([-5 50]);
set(gca,'zdir','reverse');

for k=1:length(mz)
figure()
contourf(mx, my, erms(:,:,k)',50); %Plot permukaan dengan plot kontur di bawahnya
hold on
title({['Nilai Persebaran Misfit Metode Grid Search'] ['pada Kedalaman=' num2str(k)]})
colorbar;

end

% figure
% contourf(mx, my, erms',50); %Plot permukaan dengan plot kontur di bawahnya
% hold on
% title('Nilai Persebaran Misfit Metode Grid Search')
% ax = gca;
% ax.XTick = 0:10:100;
% ax.YTick = 0:10:100;
% grid on
% grid minor
% plot(x0,y0,'pr','MarkerSize',15)
% plot(loc_x,loc_y,'hy','MarkerSize',15)
% plot(x,y,'vk','MarkerSize',10)
% xlabel('x')
% ylabel('y')
% zlabel('erms')
% grid on
% legend('Erms','Titik sampel','Lokasi Eposenter Asli','Lokasi Episenter Inversi','Stasiun')
% colorbar %color bar sebagai legenda dari warna