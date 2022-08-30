x = [1 2 3 4 5 6 7 8 9 10];
y = [4 4 5 6 6 7 7 8 8 11];

plot (x,y,'*');
% axis ([0 12 0 12])
hold on;

p = polyfit(x,y,1);
a = p(2);
b = p(1);
ycal = a+b*x;
plot(x,ycal,'-');