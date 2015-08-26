function [R C] = mlp_calc_RC(Xa, Wi, t, cascade)
% Calculates R and C matrices by computing the net function and the
% activations.
Nv = size(Xa, 1);

if(nargin<4)
    % cascade = false;
    error('Please specify 4th argument ''cascade''  true or false');
end

net = mlp_calc_net(Xa, Wi);
o = mlp_calc_activation(net);

if(cascade)
    Xa1 = [ones(Nv,1) o];   % connections only from the hidden units and bias
else
    Xa1 = [Xa o];   % connections from the input layer and hidden units
end

% Calculates autocorrelation matrix R (size (N+1+Nh) by (N+1+Nh))
R = (Xa1' * Xa1) / Nv;

% Calculates cross-correlation matrix C (size (N+1+Nh) by (M))
C = (Xa1' * t) / Nv;
