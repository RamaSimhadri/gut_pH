clc;
clear all;
close all;

I = imread('IMG_2300.JPG');
Ihsv = rgb2hsv(I);

[m,n,p] = size(I);

R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

hue = Ihsv(:,:,1);
sat = Ihsv(:,:,2);
val = Ihsv(:,:,3);

% satthreshold = 0.5;
% satmask = reshape(sat(:)>satthreshold, [2448,3264]);

step = 0.1;
huethreshlow = 0;
huethreshup = huethreshlow+step;
cnt = 1; 
threshold = 1000; %threshold for removing background noise in the mask

figure
for i = 0:step:(1-step)
    
    %create a mask with hues between a range 
    huemask{cnt} = reshape((hue(:)>=huethreshlow & hue(:)<=huethreshup), [m,n]);
    
    %get boundaries of the hue mask
    huemaskbound{cnt} = bwconncomp(huemask{cnt});
    %get the size of each region and filter the really small regions which
    %are very likely to be noise by thresholding
    numPixels{cnt} = cellfun(@numel,huemaskbound{cnt}.PixelIdxList);
%     lumps{cnt} = find(numPixels{cnt} > threshold);
    biggestlump{cnt} = find(numPixels{cnt}==max(numPixels{cnt}));
%     NP{cnt} = numPixels{cnt}(lu   mps{cnt});
    
    %use the size filtered regions to generate a new map of the regions
    %which are very likely to be the guts
    gutmask{cnt} = zeros(m,n);
    gutmask{cnt}(huemaskbound{cnt}.PixelIdxList{biggestlump{cnt}}) = 1;

    %go to the next hue regions
    huethreshlow = huethreshlow+step;
    huethreshup = huethreshup+step;  
    
    %show the regions
    subplot(ceil((1/step)/3),3, cnt);
%     imshow(huemask{cnt});
    imshow(gutmask{cnt});
    cnt = cnt+1;

end




% fraction = 1000;
% scatter3(R(1:floor(numel(R)/fraction):end), G(1:floor(numel(R)/fraction):end), B(1:floor(numel(R)/fraction):end))
% xlabel('R')
% ylabel('G')
% zlabel('B')

% fraction = 100;
% scatter3(hue(1:floor(numel(R)/fraction):end), sat(1:floor(numel(R)/fraction):end), val(1:floor(numel(R)/fraction):end))
% xlabel('Hue')
% ylabel('Sat')
% zlabel('Val')