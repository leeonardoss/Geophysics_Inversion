clear all; clc;
close all
r = 250
z = 300
x = 500
rho = 3000

xi = 0:100:1000
zi = 0
g =  6.72 * 10.^(-11)*(4/3*pi*r.^3*rho*z)./(((xi-x).^2+(zi-z).^2).^(3/2))*10.^5
plot(xi, g)

