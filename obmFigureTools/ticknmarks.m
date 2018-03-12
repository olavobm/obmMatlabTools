function ticknmarks(xyzstr, nticks, varargin)
% TICKNMARKS(xyzstr, nticks, varargin)
%
%   inputs
%       - xyzstr:
%       - nticks:
%       - varargin (optional):
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


%%

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


%%

tickaxsMap = containers.Map({'x', 'y', 'z'}, {'XTick', 'YTick', 'ZTick'});
limsaxsMap = containers.Map({'x', 'y', 'z'}, {'XLim', 'YLim', 'ZLim'});


%%

for i1 = 1:length(haxs)
    
    for i2 = 1:length(tickaxsStr)
        
        %
        axslims = get(haxs(i1), limsaxsMap(tickaxsStr{i2}));
        
        %
        set(haxs(i1), tickaxsMap(tickaxsStr{i2}), ...
                      linspace(axslims(1), axslims(2), nticks))
        
    end
    
end

