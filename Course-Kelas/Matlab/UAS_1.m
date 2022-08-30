%UAS No 1
%Leonardo Budhi Satrio Utomo
%12318011

clc
close all
clear

tobs = [11.2;7.8;8.0;11.1];
x = [40;70;50;60];
y = [60;50;70;40];
vp = 4; %km/s

t0 = 0; %s

%Menghitung gcal
iterasi = 1; eps=inf;
while eps >=0.05
    if iterasi ==1
        x_model = 60;
        y_model = 10;
    else
        x_model = x_pertu;
        y_model = y_pertu;
    end
    
    %menghitung data tcal
    tcal=zeros(length(x),1);
    for i=1:length(x)
        tcal(i) = t0 + ((sqrt((x(i)-x_model).^2+(y(i)-y_model).^2))/vp);
    end
    
    %menghitung misfit
    dg_misfit=tobs-tcal;
    eps = sqrt(mean((dg_misfit).^2));%mean
    e_plot(iterasi)=eps;
    
    %membuat kondisi untuk inversi jacobi
        %membuat matriks jacobi
        for i=1:length(x)
            turunan_x(i) = t0 + (x_model-x(i))/(sqrt((x(i)-x_model).^2+(y(i)-y_model).^2)*vp);
            turunan_y(i) = t0 + (y_model-y(i))/(sqrt((x(i)-x_model).^2+(y(i)-y_model).^2)*vp);
        end
        J = ones(length(x),2);
        J(:,1) = turunan_x';
        J(:,2) = turunan_y';
        
        %menghitung perturbasi model
        dm_perturbasi=inv(J'*J)*J'*dg_misfit;
        x_pertu=x_model+dm_perturbasi(1);
        y_pertu=y_model+dm_perturbasi(2);
        
    %plot model prediksi bawah permukaan ter-perturbasi
    loc_x=x_pertu;
    loc_y=y_pertu;
    plot(x,y,'vk','MarkerSize',10)
    hold on
    plot(loc_x,loc_y,'hy','markersize',20)
    hold on
    pause(0.5)
    xlim([0,100]);
    ylim([0,100]);
    xlabel('x(km)');
    ylabel('y(km)');
    title('Model Prediksi')
    iterasi=iterasi+1;

    if abs(dm_perturbasi(1))<1e-6 || abs(dm_perturbasi(2))<1e-6
        break
    end
    
end

sprintf('posisi episenter gempa dalam sumbu x: %3.3f', loc_x)
sprintf('posisi episenter gempa dalam sumbu y: %3.3f', loc_y)
sprintf('Nilai ERMS minimum: %3.3f', eps)

figure(2)
plot([1:1:(length(e_plot))],e_plot,'Color','m','LineStyle','-','LineWidth',2)
xlabel('Iterasi');
ylabel('Std Misfit');
title('Grafik Misfit Iterasi');

%%
%Komentar
%Saya menggunakan percobaan dengan beberapa model awal. Model awal pertama
%saya pasang di bawah x=50 dan y=50, sedangkan yang kedua menggunakan x dan
%y di atas 50. Hasilnya menunjukkan perbedaan lokasi episenter. Hal ini
%mungkin disebabkan adanya minimum lokal pada dua lokasi berbeda