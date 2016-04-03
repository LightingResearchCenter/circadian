function [  ] = changeDefaultDir( handels )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
saveloc = uigetdir(tempdir, 'Where whould you like your default directory?');
setenv('DAYSIMSAVELOC',saveloc);

%% add error check for cancel click

end

