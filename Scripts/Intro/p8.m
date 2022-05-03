clear;      % Clear MATLAB Workspace Memory
close all;  % Close all Figures and Drawings
clc;        % Clear MATLAB Command Window History

%% A piece of code needed for all sub-problems
noteFrequency = [261.63 293.66 329.63 349.23 392.00 440.00 493.88 523.25];
fs = 8000;          % sampling frequency


%% 1
y = [];
T = 1;              % time in seconds
t = 0:1/fs:T;
A = (T - t) / T;    % fading amplitude
for i = 1:8
    no = noteFrequency(i);
    s = A .* (sin(2*pi*t*no) + 0.2*(sin(pi*t*no) + sin(4*pi*t*no)));
    y = [y, 0 s];
end
sound(y,fs)


%% 2
y = [];
T = 1;
t = 0:1/fs:T;
A = (T - t) / T;
for i = 1:8
    no = noteFrequency(i);
    noback = noteFrequency(9-i);
    s1 = A .* (sin(2*pi*t*no) + 0.2*(sin(pi*t*no) + sin(4*pi*t*no)));
    s2 = A .* (sin(4*pi*t*noback) + 0.2*(sin(2*pi*t*noback) + sin(8*pi*t*noback)));
    y = [y, 0 0.8 * s1 + 0.2 * s2];
end
sound(y,fs)
audiowrite('scales_harmony.wav',y,fs);
yb = y;    % save the signal for the plot in 2(d)


%% 3
y = [];
T = linspace(1,0.1,8);
fs = 8000;
for i = 1:8
    t = 0:1/fs:T(i);
    no = noteFrequency(i);
    noback = noteFrequency(9-i);
    A = (T(i) - t) / T(i);     % amplitude is specific for duration T(i)
    no = noteFrequency(i);
    noback = noteFrequency(9-i);
    s1 = A .* (sin(2*pi*t*no) + 0.2*(sin(pi*t*no) + sin(4*pi*t*no)));
    s2 = A .* (sin(4*pi*t*noback) + 0.2*(sin(2*pi*t*noback) + sin(8*pi*t*noback)));
    y = [y, 0 0.8 * s1 + 0.2 * s2];
end
sound(y,fs)


%% 4
% fs per second, fs/1000 per milisecond, round(30*fs/1000) per 30 ms
N = round(30*fs/1000);     % number of samples corresponding to 30 ms
X = linspace(0,30,N);      % prepare x-axis
figure, plot(X,yb(1:N),'k-')
set(gca,'FontName','Candara','FontSize',12)
title('The first 30 ms of the harmony scale signal')
xlabel('time [ms]')
ylabel('sound signal')