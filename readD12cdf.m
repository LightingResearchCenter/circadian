function Data = readD12cdf(filePath)
%READD12CDF Summary of this function goes here
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
            nEntry = cdflib.getAttrMaxgEntry(cdfId,iAttr); % Entry is already zero-based
            Data.VariableAttributes.(attrInfo.name) = cell(nEntry+1,1);
            for iEntry = 0:nEntry
                attrData = cdflib.getAttrgEntry(cdfId,iAttr,iEntry);
                Data.GlobalAttributes.(attrInfo.name){iEntry+1,1} = attrData;
            end
        case 'VARIABLE_SCOPE'
            nEntry = cdflib.getAttrMaxEntry(cdfId,iAttr); % Entry is already zero-based
            Data.VariableAttributes.(attrInfo.name) = cell(nEntry+1,1);
            for iEntry = 0:nEntry
                attrData = cdflib.getAttrEntry(cdfId,iAttr,iEntry);
                Data.VariableAttributes.(attrInfo.name){iEntry+1,1} = attrData;
            end
        otherwise
            error('Unknown attribute scope.');
    end
end

% Clean up
cdflib.close(cdfId)

clear cdfId
end

