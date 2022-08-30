clc
clear
close all

z = [1 2 3 4 5 6 7 8 9 10];
T = [30 24 25 25 26 28 29 30 32 33];
n = length(z);

plot (z,T,'.m','markersize',20);
axis([0 12 20 40]);
xlabel('z(m)');
ylabel('T (deg. C)');
hold on

g = [1 1 1 1 1 1 1 1 1 1 ; 1 2 3 4 5 6 7 8 9 10];
G = g';
d = T';
m = inv(G'*G)*(G'*d);
dcal = G*m;
plot(z,dcal,'r--','LineWidth',2);
hold on

s = [1 .1 .2 .2 .3 .1 .2 .2 .1 .3];
v = zeros(n:n);
v = diag(s.^2);
W = inv(v');
m = inv(G' * W * G)*(G' * W * d);
dw = G*m;
plot(z,dw,'b','LineWidth',2);
