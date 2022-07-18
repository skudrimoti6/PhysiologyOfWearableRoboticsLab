%% Script to Seperate Top and Bottom Aponeuroses
clear
clc

I = imread("rawim_054.tif");
BW = uint8(255) - I; % inverts image
cc = bwconncomp(BW); % counts the connected components in the binary image
stats = regionprops(cc, "Area", "Centroid") ;
areaVec = [stats.Area];
[~,idx] = max(areaVec);
areaVec(idx) = 0;
[~,idx2] = max(areaVec);
idx3 = [idx, idx2];
BW2 = ismember(labelmatrix(cc),idx3);
cc = bwconncomp(BW2) % counts the connected components in the binary image
stats = regionprops(cc, "Centroid") ;
if stats(1).Centroid(2) > stats(2).Centroid(2)
    topApo = ismember(labelmatrix(cc),2);
    botApo = ismember(labelmatrix(cc),1);
else
    topApo = ismember(labelmatrix(cc),1);
    botApo = ismember(labelmatrix(cc),2);
end
figure(1)
imshow(topApo)
figure(2)
imshow(botApo)

