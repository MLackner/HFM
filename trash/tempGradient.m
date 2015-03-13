function dT = tempGradient(M)

% Y1 Difference
Y(:,:,:,1) = M(2:end-1,2:end-1,2:end-1) - M(2:end-1,1:end-2,2:end-1);
% X1 Difference
X(:,:,:,1) = M(2:end-1,2:end-1,2:end-1) - M(1:end-2,2:end-1,2:end-1);
% Y2 Difference
Y(:,:,:,2) = M(2:end-1,2:end-1,2:end-1) - M(2:end-1,3:end,2:end-1);
% X2 Difference
X(:,:,:,2) = M(2:end-1,2:end-1,2:end-1) - M(3:end,2:end-1,2:end-1);
% Z1 Difference
Z(:,:,:,1) = M(2:end-1,2:end-1,2:end-1) - M(2:end-1,2:end-1,1:end-2);
% Z2 Difference
Z(:,:,:,2) = M(2:end-1,2:end-1,2:end-1) - M(2:end-1,2:end-1,3:end);
% Make a Matrix with sum of Temperature Differences
dT.x = sum(X,4);
dT.y = sum(Y,4);
dT.z = sum(Z,4);

end