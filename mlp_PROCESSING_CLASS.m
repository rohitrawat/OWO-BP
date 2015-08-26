function [Pe_test] = mlp_PROCESSING_CLASS(weights_file, testing_file, desired_outputs_present, write_processing_results)
% Title: Multi-layer Perceptron (MLP) Network for Mapping - Processing
% program
% 
% Language: MATLAB / Octave
%
% Description: This program applies the weights generated during training
% to a validation file and produces the estimated outputs. If the desired
% outputs are given, then the validation MSE and Pe is also produced.
%
% See also mlp_TRAIN, mlp_TRAIN_CLASS, and, mlp_PROCESSING.

%   Author: Rohit Rawat
%   Copyright 2013, Image Processing and Neural Networks Lab, The
%   University of Texas at Arlington.
%   $Revision: 1.01 $  $Date: 2013/07/05 $
    
% % Get user input
if(nargin<3)
    disp('MLP Classifier Processing Program');
    disp('=================================');
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
    [x ic Nv] = read_class_file(testing_file, N, M);
else
    [x ic Nv] = read_class_file(testing_file, N, 0);
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

fprintf(fid, '\r\nProcessing outputs:\r\n');
fprintf(fid, 'Patt.#\t');
for i=1:M
    fprintf(fid, 'y(%d)\t\t', i);
end
if(desired_outputs_present)
    fprintf(fid, 'ic\t\t');
end
fprintf(fid, 'ic'' (calculated class)');

errors = 0;
errors_class = zeros(M,1);
for p=1:Nv
    fprintf(fid, '\r\n%d\t', p);
    fprintf(fid, '%f\t', y(p,:));
    if(desired_outputs_present)
        fprintf(fid, '%d\t', ic(p));
    end
    [v ic1] = max(y(p,:));
    fprintf(fid, '%d\r\n', ic1);
    if(ic(p) ~= ic1)
        errors = errors+1;
        errors_class(ic(p)) = errors_class(ic(p)) + 1;
    end
end
fprintf(fid, '\r\n');

if(write_processing_results)
    fclose(fid);
end

Pe_test = errors*100/Nv;
for i=1:M
    fprintf('Number of error patterns for class %d: %d\n', i, errors_class(i));
end
fprintf('Total number of error patterns: %d\n', errors);
fprintf('Testing Pe (%%): %.4f\n', Pe_test);

if(write_processing_results)
    fprintf('\r\nProcessing results have been written to %s.\r\n', results_fname);
end
