function write_numap_weights(weights_fname, training_fname, Wi, Wo, n_const, Nit, lambda)
% write_numap_weights(weights_fname, training_fname, Wi, Wo, n_const, Nit, lambda)
% Writes a weight file that is compatible with NuMap. If input means were
% subtracted before processing, please ensure that the threshold weights
% for all layers have been adjusted.
% The NuMap weights file format is:
% 500
% file name
% N
% M
% Nh
% The_Training_Algorithm_is_OWO_HWO_Nit
% Wo (L x M)
% Wi (Nh x N+1)
% Note: NuMap/NuClass assumes the constant input 1 is the N+1'th input. If
% n_const is something different (for example it is 1 for most of our code
% using OLS), this program moves that input to N+1th position before
% writing to the text file.
% Update 3/22/2014: The optional input Nit is written in string form
% appended to the training algorithm name. So this should not break any
% existing code that uses these weights files.
% 04/21/2015: Ability to write Nit and lambda without too many problems

if(nargin < 5)
    n_const = 1;
end
if(nargin < 6)
    Nit = 0;
end
if(nargin < 7)
    lambda = 0;
end

Nh = size(Wi, 1);
N = size(Wi, 2) - 1;
L = N + 1 + Nh;
M = size(Wo, 1);

% Re-arrange the weights so that the constant input is now at the N+1'th
% position
if(n_const == 1)
    Wi = Wi(:, [2:N+1 1]);
    Wo = Wo(:, [2:N+1 1 N+2:L]);
elseif(n_const ~= N+1)
    error('The bias input can only be the 1st or N+1th input.\n');
end

fid = fopen(weights_fname, 'w');
if(fid == -1)
    error('Unable to open weights file for writing: %s.\n', weights_fname);
end

fprintf(fid, '500\r\n');
fprintf(fid, '%s\r\n', training_fname);
fprintf(fid, '%d\r\n', N);
fprintf(fid, '%d\r\n', M);
fprintf(fid, '%d\r\n', Nh);
fprintf(fid, 'The_Training_Algorithm_is_HWO_MOLF\r\n');

for n=1:L
    for i=1:M
        fprintf(fid, '%e\t', Wo(i,n));
    end
    fprintf(fid, '\r\n');
end

for k=1:Nh
    for n=1:N+1
        fprintf(fid, '%e\t', Wi(k,n));
    end
    fprintf(fid, '\r\n');
end

fprintf(fid, '%d\n', Nit);
fprintf(fid, '%e\n', lambda);

fclose(fid);
