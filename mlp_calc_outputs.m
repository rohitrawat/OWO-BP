function [y net] = mlp_calc_outputs(Xa, Wi, Wo)
% Calculates the output of the MLP using Xa, Wi and Wo. Wi is Nhx(N+1), Wo is
% MxL. 
cascade = mlp_isCascade(Wi, Wo);

net = mlp_calc_net(Xa, Wi);
o = mlp_calc_activation(net);

if(cascade)
    Nv = size(Xa,1);
    Xa1 = [ones(Nv,1) o];
else
    Xa1 = [Xa o];
end    

y = Xa1 * Wo';
