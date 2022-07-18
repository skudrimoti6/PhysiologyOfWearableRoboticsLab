%directory of cleaned raw images
orgdir = 'D:\Sparsh\PURA\CleanedRawImages\';
%target directory 
tardir = 'D:\Sparsh\PURA\CleanedCroppedRawImages\';

%load in images, crop them, resize to 512,512, and place into new directory

for i = 1:size(listing,1) 
    I=importdata([orgdir listing(i).name]) ; 
    Cropped = imcrop(I, [56 42 352 390]) ; 
    Resized = imresize(Cropped,[512 512]);
    imwrite(Resized, [tardir listing(i).name]) ;
end
    
    