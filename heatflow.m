function [M] = heatflow(M,Nt,dt,A,d,K,C,MV,pulseEnergy,adiabatic,I,savePath,saveSteps)


fprintf('Calculating...\n')
tic

% Define index for saved files
j = 1;

%% Calculation
for i=1:Nt
    % Get time
    t = dt*(i-1);
    
    %% Heat induction
    % Engergy function
    Eind = heatInduction(t,pulseEnergy)*dt;
    % Induce
    M = M + I.*Eind./C./MV;
    
    % In case of an adiabatic system
    M = adiabaticEdge3(M,adiabatic);
    
    % Calculate temperature gradient matrix
    dT = tempGradient3(M);
    
    % Calculate heat flux matrix
    HF = heatflux3n(K,d,dT,dt,A);
    
    % Add heatflux to current matrix to gain new state
    M(2:end-1,2:end-1,2:end-1) = M(2:end-1,2:end-1,2:end-1) +...
        HF./C(2:end-1,2:end-1,2:end-1)./MV(2:end-1,2:end-1,2:end-1);
    
    % Save data
    if rem(i,saveSteps)==0 || i == 1
        % Set filename
        fileName = [savePath,int2str(j)];
        save(fileName,'M','-v6')
        % Increase index
        j = j+1;
    end
    
end

toc
end