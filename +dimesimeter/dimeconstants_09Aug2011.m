function [Sm, Vm, M, Vp, V, C] = dimeconstants_09Aug2011(id)
%pulls dimesimeter constants from a table 
%id is the id of the dimesimeter
%Sm is the Scone (macula)
%Vm is Vlamda (macula)
%M is melanopsin
%Vp is Vprime
%V is Vlamda
%C is CLA

import dimesimeter.*;

%pull in appropriate table of constants
if(id > 21)
    f = fopen('\\ROOT\projects\DaysimeterAndDimesimeterReferenceFiles\data\All Cal Values_Ithaca.txt');
elseif((id > 21) || (id == 1))
    f = fopen('\\ROOT\projects\DaysimeterAndDimesimeterReferenceFiles\data\All Cal Values_14to21.txt');
elseif(id > 8)
    f = fopen('\\ROOT\projects\DaysimeterAndDimesimeterReferenceFiles\data\All Cal Values_9to13.txt');
else
    f = fopen('\\ROOT\projects\DaysimeterAndDimesimeterReferenceFiles\data\All Cal Values_2to8.txt');
end

%throw away header
fgetl(f);

%Scone
fscanf(f, '%s', 1);
for i = 1:3
    Sm(i) = fscanf(f, '%f', 1);
end

%Vlamda (macula)
fscanf(f, '%s', 1);
for i = 1:3
    Vm(i) = fscanf(f, '%f', 1);
end

%Melanopsin
fscanf(f, '%s', 1);
for i = 1:3
    M(i) = fscanf(f, '%f', 1);
end

%Vprime
fscanf(f, '%s', 1);
for i = 1:3
    Vp(i) = fscanf(f, '%f', 1);
end

%Vlamda
fscanf(f, '%s', 1);
for i = 1:3
    V(i) = fscanf(f, '%f', 1);
end

%throw away headers
fgetl(f);
fgetl(f);
fgetl(f);
fscanf(f, '%s', 1);

%CLA
for i = 1:4
    C(i) = fscanf(f, '%f', 1);
end

fclose(f);