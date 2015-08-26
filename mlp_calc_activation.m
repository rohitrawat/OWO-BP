function o = mlp_calc_activation(net)
% Calculates sigmoid activation for the given net function.
% Rohit Rawat
% Enhanced to handle singularities.

o = 1 ./ (1 + exp(-net));
i = find(~isfinite(o));
o(i) = sign(net(i));
