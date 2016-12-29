clc;
clear all;
close all;

%read the image file and get size
I = imread('C:\Users\ramakrishna\Desktop\Larval gut pH\BB\R3_Bromophenol Blue_0_ Oblique_1-20.JPG');
[m,n,p] = size(I);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------finding the length of the gut-----------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%filter out some of the background noise
Igray = rgb2gray(I);
Ltmp = medfilt2(Igray,[5 5]);

%create a BW image and invert the BW image
slider = 0.74;
Ibwinverted = im2bw(Ltmp,slider);
Ibw = 1+(Ibwinverted*-1);

%define boundaries of the gut
Ibound = bwconncomp(Ibw); %define all objects in the image
numPixels = cellfun(@numel,Ibound.PixelIdxList); %get the size of all objects
threshold = 10000; %objects smaller than this will be rejected
gut = find(numPixels==max(numPixels) & numPixels > threshold); %pick the biggest object greater than "threshold" number of pixels

%create a mask the shape of gut using the gut boundaries
gutmask = zeros(m,n);
gutmask(Ibound.PixelIdxList{gut}) = 1;
gutmask = imfill(gutmask); %fill any holes in the image

%trace a line through the center of the gut
gutcenterline = bwmorph(gutmask,'thin','inf');

%get the length of the line (which is it "Area")
gutlength = regionprops(gutcenterline,'Area');

%Use the gutmask on the original image to create a new image with only
%the gut
Iwithmask = I;
black = [find(gutmask==0); (m*n)+find(gutmask==0); (m*n*2)+find(gutmask==0)]; %since I is a 3 dimensional matrix, mask needs to be drawn on all layers
Iwithmask(black) = 0;

%use the gutcenterline mask on the original image to create a new image
%with only the line passing through the middle of the gut
Iwith_gut_centerline = I;
dark = [find(gutcenterline==0); (m*n)+find(gutcenterline==0); (m*n*2)+find(gutcenterline==0)]; %since I is a 3 dimensional matrix, mask needs to be drawn on all layers
Iwith_gut_centerline(dark) = 0;

%show the output
scrsz = get(0,'ScreenSize');
figimg1 = figure('Position',[0 0 scrsz(3) scrsz(4)]);

figure(figimg1);
subplot(2,2,1);
imshow(I);
xlabel('Original Image');
subplot(2,2,2);
imshow(Ibw);
bwthreshold = strcat('B&W image, Threshold:',num2str(slider));
xlabel(bwthreshold);
subplot(2,2,3);
imshow(gutmask-gutcenterline);
xlabel('B&W image with gut Centerline');
subplot(2,2,4);
imshow(Iwithmask);
xlabel('Original image with gut mask');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------adjusting the gut centerline to show just the midgut region-------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
ROI = roipoly(Iwith_gut_centerline);
remove_regions = find(ROI);

Iwith_midgut_centerline = Iwith_gut_centerline;
remove_regions_alllayers = [remove_regions; (m*n)+remove_regions; (m*n*2)+remove_regions];
Iwith_midgut_centerline(remove_regions_alllayers) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------finding the length of various hues in the gut--------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%convert the RGB image with gutcenterline mask into an HSV image
Ihsv = rgb2hsv(Iwith_midgut_centerline);
hue = Ihsv(:,:,1);
sat = Ihsv(:,:,2);
val = Ihsv(:,:,3);

%The hue of the image ranges from 0-1. 
%use 0.1 increment of the hue values to check with regions of the gut are
%which hues.
step = 0.1;
huethreshlow = 0;
huethreshup = huethreshlow+step;
cnt = 1; 
threshold = 10; %threshold for removing background noise in the mask

%for each hue range, find which pixels are in that range and find the
%cumulative length of all the regions of the gut with that hue range. Also
%create a binary mask with identified regions
figimg2 = figure('Position',[0 -50 scrsz(3) scrsz(4)]);
figure(figimg2);

for i = 0:step:(1-step)
    
    pixels{cnt} = find(hue>=huethreshlow & hue<=huethreshup);
    huelength(cnt) = length(pixels{cnt});
    huemask{cnt} = zeros(m,n);
    huemask{cnt}(pixels{cnt}) = 1;
    
    %go to the next hue regions
    huethreshlow = huethreshlow+step;
    huethreshup = huethreshup+step;  
    
    %show the regions
    subplot(ceil((1/step)/3),3, cnt);
    imshow(huemask{cnt});
    bin = num2str(i);
    xlabel(bin);
    cnt = cnt+1;

end

subplot(ceil((1/step)/3),3, cnt);
imshow(Iwith_midgut_centerline);
xlabel('Gut Centerline Mask');

subplot(ceil((1/step)/3),3, cnt+1);
plot(huelength(2:10));
xlabel('Pixels in Hue bins')


