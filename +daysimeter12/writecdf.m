function writecdf(data, FileName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WRITECDF                                                  %
% -After applying custom code to a dataset, rewrite the CDF %
% file.                                                     %
% INPUT: data - The data to be written                      %
%        FileName - The name of the new CDF file. Note:     %
%                   File must not already exsist.           %
% OUTPUT: CDF File with name FileName                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Import daysimeter12 package to enable all other daysimeter12 functions
import daysimeter12.*;

%% Create CDF file
cdfID = cdflib.create(FileName);
h = waitbar(0,'Please Wait');
set(findobj(h,'type','patch'), ...
    'edgecolor','b','facecolor','b')
%% Get variable and attribute names
varNames = fieldnames(data.Variables);
gAttNames = fieldnames(data.GlobalAttributes);
vAttNames = fieldnames(data.VariableAttributes.(varNames{1}));

% timeVecT = datevec(data.Variables.time);
% timeVec = zeros(length(data.Variables.time),7);
% timeVec(:,1:6) = timeVecT;

[i1,i2,i3,i5,i6,i8,i9]= deal(0);


%% Create Variables

for i1 = 1:length(varNames)
    if strcmp(char(varNames{i1}), 'time')
        vars.(char(varNames{i1})) = cdflib.createVar(cdfID, char(varNames{i1}), 'CDF_EPOCH', 1, [], true, []);
    else
        vars.(char(varNames{i1})) = cdflib.createVar(cdfID, char(varNames{i1}), 'CDF_REAL8', 1, [], true, []);
    end
    try
        waitbar(num, h,'creating variables')
    catch
    end
end


%% Allocate Records
% -Finds the number of entries and allocates space in each
% variable.

numRecords = length(data.Variables.time);
for i2 = 1:length(varNames)
    cdflib.setVarAllocBlockRecords(cdfID, vars.(char(varNames{i2})), 1, numRecords);
    try
        waitbar(num, h, 'Alocating records')
    catch
    end
end


%% Write Records
% -Loops and writes data to records. Note: CDF uses 0
% indexing while MatLab starts indexing at 1.

for i3 = 1:length(varNames)
    numRecords = length(data.Variables.(char(varNames{i3})));
    if strcmp(char(varNames{i3}), 'time')
        for i4 = 1:numRecords
            cdflib.putVarData(cdfID, cdflib.getVarNum(cdfID, char(varNames{i3})), ...
                i4-1, [], data.Variables.time(i4));
            
        end
    else
        for i4 = 1:numRecords
            cdflib.putVarData(cdfID, cdflib.getVarNum(cdfID, char(varNames{i3})), ...
                i4-1, [], double(data.Variables.(char(varNames{i3}))(i4)));
            
        end
    end
    try
        waitbar(num, h, 'Writing Records')
    catch
    end
end


%% Create Variable Attributes

for i5 = 1:length(vAttNames)
    cdflib.createAttr(cdfID, char(vAttNames{i5}), 'variable_scope');
    try
        waitbar(num, h, 'creating Variable Attributes part 1')
    catch
    end
end

for i6 = 1:length(vAttNames)
    for i7 = 1:length(varNames)
        thisAttrNum = cdflib.getAttrNum(cdfID, char(vAttNames{i6}));
        thisEntryNum = cdflib.getAttrMaxEntry(cdfID, thisAttrNum) + 1;
        thisEntryVal = char(data.VariableAttributes.(varNames{i7}).(vAttNames{i6}));
        if isempty(thisEntryVal)
            thisEntryVal = ' ';
        end
        cdflib.putAttrEntry(cdfID, thisAttrNum, thisEntryNum, 'CDF_CHAR', thisEntryVal);
    end
    try
        waitbar(num, h, 'creating Variable Attributes part 2')
    catch
    end
end


%% Create Global Attributes

for i8 = 1:length(gAttNames)
    cdflib.createAttr(cdfID, char(gAttNames{i8}), 'global_scope');
    try
        waitbar(num, h, 'creating Global Attributes part 1')
    catch
    end
end

for i9 = 1:length(gAttNames)
    if isa(data.GlobalAttributes.(char(gAttNames{i9})), 'char')
        thisAttrNum = cdflib.getAttrNum(cdfID, char(gAttNames{i9}));
        thisEntryNum = cdflib.getAttrMaxgEntry(cdfID, thisAttrNum) + 1;
        thisEntryVal = char(data.GlobalAttributes.(char(gAttNames{i9})));
        cdflib.putAttrgEntry(cdfID, thisAttrNum, thisEntryNum, 'CDF_CHAR', thisEntryVal);
        
    elseif isa(data.GlobalAttributes.(char(gAttNames{i9})), 'numeric')
        cdflib.putAttrgEntry(cdfID, cdflib.getAttrNum(cdfID, char(gAttNames{i9})), ...
            cdflib.getAttrMaxgEntry(cdfID, cdflib.getAttrNum(cdfID, char(gAttNames{i9}))) + 1, ...
            'CDF_REAL8', double(data.GlobalAttributes.(char(gAttNames{i9}))));
    end
    try
        waitbar(num, h, 'creating Global Attributes part 2')
    catch
    end
end
try
    close(h);
catch
end
cdflib.close(cdfID)
    function n=num
        top = i1 + i2 + i3 + i5 + i6 + i8 + i9;
        bottom = 3*(length(varNames)) +...
                 2*(length(vAttNames)) +...
                 2*(length(gAttNames));
        n = top/bottom;
    end
end
