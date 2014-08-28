clear
close all
clc

Data = struct('Variables',[],'GlobalAttributes',[],'VariableAttributes',[]);

cdfId = cdflib.open('test.cdf');

fileInfo = cdflib.inquire(cdfId);

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



% Clean up
cdflib.close(cdfId)

clear cdfId