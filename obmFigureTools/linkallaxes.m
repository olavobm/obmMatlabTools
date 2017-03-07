function linkallaxes(axsstr)
%
%   inputs:
%       -
%
%
% Olavo Badaro Marques, 07/Mar/2017.



%%
% allAxes = findall(hfig(i), 'Type', 'axes');
allAxes = findall(gcf, 'Type', 'axes');
onlyAxes = allAxes(~ismember(get(allAxes, 'Tag'), {'legend', 'Colobar'}));

%%
linkaxes(onlyAxes, axsstr)