%% Script to Seperate Top and Bottom Aponeuroses
clear
clc

I = imread("rawim_003.tif");
BW = uint8(255) - I; % inverts image
cc = bwconncomp(BW) % counts the connected components in the binary image
stats = regionprops(cc, "Area", "Centroid") 
numOfObjects = size(stats);
areaVec = []
for i = 1:numOfObjects(1)
    areaVec = [areaVec, stats(i).Area]
end
[~,apo1Ind] = max(areaVec)
areaVec(apo1Ind) = -1
[~,apo2Ind] = max(areaVec)
% makes vector of centroids of objects with the two greatest areas
centroidVec = [stats(apo1Ind).Centroid(2) stats(apo2Ind).Centroid(2)]
[topApoCent,topApoInd] = max(centroidVec) 
[botApoCent,botApoInd] = min(centroidVec) 

topApo = ismember(labelmatrix(cc),topApoInd)
botApo = ismember(labelmatrix(cc),botApoInd)
topApo = im2uint8(topApo); 
botApo = im2uint8(botApo);
figure(1)
imshow(topApo)
figure(2)
imshow(botApo)
