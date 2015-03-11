function [ output ] = parseName( name )
%PARSENAME takes in the name of a file and return a struct of what it means
%   This will take in a string and parse bassed on the output to makeName.
%   It will return a struct that contains the information in a more formal
%   format. 
%   INPUT
%       name : STRING This is the name of the file 
%   OUTPUT
%       output : A struct with the with the field names being a discription
%                of what the information is.
%
%       NOTE: Add in a way to cut off the ext  based off of the . 


if strcmp(name(length(name)-3),'.')
    name = regexp(name,'\.','split');
    name = name{1};
elseif strcmp(name(length(name)-4),'.')
    name = regexp(name,'\.','split');
    name = name{1};
end
splitName = regexp(name,'_','split');
if length(splitName) == 4
    output = struct(...
        'subject'       ,splitName{1},...
        'createDate'    ,datenum(splitName{2},'yyyymmdd'),...
        'createTime'    ,datenum(splitName{3},'HHMM'),...
        'userName'      ,splitName{4});
elseif length(splitName) == 5
    output = struct(...
        'analysisType'  ,splitName{1},...
        'subject'       ,splitName{2},...
        'createDate'    ,datenum(splitName{3},'yyyymmdd'),...
        'createTime'    ,datenum(splitName{4},'HHMM'),...
        'userName'      ,splitName{5});
else
    error('parseName:nameFormat','Name is not in the proper format');
end


end