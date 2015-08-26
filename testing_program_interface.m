function [E_test] = testing_program_interface(testing_file, weights_file, desired_outputs_present, write_processing_results, file_type)
%TESTING_PROGRAM_INTERFACE Wrapper for the testing program.
%
%  This program is a wrapper for the real testing program. It receives
%  input from the GUI and uses them to call the testing code. This allows
%  the same GUI to be used with different kinds of training algorithms by
%  simply modifying this file.
%
%  See also RESOURCES, RUN_TESTING.

%  Rohit Rawat (rohitrawat@gmail.com), 08-23-2015
%  $Revision: 1 $ $Date: 23-Aug-2015 15:50:31 $

E_test = NaN;
if(file_type == 1)
    % call the program for regression case here:
    [E_test] = mlp_PROCESSING(weights_file, testing_file, desired_outputs_present, write_processing_results)
else
    % call the program for classification case here:
    [E_test] = mlp_PROCESSING_CLASS(weights_file, testing_file, desired_outputs_present, write_processing_results)
end
