function estimateRunTime(M,Nt,dt,A,d,K,C,MV,adiabatic,I,savePath,saveSteps)

fprintf('Estimating run time...\n')
preNt = 100;
tic
heatflow(M,preNt,dt,A,d,K,C,MV,adiabatic,I,savePath,saveSteps);
preT = toc; estT = preT*Nt/preNt;
% Output
fprintf('\tEstimated run time: %g min\n\tapprox. finished:',estT/60)
disp(datetime + seconds(estT))
fprintf('------------------------------\n')

end