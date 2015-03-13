function P = heatInduction(t)
% Define the power of induction in J/s dependend on time. Returns the
% energy induced in given time step



%% Define function
% if t(i)>(Nt*dt/2)
%     P = 0;
% elseif rem(t(i),20)==0
%     P = 1;
% else
%     P = 0;
% end

% P = 1*sin(1000*t(i));
% if P<0
%     P = 0;
% end

% Preallocate arrays
P = zeros(1,length(t));

for i=1:length(t)
    if t(i) <= 25e-12
        P(i) = 0.04e12/25e-12*t(i);
    elseif t(i) < 50e-12
        P(i) = -(0.04e12/25e-12)*t(i)+0.08e12;
    else
        P(i) = 0;
    end
end

P = P*100e-6;

end