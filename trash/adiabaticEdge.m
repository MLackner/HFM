function M = adiabaticEdge(M)
% Set the temperatures at the edges of the matrix equal to one
% element further in.

% Y Dimension
M(:,1,:) = M(:,2,:);
M(:,end,:) = M(:,end-1,:);
% X Dimension
M(1,:,:) = M(2,:,:);
M(end,:,:) = M(end-1,:,:);
% Z Dimension
M(:,:,1) = M(:,:,2);
M(:,:,end) = M(:,:,end-1);

end