function[A] = jacobian_CSAMT(period,r,t,lr,lt,RA,RA_cal1)
RY = 5000; %jarak titik sounding dari transmitter
nlayer = length(r);
frekuensi = 1./period;


mu = 4*pi*10.^(-7);                  % Permeabilitas magnetik (H/m)  
w = 2*pi.*frekuensi;                 % Frekuensi Sudut (Radians);

par = 0.1;
r2 = r;
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

thk2 = t; %thk= t = m(1+lr:lr+lt)
for i3 = 1:lt
    thk2(i3) = (t(i3)*par)+t(i3);
    for i = 1:length(period)
        zxy = csamt_mex(period(i),RY, r, thk2, nlayer);
        RA_cal3(i) = (abs(zxy)*abs(zxy))/(mu*w(i));
        phase_cal3(i) = atan2(imag(zxy),real(zxy))*(180/pi);
    end

    A2(:,i3) = [(RA_cal3'-RA_cal1)/(t(i3)*par)]*t(i3)./RA;
    thk2 = t;
end
A = [A1 A2];
