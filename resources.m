function value = resources(ID)
%RESOURCES Provides configuration values for the MLP training and testing GUI programs.
%
%  This program is a lookup table for parameters used by the training and 
%  testing GUI programs. This allows the GUIs to be customized for
%  different kinds of training methods needing different user interface
%  elements.
%
%  Parameter definitions:
%  'Info' : Returns information about the training algorithm
%  'TrainTitle' : Returns the title of the training program
%  'TestTitle' : Returns the title of the testing program
%  'N' : Returns the label for the N parameter
%  'M' : Returns the label for the M parameter
%  'Nh' : Returns the label for the Nh parameter
%  'Nit' : Returns the label for the Nit parameter
%  'weights_file' : Returns the filename to use for the weights file
%
%  Some algorithms do not need a separate validation file. The validation
%  file row can be removed using the 'DisableValidation' flag.
%
%  For an algorithm that only runs on classification or regression types,
%  the radio button giving this choice can be removed and pre-set.
%
%  The default layoutis N, M, Nh, Nit. One more parameter can be added with
%  the 'Extra' and 'ExtraValue' settings.
%  See also RUN_TRAINING, RUN_TESTING.

%  Rohit Rawat (rohitrawat@gmail.com), 08-23-2015
%  $Revision: 1 $ $Date: 23-Aug-2015 15:50:31 $

switch(ID);
    case 'Info'
        value = {'MLP Training Program',
            '',
            'Algorithm: OWO-BP',
            '',
            'Author: Rohit Rawat',
            'http://www.rohitrawat.com/',
            'http://www.uta.edu/faculty/manry/'};
    case 'TrainTitle'
        value = 'MLP Training Program';
    case 'TestTitle'
        value = 'MLP Testing Program';
    case 'CodeDirectory'
        value = '.';
    case 'N'  % Row 4
        value = 'Inputs (N)';
    case 'M'  % Row 5
        value = 'Outputs/Classes (M)';
    case 'Nh'  % Row 6
        value = 'Hidden Units (Nh)';
    case 'Nit'  % Row 7
        value = 'Training Iterations (Nit)';
    case 'weights_file'
        value = 'weights.txt';
    
    % Advanced settings: Do not modify unless you know what you are doing!
    case 'DisableValidation'  % Disables Row 2
        value = true;  % leave false. if true, validation file cannot be specified.
    case 'FixedType'  % Disables Row 3
        value = 0;  % 0: user chooses file type, 1: fixed regression, 2: fixed classification
    case 'Extra'  % Row 8
        value = 'Regularization lambda';  % leave empty '', otherwise set to what the Extra input should be called
    case 'ExtraValue'
        value = 0;  % set to what the Extra input should be pre-loaded with
    otherwise
        value = 'Undefined!';
end
