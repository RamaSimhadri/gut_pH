% Removes the regions of the image that the user does not want to analyze.
% Asks the user to draw a polygon to include the regions that have to be
% kept intact for further analysis.

%Inputs: An RGB image (this will be the original image from the directory)
%Outputs: An RGB image with only the user selected region (must contain the
%gut in it)

function [I] = outline_gut_regions(Ioriginal)

[m,n,p] = size(Ioriginal);

%Asks the use to select the region of interest (selected region should have
%the gut)
h = figure;
ROI = roipoly(Ioriginal);
keep_regions = find(ROI);
close(h);

%Keeps only the selected region as the original colors and paints the rest
%of the non-selected regions white
I = Ioriginal;
keep_all_layers = [keep_regions; (m*n)+keep_regions; (m*n*2)+keep_regions];
all_pixels = [1:m*n*p];
remove_all_layers = setdiff(all_pixels,keep_all_layers);
I(remove_all_layers) = 255;
