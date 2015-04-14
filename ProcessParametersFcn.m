function ProcessParametersFcn( S )
%% ProcessParameters
%
%   Process the parameters passed from the application's defined setup file
%   and run the simulation
%

fieldnames( S )

l = S.l;
N = S.N;
adiabatic = S.adiabatic;
names = S.names;
dLayer = S.dLayer;
k = S.k;
c = S.c;
rho = S.rho;
absCoeff = S.absCoeff;
sProfile = S.sProfile;
tProfile = S.tProfile;
pathName = S.pathName;
fileName = S.fileName;
folderName = S.folderName;
t = S.t;
Nt = S.Nt;
T0 = S.T0;
beamDia = S.beamDia;
pulseEnergy = S.pulseEnergy;
pulseDuration = S.pulseDuration;
saveSteps = S.saveSteps;
SaveName = S.SaveName;
SavePath = S.SavePath;
FilterIndex = S.FilterIndex;

% Calculate the distance betweeen two simulated elements. Output is an
% array d = [xdir -xdir ydir -ydir zdir -zdir] where xdir and -xdir etc.
% are the same values.
d(1:2) = l(1)/N(1);
d(3:4) = l(2)/N(2);
d(5:6) = l(3)/N(3);

% Calculate the volume of one element
V = d(1)*d(3)*d(5);

% Calculate the area per dimension (Same format as distances between
% elements.
% X Dimension
A(1:2) = d(3)*d(5);
% Y Dimension
A(3:4) = d(1)*d(5);
% Z Dimension
A(5:6) = d(1)*d(3);

% Calculate time of each time step
dt = t/Nt;
%%
% Generate a Matrix with ambient temperatures as base for the calculations.
% The size of the matrix is two elements bigger in every dimension because
% the edges can either be adiabatic or have a constant temperature.
M = zeros(N(1)+2,N(2)+2,N(3)+2) + T0;
%%
% Calculate the layer where the materials change.
dLayer(length(dLayer)+1) = l(3) - sum(dLayer);
%%
% Preallocation
Nlayer = zeros(1,length(dLayer));
for i=1:length(dLayer)
    if i==1
        NlayerPrev = 1;
    else
        NlayerPrev = Nlayer(i-1);
    end
    Nlayer(i) = round(dLayer(i)/d(6)) + NlayerPrev;
    if i==length(dLayer)
        % Make sure the whole matrix is filled
        Nlayer(i) = size(M,3);
    end
end
%%
% Define a Material matrix in the same size as the temperature matrix M.
Mat = zeros(size(M));
% Define Materials
for i=length(dLayer):-1:1
    Mat(:,:,1:Nlayer(i)) = i;
end
%%
% For each material calculate the mass of a single volume element.
m = zeros(1,length(dLayer));
for i=1:length(dLayer)
    m(i) = rho(i)*V;
end

% Define matrices with material constants
K = zeros(size(M));
C = zeros(size(M));
MV = zeros(size(M));
AC = zeros(size(M));
for i=1:numel(Mat)
    material = Mat(i);
    K(i) = k(material);
    C(i) = c(material);
    MV(i) = m(material);
    AC(i) = absCoeff(material);
end

% Convert the thermal conductivity matrix in a 4D matrix in which the
% heatflow is given in every direction
K = K3(K);

% Calculate a beam absorption matrix
I = beamAbs(l,N,beamDia,AC);

% Check if there is the specified directory in the defined save path. If
% not create one. If yes delete all files in this folder.
% Set path
savePath = [pathName,folderName];
if exist(savePath,'dir')
    delete([savePath,fileName,'*.mat'])
else
    mkdir(savePath);
end
% Include filename in path
savePath = [savePath,fileName];

%% Prerun model for time estimate
estimateRunTime(M,Nt,dt,A,d,K,C,MV,pulseEnergy,adiabatic,I,savePath,saveSteps)

%% Run model
[Y] = heatflow(M,Nt,dt,A,d,K,C,MV,pulseEnergy,adiabatic,I,savePath,saveSteps);

%% Calculate total excess heat remaining in system
sumUpEnergy(Y,T0,C,MV)

end % Main