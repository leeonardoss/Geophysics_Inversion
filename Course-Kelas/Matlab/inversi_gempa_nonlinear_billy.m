%Pemodelan Inversi Non-Linier dengan pendekatan linier
%Billy Hansen 12318013

clc
clear
close all

x_gempa = 60; %km
y_gempa = 40; %km
z_gempa = 20; %km
t_gempa = 0; %s
vp = 4; %km/s

x_sta = ([10;25;65;80]);
y_sta = ([85;40;20;90]);
z_sta = ([0;0;0;0]);
nsta = length(x_sta);

for a=1:length(x_sta)
    t_sintetik(a) = (sqrt((x_gempa-x_sta(a)).^2 - (y_gempa-y_sta(a)).^2 - (z_gempa-z_sta(a)).^2)./vp)+0.5*randn();
end
t_obs = t_sintetik;

%Batas global search
x_search = (0:1:100);
y_search = (0:1:100);
z_search = (0:2:25);

%Grid Search
e_min = inf; %Variabel penguji misfit terkecil
for i=1:length(x_search)
    for j=1:length(y_search)
        for k=1:length(z_search)
            for n=1:nsta
                t_cal(n) = (sqrt((x_search(i)-x_sta(n)).^2-(y_search(j)-y_sta(n)).^2-(z_search(k)-z_sta(n)).^2)/vp);
            end
            misfit = abs(t_obs'-t_cal');
            erms(i,j,k) = mean(misfit);
            %Penguji misfit terkecil untuk mencari lokasi hiposenter
            if erms(i,j,k)<e_min
                e_min=erms(i,j,k);
                x_hipo=x_search(i);
                y_hipo=y_search(j);
                z_hipo=z_search(k);
            end
        end
    end
end

sprintf('lokasi hiposenter gempa(x,y,z): %d,%d,%d',x_hipo,y_hipo,z_hipo)
sprintf('erms min: %3.4f',min(erms,[],'all'))

%Plot hasil grid search
plot_gs = figure;
scatter3(x_hipo,y_hipo,z_hipo,200,'r','p','filled')
hold on
scatter3(x_gempa,y_gempa,z_gempa,200,'yellow','p','filled')
xlim([0 100]);
ylim([0 100]);
zlim([-5 50]);
set(gca,'zdir','reverse');