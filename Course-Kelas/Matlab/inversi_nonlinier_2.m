%Pemodelan Inversi Non-Linier dengan pendekatan Finitie-Difference
%Leonardo Budhi Satrio Utomo
%12318011

clc
clear
close all

fileID = fopen('data1.txt','r');
data = fscanf(fileID,'%f %f', [2 inf]);
data=data';
xp = data(:,1);
gobs = data(:,2);
G = 6.674*10^-11;
R = 100;
rho = 2994;

subplot(2,2,1)
plot(xp,gobs,'.r','markersize',15);
title('Plot Nilai Observsi Gravitasi');
xlabel('x');
ylabel('grav(mGal)');

%Menghitung gcal
iterasi = 1; rms=1;
while rms >=0.05
    if iterasi ==1
        x_model = 100;
        z_model = 100;
    else
        x_model = x_pertu;
        z_model = z_pertu;
    end
    
    %menghitung data gcal
    gcal=zeros(length(xp),1);
    for i=1:length(xp)
        gcal(i)=G*(4/3*pi*R.^3*z_model*rho)/(((xp(i)-x_model).^2+(z_model).^2).^(3/2)).*10.^5; %dalam mGal
        %gcal(i)=G*(4/3*pi*R.^3*rho)/(((xp(i)-x_model).^2+(z_model).^2)).*10.^5; %dalam mGal
    end
    
    %menghitung misfit
    dg_misfit=gobs-gcal;
    rms = sqrt(mean((dg_misfit).^2));%mean
    e_plot(iterasi)=rms;
    
    %membuat kondisi untuk inversi jacobi
    dx = 5;
    dz = 5;
    %membuat matriks jacobi
    for i=1:length(xp)
        turunan_x(i)=((G*(4/3*pi*R.^3*z_model*rho)/(((xp(i)-(x_model+dx)).^2+(z_model).^2).^(3/2)).*10.^5)-(G*(4/3*pi*R.^3*z_model*rho)/(((xp(i)-x_model).^2+(z_model).^2).^(3/2)).*10.^5))/dx;
        %turunan_x(i)=G*(4/3*pi*R.^3*rho)/(((xp(i)-(x_model+dx)).^2+(z_model).^2)).*10.^5; %dalam mGal
        turunan_z(i)=((G*(4/3*pi*R.^3*(z_model+dz)*rho)/(((xp(i)-x_model).^2+(z_model+dz).^2).^(3/2)).*10.^5)-(G*(4/3*pi*R.^3*z_model*rho)/(((xp(i)-x_model).^2+(z_model).^2).^(3/2)).*10.^5))/dz;
        %turunan_z(i)=G*(4/3*pi*R.^3*rho)/(((xp(i)-x_model).^2+(z_model+dz).^2)).*10.^5; %dalam mGal
    end
    J = ones(length(xp),2);
    J(:,1) = turunan_x';
    J(:,2) = turunan_z';
    
    %menghitung perturbasi model
    dm_perturbasi=inv(J'*J)*J'*dg_misfit;
    x_pertu=x_model+dm_perturbasi(1);
    z_pertu=z_model+dm_perturbasi(2);
    
    %plot model prediksi bawah permukaan ter-perturbasi
    subplot(2,2,3)
    d=R.*2;
    px=x_pertu;
    py=z_pertu;
    %plot(px,py,'.b','markersize',100)
    p = rectangle('Position',[px py d d],'Curvature',[1,1],'EdgeColor','b');
    daspect([1,1,1]);set(gca,'ydir','reverse');
    pause(0.5)
    xlim([0,1000]);
    ylim([0,500]);
    xlabel('Jarak(m)');
    ylabel('Kedalaman(m)');
    title('Model Prediksi')
    iterasi=iterasi+1;
    
    %plot data kalkulasi dan std misfit
    subplot(2,2,2)
    plot(xp,gobs,'.b')
    hold on
    plot(xp,gcal,'-r','markersize',15);
    hold off
    xlabel('Jarak(m)');
    ylabel('Anomali Gravitasi(mGal)');
    title('Grafik gcal')
    
    if abs(dm_perturbasi(1))<1e-6 || abs(dm_perturbasi(2))<1e-6
        break
    end
    
end

    
%plot data kalkulasi dan std misfit
subplot(2,2,2)
plot(xp,gcal,'-r','markersize',15);
hold on
plot(xp,gobs,'.b')
xlabel('Jarak(m)');
ylabel('Anomali Gravitasi(mGal)');
title('Grafik gcal')

subplot(2,2,4)
rectangle('Position',[px py d d],'Curvature',[1,1],'EdgeColor','k','FaceColor','k');
daspect([1,1,1]);set(gca,'ydir','reverse');
xlim([0,1000]);
ylim([0,500]);
xlabel('Jarak(m)');
ylabel('Kedalaman(m)');
title('Model Bola Homogen Akhir')

display(px+R)
display(py+R)

figure(2)
plot([1:1:(length(e_plot))],e_plot,'Color','m','LineStyle','-','LineWidth',2)
xlabel('Iterasi');
ylabel('Std Misfit');
title('Grafik Misfit Iterasi');

