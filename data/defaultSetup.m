%% Setup file
%
%   Sample setup
%   Click 'Run' or press 'F5' to save.
%
clc,clear

%% Time settings
% Total simulation time in s
t = 2000e-12;
% Number of time steps
Nt = 40000;

%% System Dimensions
% Length of x dimension in m
l(1) = 1e-3;
% Length of y dimension in m
l(2) = 1e-3;
% Length of z dimension in m
l(3) = 1000e-9;
% Elements in x dimension
N(1) = 20;
% Elements in y dimension
N(2) = 20;
% Elements in z dimension
N(3) = 80;

%% Temperature settings
% Set ambient Temperature in K
T0 = 300;
% Adiabatic edges? (boolean - true/false)
% style: adiabatic = [X1 X2 Y1 Y2 Z1 Z2] (See description below)
adiabatic = [false false false false true false];

%         |B|
%         |e|
%     ____|a|_____
%    / Z1 |m|    /|
%   /___________/ |
%  |           |  |
%  |           |Y1|
%  |    X1     |  |
%  |           | /
%  |___________|/

%% Define Layers
%
%   
%

% Layer names (Not relevant for calculations)
names = {'Si','Ti','BK7'};
% Thickness in m (The thickness of the last layer will be defined by the
% thicknesses of the first two layers and the length of the z dimension of
% the system.)
dLayer = [100e-9 100e-9];
% Thermal conductivity in W/m/K
k = [149 22 1.114];
% Heat capacity in J/kg/K
c = [703 523 0.858];
% Density in kg/m^3
rho = [2336 7874 2510];
% Absorption coefficient in /m (The absorption coefficient is wavelength
% dependend. A source for a vast variety of materials is for example
% www.refractiveindex.info.)
absCoeff = [241060 7.9156e+7 0.18332];


%% Beam specifications
%
%
%

% Diameter in m
beamDia = 200e-9;
% Energy per pulse in J
pulseEnergy = 1e-6;
% Pulse duration in s
pulseDuration = 30e-12;
% Spatial beam profile
sProfile = 'gaussian';
% Time dependend profile
tProfile = 'triangle';

%% Data save options
%
%
%

% Define path ([String] If you set the path to 'pwd' the folder of this
% file will be used.)
pathName = '/Users/lackner/NichtLolaWegenGrosseDaten/SiTi100150';
% Set the folder name (Doesn't have to be existing)
folderName = '/savedData';
% Set the filename prefix
fileName = '/data';
% Set the number of time steps after which the simulation is saved
saveSteps = 20;

%% Save parameters
%
%   Don't edit this part!
%

% Open save file dialog
[SaveName, SavePath, FilterIndex] = ...
uiputfile( '*.mat' , 'Save Boundary Conditions' , ...
    'data/boundaryConditions.mat' );
save( [SavePath, '/', SaveName] );
% Clear the workspace
clear