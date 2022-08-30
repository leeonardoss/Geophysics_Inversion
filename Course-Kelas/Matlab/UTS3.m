%UTS No 3
%Leonardo Budhi Satrio Utomo
%12318011

clc
clear
close all

x=[0 50 100 150 200 250 300 350 400 450 500 550 600 650 700 750 800 850 900 950 1000];
g = [1.94;3.12;4.31;5.72;5.79;5.11;5.03;5.49;5.42;8.06;9.38;7.49;3.75;2.91;2.08;3.35;3.47;5.45;6.14;4.59;2.52];
n = length(x);

x0 = [200 400 500 600 900];
z0 = [200 200 100 500 100];
ra = [100 100 100 100 100];

G = 6.674.*10.^-11;


g1 = (G.*(4/3.*pi.*ra(1).^3.*z0(1))./(((x'-x0(1)).^2+(z0(1)).^2).^(3./2))).*10.^5;
g2 = (G.*(4/3.*pi.*ra(2).^3.*z0(2))./(((x'-x0(2)).^2+(z0(2)).^2).^(3./2))).*10.^5;
g3 = (G.*(4/3.*pi.*ra(3).^3.*z0(3))./(((x'-x0(3)).^2+(z0(3)).^2).^(3./2))).*10.^5;
g4 = (G.*(4/3.*pi.*ra(4).^3.*z0(4))./(((x'-x0(4)).^2+(z0(4)).^2).^(3./2))).*10.^5;
g5 = (G.*(4/3.*pi.*ra(5).^3.*z0(5))./(((x'-x0(5)).^2+(z0(5)).^2).^(3./2))).*10.^5;
mk = [g1 g2 g3 g4 g5];

std = 0.3;
var = std^2;
I = eye(n);
cd = var*I;
cm = var*inv(mk'*mk);
display(cm)
cm_diag = diag(cm);
m_std = sqrt(cm_diag);

w = inv(cd');
m = inv(mk'*w*mk) * (mk'*w*g);
m_cal_stdpos = m + m_std;
m_cal_stdneg = m - m_std;

disp('Rho:')
disp(m)
disp('Rho std:')
disp(m_std)

%%Komentar
%Plot tidak dilakukan karna hanya akan menghasilkan tampilan yang sama
%seperti soal no 1. Karena soal ini hanya berbicara mengenai tingkat dari
%ketidakpastian model yang terbentuk dari data observasi dengan nilai 
%std dev sama untuk semua titik yakni 0.3. 

