function sumUpEnergy(Y,T0,C,MV)

% Substract start temperature
Y = Y - T0;
% Excess energy matrix is therefore
E = Y(2:end-1,2:end-1,2:end-1).*C(2:end-1,2:end-1,2:end-1).*MV(2:end-1,2:end-1,2:end-1);
% Total energy is
Etotal = sum(E(:));
% Output dialog
fprintf('Additional energy remaining in the system: %g J\n',Etotal)

end