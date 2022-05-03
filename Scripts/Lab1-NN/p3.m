 %%
clc;
clear;
close all;


%% Preparing the Data
% Data for function fitting problems are set up for a neural network
% by organizing the data into two matrices, the input matrix X and the target matrix T.
% Each column of the target matrix will have one element.
dataset = load('datasets/dataset_regression.mat');
dataset = table2array(dataset.dataset);
X = dataset(:, 1:end-1)';
T = dataset(:, end)';

% We can view the sizes of inputs X and targets T.
size(X)
size(T)


%% Fitting a Function with a Neural Network
% Since the neural network starts with random initial weights,
% the results of this example will differ slightly every time it is run.
% The random seed is set to avoid this randomness.
% However this is not necessary for your own applications.
setdemorandstream(491218382);

% Two-layer (i.e. one-hidden-layer) feed forward neural networks can fit
% any input-output relationship given enough neurons in the hidden layer.
% Layers which are not output layers are called hidden layers.
% We will try a single hidden layer of 15 neurons for this example.
% In general, more difficult problems require more neurons, and perhaps more layers.
% Simpler problems require fewer neurons.
% The input and output have sizes of 0 because the network
% has not yet been configured to match our input and target data.
% This will happen when the network is trained.
net = fitnet(15);
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

% Another measure of how well the neural network has fit the data is the regression plot.
% The regression plot shows the actual network outputs plotted in terms of the associated target values.
% If the network has learned to fit the data well,
% the linear fit to this output-target relationship should closely intersect the bottom-left and top-right corners of the plot.
Y = net(X);

plotregression(T, Y);

% Another third measure of how well the neural network has fit data is the error histogram.
% This shows how the error sizes are distributed.
% Typically most errors are near zero, with very few errors far from that.
e = T - Y;
figure;
ploterrhist(e);