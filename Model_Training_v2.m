% function Model_Training()
clear
clc

% Loads Images
imds = imageDatastore('D:\Sparsh\PURA\CleanedRawImages','FileExtensions',{'.tif'});
classNames = ["apo","background"];
labelIDs   = [0 255];
pxds = pixelLabelDatastore('D:\Sparsh\PURA\CleanedMasks\*.tif',classNames,labelIDs);
pximds = pixelLabelImageDatastore(imds,pxds,'OutputSizeMode','resize');

% Splits data into training and validation
numFiles = size(pximds.Images,1);
numTrainingFiles = numFiles .* 0.80; % 80% training / 20% test split

% shuffle
pximdsShuf = shuffle(pximds);
% splitting data
pximdsTrain = partitionByIndex(pximdsShuf,[1:numTrainingFiles]);
pximdsTest = partitionByIndex(pximdsShuf,[numTrainingFiles+1:numFiles]);


lgraph = importdata('D:\Sparsh\PURA\Cronin_Update.mat');

% find option to pass in traning vs testing: Validation Data, but only
% passes in training data
options = trainingOptions('adam', ...
    'ValidationData', pximdsTest, ...
    'Shuffle', 'every-epoch',...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.1, ...
    'LearnRateDropPeriod',10, ...
    'ValidationPatience', 8, ...
    'MaxEpochs',60, ...
    'ValidationFrequency', 196, ...
    'MiniBatchSize',2, ...
    'Plots','training-progress');

% trains the network
net = trainNetwork(pximdsTrain,lgraph,options);

% evaluating the trained network by segmenting a test image and displaying the segmentation result
I = imread('rawim_001.tif');
[C,scores] = semanticseg(I,net);
B = labeloverlay(I,C);
montage({I,B})



% end