function [MSE_test] = mlp_PROCESSING(weights_file, testing_file, desired_outputs_present, write_processing_results)
% Title: Multi-layer Perceptron (MLP) Network for Mapping - Processing
% program
% 
% Language: MATLAB / Octave
%
% Description: This program applies the weights generated during training
% to a validation file and produces the estimated outputs. If the desired
% outputs are given, then the validation MSE is also produced.
%
% See also mlp_TRAIN, mlp_TRAIN_CLASS, and, mlp_PROCESSING_CLASS.

%   Author: Rohit Rawat
%   Copyright 2013, Image Processing and Neural Networks Lab, The
%   University of Texas at Arlington.
%   $Revision: 1.01 $  $Date: 2013/07/05 $
    
% % Get user input
if(nargin<3)
    disp('MLP Approximator Processing Program');
    disp('===================================');
    disp('Image Processing and Neural Networks Lab');
    disp('The University of Texas at Arlington');
    disp('Website: http://www-ee.uta.edu/eeweb/ip/');
    disp('Contact: Dr Michael T. Manry (manry@uta.edu)');
    disp('Authors: Rohit Rawat');
    disp(' ');

    weights_file = input('Enter the weights file name: ', 's');
    testing_file = input('Enter the testing data file name: ', 's');
    question = input('Does the file contain desired outputs? [y/n] ', 's');
    if(question == 'y')
        desired_outputs_present = 1;
    elseif(question == 'n')
        desired_outputs_present = 0;
    else
        error('Invalid entry.');
    end
end

if(nargin < 4)
    write_processing_results = 1;
end

fprintf('MLP Testing\r\n');
fprintf('Testing file: %s\r\n', testing_file);
fprintf('Weights file: %s\r\n', weights_file);

% Read the weights file
[training_fname N M Nh Wi Wo] = read_numap_weights(weights_file);
fprintf('Training filename: %s\r\n', training_fname);
fprintf('Number of inputs (N): %d\r\n', N);
fprintf('Number of outputs (M): %d\r\n', M);
fprintf('Number of hidden units (Nh): %d\r\n', Nh);

% Processing
fprintf('\r\nProcessing results:\r\n');
if(desired_outputs_present)
    [x t Nv] = read_approx_file(testing_file, N, M);
else
    [x t Nv] = read_approx_file(testing_file, N, 0);
end
Xa = [ones(Nv,1) x];
y = mlp_calc_outputs(Xa, Wi, Wo);

results_fname = 'MLP_Processing_Results.txt';
if(write_processing_results)
    fid = fopen(results_fname, 'w');
    if(fid == -1)
        error('Unable to open file %s for writing results.\r\n', results_fname);
    end
else
    fid = 1;    % redirect to stdout instead
end

fprintf(fid, 'Training filename: %s\r\n', training_fname);
fprintf(fid, 'Processing filename: %s\r\n', testing_file);
fprintf(fid, 'Number of inputs (N): %d\r\n', N);
fprintf(fid, 'Number of outputs (M): %d\r\n', M);
fprintf(fid, 'Number of hidden units (Nh): %d\r\n', Nh);
fprintf(fid, 'Number of patterns in processing file (Nv): %d\r\n', Nv);

fprintf(fid, '\r\nProcessing results:\r\n');
if(desired_outputs_present)
    [MSE Ei] = mlp_calc_mse(t, y);
    fprintf('Error at node %d = %f\r\n', [1:M; Ei]);
    fprintf('Total Testing MSE = %f\r\n', MSE);
    fprintf('MSE/M as shown by MATLAB = %f\r\n', MSE/M);
    fprintf(fid, 'Error at node %d = %f\r\n', [1:M; Ei]);
    fprintf(fid, 'Total Testing MSE = %f\r\n', MSE);
    fprintf(fid, 'MSE/M as shown by MATLAB = %f\r\n', MSE/M);
end

fprintf(fid, '\r\nProcessing outputs:\r\n');
fprintf(fid, 'Patt.#\t');
if(desired_outputs_present)
    for i=1:M
        fprintf(fid, 't(%d)\t\t', i);
    end
end
for i=1:M
    fprintf(fid, 'y(%d)\t\t', i);
end
for p=1:Nv
    fprintf(fid, '\r\n%d\t', p);
    if(desired_outputs_present)
        fprintf(fid, '%f\t', t(p,:));
    end
    fprintf(fid, '%f\t', y(p,:));
end
fprintf(fid, '\r\n');

if(write_processing_results)
    fclose(fid);
end

if(write_processing_results)
    fprintf('\r\nProcessing results have been written to %s.\r\n', results_fname);
end

MSE_test = MSE;
