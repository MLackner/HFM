function A = beamInt(l,N,beamDia,AC)
% Returns the absorption matrix of a beam in xy plane

% Preallocate XY Dimension matrix for intesity distribution
I = zeros(N.x+2,N.y+2,N.z+2);

%% Define beam shape in xy plane
%
% Create a gaussian profile
%

% Define xy plane
XY = zeros(N.x+2,N.y+2);
XYsize = size(XY);
[R,C] = ndgrid(1:XYsize(1), 1:XYsize(2));
% Call gauss function with parameters
% Define sigma (variance) for gauss function.
% Length of each volume element
dx = l.x/N.x;
sigma = round(beamDia/dx/3);
center = [floor((N.x+2)/2) floor((N.y+2)/2)];
I(:,:,1) = gaussC(R,C, sigma, center);

%% Calculate transmission in z direction
for i=2:N.z+1
    I(:,:,i) = I(:,:,i-1).*exp(-AC(:,:,i)*l.z/N.z);
end

%% Plot intensity
figure
subplot(1,2,1)
xData = 0:l.z/N.z:l.z;
yData = squeeze(I(center(1),center(2),2:end));
plot(xData,yData)
xlabel('Z [m]')
ylabel('I/I_0')
title('Intensity distribution in z direction')
subplot(1,2,2)
zData = I(:,:,1);
mesh(zData)
xlabel('X')
ylabel('Y')
zlabel('I/I_0')
title('Intensity distribution in xy plane')

%% Calculate Absorption for every layer
% Preallocate array
A = zeros(size(I));
for i=2:N.z+2
    % Absorption in Layer i
    A(:,:,i) = I(:,:,i-1) - I(:,:,i);
end
% Make first layer non absorbing
A(:,:,1) = 0; A(:,:,end) = 0;
A(:,1,:) = 0; A(:,end,:) = 0;
A(1,:,:) = 0; A(end,:,:) = 0;


% Normation
A = A/sum(A(:));

end

function val = gaussC(x, y, sigma, center)
xc = center(1);
yc = center(2);
exponent = ((x-xc).^2 + (y-yc).^2)./(2*sigma);
val       = (exp(-exponent));
end