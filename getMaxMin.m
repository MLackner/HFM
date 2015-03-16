function [maxT,minT] = getMaxMin(numFiles,fullPath)
% Evaluate maximum and minimum temperature of the whole data set. 1st row
% is max value of each time step, 2nd row is min value.

% Preallocate
maxMinT = zeros(2,numFiles);
% Loop through all time steps
for i=1:numFiles
    % Load Time Step
    M = loadTimeStep(fullPath,i);
    % Save maximum value
    maxMinT(1,i) = max(M(:));
    % Save minimum value
    maxMinT(2,i) = min(M(:));
end
% Get absolute max and min
maxT = max(maxMinT(:));
minT = min(maxMinT(:));