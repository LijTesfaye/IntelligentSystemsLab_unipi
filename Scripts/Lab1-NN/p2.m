 %%
clc;
clear;
close all;


%% Dataset
% number of samples of each class
K = 100;

% radius of circle
r = 0.2;

Px = [];
Py = [];
cx = [0.1 0.9 0.9 0.1 0.5];
cy = [0.9 0.1 0.9 0.1 0.5];

for i = 1 : numel(cx)
    x = cx(i);
    y = cy(i);
    [Px(i, :), Py(i, :)] = rand_circ(K, x, y, r);
end

% plot classes
plot(Px(1, :), Py(1, :),'k+')
hold on
grid on
plot(Px(2, :), Py(2, :),'b*')
plot(Px(3, :), Py(3, :),'gx')
plot(Px(4, :), Py(4, :),'md')
plot(Px(5, :), Py(5, :),'r+')

% text labels for classes
text(cx(1), cy(1),'Class A')
text(cx(2), cy(2),'Class B')
text(cx(3), cy(3),'Class C')
text(cx(4), cy(4),'Class D')
text(cx(5), cy(5),'Class E')

% coding (+1/-1) of 5 separate classes
a = [-1 -1 -1 +1 -1]';
b = [-1 -1 +1 -1 -1]';
c = [-1 +1 -1 -1 -1]';
d = [+1 -1 -1 -1 -1]';
e = [-1 -1 -1 -1 +1]';

A = [Px(1, :); Py(1, :)];
B = [Px(2, :); Py(2, :)];
C = [Px(3, :); Py(3, :)];
D = [Px(4, :); Py(4, :)];
E = [Px(5, :); Py(5, :)];
X = [A B C D E];

% define targets
T = [repmat(a,1,length(A)) repmat(b,1,length(B)) ...
     repmat(c,1,length(C)) repmat(d,1,length(D)) repmat(e,1,length(E))];

%save('datasets/dataset_mlp.mat', 'X', 'T');


%% MLP
% Init MLP network with 5 hidden neurons.
net = feedforwardnet(5);
view(net)

% Now the network is ready to be trained.
% The samples are automatically divided into training, validation and test sets.
% The training set is used to teach the network.
% Training continues as long as the network continues improving on the validation set.
% The test set provides a completely independent measure of network accuracy.
[net, tr] = train(net, X, T);


% Network's performance
% Performance is measured in terms of mean squared error, and shown in log scale. 
% It rapidly decreased as the network was trained.
% Performance is shown for each of the training, validation, and test sets.
% The final network is the network that performed best on the validation set.
plotperform(tr);


%% Testing the Neural Network
% The mean squared error of the trained neural network can now be measured with respect to the testing samples.
% This will give us a sense of how well the network will do when applied to data from the real world.
testX = X(:,tr.testInd);
testT = T(:,tr.testInd);

testY = net(testX);

perf = mse(net, testT, testY);


%% Plot classification result for the complete input space
% generate a grid
span = -1:.01:2;
[P1,P2] = meshgrid(span, span);
pp = [P1(:) P2(:)]';
% simualate neural network on a grid
aa = net(pp);
% plot classification regions based on MAX activation
figure(1)
m = mesh(P1,P2,reshape(aa(1,:),length(span),length(span))-5);
set(m,'facecolor',[1 0.2 .7],'linestyle','none');
hold on
m = mesh(P1,P2,reshape(aa(2,:),length(span),length(span))-5);
set(m,'facecolor',[1 1.0 0.5],'linestyle','none');
m = mesh(P1,P2,reshape(aa(3,:),length(span),length(span))-5);
set(m,'facecolor',[.4 1.0 0.9],'linestyle','none');
m = mesh(P1,P2,reshape(aa(4,:),length(span),length(span))-5);
set(m,'facecolor',[.3 .4 0.5],'linestyle','none');
m = mesh(P1,P2,reshape(aa(5,:),length(span),length(span))-5);
set(m,'facecolor',[.1 .3 0.5],'linestyle','none');
view(2)
% plot classes
plot(Px(1, :), Py(1, :),'k+')
hold on
grid on
plot(Px(2, :), Py(2, :),'b*')
plot(Px(3, :), Py(3, :),'gx')
plot(Px(4, :), Py(4, :),'md')
plot(Px(5, :), Py(5, :),'r+')

% text labels for classes
text(cx(1), cy(1),'Class A')
text(cx(2), cy(2),'Class B')
text(cx(3), cy(3),'Class C')
text(cx(4), cy(4),'Class D')
text(cx(5), cy(5),'Class E')



%%
function [X,Y] = rand_circ(N, x, y, r)
    % Generates N random Points in a circle.
    Ns = round(1.28*N + 2.5*sqrt(N) + 100);
    X = rand(Ns,1)*(2*r) - r;
    Y = rand(Ns,1)*(2*r) - r;
    I = find(sqrt(X.^2 + Y.^2)<=r);
    X = X(I(1:N)) + x;
    Y = Y(I(1:N)) + y;
end