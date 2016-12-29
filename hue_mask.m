%Draws a mask over the gut with the range of hue values selected and also
%calculate the number of pixels in that range
%Inputs: 
%a. Iwithgutcenterline - RGB image with the centerline of the gut traced
%out (see gut_length.m)
%b. hue_upper_limit - Upper bound for the hue value
%c. hue_lower_limit - Lower limit for the hue value
%d. handles
%Outputs:
%a. huemask - A BW image that shows the pixels in the selected hue range
%b. Iwithgutcenterline_huemask - RGB image which is obtained by
%superimposing the huemask over the Iwithgutcenterline input image
%c. huelength - Number of pixels in the selected hue range

function [huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles)

%convert the RGB image with gutcenterline mask into an HSV image
Ihsv = rgb2hsv(Iwithgutcenterline);
hue = Ihsv(:,:,1);
sat = Ihsv(:,:,2);
val = Ihsv(:,:,3);

%find the pixels in Iwithgutcenterline with hue within the bounds and write
%it into huemask
pixels = find(hue>=hue_lower_limit & hue<=hue_upper_limit);
[p,q] = size(hue);
huemask = zeros(p,q);
huemask(pixels) = 1;

%find the length of the gut that is within the hue range
%A slight complication is that when the hue_upper_limit or the
%hue_lower_limit is at 0, all the backgournd is selected. To avoide that,
%when either of these limits are 0, a very small number (0.000001) will be
%used instead.
d = 0.000001;
if (hue_upper_limit==0 || hue_lower_limit==0)
    if (hue_lower_limit==0)
       hue_lower_limit = d;
       huelength = length(find(hue>=hue_lower_limit & hue<=hue_upper_limit));
    elseif (hue_upper_limit==0)
       hue_upper_limit = d;
       huelength = length(find(hue>=hue_lower_limit & hue<=hue_upper_limit));
    elseif (hue_upper_limit==0 && hue_lower_limit==0)
       hue_upper_limit = d;
       hue_lower_limit = d;
       huelength = length(find(hue>=hue_lower_limit & hue<=hue_upper_limit));
    end
else
    huelength = length(find(hue>=hue_lower_limit & hue<=hue_upper_limit));
end

%generate a new image with the huemask and Iwithgutcenterline
Iwithgutcenterline_huemask = Iwithgutcenterline;
[m,n,p] = size(Iwithgutcenterline);
select_mask = find(huemask==0);
dark = [select_mask; (m*n)+select_mask; (m*n*2)+select_mask]; %since Iwithgutcenterline is a 3 dimensional matrix, mask needs to be drawn on all layers
Iwithgutcenterline_huemask(dark) = 0;