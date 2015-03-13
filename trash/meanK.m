function Kmean = meanK(K)

% Y1 Difference
Y(:,:,:,1) = K(2:end-1,1:end-2,2:end-1);
% X1 Difference
X(:,:,:,1) = K(1:end-2,2:end-1,2:end-1);
% Y2 Difference
Y(:,:,:,2) = K(2:end-1,3:end,2:end-1);
% X2 Difference
X(:,:,:,2) = K(3:end,2:end-1,2:end-1);
% Z1 Difference
Z(:,:,:,1) = K(2:end-1,2:end-1,1:end-2);
% Z2 Difference
Z(:,:,:,2) = K(2:end-1,2:end-1,3:end);
% Make a Matrix with sum of Temperature Differences
L(:,:,:,1) = sum(X,4);
L(:,:,:,2) = sum(Y,4);
L(:,:,:,3) = sum(Z,4);

Kmean = mean(L,4)/2;

end