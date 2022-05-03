%% Demo of classifying images with the googlenet pre-trained network
% You must install the googlenet Add-On for this demo.


%% Load the pretrained network
net = googlenet;
% display the 144 layer network
net

%% The pepper
% Read the image to classify 
I = imread('peppers.png');

sz = net.Layers(1).InputSize;
I = I(1:sz(1),1:sz(2),1:sz(3)); 

[label, scorePeppers] = classify(net, I);

figure('Name', 'Pepper');
imshow(I); 
title(label);

plot(1:length(scorePeppers),scorePeppers);
title('Peppers');
xlabel('Category');
ylabel('Score');

% What other categories are similar?
disp('Categories with highest scores for Peppers:')
kPos = find(scorePeppers>0.01);
[vals,kSort] = sort(scorePeppers(kPos),'descend');
for k = 1:length(kSort)
    fprintf('%13s:\t%g\n',net.Layers(end).Classes(kPos(kSort(k))),vals(k));
end


%% First, an image of a cat
% Adjust size of the image 
I0 = imread('Cat.png');
I  = imresize(I0,[224 224]);

% Classify the image using GoogleNet 
[label, scoreCat] = classify(net, I);

% Show the image and the classification results 
figure('Name', 'Tabby Cat');
ax = gca;
imshow(I);
title(ax,label);

plot(1:length(scoreCat),scoreCat);
title('Tabby Cat');
xlabel('Category');
ylabel('Score');

% What other categories are similar?
disp('Categories with highest scores for Cat:')
kPos = find(scoreCat>0.01);
[vals,kSort] = sort(scoreCat(kPos),'descend');
for k = 1:length(kSort)
    fprintf('%20s:\t%g\n',net.Layers(end).Classes(kPos(kSort(k))),vals(k));
end


%% Test a picture of a box
% This shiny metal box gets identified as an iPod

% Read and adjust size of the image 
I0 = imread('Box.jpg');
I  = imresize(I0,[224 224]);

% Classify the image using GoogleNet 
[label, scoreBox] = classify(net, I);

% Show the image and the classification results 
figure('Name', 'Box');
ax = gca;
imshow(I) 
title(ax,label);

plot(1:length(scoreBox),scoreBox);
title('Box');
xlabel('Category');
ylabel('Score');
      
% What other categories are similar?
disp('Categories with highest scores for Box:')
kPos = find(scoreBox>0.01);
[vals,kSort] = sort(scoreBox(kPos),'descend');
for k = 1:length(kSort)
    fprintf('%20s:\t%g\n',net.Layers(end).Classes(kPos(kSort(k))),vals(k));
end


%% A summary
disp('GoogleNet results summary:')
fprintf('\nPepper  %12.4f\nCat     %12.4f\nBox     %12.4f\n\n',...
    max(scorePeppers),max(scoreCat),max(scoreBox));