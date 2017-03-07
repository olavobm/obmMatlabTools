function titleAll(celltitles, axeshandles, varargin)
% TITLEALL(celltitles, varargin)
%
%   inputs:
%       - celltitles:
%       - axeshandles (optional):
%       - varargin (optional):
%
%
% Olavo Badaro Marques, 07/Mar/2017.

allAxes = findall(gcf, 'Type', 'axes');
onlyAxes = allAxes(~ismember(get(allAxes, 'Tag'), {'legend', 'Colobar'}));

if length(onlyAxes) ~= length(celltitles)
    error('')
else
    n = length(celltitles);
end


%%

if ~exist('axeshandles', 'var') || isempty(axeshandles)
    
    axeshandles = flipud(onlyAxes);
end

%%

for i = 1:n
    axes(axeshandles(i))
    title(celltitles{i}, varargin{:})
end

