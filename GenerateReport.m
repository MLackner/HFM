%% Generate Report
%
%
%

%% Generate file name
% Make directory
mkdir([pathName,'/report'])
% Make directory for figures
mkdir([pathName,'/report/figs'])
diary([pathName,'/report/',num2str(round(now*1e4)),'.html'])

%% Load report template
HTMLcode = fileread([pwd,'/reportTemp.html']);

%% Get variables and store in array
% Convert booleans to strings
for i=1:numel(adiabatic)
    if adiabatic(i)
        boolCell{i} = 'true';
    else
        boolCell{i} = 'false';
    end
end
stringCell = {datestr(datetime)};
variableArray = [t,Nt,l(1),l(2),l(3),N(1),N(2),N(3),...
    T0,];

%% Print to command line
fprintf(HTMLcode,stringCell{1},variableArray,boolCell{1:6})

%% Close diary
clc
diary off