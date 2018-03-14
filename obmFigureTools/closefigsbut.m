function closefigsbut(fignumbers)
% CLOSEFIGSBUT(fignumbers)
%
%   inputs
%       - fignumbers: array of figure numbers.
%
% CLOSEFIGSBUT close all the figures but those with
% numbers given in the input. You can also not give
% any input, in which case only the current active
% figure will not be closed.
%
% Olavo Badaro Marques, 18/Aug/2017.


%% Get all figure numbers (groot was implemented in Matlab's
% version 2014b -- substitute by 0 for earlier versions)

% Get all figure handles
allFigHnds = findall(groot, 'Type', 'Figure');

% Get correspondent figure numbers
allFigNumbers = [allFigHnds(:).Number];


%% If there is no input, then get number of current figure
% such that this is the only one that will not be closed

if nargin==0
    hfig = gcf;
    fignumbers = hfig.Number;
end


%% Loop over figure numbers and close if not present in input

for i = 1:length(allFigNumbers)
    
    if ~ismember(allFigNumbers(i), fignumbers)
        close(allFigHnds(i).Number)
    end
end



