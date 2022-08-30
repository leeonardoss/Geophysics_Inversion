clear all; clc;
close all

a = 2;
b = 4;

x = (1:.5:100);
y = a+b*x;
plot (x,y,'*')