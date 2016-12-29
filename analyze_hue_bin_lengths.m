function [hue_bin_lengths] = analyze_hue_bin_lengths(Iwithgutcenterline,numhuebins)

%convert the RGB image with gutcenterline mask into an HSV image
Ihsv = rgb2hsv(Iwithgutcenterline);
hue = Ihsv(:,:,1);
sat = Ihsv(:,:,2);
val = Ihsv(:,:,3);

huebins = 1/numhuebins;
bins = 0:huebins:1;

hue_bin_lengths = zeros(numhuebins,1);
for i = 1:numhuebins-1
    hue_lower_limit = bins(i);
    if hue_lower_limit == 0; hue_lower_limit = 0.000001; end
    hue_upper_limit = bins(i+1);
    hue_bin_lengths(i) = length(find(hue>=hue_lower_limit & hue<=hue_upper_limit));
end

figure
plot(bins(1:numhuebins),hue_bin_lengths)