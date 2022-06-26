function[A] = jacobian_occam(period,r,t,lr,lt,RA,RA_cal1)
RY = 5000;                           %jarak titik sounding dari transmitter
nlayer = length(r);                  %jumlah lapisan
frekuensi = 1./period;


mu = 4*pi*10.^(-7);                  % Permeabilitas magnetik (H/m)  
w = 2*pi.*frekuensi;                 % Frekuensi Sudut (Radians);

par = 0.1;                           % Nilai perturbasi matriks jacobi
r2 = r;

%% perturbasi matriks jacobi resistivitas lapisan
for i2 = 1:lr
    r2(i2) = (r(i2)*par)+r(i2);
    for i = 1:length(period)
        zxy = csamt_mex(period(i),RY, r2, t, nlayer);
        RA_cal2(i) = (abs(zxy)*abs(zxy))/(mu*w(i));
        phase_cal2(i) = atan2(imag(zxy),real(zxy))*(180/pi);
        %roa2(ii,:) = g;         
    end

    A1(:,i2) = [(RA_cal2'-RA_cal1)/(r(i2)*par)]*r(i2)./RA;
    r2 = r;
end

A = [A1];
