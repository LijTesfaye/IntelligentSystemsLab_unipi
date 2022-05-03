 %%
clc;
clear;
close all;


%% Prepare Data
% Data for classification problems are set up for a neural network
% by organizing the data into two matrices, the input matrix X and the target matrix T.
dataset = load('datasets/dataset_classification.mat');
dataset = table2array(dataset.dataset);
x = dataset(:, 1:end-1)';
t = dataset(:, end)';


%% Dataset cleaning: remove classes with a small number of samples
y = [];
for i = 1 : max(t)
    y(i) = sum(t == i);
end

idxs = [];
for i = 1 : numel(y)
    if y(i) < floor(mean(y))
        idxs = [idxs find(t == i)];
    end
end

x(:, idxs) = [];
t(idxs) = [];


%% Subsampling of classes to balance the number of samples for each class 
t = t - (min(t) -  1);
y = [];
for i = 1 : max(t)
    y(i) = sum(t == i);
end

rand_idxs = [];
for i = 1 : max(t)
    rand_idxs(:, i) = randsample(find(t == i), min(y));
end
c = cat(1, rand_idxs(:, 1), rand_idxs(:, 2), rand_idxs(:, 3));
t = t(c);
x = x(:, c);


%% One-hot encoding
t = full(ind2vec(t));


%% Matlab Dataset (cleaned) 
%[x,t] = wine_dataset;


%% Pattern Recognition with a Neural Network
net = patternnet(10);
view(net);
[net, tr] = train(net, x, t);
plotperform(tr);


%% Test the Network
% The mean squared error of the trained neural network can now be measured with respect to the testing samples.
% This will give us a sense of how well the network will do when applied to data from the real world.
% The network outputs will be in the range 0 to 1,
% so we can use vec2ind function to get the class indices as the position
% of the highest element in each output vector.
testX = x(:, tr.testInd);
testT = t(:, tr.testInd);

testY = net(testX);
testIndices = vec2ind(testY);


% Another measure of how well the neural network has fit the data is the confusion plot.
% The confusion matrix shows the percentages of correct and incorrect classifications.
% Correct classifications are the green squares on the matrices diagonal.
% Incorrect classifications form the red squares.

% If the network has learned to classify properly,
% the percentages in the red squares should be very small, indicating few misclassifications.
plotconfusion(testT, testY);

% Here are the overall percentages of correct and incorrect classification.
[c, cm] = confusion(testT, testY);
fprintf('Percentage Correct Classification: %f%%\n', 100*(1-c));
fprintf('Percentage Incorrect Classification: %f%%\n', 100*c);

% A third measure of how well the neural network has fit data is the receiver operating characteristic plot.
% This shows how the false positive and true positive rates relate as the thresholding of outputs is varied from 0 to 1.
% The farther left and up the line is, the fewer false positives need to be accepted
% in order to get a high true positive rate.
% The best classifiers will have a line going from the bottom left corner,
% to the top left corner, to the top right corner, or close to that.
figure;
plotroc(testT, testY);
