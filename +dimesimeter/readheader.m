function [cal, chrom, time, red, green, blue, activity] = readheader(filename, id)
%This function takes a dimesimeter file (normal or header format) and 
%dimesimeter id number, and looks in the lookup tables on the network to 
%get all values needed to process the file

import dimesimeter.*;

f = fopen(filename);

%load in cal files
g = fopen('\\ROOT\projects\DaysimeterAndDimesimeterReferenceFiles\data\RGB Calibration Values.txt');
if(id > 21)
    h = fopen('\\ROOT\projects\DaysimeterAndDimesimeterReferenceFiles\data\Other Calibration Values_Ithaca.txt');
elseif(id > 13)
    h = fopen('\\ROOT\projects\DaysimeterAndDimesimeterReferenceFiles\data\Other Calibration Values_14 to 21.txt');
elseif(id > 7)
    h = fopen('\\ROOT\projects\DaysimeterAndDimesimeterReferenceFiles\data\Other Calibration Values_8 to 13.txt');
elseif(id > 1)
    h = fopen('\\ROOT\projects\DaysimeterAndDimesimeterReferenceFiles\data\Other Calibration Values_2 to 7.txt');
elseif(id == 1)
    h = fopen('\\ROOT\projects\DaysimeterAndDimesimeterReferenceFiles\data\Other Calibration Values_8 to 13.txt');
else
    error('Cal values cannot be found for given ID');
end

%find line corresponding to id number
for i = 1:id
    fgetl(g);
end

%pull in RGB cal constants
fscanf(g, '%d', 1);
for i = 1:3
    cal(i) = fscanf(g, '%f', 1);
end

%pull in the other 9 cal constants
for i = 1:9
    cal(i + 3) = fscanf(h, '%f', 1);
end

%pull in chromaticity conversion constants
while(fscanf(h, '%c', 1) ~= '#')
end

chrom = sscanf(fgetl(h), '%f %f %f')';

while(fscanf(h, '%c', 1) ~= '#')
end

chrom = vertcat(chrom, sscanf(fgetl(h), '%f %f %f')');

while(fscanf(h, '%c', 1) ~= '#')
end

%chrom is lines 3 - 5 (3x3 matrix)
chrom = vertcat(chrom, sscanf(fgetl(h), '%f %f %f')');

%check to see if there is a header
z = 1;
while(fscanf(f, '%c', 1) ~= '#')
    z = z + 1;
    if(z > 10)
        break;
    end
end

%determine how many header lines to skip
%if there are no header lines, skip nothing
if(z > 10)
    x = fgetl(f);
    if(~isempty(x))
        i = 0;
    end
    
%if there are header lines, read until a 'T' shows up
else
    i = 1;
    while(i)
        x = fgetl(f);
        if(isempty(x))
        elseif(x(1) == 'T')
            break;
        else
        end
        i = i + 1;
    end
end

%if there's an extra endline before the data, count it also
while(isempty(fgetl(f)))
    i = i + 1;
end

% %skip lines until first valid float shows up (first valid float is time(1)
% i = 0;
% while(1)
%     a = fscanf(f, '%f', 1);
%     if(isempty(a))
%         a = fgetl(f);
%         i = i + 1
%     else
%         break;
%     end
%     
%     %catch infinite loops due to improper file format
%     if(i > 100)
%         error('The wrong file type was selected, or the file is not formatted correctly');
%     end
% end

%read in everything past number of headerlines
[time, red, green, blue, activity] = textread(filename, '%f %f %f %f %f', 'headerlines', i);

%catch order issues from wrong file type
timeErr = time<1000000;
if(max(timeErr) == 1)
    error('The wrong file type was selected, or the file is not formatted correctly');
end

fclose(f);
fclose(g);
fclose(h);