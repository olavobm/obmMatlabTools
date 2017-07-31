function titleAll(celltitles, axeshandles, varargin)
% TITLEALL(celltitles, varargin)
%
%   inputs:
%       - celltitles: cell array of strings to be subplot titles.
%       - axeshandles (optional): array of axes handles referencing to
%                                 the same axes as celltitles.
%       - varargin (optional): parameter name-value pairs to
%                              customize title.
%
% Add title to all subplots in current figure. If not specifying input
% axeshandles, the order of celltitles should be given in the same
% order in which the existing axes were created.
%
% Olavo Badaro Marques, 07/Mar/2017.


%% If axeshandles is not given, get all existing axes in current figure:

if ~exist('axeshandles', 'var') || isempty(axeshandles)
    
    allAxes = findall(gcf, 'Type', 'axes');
    onlyAxes = allAxes(~ismember(get(allAxes, 'Tag'), {'legend', 'Colobar'}));
    
    axeshandles = flipud(onlyAxes);  % flipud because matlab "store" axes
                                     % such that the first handle
                                     % references to the last one that
                                     % was created
end


%% Get axes handles in current figure:

if length(axeshandles) ~= length(celltitles)
    error(['Input celltitles does NOT have the same length as ' ...
           'the axeshandles array. It must have.'])
else
    n = length(celltitles);
end


%% Loop over axes and title them:

for i = 1:n
%     axeshandles(i).Title.String = celltitles{i};
    
    % Add title to the i'th axes handle
    title(axeshandles(i), celltitles{i}, varargin{:})
end

