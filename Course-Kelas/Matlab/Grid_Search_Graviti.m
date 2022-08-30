%Pemodelan Inversi Non-Linier dengan pendekatan Grid Search
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

x_model = (0:25:1000);
z_model = (0:25:1000);

min_e=inf; %nilai minimum erms
for i=1:length(x_model)
    for j=1:length(z_model)
            for a=1:length(x)
                gcal(a) = G*(4/3*pi*R.^3*z_model(j)*rho)/(((x(a)-x_model(i)).^2+(z_model(j)).^2).^(3/2)).*10.^5; %dalam mGal
                
            end
            misfit = (gobs-gcal').^2;
            erms(i,j) = sqrt(mean(misfit));
            if erms(i,j)<min_e
                min_e=erms(i,j);
                loc_x = x_model(i);
                loc_z = z_model(j);
            end
        %end
    end
end

sprintf('lokasi bola homogen(x,z): %d,%d',loc_x,loc_z)
sprintf('erms min: %3.4f',min(erms,[],'all'))

subplot(2,2,1)
plot(x,gobs,'.r','markersize',15);
title('Plot Nilai Observsi Gravitasi');
xlabel('x');
ylabel('grav(mGal)')

figure
contourf(x_model, z_model, erms',50); %Plot permukaan dengan plot kontur di bawahnya
hold on
title('Nilai Persebaran Misfit Metode Grid Search')
ax = gca;
ax.XTick = 0:50:1000;
ax.YTick = 0:50:1000;
grid on
grid minor
set(gca,'ydir','reverse');
plot(x0,z0,'.r','MarkerSize',100)
hold on
plot(loc_x,loc_z,'.y','MarkerSize',100)
hold on
plot(x,0,'vk','MarkerSize',10)
xlabel('x')
ylabel('z')
zlabel('erms')
grid on
legend('Erms','Lokasi Bola Homogen Asli','Lokasi Bola Homogen Inversi','Stasiun')
set(gca,'ydir','reverse');
colorbar %color bar sebagai legenda dari warna

