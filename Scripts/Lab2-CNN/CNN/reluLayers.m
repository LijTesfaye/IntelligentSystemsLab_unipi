filter = [1 0;1 1];
x = linspace(-8,8);
y = x;
y(y<0) = 0;
plot(x, y);
title('reluLayer');
xlabel('Input');
ylabel('reluLayer');
grid on;

figure;
filter = [1 0;1 1];
x = linspace(-8,8);
y = x;
y(y<0) = 0.01*x(y<0);
plot(x, y);
title('leaky reluLayer');
xlabel('Input');
ylabel('reluLayer');
grid on;