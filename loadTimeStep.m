function X = loadTimeStep(fullPath,i)

% Load Time Step
load([fullPath,int2str(i),'.mat']);
X = M;

end