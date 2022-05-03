%%
clc;
clear;
close all;


%% Load Data
unzip('MerchData.zip');
imds = imageDatastore('MerchData', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');


%% Divide the data into training and validation data sets. 
% Use 70% of the images for training and 30% for validation.
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.7,'randomized');

numTrainImages = numel(imdsTrain.Labels);
idx = randperm(numTrainImages,16);
figure
for i = 1:16
    subplot(4,4,i)
    I = readimage(imdsTrain,idx(i));
    imshow(I)
end


%% Load Pretrained Network
net = alexnet;
analyzeNetwork(net);

inputSize = net.Layers(1).InputSize;


%% Replace Final Layers (First Method)
% The last three layers of the pretrained network net are configured for 1000 classes.
% These three layers must be fine-tuned for the new classification problem.
% Extract all layers, except the last three, from the pretrained network.

layersTransfer = net.Layers(1:end-3);
% Transfer the layers to the new classification task by replacing the last three layers
% with a fully connected layer, a softmax layer, and a classification output layer.
% Specify the options of the new fully connected layer according to the new data.
% Set the fully connected layer to have the same size as the number of classes in the new data.
% To learn faster in the new layers than in the transferred layers,
% increase the WeightLearnRateFactor and BiasLearnRateFactor values of the fully connected layer.
numClasses = numel(categories(imdsTrain.Labels));

layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];


%% Replace Final Layers (Second Method)
numClasses = numel(categories(imdsTrain.Labels));
layers = net.Layers;
layers(23) = fullyConnectedLayer(numClasses);
layers(25) = classificationLayer;

% Setup learning rates for fine tuning
layers(end-2).WeightLearnRateFactor = 10;
layers(end-2).BiasLearnRateFactor = 20;


%% Train Network
% The network requires input images of size 227-by-227-by-3,
% but the images in the image datastores have different sizes.
% Use an augmented image datastore to automatically resize the training images.
% Specify additional augmentation operations to perform on the training images:
% randomly flip the training images along the vertical axis,
% and randomly translate them up to 30 pixels horizontally and vertically.
% Data augmentation helps prevent the network from overfitting and memorizing the exact details of the training images.
pixelRange = [-30 30];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);

augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter);

% To automatically resize the validation images without performing further data augmentation,
% use an augmented image datastore without specifying any additional preprocessing operations.
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);

options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');

% Train the network that consists of the transferred and new layers. 
netTransfer = trainNetwork(augimdsTrain,layers,options);


%% Classify Validation Images images using the fine-tuned network.
[YPred,scores] = classify(netTransfer,augimdsValidation);

% Display four sample validation images with their predicted labels.
idx = randperm(numel(imdsValidation.Files),4);
figure
for i = 1:4
    subplot(2,2,i)
    I = readimage(imdsValidation,idx(i));
    imshow(I)
    label = YPred(idx(i));
    title(string(label));
end

%% Calculate the classification accuracy on the validation set.
% Accuracy is the fraction of labels that the network predicts correctly.
YValidation = imdsValidation.Labels;
accuracy = mean(YPred == YValidation);