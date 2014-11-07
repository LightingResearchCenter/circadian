function [time, lux, CLA, activity, temp, x, y] = processheader(rawfilename, id, varargin)
%This function processes the raw dimesimeter data and returns time, lux, CS, activity,
%temperature, x, and y values.  The only required argument is the filename
%for the raw data, but you can also pass another filename that can be used
%to save the processed data.


import dimesimeter.*;

%cal = [RCAL, GCAL, BCAL, kp, rp, gp, bp, kc, ac, bc, cc]
%chrom = 3x3 matrix with chrom constants
[cal, chrom, time, red, green, blue, activity] = readheader(rawfilename, id);

%save new hearder file with correct headers if needed
if(length(varargin) > 1)
    f = fopen(varargin{2},'w');
    fprintf(f, '#');
    for i = 1:3
        fprintf(f, '%f\t', cal(i));
    end
    fprintf(f, '\r\n#');
    for i = 1:9
        fprintf(f, '%f\t', cal(i + 3));
    end
    for i = 1:3
        fprintf(f, '\r\n#');
        for j = 1:3
            fprintf(f, '%f\t', chrom(i, j));
        end
    end
    fprintf(f, '\r\nTime\tRed\tGreen\tBlue\tActivity\r\n');
    for i = 1:length(time)
        fprintf(f, '%f\t%f\t%f\t%f\t%f\r\n', time(i), red(i), green(i), blue(i), activity(i));
    end
    fclose(f);
end
    

%remove resets
resets = 0;
j = 1;
total = length(red);
for i = 1:length(red)
    if(i == (total))
        break;
    end
    if((red(i) > 10000) && (green(i) == 0) && (blue(i) > 10000))
        
        %every other reset, remove the point so that the time is more
        %accurate
        
        %replace reset with previous value on odd # of resets
        if(mod(resets,2) ~= 0)
            red(i) = red(i - 3);
            green(i) = green(i - 3);
            blue(i) = blue(i - 3);
            activity(i) = activity(i - 3);
            
        %delete reading on even # of resets
        else
            time(i) = [];
            for count = i:length(time)
                time(count) = time(count) - (time(3) - time(2));
            end
            red(i) = [];
            green(i) = [];
            blue(i) = [];
            activity(i) = [];
            i = i - 1;
            total = total - 1;
        end
       
        resets = resets + 1;        %keep track of number of resets
        reset(j) = i;               %keep track of location of resets
        j = j + 1;
    end
end

% red(find((red < max(red)) & (red > 10000))) = red(find((red < max(red)) & (red > 10000)) - 1);
% green(find((red < max(red)) & (red > 10000))) = green(find((red < max(red)) & (red > 10000)) - 1);
% blue(find((red < max(red)) & (red > 10000))) = blue(find((red < max(red)) & (red > 10000)) - 1);
% activity(find((red < max(red)) & (red > 10000))) = activity(find((red < max(red)) & (red > 10000)) - 1);

%display number of resets, and when they occured
if(resets > 0)
    disp(['Number of resets = ',num2str(resets)]);
    disp('reset times: ');
    disp(datestr((time(reset)/(3600*24)+6.954217798611112e+005) - (1/24) + (17/1440)));
end

%set all temp values to zero since temp isn't saved by the dimesimeter
for i = 1:length(time)
    temp(i) = 0;
end
temp = temp';

%convert activity to rms g
%raw activity is a mean squared value, 1 count = .0039 g's, and the 4 comes
%from four right shifts in the source code
activity = (sqrt(activity))*.0039*4;

%calibrate to illuminant A
red = red*cal(1);
green = green*cal(2);
blue = blue*cal(3);

[lux, CLA] = dimeluxCLA_09Aug2011(red, green, blue, id);
CLA(CLA < 0) = 0;

%find chromaticity coordinates
tristim = [red green blue] * chrom;
for i = 1:length(red)
    if((red(i) > 5) && (green(i) > 5) && (blue(i) > 4))
        Chrom(i,:) = tristim(i,:)/sum(tristim(i,:));
    else
        Chrom(i,:) = [0 0 0];
    end
end
x = Chrom(:,1);
y = Chrom(:,2);

lux((find((activity < max(activity)) & (activity > 2)))) = lux((find((activity < max(activity)) & (activity > 2)) - 1));
CLA((find((activity < max(activity)) & (activity > 2)))) = CLA((find((activity < max(activity)) & (activity > 2)) - 1));
activity((find((activity < max(activity)) & (activity > 2)))) = activity((find((activity < max(activity)) & (activity > 2)) - 1));


%save the processed data in a file if a second filename was passed to the
%function
if(~isempty(varargin))
    fid = fopen(varargin{1},'w');
    fprintf(fid, 'time\tlux\tCLA\tactivity\ttemperature\tx\ty\r\n');
    for i = 1:length(time)
        fprintf(fid,'%.1f\t%f\t%f\t%f\t%f\t%f\t%f\r\n',time(i),lux(i),CLA(i),activity(i),temp(i),x(i),y(i));
    end
    fclose(fid);
end