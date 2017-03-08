function linkallaxes(axsstr)
% LINKALLAXES(axsstr)
%
%   inputs:
%       - axsstr: string in the same manner as it goes into linkaxes.m
%
% LINKALLAXES applys linkaxes.m for all axes in the current
% figure (so you don't have to specify all axes handles).
%
% Olavo Badaro Marques, 07/Mar/2017.


%% Get all axes handles in the current figure:

allAxes = findall(gcf, 'Type', 'axes');
onlyAxes = allAxes(~ismember(get(allAxes, 'Tag'), {'legend', 'Colobar'}));


%% Call linkaxes:

linkaxes(onlyAxes, axsstr)