%% Script to pull, clean, and save raw and masked images
clear

% Masks
orgdir='D:\Sparsh\PURA\Masks\'; % original directory
tardir='D:\Sparsh\PURA\CleanedTopApoMasks\'; % top apo target directory
tardir2='D:\Sparsh\PURA\CleanedBotApoMasks\'; % bot apo target directory
% for each mask, load in, crop, set to uint8, then save as .tif
listing = dir([orgdir '\*.tif']);
for i = 1:size(listing,1)
    % resize to 512 by 512
    tiffile=importdata([orgdir listing(i).name]);
    I = tiffile.cdata;
    I_resize=imresize(I,[512 512]);
    % crop image
    Cropped = imcrop(I_resize, [56 42 352 390]) ; 
    Resized = imresize(Cropped,[512 512]);
    % seperate top and bottom apos
    BW = uint8(255) - Resized; % inverts image
    cc = bwconncomp(BW); % counts the connected components in the binary image
    stats = regionprops(cc, "Area", "Centroid");
    areaVec = [stats.Area];
    [~,idx] = max(areaVec);
    areaVec(idx) = 0;
    [~,idx2] = max(areaVec);
    idx3 = [idx, idx2];
    BW2 = ismember(labelmatrix(cc),idx3);
    cc = bwconncomp(BW2); % counts the connected components in the binary image
    stats = regionprops(cc, "Centroid"); 
    if stats(1).Centroid(2) > stats(2).Centroid(2)
        topApo = ismember(labelmatrix(cc),2);
        botApo = ismember(labelmatrix(cc),1);
    else
        topApo = ismember(labelmatrix(cc),1);
        botApo = ismember(labelmatrix(cc),2);
    end
    % write to cleaned top and bot apo folders
    imwrite(im2uint8(topApo), [tardir listing(i).name]);
    imwrite(im2uint8(botApo), [tardir2 listing(i).name]);
end

% Raw Images
orgdir='D:\Sparsh\PURA\TrainData\RawImages\'; % original directory
tardir='D:\Sparsh\PURA\CleanedRawImages\'; % target directory
% for each raw image, load in, crop, set to uint8, then save as .tif
listing = dir([orgdir '\*.tif']);
for i = 1:size(listing,1)
    % resize to 512 by 512 and make raw image black and white
    I=importdata([orgdir listing(i).name]);
    I_gray=rgb2gray(I);
    I_resize=imresize(I_gray,[512 512]);
    % crop raw image
    Cropped = imcrop(I_resize, [56 42 352 390]) ; 
    Resized = imresize(Cropped,[512 512]);
    % write to cleaned raw image folder
    imwrite(Resized, [tardir listing(i).name]) ;
end
   

    