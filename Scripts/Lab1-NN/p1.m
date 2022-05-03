 %%
clc;
clear;
close all;


%% 1
% Each of the four column vectors in X defines a two-element input vectors and 
% a row vector T defines the vector's target categories.
% We can plot these vectors with PLOTPV.
X = [-0.5 -0.5 +0.3 -0.1;  ...
     -0.5 +0.5 -0.5 +1.0];
T = [1 1 0 0];
plotpv(X, T);

% Creates a new neural network with a single neuron.
% The network is then configured to the data, so we can examine its initial weight and bias values. 
% (Normally the configuration step can be skipped as it is automatically done by ADAPT or TRAIN.)
net = perceptron;
net = configure(net, X, T);

% The input vectors are replotted with the neuron's initial attempt at classification.
% The initial weights are set to zero, so any input gives the same output and 
% the classification line does not even appear on the plot. We are going to
% train it.
plotpv(X,T);
plotpc(net.IW{1}, net.b{1});

% Here the input and target data are converted to sequential data
% (cell array where each column indicates a timestep) and copied three times to form the series XX and TT.
% ADAPT updates the network for each timestep in the series and returns
% a new network object that performs as a better classifier, the network output, and the error.
XX = repmat(con2seq(X), 1, 3);
TT = repmat(con2seq(T), 1, 3);
net = adapt(net, XX, TT);
plotpc(net.IW{1}, net.b{1});

% Now NET is used to classify any other input vector, like [0.7; 1.2].
% A plot of this new point with the original training set shows how the network performs.
% To distinguish it from the training set, color it red.
x = [0.7; 1.2];
y = net(x);
plotpv(x, y);
point = findobj(gca, 'type', 'line');
point.Color = 'red';

% Turn on "hold" so the previous plot is not erased and plot the training set and the classification line.
% The perceptron correctly classified our new point (in red) as category "zero"
% (represented by a circle) and not a "one" (represented by a plus).
hold on;
plotpv(X,T);
plotpc(net.IW{1},net.b{1});
hold off;


%% 2
% 1 input vector is much larger than all of the others.
X = [-0.5 -0.5 +0.3 -0.1 -40; -0.5 +0.5 -0.5 +1.0 50];
T = [1 1 0 0 1];
plotpv(X, T);

net = perceptron;
% perceptron('hardlim', 'learnpn') creates a new network with LEARPN learning rule,
% which is less sensitive to large variations in input vector size than LEARNP (the default).
%net = perceptron('hardlim', 'learnpn');
net = configure(net,X,T);

hold on;
linehandle = plotpc(net.IW{1},net.b{1});

% This loop adapts the network and plots the classification line, until the error is zero.
E = 1;
while (sse(E))
   [net, Y, E] = adapt(net, X, T);
   linehandle = plotpc(net.IW{1}, net.b{1}, linehandle);
   drawnow;
end

% Note that it took the perceptron three passes to get it right.
% This a long time for such a simple problem.
% The reason for the long training time is the outlier vector.
% Despite the long training time, the perceptron still learns properly and can be used to classify other inputs.
x = [0.7; 1.2];
y = net(x);
plotpv(x, y);
circle = findobj(gca, 'type', 'line');
circle.Color = 'red';

hold on;
plotpv(X,T);
plotpc(net.IW{1},net.b{1});
hold off;

axis([-2 2 -2 2]);