function finder(foo,root)
%FINDER - Opens a separate file explorer window
%
% finder
% finder(directory)
% finder(directory,1)
%
% opens a new explorer window, depending on operating system:
% Windows Explorer or Mac Finder.
% does not work under unix.
%
% If no directory is specified, the explorer is opened for the current
% MATLAB directory.  Otherwise, the explorer is opened for the
% specified directory.
% If a file name is specified instead of a directory the explorer window
% is opened showing the directory  containing that file.
%
% An error is thrown if the specified directory (or file) is not found.
%
% The final parameter, if specified and non-zero, indicates that the
% "Explorer from here" option should be used, i.e. that the folder hierarchy
% should be shown with the root at the specified directory.
% this option does nothing under mac or unix.
%
% Examples:
%   finder(pwd,1)
%   finder peaks
%
% created July 2012 by C. Pedersen.
% Based on 'explorer' by Malcolm Wood, from:
% http://www.mathworks.com/matlabcentral/fileexchange/11064-explorer-m-quick-access-to-the-windows-explorer

    if nargin<2
        root = 0;
        if nargin<1
            foo = pwd;
        end
    end
    
    if exist(foo,'dir');
        isfile = false;
        foo = fullfile(foo);
    else
        if exist(foo,'file');
            isfile = true;
            foo = which(foo);
        else
            % Not a file either.
            error('Not found: %s',foo);
        end
    end
    
if ispc
    % Get just the directory part of the file name.
    if isfile; foo = fileparts(foo); end
    if root
        % Open the Explorer window with the Folders tree visible and
        % with this directory as the root
        command = ['explorer.exe /e,/root,' foo];
    else
        % Just open an Explorer window without the Folders tree
        command = ['explorer.exe ' foo];
    end
    
    [~,b] = dos(command);
    if ~isempty(b)
        error('Error starting Windows Explorer: %s', b);
    end
    return
end

if ismac %command syntax if under mac
    %the -R flag will reveal (highlight) the item if it is a file
    %the & creates a separate process, so matlab isn't halted until
    %the new window closes
    if isfile;
        system(['open -R ' foo ' &']);
    else
        system(['open ' foo ' &']);
    end
    return %this is needed, because mac systems also have isunix=1, so
    %would run the part below as well
end

if isunix
    error('not working under unix');
    %the below ought to open an xterm window, but does nothing under mac os
    
    %get just the directory
    foo = fileparts(foo);
    %opens a new xterm window
    %unix('xterm &');
    %opens a new xterm window cd to the specified folder
    unix(['xterm  -e cd foo &']);
end

end

