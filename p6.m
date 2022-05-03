clear;      % Clear MATLAB Workspace Memory
close all;  % Close all Figures and Drawings
clc;        % Clear MATLAB Command Window History

%% 1
a = randn(1,1000).*(1:1000)*0.2;     % random signal with increasing amplitude
y_offset = linspace(-400,200,1000);  % increasing slope to add
s = a + y_offset;                    % the signal
[mins,ind_mins] = min(s);
[maxs,ind_maxs] = max(s);
figure, hold on, grid on
xlabel('time'), ylabel('amplitude')
plot([ind_mins, ind_maxs],[mins maxs],'ys','markersize',20,'MarkerFaceColor','y')
% plot the min and the max first so that the signal plot goes over
plot(s,'k-')
plot([0 1000],[-400, 200],'r-','linewidth',1.5)
axis([0 1000 -600 800])


%% 2
k = rand * (12.6 - (-30.4)) - 30.4;
A = randi([-40, 10],20);
A(A < k) = 0;
mnzA = mean(A(A~=0));
rndA = A(randi(numel(A)));
figure, imagesc(A), axis equal off
c = numel(unique(A));              % how many colours are needed
colormap(rand(c,3))
r = randperm(size(A,1),4);         % rows # to extract
B = A(r,:);
propnzB = mean(B(:)~=0);           % B is reshaped into a vector
disp('A random number between -30.4 and 12.6:'), disp(k)
disp('Mean of all non-zero elements of A:'), disp(mnzA)
disp('A random element of A:'), disp(rndA)
disp('Proportion of non-zero elements of B:'), disp(propnzB)


%% 3
outcomes = randi(6,10000,3);
wins = sum(outcomes(:,1) == outcomes(:,2) & outcomes(:,1) == outcomes(:,3));
win_index = outcomes(:,1) == outcomes(:,2) & outcomes(:,1) == outcomes(:,3);
profit = 10000 - sum((win_index & outcomes(:,1) ~= 1) * 10) - ...
    sum((win_index & outcomes(:,1) == 1) * 50);
disp('Profit = '), disp(profit)


