%% Data path
% Count number of files in folder
fileInfo = dir([pathName,folderName,'/*.mat']);
numFiles = length(fileInfo);
fullPath = [pathName,folderName,fileName];
fprintf('Getting maximum and minimum temperatures of data set...\n')
[maxT,minT] = getMaxMin(numFiles,fullPath);
fprintf('\tDone.\n')

%% Make an animated 3D plot of the temperature data with time

stepSize = 1;

% Load data
M = loadTimeStep(fullPath,1);

% Colorbar needs different values
M(1,1,1) = M(1,1,1)*1.0000000000001;

% Define data
yData = M(:,:,:);

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
    timeStamp = (i-1)*t/Nt*saveSteps*1e12;
    title(sprintf('%g ps',timeStamp))
    pause(0.001)
    
    % Delete data set
    clear M
end

%%

% Load data
M = loadTimeStep(fullPath,1);

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
    timeStamp = (i-1)*t/Nt*saveSteps*1e12;
    title(sprintf('%g ps',timeStamp))
    pause(0.001)
end

%% 2D plot T on surface

xslice = floor((size(M,1)+2)/2);
yslice = floor((size(M,2)+2)/2);
zslice(1) = 2;
zslice(2) = Nlayer(1);
zslice(3) = Nlayer(2);
zslice(4) = Nlayer(3);

timeData = (0:t/Nt*saveSteps:t)*1e12;
% Preallocate temperature data
tempData = zeros(length(Nlayer)+1,length(timeData));
for i=1:numFiles
    M = loadTimeStep(fullPath,i);
    for j=1:length(Nlayer)+1
        tempData(j,i) = squeeze(M(xslice,yslice,zslice(j)));
    end
end

figure
p = plot(timeData,tempData);
xlabel('Time [ps]'), ylabel('Temperature [K]')
ylim([min(tempData(:)) max(tempData(:))])
xlim([timeData(1) timeData(end)])
% Legend
legend('Surface',[names{1},'/',names{2}],[names{2},'/',names{3}],'End of system')