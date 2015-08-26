function [MSE Ei] = mlp_calc_mse(t, y)
% Computes the MSE from t and y. Also returns the error at each output as
% Ei.

Ei = sum((t-y).^2)/size(t,1);
MSE = sum(Ei);
