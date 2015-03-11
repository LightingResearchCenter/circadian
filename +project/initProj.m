function [ status ] = initProj(projName,Experiment,root)
%ProjectInitializaton Creates the folders for a new project as of 08/2015
%   Run this program when starting a new project to make sure that all the
%   folders get created it accoridance with the structure created in August
%   2014.
%
%   projName:   This will be the base folder that the program will look for
%               This is gennerally the Name for the Entire Project.
%
%   Experiment: This is the name of the experiment inside the project. This
%               can be the iteration of the project or the name of the
%               loatcation. Should make this highly identafiable to the
%               specific data being put inside here. 
%   root:       This is a Folder location that was added to make it faster
%               to test the program. 
%
%   Note: Due to the way that the exist function works, this program will
%   not be able to be case sensitive. meaning that this program will assume
%   that a folder name is lowercase when checking if it exists, but mkdir 
%   will be Case sensitive. 


if nargin == 2
    root= fullfile([filesep,filesep],'root','projects');
end
if exist(root,'dir') == 7
    if exist([root,filesep,projName],'dir') ~= 7
        status = 'project file does not exist';
        mkdir([root,filesep,projName]);
    else % Project folder already exist
    end
else % Program can not find the Projects folder that we use to store data
    status = 'Cant find the root folder';
end

logFolder = [root,filesep,projName,filesep,'Logistics'];
dataFolder = [root,filesep,projName,filesep,'Data'];
pubFolder = [root,filesep,projName,filesep,'Publications'];
logFound = exist(logFolder,'dir');
dataFound = exist(dataFolder,'dir');
pubFound = exist(pubFolder,'dir');

if logFound ~= 7
    mkdir(logFolder);
else
    disp('Logistics Folder Already Exists');
end

if dataFound ~= 7
    mkdir(dataFolder);
else
    disp('Data Folder Already Exists');
end

if pubFound ~= 7
    mkdir(pubFolder);
    mkdir([pubFolder, filesep, 'Multi-Experiment'])
    mkdir([pubFolder, filesep, 'Multi-Experiment', filesep, 'Drafts']);
    mkdir([pubFolder, filesep, 'Multi-Experiment', filesep, 'Data Used']);
    mkdir([pubFolder, filesep, 'Multi-Experiment', filesep, 'Functions Used']);
else
    disp('Publications Folder Already Exists');
end
logExpFolder = [logFolder,filesep,Experiment];
dataExpFolder = [dataFolder,filesep,Experiment];
pubExpFolder = [pubFolder,filesep,Experiment];
if exist(logExpFolder, 'dir') ~= 7
    mkdir(logExpFolder);
    mkdir([logExpFolder,filesep,'Administration']);
    mkdir([logExpFolder,filesep,'Equipment']);
    mkdir([logExpFolder,filesep,'Experiment Layout']);
    mkdir([logExpFolder,filesep,'Print Outs']);
else
    disp('Logistics Experiment Folder Already Exists');
end
if exist(dataExpFolder, 'dir') ~= 7
    mkdir(dataExpFolder);
    mkdir([dataExpFolder,filesep,'Data-Enviroment']);
    mkdir([dataExpFolder,filesep,'Data-Enviroment',filesep,'Originals']);
    mkdir([dataExpFolder,filesep,'Data-Enviroment',filesep,'Work In Progress']);
    mkdir([dataExpFolder,filesep,'Data-Enviroment',filesep,'Work In Progress',filesep,'Editied Data']);
    mkdir([dataExpFolder,filesep,'Data-Enviroment',filesep,'Work In Progress',filesep,'Analysis Results']);
    mkdir([dataExpFolder,filesep,'Data-Enviroment',filesep,'Work In Progress',filesep,'Meta-Analysis']);
    mkdir([dataExpFolder,filesep,'Data-People']);
    mkdir([dataExpFolder,filesep,'Data-People',filesep,'Originals']);
    mkdir([dataExpFolder,filesep,'Data-People',filesep,'Originals',filesep,'Device']);
    mkdir([dataExpFolder,filesep,'Data-People',filesep,'Originals',filesep,'Logs']);
    mkdir([dataExpFolder,filesep,'Data-People',filesep,'Work In Progress']);
    mkdir([dataExpFolder,filesep,'Data-People',filesep,'Work In Progress',filesep,'Editied Data']);
    mkdir([dataExpFolder,filesep,'Data-People',filesep,'Work In Progress',filesep,'Analysis Results']);
    mkdir([dataExpFolder,filesep,'Data-People',filesep,'Work In Progress',filesep,'Meta-Analysis']);
    mkdir([dataExpFolder,filesep,'Device Info']);
else
    disp('Data Experiment Folder Already Exists');
end
if exist(pubExpFolder,'dir') ~=7
    mkdir(pubExpFolder);
    mkdir([pubExpFolder,filesep,'Drafts']);
    mkdir([pubExpFolder,filesep,'Data Used']);
    mkdir([pubExpFolder,filesep,'Functions Used']);
else
    disp('Publications Experiment Folder Already Exists');
end

end
