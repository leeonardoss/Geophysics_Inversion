close all;
clear all;
clc;

fileID = fopen('model_syn_q.txt','r');
data = fscanf(fileID,'%d %d', [2 inf]);
data=data';

resist = data(:,1); %Resistivitas lapisan
thicks = data(:,2); %ketebalan lapisan
thicks = nonzeros(thicks);
nlayer = length(resist); %jumlah layer
RY = 5000; %jarak titik sounding dari transmitter
resist = resist';
thicks = thicks';
t = logspace(1,-4,31);
period = t;
%ra = zeros(length(t),1);
frekuensi = 1./t;

mu = 4*pi*10.^(-7);                  % Permeabilitas magnetik (H/m)  
w = 2*pi.*frekuensi;                 % Frekuensi Sudut (Radians);

for i = 1:length(t)
    zxy = csamt_mex(t(i),RY, resist, thicks, nlayer);
    Z(i,1) = zxy;
end

%tambah noise
for k = 1:length(t)
    riil(k) = real(Z(k))+0.05*real(Z(k))*randn();
    ima(k) = imag(Z(k))+0.05*imag(Z(k))*randn();
    Zbar(k) = complex(riil(k),ima(k));
end
%tanpa noise
apparentResistivity = (abs(Z).*abs(Z))./(mu*w');
phase = atan2(imag(Z),real(Z))*(180/pi);

raw = [t;apparentResistivity';phase';real(Z)';imag(Z)'];
file_fw = fopen('FW_syn_q.txt','w');
fprintf(file_fw,'%3.4f %3.4f %3.4f %3.4f %3.4f \n',raw);
fclose(file_fw);

%dengan noise
apparentResistivity_n = (abs(Zbar).*abs(Zbar))./(mu*w);
phase_n = atan2(imag(Zbar),real(Zbar))*(180/pi);


raw = [t;apparentResistivity_n;phase_n;real(Zbar);imag(Zbar)];
file_fw = fopen('FW_syn_q_noise.txt','w');
fprintf(file_fw,'%3.4f %3.4f %3.4f %3.4f %3.4f \n',raw);
fclose(file_fw);



figure(1)

subplot(2, 4, [1,3])
loglog(period,apparentResistivity,'.r','MarkerSize',10);
hold on
legend('Rho-Apparent');
axis([10^-4 10^1 10^0 2*10^4])
title({['Apparent Resistivity (Ohm m) vs Period (s)']});   
xlabel('Period (s)');
ylabel('Apparent Resistivity (Ohm m)');

subplot(2,4,[5,7])
plot(period,phase,'.b','MarkerSize',10);
set(gca,'Xscale','log');
hold on
legend('phase');
axis([10^-4 10^1 -90 90])
title({['Phase (degree) vs Period (s)']}); 
xlabel('Period (s)');
ylabel('phase');

subplot(2,4,[4 8])
rr = [0,resist];
tt = [0,cumsum(thicks),max(thicks)*5];
stairs(rr,tt,'r--', 'LineWidth',2);

set(gca,'Ydir','reverse');
set(gca,'Xscale','log');

axis([1 10^4 1 2500])
xlabel('Resistivity (Ohm-m)');
ylabel('Depth (m)');
title({['Resistivity Section']});   

sgtitle({['Forward Modelling CSAMT'],['Tanpa Noise']})


figure(2)

subplot(2, 4, [1,3])
loglog(period,apparentResistivity_n,'.r','MarkerSize',10);
hold on
legend('Rho-Apparent');
axis([10^-4 10^1 10^0 2*10^4])
title({['Apparent Resistivity (Ohm m) vs Period (s)']});   
xlabel('Period (s)');
ylabel('Apparent Resistivity (Ohm m)');

subplot(2,4,[5,7])
plot(period,phase_n,'.b','MarkerSize',10);
set(gca,'Xscale','log');
hold on
legend('phase');
axis([10^-4 10^1 -90 90])
title({['Phase (degree) vs Period (s)']}); 
xlabel('Period (s)');
ylabel('phase');

subplot(2,4,[4 8])
rr = [0,resist];
tt = [0,cumsum(thicks),max(thicks)*5];
stairs(rr,tt,'r--', 'LineWidth',2);
% rrr = [0,rinitial];
% ttt = [0,cumsum(tinitial),max(t)*10];
% subplot(1,2,2),
% stairs(rrr,ttt,'k--');
set(gca,'Ydir','reverse');
set(gca,'Xscale','log');
%ylim([0 50]);
% xlim([0 1000]);
axis([1 10^4 1 2500])
xlabel('Resistivity (Ohm-m)');
ylabel('Depth (m)');
title({['Resistivity Section']});   

sgtitle({['Forward Modelling CSAMT'],['Dengan Noise']})




