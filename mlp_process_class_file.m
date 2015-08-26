function Pe = mlp_process_class_file(filename, Wi, Wo)

N = size(Wi,2) - 1;
M = size(Wo,1);
[x ic Nv] = read_class_file(filename, N, M);
Xa = [ones(Nv,1) x];
y = mlp_calc_outputs(Xa, Wi, Wo);
[C ic1] = max(y, [], 2);

% E = mlp_calc_mse(t, y);
Pe = sum(ic ~= ic1)*100/Nv;
