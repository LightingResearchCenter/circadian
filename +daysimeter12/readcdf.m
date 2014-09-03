function Data = readcdf(filePath)
%READCDF Summary of this function goes here
%   Detailed explanation goes here

Data = struct('Variables',[],'GlobalAttributes',[],'VariableAttributes',[]);

cdfId = cdflib.open(filePath);

fileInfo = cdflib.inquire(cdfId);

% Read in variables
nVars = fileInfo.numVars;

for iVar = 0:nVars-1
    varInfo = cdflib.inquireVar(cdfId,iVar);
    
    % Determine the number of records allocated for the first variable in the file.
    maxRecNum = cdflib.getVarMaxWrittenRecNum(cdfId,iVar);
    
    % Retrieve all data in records for variable.
    if maxRecNum > 0
        varData = cdflib.hyperGetVarData(cdfId,iVar,[0 maxRecNum 1]);
    else
        varData = cdflib.getVarData(cdfId,iVar,0);
    end
    
    Data.Variables.(varInfo.name) = varData;
end

% Read in attributes
nAttrs = fileInfo.numvAttrs + fileInfo.numgAttrs;

for iAttr = 0:nAttrs-1
    attrInfo = cdflib.inquireAttr(cdfId,iAttr);
    switch attrInfo.scope
        case 'GLOBAL_SCOPE'
            nEntry = cdflib.getAttrMaxgEntry(cdfId,iAttr) + 1;
            if nEntry == 1
                attrData = cdflib.getAttrgEntry(cdfId,iAttr,0);
                Data.GlobalAttributes.(attrInfo.name) = attrData;
            else
                Data.GlobalAttributes.(attrInfo.name) = cell(nEntry,1);
                for iEntry = 0:nEntry-1
                    attrData = cdflib.getAttrgEntry(cdfId,iAttr,iEntry);
                    Data.GlobalAttributes.(attrInfo.name){iEntry+1,1} = attrData;
                end
            end
        case 'VARIABLE_SCOPE'
<<<<<<< HEAD
            nEntry = cdflib.getAttrMaxEntry(cdfId,iAttr); % Entry is already zero-based
            Data.VariableAttributes.(attrInfo.name) = cell(nEntry+1,2);
            for iEntry = 0:nEntry
=======
            nEntry = cdflib.getAttrMaxEntry(cdfId,iAttr) + 1;
            Data.VariableAttributes.(attrInfo.name) = cell(nEntry,2);
            for iEntry = 0:nEntry-1
>>>>>>> origin/input
                varName = cdflib.getVarName(cdfId,iEntry);
                attrData = cdflib.getAttrEntry(cdfId,iAttr,iEntry);
                Data.VariableAttributes.(attrInfo.name){iEntry+1,1} = varName;
                Data.VariableAttributes.(attrInfo.name){iEntry+1,2} = attrData;
            end
        otherwise
            error('Unknown attribute scope.');
    end
end

% Clean up
cdflib.close(cdfId)

clear cdfId
end

