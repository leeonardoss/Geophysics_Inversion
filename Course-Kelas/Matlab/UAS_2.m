%UAS No 2
%Leonardo Budhi Satrio Utomo
%12318011

clc
close all
clear

x0 = 600; %posisi x untuk bola homogen asli
z0 = 600; %posisi z untuk bola homogen asli

fileID = fopen('data_UAS.txt','r');
data = fscanf(fileID,'%f %f', [2 inf]);
data=data';

x = data(:,1);
gobs = data(:,2);
G = 6.674*10^-11;
R = 300;
d=R.*2;
rho = 8000;

x_model = (0:50:2000);
z_model = (0:50:1000);

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
            
%             if erms(i,j)>50
%             erms(i,j)=NaN;
%             end

    end
end

for a=1:length(x)
    gcal_optimum(a) = G*(4/3*pi*R.^3*loc_z*rho)/(((x(a)-loc_x).^2+(loc_z).^2).^(3/2)).*10.^5; %dalam mGal
end

sprintf('lokasi bola homogen(x,z): %d,%d',loc_x,loc_z)
sprintf('erms min: %3.4f',min(erms,[],'all'))

subplot(2,1,1)
plot(x,gobs,'.r','markersize',15);
title('Plot Nilai Observsi Gravitasi');
xlabel('x');
ylabel('grav(mGal)')

subplot(2,1,2)
plot(x,gobs,'.b')
hold on
plot(x,gcal_optimum,'-r','markersize',15);
hold on
xlabel('Jarak(m)');
ylabel('Anomali Gravitasi(mGal)');
title('Grafik gcal')

figure
contourf(x_model, z_model, erms',100); %Plot permukaan dengan plot kontur di bawahnya
hold on
title('Nilai Persebaran Misfit Metode Grid Search')
ax = gca;
ax.XTick = 0:50:2000;
ax.YTick = 0:50:1000;
grid on
grid minor
set(gca,'ydir','reverse');
plot(loc_x,loc_z,'.r','MarkerSize',600)
hold on
plot(x0,z0,'.y','MarkerSize',600)
hold on
plot(x,0,'vk','MarkerSize',10)
xlabel('x')
ylabel('z')
zlabel('erms')
grid on
legend('Erms','Lokasi Bola Homogen Inversi','Lokasi Bola Homogen Asli','Stasiun')
set(gca,'ydir','reverse');
colorbar %color bar sebagai legenda dari warna
% caxis([0 50])


%%
%Komentar
%Pada grafik contourf yang tidak di NaN kan, nilai erms pada kedalaman
%dangkal tidak ada alias kosong berwarna putih sebab ruang model dimulai
%dari x dan z pada nilai 1 bukan 0 dalam nilai increment 50. Sehingga nilai
%gcal yang akan terbaca pun akan dimulai pada kedalaman 50 bukan 0, begitu
%pula dengan nilai erms nya.

%Sedangkan untuk posisi hasil inversi dengan aslinya tidak ditemukan
%perbedaan posisi.