%Coverts a given RGB_image into a B&W image using a user defined threshold
%for the conversion
%Following are the operations performed:
%1. Converts the RGB image into a gray scale image
%2. Performs a median filtering to remove the background noise (this limits
%the background dust from being highlighted)
%3. coverts the filtered grascale image into a B&W image using the user
%defined threshold

%inputs:
%a. RGB_image - The RGB image containing the gut
%b. Threshold - User defined parameter ranging from 0-1
%c. handles

%outputs:
%a. Ibw - B&W image which highlights the gut (or other junk) above the user
%defined contrast threshold

function Ibw = convert_RGB2BW(RGB_image,Threshold,handles)
%convert RGB to a gray scale image
Igray = rgb2gray(RGB_image);
%use a median filter to remove noise
Itmp = medfilt2(Igray,[5 5]);
%convert the grascale image to a B&W image using Threshold
Ibwinverted = im2bw(Itmp,Threshold);
%invert the B&W image
Ibw = 1+(Ibwinverted*-1);
