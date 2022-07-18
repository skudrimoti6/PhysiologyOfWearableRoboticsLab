% function Model_Training()

addpath D:\Sparsh\PURA\CleanedMasks
addpath D:\Sparsh\PURA\CleanedRawImages
 
% Loads Images
%labelDir = fullfile('c:\','Users','spars','Documents','PURA','CleanedMasks');
labelDir = fullfile('D:\','Sparsh','PURA','CleanedMasks');
%imageDir = fullfile('c:\','Users','spars','Documents','PURA', 'CleanedRawImages'); 
imageDir = fullfile('D:\','Sparsh','PURA','CleanedRawImages');
imds = imageDatastore(imageDir,'FileExtensions',{'.tif'});
classNames = ["apo" "background"];
labelIDs   = [0 255];
pxds = pixelLabelDatastore(labelDir,classNames,labelIDs);
pximds = pixelLabelImageDatastore(imds,pxds);

% Splits data into training and validation
numFiles = size(dir([labelDir '/*.tif']),1);
numTrainingFiles = numFiles .* 0.80; % 80% training / 20% test split

% shuffle
pximdsShuf = shuffle(pximds);
% splitting data
pximdsTrain = partitionByIndex(pximdsShuf,[1:numTrainingFiles]);
pximdsTest = partitionByIndex(pximdsShuf,[numTrainingFiles+1:numFiles]);

% net = importKerasNetwork('model-apo2-nc.h5');
% lgraph = layerGraph(net);
% lgraph = removeLayers(lgraph,'BinaryCrossEntropyRegressionLayer_conv2d_19');
% lgraph = addLayers(lgraph,softmaxLayer);
% lgraph = connectLayers(lgraph,'conv2d_19_sigmoid','softmax');
% lgraph = addLayers(lgraph,pixelClassificationLayer);
% lgraph = connectLayers(lgraph,'softmax','classoutput');
Sparshnet = importdata('D:\Sparsh\PURA\Sparshnet.mat');
% plot(lgraph)

% find option to pass in traning vs testing: Validation Data, but only
% passes in training data
options = trainingOptions('adam',...
    'ValidationData', pximdsTest,...
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
net_both = trainNetwork(pximdsTrain,Sparshnet,options)

save('D:\Sparsh\PURA\TrainedNetwork_Both.mat',net_both) 


% end