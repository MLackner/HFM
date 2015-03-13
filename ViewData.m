%% Data path
% Count number of files in folder
fileInfo = dir([pathName,folderName,'/*.mat']);
numFiles = length(fileInfo);
fullPath = [pathName,folderName,fileName];
%% Make an animated 3D plot of the temperature data with time

stepSize = 1;

% Load data
M = loadTimeStep(fullPath,1);

% Colorbar needs different values
M(1,1,1) = M(1,1,1)*1.0000000000001;

% Define data
yData = M(:,:,:);

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

% Make figure
fh = figure;

xslice = floor((size(M,1)+2)/2);
yslice = floor((size(M,2)+2)/2);
zslice1 = 2;
xrange = [2 size(M,1)-1];
yrange = [2 size(M,2)-1];
zrange = [2 size(M,3)-1];

p = slice(yData,xslice,yslice,zslice1);
xlabel('X'), ylabel('Y'), zlabel('Z')
colorbar
caxis([minT maxT])
xlim(xrange)
ylim(yrange)
zlim(zrange)

pause(1)

for i=1:stepSize:numFiles
    % Load Time Step
    M = loadTimeStep(fullPath,i);
    Xdat = M(xslice,:,:);
    Ydat = M(:,yslice,:);
    Zdat = M(:,:,zslice1);
    p(1).CData = squeeze(Xdat);
    p(2).CData = squeeze(Ydat);
    p(3).CData = squeeze(Zdat);
    title(num2str(i))
    pause(0.2)
    
    % Delete data set
    clear M
end

%%

% Load data
M = loadTimeStep(fullPath,1);

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

layer1 = 10;
layer2 = 2;
stepSize = 1;

fh = figure;
subplot(1,2,1)
p1 = mesh(M(:,:,layer1));

xrange = [2 size(M,1)-1];
yrange = [2 size(M,2)-1];
zrange = [minT maxT];
crange = 'auto';
vAngle = [60 10];

xlim(xrange)
ylim(yrange)
zlim(zrange)
caxis(crange)
view(vAngle)

subplot(1,2,2)
p2 = mesh(M(:,:,layer2));

xlim(xrange)
ylim(yrange)
zlim(zrange)
caxis(crange)
view(vAngle)

pause(1)

for i=1:stepSize:numFiles
    M = loadTimeStep(fullPath,i);
    p1.ZData = M(:,:,layer1);
    p2.ZData = M(:,:,layer2);
    title(num2str(i))
    pause(0.2)
end

%% 2D plot T through Z dimension

stepSize = 1;

% Load data
M = loadTimeStep(fullPath,1);

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

fh = figure;

xslice = floor((size(M,1)+2)/2);
yslice = floor((size(M,2)+2)/2);
xrange = [2 size(M,3)-1];
yrange = [minT maxT];

yData = squeeze(M(xslice,yslice,:));

p = plot(yData);
xlabel('Z'), ylabel('Temperature [K]')
xlim(xrange)
ylim(yrange)
pause(1)

for i=1:stepSize:numFiles
    % Load Time Step
    M = loadTimeStep(fullPath,i);
    % Update plot
    yData = squeeze(M(xslice,yslice,:));
    p.YData = yData;
    title(int2str(i))
    pause(0.2)
end

%% 2D plot T on surface

xslice = floor((size(M,1)+2)/2);
yslice = floor((size(M,2)+2)/2);
zslice(1) = 2;
zslice(2) = Nlayer(1);
zslice(3) = Nlayer(2);
zslice(4) = Nlayer(3);

stepSize = 1;

timeData = (dt:dt*100:t)*1e12;
% Preallocate temperature data
tempData = zeros(length(Nlayer)+1,400);
for i=0:numFiles
    if i==0
        i=1;
    end
    M = loadTimeStep(fullPath,i);
    for j=1:length(Nlayer)+1
        tempData(j,ceil(i/100)) = squeeze(M(xslice,yslice,zslice(j)));
    end
end

figure
p = plot(timeData,tempData);
xlabel('Time [ps]'), ylabel('Temperature [K]')
ylim([min(tempData) max(tempData)])