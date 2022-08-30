%Pemodelan Inversi Non-Linier dengan pendekatan Random Search
%Leonardo Budhi Satrio Utomo
%12318011

clc
close all
clear

%%
x0 = 65; %posisi x untuk event gempa
y0 = 27; %posisi y untuk event gempa
z0 = 15; %posisi z untuk event gempa
%%
fileID = fopen('gelombang_gempa.txt','r');
data = fscanf(fileID,'%d %d %d %f', [4 inf]);
data=data';


x = data(:,1);
y = data(:,2);
z = data(:,3);
%z0 = data(1,4);
tobs = data(:,4);
vp = 7.2;

xmax = (1:1:100); %batas ruang model x
ymax = (1:1:100); %batas ruang model y

nx = 0.25*length(xmax); %jumlah sampel x
ny = 0.25*length(ymax); %jumlah sampel y
n = 0.1*length(xmax)*length(ymax);
xx = (0:2:100);
yy = (0:2:100);


min_e = inf; %nilai minimum erms
for i = 1:n
    %mx(i) = (length(xmax)/nx)*randi([0 nx]); 
    %my(i) = (length(ymax)/ny)*randi([0 ny]);
    mx(i) = randi(100); %xx(randi(50))
    my(i) = randi(100); %yy(randi(50))
    for a=1:length(x)
        tcal(a) = ((sqrt((x(a)-mx(i)).^2+(y(a)-my(i)).^2))/vp);
        
    end
    misfit = (tobs-tcal').^2;
    erms(i) = sqrt(mean(misfit));
end

for i=1:length(erms)
    if erms(i)<min_e
        min_e=erms(i);
        loc_x=mx(i);
        loc_y=my(i);
    end
end

sprintf('lokasi episenter gempa(x,y): %d,%d',loc_x,loc_y)
sprintf('erms min: %3.4f',min(erms,[],'all'))

[X,Y] = meshgrid(xmax,ymax);
f = scatteredInterpolant(mx',my',erms'); %interpolasi nilai erms dari data sampel
Z = f(X,Y);

figure
contourf(X,Y,Z,20) %plot nilai erms dalam kontur
axis tight
hold on
plot3(mx,my,erms,'.','MarkerSize',15) %plot titik sample
plot(x0,y0,'pr','MarkerSize',15)
plot(loc_x,loc_y,'hy','MarkerSize',15)
plot(x,y,'vk','MarkerSize',10)
title('Nilai Persebaran Misfit Metode Random Search')
xlabel('x')
ylabel('y')
zlabel('Erms')
legend('Erms','Titik sampel','Lokasi Episenter Asli','Lokasi Episenter Inversi','Stasiun')
colorbar %color bar sebagai legenda dari warna


        




