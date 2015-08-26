function [E Wi Wo] = mlp_train_data(x, t_ic, N, M, Nh, Nit, lambda, cascade, classifier_mode)
%mlp_train_data Trains a Multi Layer Perceptron (MLP) neural network.
%   [E E Wi Wo] = mlp_train_data(x, t_ic, N, M, Nh, Nit, cascade, classifier_mode)
%   trains an MLP on the training data x, t
%   with N inputs and M output classes. Nh is the
%   number of hidden units. Nit is the maximum number of
%   training iterations/epochs. 
%
%   The training algorithm used is Adaptive OWO-BP
%
%   See also mlp_PROCESSING, mlp_TRAIN_CLASS, and, mlp_PROCESSING_CLASS.

%   Copyright 2013, Image Processing and Neural Networks Lab, The
%   University of Texas at Arlington.
%   $Revision: 1.01 $  $Date: 2013/07/05 $

if(Nh < 1)
    error('You must have at least one hidden unit. Please use a linear network training program.\n');
end

if(nargin < 7)
    error('Please provide a lambda');
end

if(nargin < 8)
    error('Please set cascade = true or false');
end

if(nargin < 9)
    error('Please set classifier_mode = true or false');
end

mlp_randn(0,0,1); % reset the MLP random number generator slete

n_const = 1;

fprintf('Number of inputs: %d\n', N);
if(classifier_mode)
    fprintf('Number of output classes: %d\n', M);
else
    fprintf('Number of outputs: %d\n', M);
end
fprintf('Number of hidden units: %d\n', Nh);
fprintf('Number of training iterations: %d\n', Nit);

global global_debug;
global_debug = 0;

if(classifier_mode)
    ic = t_ic;
else
    t = t_ic;
end

Nv = size(x,1);

if(classifier_mode)
    % Generate t from ic for training data
    Nv = size(x,1);
    t = generate_t(ic, M);
end

% Make inputs zero mean, and use the same means to fix validation data
% (Notes II-E-4 Lemma  3:  During  BP  training,  input  weights are
% sensitive to input means.)
input_means = mean(x);

% x = x - repmat(input_means, [Nv 1]);
x = bsxfun(@minus, x, input_means);

% Randomly initialize the input weights
% (Notes II-E-4 Lemma 2: Random initial weights insure that no hidden units
% are identical.)
Wi = mlp_randn(Nh, N+1);

% Normalize input weights by input variance
% input_std = std(x, 1);
% repmat([1 input_std]', [1 Nh]);
% Wi = Wi ./ repmat([1 input_std], [Nh 1]);

% Creates an augmented vector Xa = [1 x(1) x(2) ... x(N)]
Xa = [ones(Nv,1) x];

% % Net control
Wi = mlp_net_control(Xa, Wi, 0);

% Calculates output energies
Et = sum(t .* t) / Nv;

% % OWO-BP Algorithm
z = 0.01;
z1 = 0.01;
E_old = +Inf;

% Perform OWO and calculate E
[R C] = mlp_calc_RC(Xa, Wi, t, cascade);

% including regularization parameter lambda here
eye1 = eye(size(R));
eye1(1,1) = 0;
eye1 = eye1*lambda;
R = R + eye1;

[E,Wo] = ols1(R, C, Et); % the new ols3 is fast enough and may produce better results.

fprintf('Initial OLS complete. MSE = %f\n', E);

% Input autocorrelation matrix required for HWO
Ri = Xa' * Xa / Nv;

if(cascade)
    fprintf('Cascade\n');
else
    fprintf('Fully connected\n');
end

if(classifier_mode)
    fprintf('It\t sum(z)\t\t Grad. Energy\t Trg. Err\t Trg. Pe\n');
else
    fprintf('It\t sum(z)\t\t Grad. Energy\t Trg. Err\n');
end
ending = false; % termination flag
for it = 1:Nit
    
    if(E > E_old)  % Backtracking is disabled for pruning during iterations
        Wo = W_saved;
        Wi = Wi_saved;
        z = z/2;
        z1 = z1/2;
        backtracking_flag = '1';
    else
        backtracking_flag = ' ';
        E_old = E;
        W_saved = Wo;
        Wi_saved = Wi;
        z = z*1.1;
        
        % Perform BP and calculate z1
        
        % calculate y
        [y net] = mlp_calc_outputs(Xa, Wi, Wo);
        if(classifier_mode)
            % and recompute t using OR
            [t Et] = output_reset(y, ic, t);
        end
        
        if(cascade)
            Woh = Wo(:,2:end);
        else
            Woh = Wo(:, N+2:end);
        end
        G = mlp_calc_input_gradient(Xa, t, y, net, Woh);
        gradient_energy = sum(sum(G.^2));
        
        if(gradient_energy < 1e-12)
            ending = true;
            G = zeros(size(G));
        end
        
        z1 = mlp_calc_HLF(gradient_energy, z, E_old);
    end
    
    % Change input weights
    Wi = Wi + z1*G;
    
    % Perform OWO and calculate E
    if(classifier_mode)
        % update t using OR
        [y net] = mlp_calc_outputs(Xa, Wi, Wo);
        [t Et] = output_reset(y, ic, t);
    end
    [R C] = mlp_calc_RC(Xa, Wi, t, cascade);
    
    % including regularization parameter lambda here
    R = R + eye1;
    
    [E,Wo] = ols1(R, C, Et); % the new ols3 is fast enough and may produce better results.
        
    if(classifier_mode)
        [y net] = mlp_calc_outputs(Xa, Wi, Wo);
        Pe = mlp_calc_Pe(ic, y);
    end
    
    % Print results
    if(classifier_mode)
        fprintf('%d\t %f\t %.2e\t %f\t %f\t %c\n', it, mean(z), gradient_energy, E, Pe, backtracking_flag);
    else
        fprintf('%d\t %f\t %.2e\t %f\t %c\n', it, mean(z), gradient_energy, E, backtracking_flag);
    end
    
    if(ending)
        break;
    end
    
end

if(classifier_mode)
    y = mlp_calc_outputs(Xa, Wi, Wo);
    Pe = mlp_calc_Pe(ic, y);
end

fprintf('Training MSE after pruning: %f\n', E);
if(classifier_mode)
    fprintf('Training Pe after pruning: %f\n', Pe);
end

% Integrates the input means into the thresholds to remove the need for
% mean subtraction during processing.
[Wo Wi] = mlp_integrate_input_means_into_weights(Wo, Wi, input_means);

% pad output weights with zeros for the bypass weights
if(cascade)
    Wo = [Wo(:,1) zeros(M, N)  Wo(:,2:end)];
end
