function predictMethod()
    
net = importKerasNetwork('model-apo2-nc.h5');
%net2 = importKerasNetwork('model-fascSnippets2-nc.h5');

rawImage = imread('rawim_001.tif');
I = rgb2gray(rawImage);
clahe = adapthisteq(I);
J = imresize(clahe, [512 512]);
figure, imshow(I), figure, imshow(J)

YPred = predict(net,J)
figure, imshow(YPred)
lgraph = layerGraph(net)
plot(lgraph)      

layers

end