function ticknmarks(xyzstr, nticks, varargin)
% TICKNMARKS(xyzstr, nticks, varargin)
%
%   inputs
%       - xyzstr:
%       - nticks:
%       - varargin (optional):
%
% TICKNMARKS creates evenly spaced ticks for an axis on an
% axes handle. The current axis limit is used to create the
% evenly spaced ticks and both limits are included in the
% set of ticks. You can also change the ticks for multiple
% axes (x, y and z) or on multiple axes handles.
% 
% 
% 
% 
% TO DO:
%   - select decimal place
%   - convert datenum to datestr
%
% Olavo Badaro Marques, 11/Mar/2018.


%% Deal with possibility that first input might be an axis handle:

if isgraphics(xyzstr)

    haxs = xyzstr;
    xyzstr = nticks;
    nticks = varargin{1};
    
    if length(varargin)>1
        varargin = varargin(2:end);
    else
        varargin = {};
    end
    
else
    
    haxs = gca;
       
end


%% Look at input "xyzstr" to see what axes will be ticked:

%
tickaxsStr = cell(1, 3);

%
if ~isempty(strfind(xyzstr, 'x'))
    tickaxsStr{1} = 'x';
end

if ~isempty(strfind(xyzstr, 'y'))
    tickaxsStr{2} = 'y';
end

if ~isempty(strfind(xyzstr, 'z'))
    tickaxsStr{3} = 'z';
end

%
tickaxsStr = tickaxsStr(~cellfun(@isempty, tickaxsStr));


%% Create variables to map from an axis ('x', 'y', 'z')
% to their correspondent properties in an axes handle:

tickaxsMap = containers.Map({'x', 'y', 'z'}, {'XTick', 'YTick', 'ZTick'});
limsaxsMap = containers.Map({'x', 'y', 'z'}, {'XLim', 'YLim', 'ZLim'});


%% Set axis' ticks:

% Loop over axes handles
for i1 = 1:length(haxs)
    
    % Loop over axes to tick
    for i2 = 1:length(tickaxsStr)
        
        % Get limits of the current axis
        axslims = get(haxs(i1), limsaxsMap(tickaxsStr{i2}));
        
        % Create evenly spaced ticks on the current axis
        set(haxs(i1), tickaxsMap(tickaxsStr{i2}), ...
                      linspace(axslims(1), axslims(2), nticks))
        
    end
    
end

