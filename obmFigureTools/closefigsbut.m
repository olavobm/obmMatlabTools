function closefigsbut(fignumbers)
% CLOSEFIGSBUT(fignumbers)
%
%   inputs
%       - fignumbers: array of figure numbers.
%
% CLOSEFIGSBUT close all the figures but
% those with numbers given in the input.
%
% Olavo Badaro Marques, 18/Aug/2017.


%% Get all figure numbers (groot was implemented in Matlab's
% version 2014b -- substitute by 0 for earlier versions)

% Get all figure handles
allFigHnds = findall(groot, 'Type', 'Figure');

% Get correspondent figure numbers
allFigNumbers = [allFigHnds(:).Number];


%% Loop over figure numbers and close if not present in input

for i = 1:length(allFigNumbers)
    
    if ~ismember(allFigNumbers(i), fignumbers)
        close(allFigHnds(i).Number)
    end
end



