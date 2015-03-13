clear,clc,close all

% Ambient Temperature in K
T0 = 300;
% Dimensions in m
l.x = 3000e-6;
l.y = 3000e-6;
l.z = 500e-9;
% Elements per Dimension
N.x = 30;
N.y = 30;
N.z = 60;
Ntot = N.x*N.y*N.z;

% Distance between elements
dx = l.x/N.x;
dy = l.y/N.y;
dz = l.z/N.z;
d(1:2) = dx;
d(3:4) = dy;
d(5:6) = dz;

% Area per element per Dimension
A.x = 2*dy*dz;
A.y = 2*dx*dz;
A.z = 2*dx*dy;

% Volume of one Element in m^3
V = dx*dy*dz;

% 3D Matrix
M = T0*ones(N.x+2,N.y+2,N.z+2);

%% Material dimensions
% Material thickness in m
d1 = 449e-9;
d2 = 0.7e-9;
% Rest is BK7

% Number of elements per material
Nlayer1 = round(d1/l.z*N.z) +1;
Nlayer2 = round(d2/l.z*N.z);

% Define Materials
Mat = zeros(size(M));
% BK7 is denoted as 3
Mat(:,:,Nlayer1+2+Nlayer2:end) = 1;
% Silicon is denoted as 1
Mat(:,:,1:Nlayer1) = 3;
% Titanium is denoted as 2
Mat(:,:,Nlayer1+1:Nlayer1+1+Nlayer2) = 2;

%% Time settings
% Total simulation time
t = 100e-12;
% Number of time steps
Nt = 30000;
% Time step
dt = t/Nt;
% Adiabatic?
adiabatic = true;

%% Material Ti
% Thermal Conductivity in W/m/K
lambdaTi = 22; %80
% Heat capacity in J/kg/K
cTi = 523;
% Density in kg/m^3
rho = 7874; %7874
% Mass of one volume element is m=rho*V
mTi = rho*V;
% Absorption coefficient @532nm
absCoeffTi = 7.9156e+7;

%% Material Si
% Thermal Conductivity in W/m/K
lambdaSi = 149;
% Heat capacity in J/kg/K
cSi = 703;
% Density in kg/m^3
rho = 2336;
% Mass of one volume element is m=rho*V
mSi = rho*V;
% Absorption coefficient @532nm in /m
absCoeffSi = 241060;

%% Material BK7
% Thermal Conductivity in W/m/K
lambdaBK7 = 1.114;
% Heat capacity in J/kg/K
cBK7 = 0.858;
% Density in kg/m^3
rho = 2510;
% Mass of one volume element is m=rho*V
mBK7 = rho*V;
% Absorption coefficient @532nm in /m
absCoeffBK7 = 0.18332;

%% Material Au
% Thermal Conductivity in W/m/K
lambdaAu = 320;
% Heat capacity in J/kg/K
cAu = 129;
% Density in kg/m^3
rho = 19320;
% Mass of one volume element is m=rho*V
mAu = rho*V;
% Absorption coefficient @532nm in /m
absCoeffAu = 505.59e5;

%% Material Cr
% Thermal Conductivity in W/m/K
lambdaCr = 94;
% Heat capacity in J/kg/K
cCr = 449;
% Density in kg/m^3
rho = 7140;
% Mass of one volume element is m=rho*V
mCr = rho*V;
% Absorption coefficient @532nm in /m
absCoeffCr = 982.6e5;


%% Make matrices of material specific constants
% Preallocate matrices
K = zeros(size(M));
C = zeros(size(M));
MV = zeros(size(M));
AC = zeros(size(M));
for i=1:numel(Mat)
    if Mat(i)==1
        K(i) = lambdaAu;
        C(i) = cAu;
        MV(i) = mAu;
        AC(i) = absCoeffAu;
    elseif Mat(i)==2
        K(i) = lambdaCr;
        C(i) = cCr;
        MV(i) = mCr;
        AC(i) = absCoeffCr;
    elseif Mat(i)==3
        K(i) = lambdaBK7;
        C(i) = cBK7;
        MV(i) = mBK7;
        AC(i) = absCoeffBK7;
    end
end

%% Conversion of thermal conductivity matrix to mean values
K = K3(K);

%% Beam specifications
% Beam diameter in m
beamDia = 300e-6;
% Calculate beam intensity matrix
I = beamInt(l,N,beamDia,AC);
% Plot
xslice = floor((N.x+2)/2 + 1);
yslice = floor((N.y+2)/2 + 1); 
zslice = 2;
figure; slice(I,xslice,yslice,zslice); title('Beam Absorption')
xlabel('Z Coordinate'),ylabel('Y Coordinate'),zlabel('Z Coordinate')
caxis([min(I(:)) max(I(:))])
colorbar

%% Plot output power of laser over time
figure
xData = 0:dt:t;
yData = heatInduction(xData);
plot(xData,yData)
xlabel('Time [s]')
ylabel('Laser power')
title('Power output of laser')

%% Output conditions
fprintf('Boundary Conditions:\n')
fprintf('------------------------------\n')
fprintf('System Dimensions:\n')
fprintf('\tX-Y-Z Dimensions: %gx%gx%g m\n',l.x,l.y,l.z)
fprintf('\tNumber of Blocks: %gx%gx%g\n',N.x,N.y,N.z)
fprintf('Adiabatic: %g\n',adiabatic)
fprintf('Ambient Temperature: %g K\n',T0)
fprintf('------------------------------\n')
fprintf('Materials:\n')
fprintf('\td(Si) : %g m\n',(d1-1)*dz)
fprintf('\td(Ti) : %g m\n',(N.z - d1-1)*dz)
fprintf('\td(BK7): %g m\n',(N.z - d1-1)*dz)
fprintf('------------------------------\n')
fprintf('Time settings:\n\tSimulation time: %g s\n\tTime step: %g s\n',t,dt)
fprintf('\tNumber of time steps: %g\n',Nt)
fprintf('------------------------------\n')

%% Save options
% Set path name
pathName = '/Users/lackner/NichtLolaWegenGrosseDaten/HeatFlowFEA';
% Set folder name
folderName = '/savedData';
% Set path
savePath = [pathName,folderName];
% Set filename praefix
fileName = '/data';
% Delete existing files if the folder already exists. Otherwise create
% folder.
if exist(savePath,'dir')
    delete([savePath,fileName,'*.mat'])
else
    mkdir(savePath);
end
% Include filename in path
savePath = [savePath,fileName];

%% Prerun model for time estimate
% Timesteps for prerun
fprintf('Estimating run time...\n')
preNt = 100;
tic
[Ypre] = heatflow(M,preNt,dt,A,d,K,C,MV,adiabatic,I,savePath);
preT = toc; estT = preT*Nt/preNt;
% Output
fprintf('\tEstimated run time: %g min\n\tapprox. finished:',estT/60)
disp(datetime + seconds(estT))
fprintf('------------------------------\n')

%% Run model
fprintf('Calculating...\n')
tic
[Y] = heatflow(M,Nt,dt,A,d,K,C,MV,adiabatic,I,savePath);
toc
%% Calculate total excess heat remaining in system
% Substract start temperature
Y = Y - T0;
% Excess energy matrix is therefore
E = Y(2:end-1,2:end-1,2:end-1).*C(2:end-1,2:end-1,2:end-1).*MV(2:end-1,2:end-1,2:end-1);
% Total energy is
Etotal = sum(E(:));
% Output dialog
fprintf('Additional energy remaining in the system: %g J\n',Etotal)

% ViewData