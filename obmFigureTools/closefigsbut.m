function closefigsbut(fignumbers)
% CLOSEFIGSBUT(fignumbers)
%
%   inputs
%       - fignumbers
%
%
%
%
%
%
%
% Olavo Badaro Marques, 18/Aug/2017.


allFigHnds = findall(groot, 'Type', 'Figure');

allFigNumbers = [allFigHnds(:).Number];


%%

for i = 1:length(allFigNumbers)
    
    if ~ismember(allFigNumbers(i), fignumbers)
        close(allFigHnds(i).Number)
    end
end



