%Calculates the length of the midgut region from the given RGB_image and a
%mask image that highlights the gut boundaries.
%Following are the operations performed:
%1. Draws a centerline through the entire gut (foregut+midgut+hindgut)
%2. Creates a new image by superimposing the centerline onto the RGB_image
%3. Shows this Centerline image and asks the user to manually remove the
%foregut and the hindgut
%4. Creates a new image showing only the subset of the RGB centerline image
%that the user didn't discard
%5. Calculates the length of the midgut region
%6. Generates an RGB image with the gut_mask superimposed over the
%RGB_image

%inputs:
%a. RGB_image - The original RGB image
%b. gut_mask - A B&W image that has the shape of the gut (generated by the
%define_gut_mask function)
%c. handles

%output:
%a. gutlength - the length of the midgut region that was selected by the
%user
%b. Iwithgutmask - An RGB image obtained by superimposition of the gut_mask
%over the RGB_image to highlight the gut alone in the image
%c. Iwithgutcenterline - An RGB image showing the colors along the
%centerline of the selected region of the gut (mostly the midgut)

function [gutlength, Iwithgutmask, Iwithgutcenterline] = gut_length(RGB_image,gut_mask,handles)

%trace a line through the center of the gut
gutcenterline = bwmorph(gut_mask,'thin','inf');

%use the gutcenterline mask on the original image to create a new image
%with only the line passing through the middle of the gut
Iwith_wholegut_centerline = RGB_image;
[m,n,p] = size(Iwith_wholegut_centerline);
select = find(gutcenterline==0);
dark = [select; (m*n)+select; (m*n*2)+select]; %since I is a 3 dimensional matrix, mask needs to be drawn on all layers
Iwith_wholegut_centerline(dark) = 0;

%use the ROIPOLY function to remove the hindgut and foregut regions which
%flares up and messes up the length analysis. 
%Also create a new RBG image called Iwith_midgut_centerline which shows the
%colors of the original RGB image only along the midgut region and not the
%full gut
h = figure;
ROI = roipoly(Iwith_wholegut_centerline);
remove_regions = find(ROI);
close(h);

Iwithgutcenterline = Iwith_wholegut_centerline;
remove_regions_alllayers = [remove_regions; (m*n)+remove_regions; (m*n*2)+remove_regions];
Iwithgutcenterline(remove_regions_alllayers) = 0;

%get the length of the line (which is it "Area")
BW_Iwith_midgut_centerline = im2bw(Iwithgutcenterline,0);
gutlength = regionprops(BW_Iwith_midgut_centerline,'Area');


%Use the gut_mask to superimpose on teh original RGB_image
Iwithgutmask = RGB_image;
[m,n,p] = size(Iwithgutmask);
select_mask = find(gut_mask==0);
dark = [select_mask; (m*n)+select_mask; (m*n*2)+select_mask]; %since I is a 3 dimensional matrix, mask needs to be drawn on all layers
Iwithgutmask(dark) = 0;