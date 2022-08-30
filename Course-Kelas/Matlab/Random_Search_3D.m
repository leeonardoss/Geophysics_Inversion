%Pemodelan Inversi Non-Linier dengan pendekatan Random Search
%Leonardo Budhi Satrio Utomo
%12318011

clc
close all
clear

x0 = 65; %posisi x untuk event gempa
y0 = 27; %posisi y untuk event gempa
z0 = 15; %posisi z untuk event gempa

fileID = fopen('gelombang_gempa3d.txt','r');
data = fscanf(fileID,'%d %d %d %d %f', [5 inf]);
data=data';


x = data(:,1);
y = data(:,2);
z = data(:,3);
z0 = data(1,4);
tobs = data(:,5);
vp = 7.2;

xmax = (1:1:100); %batas ruang model x
ymax = (1:1:100); %batas ruang model y
zmax = (1:1:50); %batas ruang model z

nx = 0.25*length(xmax); %jumlah sampel x
ny = 0.25*length(ymax); %jumlah sampel y
nz = ceil(0.25*length(zmax)); %jumlah sampel z
n = 0.1*length(xmax)*length(ymax)*length(zmax);
xx = (0:2:100);
yy = (0:2:100);
zz = (0:2:50);


min_e = 1; %nilai minimum erms
for i = 1:n
%     mx(i) = (length(xmax)/nx)*randi([0 nx]);
%     my(i) = (length(ymax)/ny)*randi([0 ny]);
%     mz(i) = (length(zmax)/nz)*randi([0 nz]);
    mx(i) = randi(100); %xx(rand(50))
    my(i) = randi(100); %yy(rand(50))
    mz(i) = randi(50); %zz(randi(25))
    for a=1:length(x)
        tcal(a) = ((sqrt((x(a)-mx(i)).^2+(y(a)-my(i)).^2+mz(i).^2))/vp);
        
    end
    misfit = (tobs-tcal').^2;
    erms(i) = sqrt(mean(misfit));
end

for i=1:length(erms)
    if erms(i)<min_e
        min_e=erms(i);
        loc_x=mx(i);
        loc_y=my(i);
        loc_z=mz(i);
    end
end

sprintf('lokasi episenter gempa(x,y,z): %d,%d,%d',loc_x,loc_y,loc_z)
sprintf('erms min: %3.4f',min(erms,[],'all'))

[X,Y,Z] = meshgrid(xmax,ymax,zmax);
f = scatteredInterpolant(mx',my',mz',erms'); %interpolasi nilai erms dari data sampel
T = f(X,Y,Z);
for k=1:length(zmax)
    figure()
    contourf(xmax,ymax,T(:,:,k),20)
    colorbar
end


%Plot hasil grid search
plot_gs = figure;
scatter3(loc_x,loc_y,loc_z,200,'r','p','filled')
hold on
scatter3(x0,y0,z0,200,'yellow','p','filled')
hold on
scatter3(x,y,z,200,'vk','filled')
hold on

xlim([0 100]);
ylim([0 100]);
zlim([-5 50]);
set(gca,'zdir','reverse');



% figure
% contourf(X,Y,T) %plot nilai erms dalam kontur
% axis tight
% hold on
% plot3(mx,my,mz,erms,'.','MarkerSize',15) %plot titik sample
% title('Nilai Persebaran Misfit Metode Random Search')
% xlabel('x')
% ylabel('y')
% zlabel('Erms')
% colorbar %color bar sebagai legenda dari warna
