function [  ] = changeDefaultDir( handels )
%UNTITLED will update the users difault directory for saving daysim files
%   This will ask the user where they want to save their daysimeter files
%   and make the nessacary changes. If the user click cance it will make no
%   changes. 
saveloc = uigetdir(tempdir, 'Where whould you like your default directory?');
if saveloc == 0
    return
else
    setenv('DAYSIMSAVELOC',saveloc);
end


end

