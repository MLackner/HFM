%% Make figures

%% Data path
% Count number of files in folder
fileInfo = dir([pathName,folderName,'/*.mat']);
numFiles = length(fileInfo);
fullPath = [pathName,folderName,fileName];

%% 2D plot T on surface

xslice = floor((size(M,1)+2)/2);
yslice = floor((size(M,2)+2)/2);
zslice(1) = 2;
zslice(2) = Nlayer(1);
zslice(3) = Nlayer(2);
zslice(4) = Nlayer(3);

stepSize = 100;

timeData = (dt:dt*100:t)*1e12;
% Preallocate temperature data
tempData = zeros(length(Nlayer)+1,400);
for i=0:100:numFiles
    if i==0
        i=1;
    end
    M = loadTimeStep(fullPath,i);
    for j=1:length(Nlayer)+1
        tempData(j,ceil(i/100)) = squeeze(M(xslice,yslice,zslice(j)));
    end
end

% Make figure and plot
figure(1)
p = plot(timeData,tempData);
xlabel('Time [ps]'), ylabel('Temperature [K]')
ylim([min(tempData) max(tempData)])

% Save
saveas(1,[pathName,folderName],'/figs/tempLayersTime','png')