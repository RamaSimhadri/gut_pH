function [] = write_to_file(hue_bin_lengths,csvfile)

if (exist(csvfile,'file') == 2)
    existing_data = csvread(csvfile);
    [m,n] = size(existing_data);
    dlmwrite(csvfile,hue_bin_lengths','delimiter',',','-append');
else
    fid = fopen(csvfile, 'w');
    csvwrite(csvfile,hue_bin_lengths');
    fclose(fid);
end

