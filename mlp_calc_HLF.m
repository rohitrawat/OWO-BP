function z1 = mlp_calc_HLF(E_G, z, E_old)
% Calculates the invisible learning factor z1 using heuristics.

z1 = z*E_old / E_G;
