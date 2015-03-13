function HF = heatflux3(K,d,dT,dt,A)

% Preallocation (Maybe better to pass this variable and define in parent
% function)
Q = zeros(size(dT));
F(1:2) = A.x;
F(3:4) = A.y;
F(5:6) = A.z;

% All directions
for i=1:6
    Q(:,:,:,i) = -K(:,:,:,i).*dT(:,:,:,i)/d(i)*F(i)*dt;
end

% Sum up
HF = sum(Q,4);

end