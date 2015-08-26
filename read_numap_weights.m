function [training_fname N M Nh Wi Wo Nit lambda] = read_numap_weights(weights_fname, n_const)
% Reads a weight file that was generated with NuMap or compatible programs.
%   [training_fname N M Nh Wi Wo Nit] = read_numap_weights(weights_fname, n_const)
% The NuMap weights file format is:
% 500
% file name
% N
% M
% Nh
% The_Training_Algorithm_is_OWO_HWO
% Wo (L x M)
% Wi (Nh x N+1)
% Note: Here the constant input 1 is the N+1'th input. It is move to the
% 'n_const' column automatically by this program. (default n_const = 1).
% Author: Rohit Rawat
% 03/22/2014: Added ability to read Nit included in the algo name. Old functionality not affected.
% 04/21/2015: Ability to read Nit and lambda without too many problems

if(nargin < 2)
    n_const = 1;
end

fid = fopen(weights_fname, 'r');
if(fid == -1)
    error('Unable to open weights file %s\n', weights_fname);
end

temp = fscanf(fid, '%d', [1 1]);
if(temp ~= 500)
    fprintf('Warning: Invalid code in weights file!');
end
training_fname = fscanf(fid, '%s', [1 1]);
N = fscanf(fid, '%d', [1 1]);
M = fscanf(fid, '%d', [1 1]);
Nh = fscanf(fid, '%d', [1 1]);
algo_name = fscanf(fid, '%s', [1 1]);

L = N + Nh + 1;
Nw = L*M + (N+1)*Nh;
weights = fscanf(fid, '%f', [1 Nw]);
Wo = reshape(weights(1:(L*M)), M, L);
Wi = reshape(weights((L*M+1):end), N+1, Nh)';

% Re-arrange weights so that the bias weights are in the proper column
if(n_const == 1)
    Wo = Wo(:, [N+1 1:N N+2:L]);
    Wi = Wi(:, [N+1 1:N]);
elseif(n_const ~= N+1)
    error('The bias input can only be the 1st or N+1th input.\n');
end

Nit = 0;
lambda = 0;
try
    Nit = fscanf(fid, '%d', [1 1]);
    lambda = fscanf(fid, '%f', [1 1]);
catch e
end

fclose(fid);
