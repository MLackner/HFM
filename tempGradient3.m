function dT = tempGradient3(M)

% Y1 Difference
dT(:,:,:,3) = M(2:end-1,2:end-1,2:end-1) - M(2:end-1,1:end-2,2:end-1);
% X1 Difference
dT(:,:,:,1) = M(2:end-1,2:end-1,2:end-1) - M(1:end-2,2:end-1,2:end-1);
% Y2 Difference
dT(:,:,:,4) = M(2:end-1,2:end-1,2:end-1) - M(2:end-1,3:end,2:end-1);
% X2 Difference
dT(:,:,:,2) = M(2:end-1,2:end-1,2:end-1) - M(3:end,2:end-1,2:end-1);
% Z1 Difference
dT(:,:,:,5) = M(2:end-1,2:end-1,2:end-1) - M(2:end-1,2:end-1,1:end-2);
% Z2 Difference
dT(:,:,:,6) = M(2:end-1,2:end-1,2:end-1) - M(2:end-1,2:end-1,3:end);

end