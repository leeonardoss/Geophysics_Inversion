close all;
clear all;
clc;
format long;

%% input model sintetik non noise untuk plot penampang resistivitas
fileFW = fopen('model_syn_h.txt','r');
data_FW = fscanf(fileFW,'%d %d', [2 inf]);
data_FW=data_FW';

resist_FW = data_FW(:,1); %Resistivitas lapisan
thicks_FW = data_FW(:,2); %ketebalan lapisan
thicks_FW = nonzeros(thicks_FW);

%% input data sintetik
fileID = fopen('FW_syn_h_noise.txt','r');
data = fscanf(fileID,'%f %f %f %f %f', [5 inf]);
data=data';

period = data(:,1);
RA = data(:,2);
phase = data(:,3);
realZ = data(:,4);
imagZ = data(:,5);
frekuensi = 1./period;
n = length(period);

%% Penentuan parameter model awal
mu = 4*pi*10.^(-7);                  % Permeabilitas magnetik (H/m)  
w = 2*pi.*frekuensi;                 % Frekuensi Sudut (Radians);


%initial model
r = [1000 1000 1000 1000 1000 1000 1000 1000 1000 1000];
% r = [300 300 300 300 300 300 300 300 300 300];
% r = [100 100 100 100 100 100 100 100 100 100];
thickness = [150 175 200 225 250 300 350 400 500];
nlayer = length(r);
RY = 5000; %jarak titik sounding dari transmitter
m = [r];

rinitial = r;
tinitial = thickness;
lr = length(r); 
lt = length(thickness); 
kr = 10e-4;                     % convergence tolerance
dfit = 1;                        % initial iteration
iteration = 1;
itermax = 100;

%% Pembuatan matriks DEL untuk Jacobi
DEL = diag(ones(lr,1),0)-diag(ones(lr-1,1),1);
DEL(1,1) = 0;
alpha = 1;

%% Pembuatan Textbox nilai ERMS pada plot
rms_err2 = 0;
dim = [.15 .15 .1 .05];
str1 = ("Erms: ");
str2 = rms_err2;
a1 = annotation('textbox',dim,'String',str1+str2,'FitBoxToText','off');

%% Aktivasi Video
v = VideoWriter('CSAMT Syn H occam smooth .avi');
v.FrameRate = 3;
open(v);

%% Iterasi Program Utama
while iteration<itermax
    it_title = iteration;
    r = m(1:lr);
    %t = m(1+lr:lr+lt);
    t = thickness;
    for i = 1:n
        per = period(i);
        zxy = csamt_mex(per,RY, r, t, nlayer);
        %Z_cal1(i,1) = zxy;

        RA_cal1(i,1) = (abs(zxy)*abs(zxy))/(mu*w(i));
        phase_cal1(i,1) = atan2(imag(zxy),real(zxy))*(180/pi);
    end
    
    e1 = [log(RA)-log(RA_cal1)];
    dd = e1;
    
    misfit1 = e1'*e1;
    rms(iteration) = misfit1;
    nit(iteration) = iteration;
    rms_err = norm((log(RA_cal1)-log(RA))/log(RA))./(sqrt(length(RA)))+norm((phase_cal1-phase)/phase)./(sqrt(length(phase)));
    if misfit1<kr
        figure()
        loglog(period,RA,'r.',period,RA_cal1,'k');
        %axis([1 1000 1 1000])
        xlabel('Period(s)');
        ylabel('--');
    break
    end

%% Pembuatan matriks Jacobi untuk parameter model terperturbasi
    [A] = jacobian_occam(period,r,t,lr,lt,RA,RA_cal1);
    B = A'*A+alpha.*DEL;
    [U,S,V] = svd(B,0);

    ss = length(S);
    say = 1;
    k = 0;

    while say<ss
        diagS = diag(S);
        beta = S(say)*(dfit^(1/say));
        if beta<10e-5
            beta = 0.001*say;
        end
        for i4 = 1:ss
            SS(i4,i4) = S(i4,i4)/(S(i4,i4)^2+beta);
        end

        dmg = (V*SS*U')*A'*dd;
        mg = exp(log(m)+dmg');
        r = mg(1:lr);
%         t = mg(1+lr:lr+lt);

        for i5 = 1:length(period)
            zxy = csamt_mex(period(i5),RY, r, t, nlayer);
            RA_cal4(i5,1) = (abs(zxy)*abs(zxy))/(mu*w(i5));
            phase_cal4(i5,1) = atan2(imag(zxy),real(zxy))*(180/pi);
        end

    
        e2 = [log(RA)-log(RA_cal4)];
        misfit2 = e2'*e2;
        
        rms_err2 = norm((log(RA_cal4)-log(RA))/log(RA))./(sqrt(length(RA)))+norm((phase_cal4-phase)/phase)./(sqrt(length(phase))) ;
        disp(rms_err2)

%% Penentuan kualitas model (misfit)
        if misfit2>misfit1
                %('Beta control')
                say = say+1;
                k = k+1;
                if k == ss-1
                    iteration = itermax;
                    nit(end+1)=length(nit)+1;
                    say = ss+1;
                end
            
        else
            say = ss+1;
            m = mg;
            dfit = (misfit1-misfit2)/misfit1;
            iteration = iteration+1;
            u = iteration;
            rms(iteration) = misfit2;
            
            if dfit<kr
                iteration = itermax;
                say = say+1;
                nit(end+1)=length(nit)+1;
            end
            
        end

    end

    if length(nit)==itermax-1
        nit(end+1)=length(nit)+1;
    end
%% Plot Grafik Resistivitas Semu
    subplot(2,2,1),
    loglog(period,RA,'k.',period,RA_cal4,'r','MarkerSize',15,'LineWidth',1.5);
    xlabel('T(s)','FontSize',12,'FontWeight','Bold');
    ylabel('Rho-App(ohm.m)','FontSize',12,'FontWeight','Bold');
    axis([10^-4 10^1 10^0 2*10^4])
    title({['Apparent Resistivity (Ohm m) vs Period (s) || Iteration:', num2str(length(nit))]},'FontSize',12);  
    legend('Synthetic','Inversion')
    str2 = rms_err2*100;
    set(a1,'position',dim,'String',str1+str2+'%');
    drawnow;
    pause(0.000001)

%% Plot grafik Fasa
    subplot(2,2,3),
    plot(period,phase,'.k','MarkerSize',15);
    hold on
    plot(period,phase_cal4,'r','LineWidth',1.5);
    hold off
    set(gca,'Xscale','log');
    xlabel('T(s)','FontSize',12,'FontWeight','Bold');
    ylabel('Degree(°)','FontSize',12,'FontWeight','Bold');
    axis([10^-4 10^1 -90 90])
    title({['Phase (degree) vs Period (s)']},'FontSize',12);   
    legend('Synthetic','Inversion')
    pause(0.000001)

 %% Plot grafik resistivity-section
    rrr = [0,resist_FW'];
    ttt = [0,cumsum(thicks_FW'),max(thicks_FW')*5];
    subplot(2,2,[2 4]),
    stairs(rrr,ttt,'k--');
    hold on
    subplot(2,2,[2 4]),
    rr = [0,r];
    tt = [0,cumsum(t),max(t)*10];
    stairs(rr,tt,'r', 'LineWidth',3);
    hold off
    axis([10^0 10^4 0 2500])
    set(gca,'Ydir','reverse');
    set(gca,'Xscale','log');
    xlabel('Resistivity (Ohm-m)','FontSize',12,'FontWeight','Bold');
    ylabel('Depth (m)','FontSize',12,'FontWeight','Bold');
    title({['Resistivity Section']},'FontSize',12); 
    legend('Synthetic','Inversion')
    set(gcf, 'Position', get(0, 'Screensize'));
    grid on
    frame = getframe(gcf);
    writeVideo(v,frame);
end
close(v);

%% Plot grafik misfit
figure(2)
plot(nit,rms,'r','Linewidth',2)
ylim([0 200])
xlabel('Iteration Number','FontSize',10,'FontWeight','Bold');
ylabel('RMSE','FontSize',10,'FontWeight','Bold');
title('\bf \fontsize{12} Grafik Misfit ');
set(gcf, 'Position', get(0, 'Screensize'));
grid on

