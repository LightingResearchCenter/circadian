function [ name ] = makeName( fileType, subjectIdent,analysisName )
%MAKENAME Generates a name for file storage
%   this will generate a file name for any file that a program may need to
%   create. This will generate two diffrent type of names, one for data
%   files and one for results files. 
%
%   fileType:       0 : Data files
%                   1 : Analysis results files
%   subjectIdenty   this is the name of the file. Use a subject identifyey,
%                   if this is a batch analysis file please use 'Batch'
%   analysisName    This is the name of what the analysis type and version
%                   number of the result is. 

if nargin == 2
    analysisName = [];
end
    
if fileType == 0 % Name is for a data file
    name = [subjectIdent, '_', datestr(now,'yyyymmdd_HHMM'),'_'...
            ,getenv('USERNAME')];
elseif fileType == 1 % Name is for a Analysis Results file
    name = [analysisName,'_',subjectIdent, '_',...
            datestr(now,'yyyymmdd_HHMM'),'_',getenv('USERNAME')];
else% this is a catch all for errors  
    error('unknown file type');
end

end

