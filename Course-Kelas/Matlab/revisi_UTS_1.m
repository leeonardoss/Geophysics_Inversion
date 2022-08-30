x=[0 50 100 150 200 250 300 350 400 450 500 550 600 650 700 750 800 850 900 950 1000];
g = [1.94;3.12;4.31;5.72;5.79;5.11;5.03;5.49;5.42;8.06;9.38;7.49;3.75;2.91;2.08;3.35;3.47;5.45;6.14;4.59;2.52];
xplot = [0:1:1000];
x0 = [200 400 500 600 900];
z0 = [200 200 100 500 100];
ra = [100 100 100 100 100];

G = 6.674.*10.^-11;

mk = zeros(length(x),length(x0));

for i = 1:length(x)
    for j = 1:length(x0)
        mk(i,j) = (G*(4/3).*pi.*ra(j).^3.*z0(j)/(((x(i)-x0(j)).^2+z0(j).^2).^(3/2))).*10.^5;
    end
end

m = inv(mk'*mk)*mk'*g;

disp(m)
gcal = mk*m;

%%
%Hitung ERMS
delta_g = g - gcal;
ERMS = sqrt(mean(delta_g.^2));
disp(ERMS)

%%
figure
plot(x,g,'ob')
hold on
plot(x,gcal,'-r')
title('Model gravitasi 2 Dimensi')
xlabel('Distance (m)','fontweight','bold')
ylabel('Gravitasi (mGal)','fontweight','bold')
legend('Data observasi','Hasil pemodelan inversi')

dim = [.2 .1 .2 .1];
str1 = ("Erms: ");
str2 = ERMS;
annotation('textbox',dim,'String',str1+str2,'FitBoxToText','on');