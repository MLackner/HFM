function c = heatcapacity(T,mat)
% Returns the heat capactiy of a given material (mat) at a temperature T

if strcmp(mat,'Ti')
    c = 2.71e-7*T.^3 - 0.6252e-3*T.^2 + 0.6534*T + 391.4;
elseif strcmp(mat,'Si')
    c = T./T*703;
else
    fprintf('Material "%s" not found.\n',mat)
end

end