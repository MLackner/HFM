function HF = heatflux3n(K,d,dT,dt,A)

% Preallocation (Maybe better to pass this variable and define in parent
% function)
Q = zeros(size(dT));

% All directions
for i=1:6
    Q(:,:,:,i) = -K(:,:,:,i).*dT(:,:,:,i)/d(i)*A(i)*dt;
end

% Sum up
HF = sum(Q,4);

end