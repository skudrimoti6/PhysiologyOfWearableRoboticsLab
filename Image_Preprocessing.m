%function Image_Preprocessing()

%DatasetPath = fullfile('c:\','Users','spars','Documents','PURA','Masks');
DatasetPath = fullfile('D:\','Sparsh','PURA','Masks');
DatasetPathDir = dir(DatasetPath)
DatasetPathDir = DatasetPathDir(~[DatasetPathDir.isdir])
destdirectory = 'D:\Sparsh\PURA\CleanedMasks';
if isfolder('CleanedMasks')
    rmdir CleanedMasks s;
end
mkdir(destdirectory);
for k = 1:length(DatasetPathDir)
    filename = fullfile(DatasetPath, DatasetPathDir(k).name);
    rawImage = imread(filename);
    J = imresize(rawImage, [512 512]);
    hunds = floor(k/100);
    tens = floor((k - 100*hunds)/10);
    ones = k - 100*hunds - 10*tens;
    newFileName = sprintf('rawim_%d%d%d.tif', hunds, tens, ones);
    fulldestination = fullfile(destdirectory, newFileName); 
    imwrite(J, fulldestination);
end

%DatasetPath = fullfile('c:\','Users','spars','Documents','PURA','TrainData','RawImages'); 
DatasetPath = fullfile('D:\','Sparsh','PURA','TrainData','RawImages');
DatasetPathDir = dir(DatasetPath)
DatasetPathDir = DatasetPathDir(~[DatasetPathDir.isdir])
%destdirectory = 'c:\Users\spars\Documents\PURA\CleanedRawImages';
destdirectory = 'D:\Sparsh\PURA\CleanedRawImages';
if isfolder('CleanedRawImages')
    rmdir CleanedRawImages s;
end
mkdir(destdirectory);
for k = 1:length(DatasetPathDir)
    filename = fullfile(DatasetPath, DatasetPathDir(k).name);
    rawImage = imread(filename);
    I = rgb2gray(rawImage);
    clahe = adapthisteq(I);
    J = imresize(clahe, [512 512]);
    hunds = floor(k/100);
    tens = floor((k - 100*hunds)/10);
    ones = k - 100*hunds - 10*tens;
    newFileName = sprintf('rawim_%d%d%d.tif', hunds, tens, ones);
    fulldestination = fullfile(destdirectory, newFileName); 
    imwrite(J, fulldestination);
end

%end