clc
clear
close all

d = [2.0;2.5;3.0;3.5;4.0;4.5;5.0;5.5;6.0];
Vp = [2.1 2.2 2.3 2.4 2.4 2.5 2.6 2.6 2.7];


g = [ones(length(Vp),1), Vp'];

%%
m = inv(g'*g)*g'*d;
dcal = g*m;

%%
figure
plot(Vp, d, '.k','markersize',10);
hold on
plot(Vp, dcal, '-b','linewidth',2);
hold on
% title('Inversi Linier');
% xlabel('Vp');
% ylabel('D');
% hold on

erms = sqrt(sum(dcal-d)/length(d));
fprintf("Error rms a: %s",erms)
lse = sum((dcal-d).^2);
fprintf("Error lse a: %s",lse)

dim = [.2 .1 .2 .7];
str1 = {"Erms a: "+erms,"lse a: "+ lse};
%str2 = {"lse: ", lse};
annotation('textbox',dim,'String',str1,'FitBoxToText','on');
hold on

%%
[m,n] = size(g'*g);
mref = [2.0;1.0];
eps = 0.01;
m = mref + inv(g'*g+eps*eye(m))*g'*(d-g*mref);
dcal = g*m;

% plot(Vp, d, '.k','markersize',10);
% hold on
plot(Vp, dcal, '--c','linewidth',2);
hold on
title('Inversi Linier');
xlabel('Vp');
ylabel('D');

erms = sqrt(sum(dcal-d)/length(d));
fprintf("Error rms b: %s",erms)
lse = sum((dcal-d).^2);
fprintf("Error lse b: %s",lse)

dim = [.2 .1 .2 .6];
str1 = {"Erms b: "+erms,"lse b: "+ lse};
%str2 = {"lse: ", lse};
annotation('textbox',dim,'String',str1,'FitBoxToText','on');
hold on

%%
s = [.5 .5 .5 .5 .1 .5 .5 .1 .5];
v = zeros(n:n);
v = diag(s.^2);
W = inv(v');
m = inv(g' * W * g)*(g' * W * d);
dw = g*m;
figure
plot(Vp, d, '.k','markersize',10);
hold on
plot(Vp,dw,'-b','LineWidth',2);