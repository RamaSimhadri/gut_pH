%Generates a gut_mask (a B&W image) that outlines the shape of the gut from
%a given B&W image using a user defined threshold for the gut size

%imputs
%a. Ibw - A B&W image containing the gut
%b. pixel_threshold - Number of pixels that the gut outline should be
%bigger than
%c. handles

%outputs
%a. gut_mask - A B&W image with objects whose sizes are bigger than the
%user defined pixel_threshold

function gut_mask = define_gut_mask(Ibw,pixel_threshold,handles)

%define boundaries of the gut
Ibound = bwconncomp(Ibw); %define all objects in the image
numPixels = cellfun(@numel,Ibound.PixelIdxList); %get the size of all objects
gut = find(numPixels==max(numPixels) & numPixels > pixel_threshold); %pick the biggest object greater than "threshold" number of pixels

%create a mask (B&W image) the shape of gut using the gut boundaries
[m,n] = size(Ibw);
gut_mask = zeros(m,n);
gut_mask(Ibound.PixelIdxList{gut}) = 1;
gut_mask = imfill(gut_mask); %fill any holes in the image