function [E] = mlp_TRAIN(training_file, N, M, Nh, Nit, lambda, cascade, different_weights_filename)
%mlp_TRAIN Trains a Multi Layer Perceptron (MLP) neural network.
%   mlp_TRAIN(training_file, N, M, Nh, Nit, cascade, different_weights_filename)
%   trains an MLP on the training data file
%   specified by training_file with N inputs and M outputs. Nh is the
%   number of hidden units to begin with. Nit is the maximum number of
%   training iterations/epochs. 
%
%   Calling the function without any or insufficient arguments prompts the 
%   user for input on the command line.
%
%   The training algorithm used is HWO-MOLF. See: 
%   Malalur, S. S., & Manry, M. T. (2010, April). Multiple optimal learning 
%   factors for feed-forward networks. In SPIE Defense, Security, and Sensing
%   (pp. 77030F-77030F). International Society for Optics and Photonics.
%
%   See also mlp_PROCESSING, mlp_TRAIN_CLASS, and, mlp_PROCESSING_CLASS.

%   Copyright 2013, Image Processing and Neural Networks Lab, The
%   University of Texas at Arlington.
%   Rohit Rawat
%   $Revision: 2.01 $  $Date: 2014/11/09 $

if(nargin < 6)
    lambda = 0;
end

if(nargin < 7)
    % Default is fully connected
    cascade = false;
end

if(nargin < 8)
    different_weights_filename = 'weights.txt';
end

disp('MLP Approximation Training Program');
disp('==================================');
disp('Training Algorithm: OWO-BP.')
disp('Image Processing and Neural Networks Lab');
disp('The University of Texas at Arlington');
disp('Website: http://www-ee.uta.edu/eeweb/ip/');
disp('Contact: Dr Michael T. Manry (manry@uta.edu)');
disp('Authors: Jignesh Patel and Rohit Rawat');
disp(' ');

if(nargin < 5)

    % Get user input
    training_file = input('Enter the training file name: ', 's');
    N = input('Enter the number of inputs (N): ');
    M = input('Enter the number of outputs (M): ');
    Nh = input('Enter the number of hidden units (Nh): ');
    Nit = input('Enter the number of training iterations (Nit): ');
    lambda = input('Enter the value for lambda (small value like 0 or 0.01) (lambda): ');
    if(lambda>=1)
      error('lambda cannot be this large. Try a smaller value like 0.1');
    end

end

if(Nh < 1)
    error('You must have at least one hidden unit. Please use a linear network training program.\n');
end

debugging = 0;
mlp_randn(0,0,1); % reset the random number generator slete

fprintf('\nTraining file name: %s\n', training_file);
fprintf('Number of inputs: %d\n', N);
fprintf('Number of output classes: %d\n', M);
fprintf('Number of hidden units: %d\n', Nh);
fprintf('Number of training iterations: %d\n', Nit);
fprintf('Regularization parameter lambda: %d\n', lambda);


global global_debug;
global_debug = 0;

% The following code reads a text file and stores all the paterns in 
% an Nv by (N+M) matrix
[x t Nv] = read_approx_file(training_file, N, M);

classifier_mode = false;
[E Wi Wo] = mlp_train_data(x, t, N, M, Nh, Nit, lambda, cascade, classifier_mode);

fprintf('Network saved to file %s\n', different_weights_filename);
write_numap_weights(different_weights_filename, training_file, Wi, Wo, 1, Nit, lambda);
