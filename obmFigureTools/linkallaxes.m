function linkallaxes(axsstr, haxs)
% LINKALLAXES(axsstr, haxs)
%
%   inputs:
%       - axsstr: string in the same manner as it goes into linkaxes.m
%       - haxs (optional): vector of axes handles (if not given search
%                          for the axes of the current figure).
%
% LINKALLAXES apply linkaxes.m for all axes in the current
% figure (so you don't have to specify all axes handles).
% You can also give the axes handles to specify which axes
% you want to link.
%
% Olavo Badaro Marques, 07/Mar/2017.


%% Get handles of axes to link:

% If second input is not given, get current figure's axes handles:
if ~exist('haxs', 'var')
    
    % Get all axes handles in the current figure:
    allAxes = findall(gcf, 'Type', 'axes');
    onlyAxes = allAxes(~ismember(get(allAxes, 'Tag'), {'legend', 'Colobar'}));
   
% Otherwise use input:
else
   
    onlyAxes = haxs;
    
end


%% Call linkaxes:

linkaxes(onlyAxes, axsstr)