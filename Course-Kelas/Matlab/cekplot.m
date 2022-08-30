% Fake data
x = randn(500,1);
y = randn(500,1);
z =  3*(1-x).^2.*exp(-(x.^2) - (y+1).^2) ...
   - 10*(x/5 - x.^3 - y.^5).*exp(-x.^2-y.^2) ...
   - 1/3*exp(-(x+1).^2 - y.^2); % peaks
% Plot
tri = delaunay(x,y);
tricontour(tri,x,y,z,-6:6);
hold on;
scatter(x,y,[],z,'filled');