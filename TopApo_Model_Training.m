%% Script to Train the Model to Identify the Top Aponeurosis 
clear
clc

% Loads Images
imds = imageDatastore('D:\Sparsh\PURA\CleanedRawImages','FileExtensions',{'.tif'});
classNames = ["apo","background"];
labelIDs   = [0 255];
pxds = pixelLabelDatastore('D:\Sparsh\PURA\CleanedTopApoMasks\*.tif',classNames,labelIDs);
pximds = pixelLabelImageDatastore(imds,pxds,'OutputSizeMode','resize');

% Splits data into training and validation
numFiles = size(pximds.Images,1);
numTrainingFiles = numFiles .* 0.80; % 80% training / 20% test split

% shuffle
pximdsShuf = shuffle(pximds);
% splitting data
pximdsTrain = partitionByIndex(pximdsShuf,[1:numTrainingFiles]);
pximdsTest = partitionByIndex(pximdsShuf,[numTrainingFiles+1:numFiles]);

% imports U-net architecture
lgraph = importdata('D:\Sparsh\PURA\Cronin_Update.mat');
% sets options for model training
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
topApoNet = trainNetwork(pximdsTrain,lgraph,options);

% evaluating the trained network by segmenting a test image and displaying the segmentation result
I = imread('rawim_001.tif');
[C,scores] = semanticseg(I,topApoNet);
B = labeloverlay(I,C);
montage({I,B})
% elvaluating the Data Set Metrics
pxdsTruth = pixelLabelDatastore(pximdsTest.PixelLabelData,classNames,labelIDs);
imds = imageDatastore(pximdsTest.Images);
pxdsResults = semanticseg(imds,topApoNet,'MiniBatchSize',2,"WriteLocation",tempdir);
metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTruth);